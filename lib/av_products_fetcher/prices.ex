defmodule AvProductsFetcher.Prices do
  @moduledoc """
  The Prices context.
  """

  alias AvProductsFetcher.Repo
  alias AvProductsFetcher.Prices.Product
  alias AvProductsFetcher.Prices.ConsultationPrice

  def list_products do
    Repo.all(Product)
  end

  def list_products_for_index do
    list_products()
    |> Enum.map(fn product ->
      consultation_price =
        product
        |> Repo.preload(:consultation_prices)
        |> Map.get(:consultation_prices)
        |> Enum.find(fn consultation_price -> consultation_price.base_link == "https://www.cotabest.com.br/" end)
        |> case do
          nil -> %{last_fetched_price: "Não localizado", product_link: "Não localizado", base_link: "Não localizado"}
          c_price -> c_price
        end

      cheapest_price = calculate_cheapest_price(product)

      %{
        id: product.id,
        name: product.name,
        cheapest_price: cheapest_price,
        last_fetched_price: consultation_price.last_fetched_price || "Não localizado",
        product_link: consultation_price.product_link,
        economy: calculate_economy(consultation_price.last_fetched_price, cheapest_price),
        base_link: consultation_price.base_link
      }
    end)
  end

  def list_consultation_prices do
    Repo.all(ConsultationPrice)
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def get_consultation_price!(id), do: Repo.get!(ConsultationPrice, id)

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def create_consultation_price(attrs \\ %{}) do
    %ConsultationPrice{}
    |> ConsultationPrice.changeset(attrs)
    |> Repo.insert()
  end

  defp calculate_cheapest_price(product) do
    [product.last_purchase_price, product.stl_purchase_price, product.ttl_purchase_price]
    |> Enum.sort
    |> hd
  end

  defp calculate_economy(fetched_price, cheapest_price) do
    case fetched_price do
      "Não localizado" ->
        "N/A"
      0 ->
        "Preço com divergência"
      price ->
        if fetched_price do
          ((1 - (price / cheapest_price)) * 100)
          |> Float.round(2)
        else
          "N/A"
        end
    end
  end
end
