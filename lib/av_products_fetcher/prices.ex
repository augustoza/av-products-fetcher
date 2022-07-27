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
end
