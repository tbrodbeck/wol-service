#!/bin/bash
# Setup script for raspi-large gateway

set -e

echo "Configuring Tailscale Serve..."
sudo tailscale serve reset
sudo tailscale serve --bg --set-path / https+insecure://192.168.178.151:443
sudo tailscale serve --bg --set-path /api http://127.0.0.1:4000

echo "Starting Phoenix app..."
cd /home/t/wol_service
mix deps.get --only prod
MIX_ENV=prod mix compile
MIX_ENV=prod mix phx.server &

echo "Setup complete!"
sudo tailscale serve status
