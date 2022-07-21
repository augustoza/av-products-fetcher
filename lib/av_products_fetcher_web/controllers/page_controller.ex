defmodule AvProductsFetcherWeb.PageController do
  use AvProductsFetcherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
