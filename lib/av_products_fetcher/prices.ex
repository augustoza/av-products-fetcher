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
      cheapest_date = get_cheapest_date(product, cheapest_price)
      calculated_economy = calculate_economy(consultation_price.last_fetched_price, cheapest_price)

      %{
        id: product.id,
        name: product.name,
        cheapest_price: cheapest_price,
        cheapest_date: cheapest_date,
        last_fetched_price: consultation_price.last_fetched_price || "Não localizado",
        product_link: consultation_price.product_link,
        economy: calculated_economy,
        base_link: consultation_price.base_link,
        color_class: get_color_class(calculated_economy)
      }
    end)
  end

  def get_price_and_date(product) do
    cond do
      product.cheapest_price && product.cheapest_date ->
        "R$ #{:erlang.float_to_binary(product.cheapest_price, [decimals: 2])} em #{product.cheapest_date |> Calendar.strftime("%d/%m/%y")}"
      product.cheapest_price ->
        "R$ #{:erlang.float_to_binary(product.cheapest_price, [decimals: 2])}"
      true ->
        "Nenhuma compra encontrada."
    end
  end

  def list_consultation_prices do
    Repo.all(ConsultationPrice)
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def get_consultation_price!(id), do: Repo.get!(ConsultationPrice, id)

  def update_consultation_price(%ConsultationPrice{} = consultation_price, attrs) do
    consultation_price
    |> ConsultationPrice.changeset(attrs)
    |> Repo.update()
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def create_consultation_price(attrs \\ %{}) do
    %ConsultationPrice{}
    |> ConsultationPrice.changeset(attrs)
    |> Repo.insert()
  end

  defp get_color_class(economy) do
    cond do
      is_binary(economy) -> "color-default"
      economy > 0 -> "color-green"
      true -> "color-red"
    end
  end

  defp calculate_cheapest_price(product) do
    [product.last_purchase_price, product.stl_purchase_price, product.ttl_purchase_price]
    |> Enum.sort
    |> hd
  end

  defp get_cheapest_date(product, cheapest_price) do
    cond do
      cheapest_price == product.last_purchase_price ->
        product.last_purchase_date
      cheapest_price == product.stl_purchase_price ->
        product.stl_purchase_date
      true ->
        product.ttl_purchase_date
    end
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
