#!/bin/bash
# Setup script for raspi-large gateway

set -e

echo "Configuring Tailscale Serve..."
sudo tailscale serve reset
sudo tailscale serve --bg --set-path / https+insecure://192.168.178.151:443
sudo tailscale serve --bg --set-path /app http://127.0.0.1:4000

echo "Starting Phoenix app..."
cd /home/t/wol_service
mix deps.get --only prod
MIX_ENV=prod mix compile
MIX_ENV=prod mix phx.server &

echo "Setup complete!"
echo ""
echo "URLs:"
echo "  NAS:      https://raspi-large.bass-mora.ts.net/"
echo "  Admin UI: https://raspi-large.bass-mora.ts.net/app/"
echo "  WoL API:  https://raspi-large.bass-mora.ts.net/app/api/wake"
echo ""
sudo tailscale serve status
