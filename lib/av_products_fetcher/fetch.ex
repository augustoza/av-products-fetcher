defmodule AvProductsFetcher.Fetch do
  @moduledoc """
  The Fetch context.
  """

  alias AvProductsFetcher.Prices

  def fetch_prices_from_client do
    post_response =
      HTTPoison.post(
        "http://host.docker.internal:3000/fetch_prices",
        generate_body(),
        [{"Content-Type", "application/json"}],
        [timeout: 50_000, recv_timeout: 50_000]
      )
      |> IO.inspect

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

      %{rootLink: products |> hd |> Map.get(:base_link)}
      |> Map.put(:products, inside_list)
      |> Jason.encode!
  end
end
