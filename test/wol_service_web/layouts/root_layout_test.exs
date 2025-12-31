defmodule WolServiceWeb.RootLayoutTest do
  use WolServiceWeb.ConnCase

  describe "app-path-prefix meta tag" do
    test "renders empty path prefix when url path is not configured", %{conn: conn} do
      # Default test config has no url: [path: ...] set
      conn = get(conn, ~p"/")
      html = html_response(conn, 200)

      assert html =~ ~r/<meta name="app-path-prefix" content="">/
    end

    test "renders configured path prefix when url path is set", %{conn: conn} do
      # Temporarily set the path config
      original_config = Application.get_env(:wol_service, WolServiceWeb.Endpoint)

      updated_url = Keyword.put(original_config[:url] || [], :path, "/app")
      updated_config = Keyword.put(original_config, :url, updated_url)
      Application.put_env(:wol_service, WolServiceWeb.Endpoint, updated_config)

      try do
        conn = get(conn, ~p"/")
        html = html_response(conn, 200)

        assert html =~ ~r/<meta name="app-path-prefix" content="\/app">/
      after
        # Restore original config
        Application.put_env(:wol_service, WolServiceWeb.Endpoint, original_config)
      end
    end
  end

  describe "favicon" do
    test "uses verified route for favicon", %{conn: conn} do
      conn = get(conn, ~p"/")
      html = html_response(conn, 200)

      # Should use ~p sigil which respects path prefix config
      assert html =~ ~r/<link rel="icon" href="[^"]*\/favicon\.svg"/
    end
  end
end
