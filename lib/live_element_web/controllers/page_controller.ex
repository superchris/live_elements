defmodule LiveElementWeb.PageController do
  use LiveElementWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
