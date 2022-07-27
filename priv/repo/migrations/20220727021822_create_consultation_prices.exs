defmodule AvProductsFetcher.Repo.Migrations.CreateConsultationPrices do
  use Ecto.Migration

  def change do
    create table(:consultation_prices) do
      add :last_fetched_price, :float
      add :base_link, :string
      add :product_link, :string
      add :product_id, references(:products), null: false

      timestamps()
    end
  end
end
