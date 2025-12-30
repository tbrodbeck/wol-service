defmodule WolServiceWeb.PageController do
  use WolServiceWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
