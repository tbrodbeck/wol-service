defmodule WolService.WolTest do
  use ExUnit.Case, async: true

  alias WolService.Wol

  describe "build_magic_packet/1" do
    test "builds a valid 102-byte magic packet" do
      mac = "AA:BB:CC:DD:EE:FF"
      packet = Wol.build_magic_packet(mac)

      assert byte_size(packet) == 102
    end

    test "starts with 6 bytes of 0xFF" do
      mac = "11:22:33:44:55:66"
      packet = Wol.build_magic_packet(mac)

      <<header::binary-size(6), _rest::binary>> = packet
      assert header == <<0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>
    end

    test "contains MAC address repeated 16 times" do
      mac = "AA:BB:CC:DD:EE:FF"
      packet = Wol.build_magic_packet(mac)

      <<_header::binary-size(6), mac_section::binary>> = packet
      mac_bytes = <<0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF>>
      expected = String.duplicate(mac_bytes, 16)

      assert mac_section == expected
    end

    test "handles lowercase MAC addresses" do
      mac = "aa:bb:cc:dd:ee:ff"
      packet = Wol.build_magic_packet(mac)

      assert byte_size(packet) == 102
    end

    test "handles MAC addresses with dashes" do
      mac = "AA-BB-CC-DD-EE-FF"
      packet = Wol.build_magic_packet(mac)

      assert byte_size(packet) == 102
    end
  end

  describe "parse_mac/1" do
    test "parses colon-separated MAC" do
      assert Wol.parse_mac("AA:BB:CC:DD:EE:FF") == <<0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF>>
    end

    test "parses dash-separated MAC" do
      assert Wol.parse_mac("AA-BB-CC-DD-EE-FF") == <<0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF>>
    end

    test "parses lowercase MAC" do
      assert Wol.parse_mac("aa:bb:cc:dd:ee:ff") == <<0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF>>
    end
  end
end
