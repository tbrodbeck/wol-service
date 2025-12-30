defmodule WolServiceWeb.WakeControllerTest do
  use WolServiceWeb.ConnCase

  test "POST /api/wake returns success when MAC is provided", %{conn: conn} do
    conn = post(conn, ~p"/api/wake", %{mac: "AA:BB:CC:DD:EE:FF"})

    assert json_response(conn, 200)["status"] == "ok"
    assert json_response(conn, 200)["message"] =~ "AA:BB:CC:DD:EE:FF"
  end

  test "POST /api/wake returns error when MAC is missing", %{conn: conn} do
    conn = post(conn, ~p"/api/wake", %{})

    assert json_response(conn, 400)["status"] == "error"
    assert json_response(conn, 400)["message"] =~ "Missing"
  end
end
