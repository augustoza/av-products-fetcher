defmodule AvProductsFetcherWeb.PriceLive do
  @moduledoc """
  The live view responsible to coordinate logic about the price process for the user.
  """

  alias AvProductsFetcher.Fetch
  alias AvProductsFetcher.Prices

  use AvProductsFetcherWeb, :live_view

  def mount(_params, _session, socket) do
    products = list_products_for_index_ordered()

    {:ok, assign(socket, products: products, backup_products: products)}
  end

  def handle_event("fetch_prices", _params, socket) do
    Task.async(fn ->
      Fetch.fetch_prices_from_client
    end)

    {:noreply,
     socket
     |> put_flash(:info, "Os preços estão sendo buscados. Quando o processo terminar, a página será atualizada automaticamente.")
    }
  end

  def handle_event("search_product_table", %{"search_value" => search_value}, socket) do
    downcase_search_value =
      if search_value && String.length(search_value) > 0 do
        String.downcase(search_value)
      else
        search_value
      end

    filtered_products =
      socket.assigns.backup_products
      |> Enum.filter(fn product ->
        product
        |> Map.get(:name)
        |> String.downcase
        |> String.contains?(downcase_search_value)
      end)

    {:noreply, assign(socket, products: filtered_products)}
  end

  def handle_info({:DOWN, _ref, :process, _object, :normal}, socket) do
    {:noreply, socket}
  end

  def handle_info(_response, socket) do
    products = list_products_for_index_ordered()

    {:noreply,
      socket
      |> clear_flash()
      |> assign(products: products, backup_products: products)}
  end

  defp list_products_for_index_ordered do
    products_unordered = Prices.list_products_for_index()
    inexistant_rate = Enum.filter(products_unordered, fn product -> product.last_fetched_price == "Não localizado" end)
    existant_rate =
      Enum.filter(products_unordered, fn product -> product.last_fetched_price != "Não localizado" end)
      |> Enum.sort_by(fn product -> product.economy end, :desc)

    existant_rate ++ inexistant_rate
  end
end
