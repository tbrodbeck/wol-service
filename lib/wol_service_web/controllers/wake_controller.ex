defmodule WolServiceWeb.WakeController do
  use WolServiceWeb, :controller

  alias WolService.Wol

  def wake(conn, %{"mac" => mac}) do
    case Wol.wake(mac) do
      :ok ->
        json(conn, %{status: "ok", message: "Magic packet sent to #{mac}"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{status: "error", message: "Failed to send packet: #{inspect(reason)}"})
    end
  end

  def wake(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{status: "error", message: "Missing required parameter: mac"})
  end
end
