# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AvProductsFetcher.Repo.insert!(%AvProductsFetcher.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AvProductsFetcher.Prices
alias AvProductsFetcher.Repo

Prices.list_consultation_prices
|> Enum.each(fn c_price ->
  c_price
  |> Repo.delete
end)

Prices.list_products
|> Enum.each(fn product ->
  product
  |> Repo.delete
end)

{:ok, product_1} = Prices.create_product(
  %{
    name: "Refrigerante Pet 2 Litros - Coca-Cola",
    last_purchase_price: 8.98,
    stl_purchase_price: 8.89,
    ttl_purchase_price: 8.80
  }
)

{:ok, product_2} = Prices.create_product(
  %{
    name: "Arroz Selvagem Vermelho pacote 1kg - Paiol",
    last_purchase_price: 17.00,
    stl_purchase_price: 17.13,
    ttl_purchase_price: 17.10
  }
)

{:ok, product_3} = Prices.create_product(
  %{
    name: "Whisky Americano Tenessee garrafa 1 Litro - Jack Daniel's",
    last_purchase_price: 138.9,
    stl_purchase_price: 140.2,
    ttl_purchase_price: 136.5
  }
)

Prices.create_consultation_price(
  %{
    product_id: product_1.id,
    base_link: "https://www.cotabest.com.br/",
    product_link: "https://www.cotabest.com.br/refrigerante-coca-cola-pet-2-litros/"
  }
)

Prices.create_consultation_price(
  %{
    product_id: product_2.id,
    base_link: "https://www.cotabest.com.br/",
    product_link: "https://www.cotabest.com.br/arroz-selvagem-vermelho-paiol-pacote-1kg/"
  }
)

Prices.create_consultation_price(
  %{
    product_id: product_3.id,
    base_link: "https://www.cotabest.com.br/",
    product_link: "https://www.cotabest.com.br/whisky-americano-tenessee-jack-daniels-garrafa-1-litro/"
  }
)
