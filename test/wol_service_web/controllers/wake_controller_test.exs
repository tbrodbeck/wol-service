defmodule WolServiceWeb.WakeControllerTest do
  use WolServiceWeb.ConnCase

  describe "POST /api/wake" do
    test "returns success when MAC is provided", %{conn: conn} do
      conn = post(conn, ~p"/api/wake", %{mac: "AA:BB:CC:DD:EE:FF"})
      
      assert json_response(conn, 200)["status"] == "ok"
      assert json_response(conn, 200)["message"] =~ "Magic packet sent"
    end

    test "returns error when MAC is missing", %{conn: conn} do
      conn = post(conn, ~p"/api/wake", %{})
      
      assert json_response(conn, 400)["status"] == "error"
      assert json_response(conn, 400)["message"] =~ "Missing required parameter"
    end
  end
end
