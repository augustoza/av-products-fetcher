defmodule AvProductsFetcher.Prices.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias AvProductsFetcher.Prices.ConsultationPrice

  schema "products" do
    field :last_purchase_price, :float
    field :name, :string
    field :stl_purchase_price, :float
    field :ttl_purchase_price, :float

    has_many :consultation_prices, ConsultationPrice

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :last_purchase_price, :stl_purchase_price, :ttl_purchase_price])
    |> validate_required([:name, :last_purchase_price, :stl_purchase_price, :ttl_purchase_price])
  end
end
