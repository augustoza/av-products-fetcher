defmodule AvProductsFetcher.Prices.ConsultationPrice do
  use Ecto.Schema
  import Ecto.Changeset
  alias AvProductsFetcher.Prices.Product

  schema "consultation_prices" do
    field :base_link, :string
    field :last_fetched_price, :float
    field :product_link, :string

    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(consultation_price, attrs) do
    consultation_price
    |> cast(attrs, [:last_fetched_price, :base_link, :product_link, :product_id])
    |> validate_required([:last_fetched_price, :base_link, :product_link, :product_id])
  end
end
