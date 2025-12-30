defmodule WolService.Wol do
  @moduledoc """
  Wake-on-LAN magic packet builder and sender.
  """

  @broadcast_address {255, 255, 255, 255}
  @wol_port 9

  @doc """
  Parses a MAC address string into a 6-byte binary.
  Supports formats: "AA:BB:CC:DD:EE:FF" or "AA-BB-CC-DD-EE-FF"
  """
  def parse_mac(mac_string) do
    mac_string
    |> String.upcase()
    |> String.replace(~r/[:-]/, "")
    |> String.to_charlist()
    |> Enum.chunk_every(2)
    |> Enum.map(fn chars -> List.to_integer(chars, 16) end)
    |> :binary.list_to_bin()
  end

  @doc """
  Builds a Wake-on-LAN magic packet for the given MAC address.
  Returns a 102-byte binary.
  """
  def build_magic_packet(mac_string) do
    mac_bytes = parse_mac(mac_string)
    header = <<0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>
    mac_repeated = String.duplicate(mac_bytes, 16)
    header <> mac_repeated
  end

  @doc """
  Sends a Wake-on-LAN magic packet to wake the device with the given MAC address.
  """
  def wake(mac_string) do
    packet = build_magic_packet(mac_string)
    
    {:ok, socket} = :gen_udp.open(0, [:binary, {:broadcast, true}])
    result = :gen_udp.send(socket, @broadcast_address, @wol_port, packet)
    :gen_udp.close(socket)
    
    result
  end
end
