defmodule AvProductsFetcher.Repo do
  use Ecto.Repo,
    otp_app: :av_products_fetcher,
    adapter: Ecto.Adapters.Postgres
end
