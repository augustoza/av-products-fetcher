defmodule AvProductsFetcher.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :last_purchase_price, :float
      add :stl_purchase_price, :float
      add :ttl_purchase_price, :float

      timestamps()
    end
  end
end
