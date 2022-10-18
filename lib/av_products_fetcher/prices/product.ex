defmodule AvProductsFetcher.Prices.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias AvProductsFetcher.Prices.ConsultationPrice

  schema "products" do
    field :last_purchase_price, :float
    field :name, :string
    field :stl_purchase_price, :float
    field :ttl_purchase_price, :float
    field :last_purchase_date, :utc_datetime
    field :stl_purchase_date, :utc_datetime
    field :ttl_purchase_date, :utc_datetime

    has_many :consultation_prices, ConsultationPrice

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :last_purchase_price, :stl_purchase_price, :ttl_purchase_price, :last_purchase_date, :stl_purchase_date, :ttl_purchase_date])
    |> validate_required([:name, :last_purchase_price, :stl_purchase_price, :ttl_purchase_price])
  end
end
