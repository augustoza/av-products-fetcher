defmodule AvProductsFetcher.Repo.Migrations.AddDatesToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :last_purchase_date, :utc_datetime
      add :stl_purchase_date, :utc_datetime
      add :ttl_purchase_date, :utc_datetime
    end
  end
end
