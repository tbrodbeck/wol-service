defmodule WolServiceWeb.AdminLive do
  use WolServiceWeb, :live_view

  alias WolService.Wol

  @known_devices [
    %{name: "t1llusNAS", mac: "00:08:9b:d2:df:42", description: "QNAP NAS"},
    %{name: "Windows PC", mac: "48:4d:7e:a2:d6:b7", description: "Windows Desktop"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:devices, @known_devices)
     |> assign(:custom_mac, "")
     |> assign(:flash_message, nil)
     |> assign(:flash_type, nil)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-200 p-8">
      <div class="max-w-2xl mx-auto">
        <h1 class="text-3xl font-bold mb-8">Wake-on-LAN Admin</h1>
        
    <!-- Known Devices -->
        <div class="card bg-base-100 shadow-xl mb-6">
          <div class="card-body">
            <h2 class="card-title">Known Devices</h2>
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th></th>
                    <th>Name</th>
                    <th>MAC Address</th>
                    <th>Description</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for device <- @devices do %>
                    <tr>
                      <td>
                        <button
                          class="btn btn-primary btn-sm"
                          phx-click="wake"
                          phx-value-mac={device.mac}
                          phx-value-name={device.name}
                        >
                          Wake
                        </button>
                      </td>
                      <td class="font-medium">{device.name}</td>
                      <td class="font-mono text-sm">{device.mac}</td>
                      <td class="text-base-content/60">{device.description}</td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
    <!-- Custom MAC -->
        <div class="card bg-base-100 shadow-xl">
          <div class="card-body">
            <h2 class="card-title">Wake Custom Device</h2>
            <form phx-submit="wake_custom" class="flex gap-4">
              <input
                type="text"
                name="mac"
                value={@custom_mac}
                placeholder="00:11:22:33:44:55"
                class="input input-bordered flex-1 font-mono"
                pattern="^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$"
                required
              />
              <button type="submit" class="btn btn-secondary">
                Send WoL Packet
              </button>
            </form>
          </div>
        </div>
        
    <!-- Flash Message -->
        <%= if @flash_message do %>
          <div class={"alert mt-6 " <> if(@flash_type == :success, do: "alert-success", else: "alert-error")}>
            <span>{@flash_message}</span>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("wake", %{"mac" => mac, "name" => name}, socket) do
    case Wol.wake(mac) do
      :ok ->
        {:noreply,
         socket
         |> assign(:flash_message, "Magic packet sent to #{name} (#{mac})")
         |> assign(:flash_type, :success)}

      {:error, reason} ->
        {:noreply,
         socket
         |> assign(:flash_message, "Failed to wake #{name}: #{inspect(reason)}")
         |> assign(:flash_type, :error)}
    end
  end

  def handle_event("wake_custom", %{"mac" => mac}, socket) do
    case Wol.wake(mac) do
      :ok ->
        {:noreply,
         socket
         |> assign(:flash_message, "Magic packet sent to #{mac}")
         |> assign(:flash_type, :success)
         |> assign(:custom_mac, "")}

      {:error, reason} ->
        {:noreply,
         socket
         |> assign(:flash_message, "Failed: #{inspect(reason)}")
         |> assign(:flash_type, :error)}
    end
  end
end
