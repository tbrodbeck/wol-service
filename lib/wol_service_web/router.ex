defmodule WolServiceWeb.Router do
  use WolServiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WolServiceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Admin UI at root (accessed via /app on Tailscale)
  scope "/", WolServiceWeb do
    pipe_through :browser

    live "/", AdminLive
  end

  # API routes (accessed via /app/api on Tailscale)
  scope "/api", WolServiceWeb do
    pipe_through :api

    post "/wake", WakeController, :wake
  end
end
