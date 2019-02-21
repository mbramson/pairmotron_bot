defmodule PairmotronBotWeb.PageController do
  use PairmotronBotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
