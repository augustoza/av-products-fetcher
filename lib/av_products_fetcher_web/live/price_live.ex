defmodule AvProductsFetcherWeb.PriceLive do
  @moduledoc """
  The live view responsible to coordinate logic about the price process for the user.
  """

  alias AvProductsFetcher.Fetch
  alias AvProductsFetcher.Prices

  use AvProductsFetcherWeb, :live_view

  def mount(_params, _session, socket) do
    products = Prices.list_products_for_index()

    {:ok, assign(socket, products: products)}
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
end
