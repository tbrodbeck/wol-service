defmodule WolServiceWeb.PageControllerTest do
  use WolServiceWeb.ConnCase

  test "GET / renders admin LiveView", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Wake-on-LAN Admin"
  end
end
