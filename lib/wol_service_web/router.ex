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

  scope "/", WolServiceWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # API routes - served under /api via Tailscale Serve
  # Tailscale strips the /api prefix, so routes here are at root
  scope "/", WolServiceWeb do
    pipe_through :api

    post "/wake", WakeController, :wake
  end
end
