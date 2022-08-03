defmodule AvProductsFetcher.Fetch do
  @moduledoc """
  The Fetch context.
  """

  alias AvProductsFetcher.Prices
  alias AvProductsFetcher.Repo

  def fetch_prices_from_client do
    [post_body, base_link] = generate_body()

    {:ok, post_response} =
      HTTPoison.post(
        "http://host.docker.internal:3000/fetch_prices",
        post_body,
        [{"Content-Type", "application/json"}],
        [timeout: 50_000, recv_timeout: 50_000]
      )

    post_response.body
    |> Jason.decode!()
    |> persist_response_on_db(base_link)
  end

  defp persist_response_on_db(response, base_link) do
    response
    |> Enum.each(fn data ->
      Prices.get_product!(data["id"])
      |> Repo.preload(:consultation_prices)
      |> Map.get(:consultation_prices)
      |> Enum.find(fn c_price ->
        c_price.base_link == base_link
      end)
      |> Prices.update_consultation_price(
        %{
          last_fetched_price: String.to_float(data["price"])
        }
      )
    end)
  end

  defp generate_body do
    products = Prices.list_products_for_index()
    inside_list =
      products
      |> Enum.map(fn product ->
        %{
          productLink: product.product_link,
          id: product.id
        }
      end)

    base_link = products |> hd |> Map.get(:base_link)

    post_body =
      %{rootLink: base_link}
      |> Map.put(:products, inside_list)
      |> Jason.encode!

    [post_body, base_link]
  end
end
