#!/bin/bash
# Production deployment script for WoL Service

set -e

echo "==> WoL Service Production Deployment"
echo ""

# Check if .env exists
if [ ! -f /home/t/wol_service/.env ]; then
  echo "Creating .env file from template..."
  cp /home/t/wol_service/.env.example /home/t/wol_service/.env

  echo "Generating SECRET_KEY_BASE..."
  SECRET=$(mix phx.gen.secret)
  sed -i "s/CHANGEME_run_mix_phx_gen_secret/$SECRET/" /home/t/wol_service/.env

  echo "✓ Created .env with generated secret"
  echo ""
fi

# Install dependencies
echo "Installing dependencies..."
cd /home/t/wol_service
mix deps.get --only prod

# Compile application
echo "Compiling application..."
MIX_ENV=prod mix compile

# Build and digest assets
echo "Building and digesting assets..."
MIX_ENV=prod mix assets.deploy

# Setup systemd service
echo "Setting up systemd service..."
sudo cp /home/t/wol_service/infrastructure/wol-service.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable wol-service

# Configure Tailscale Serve
echo "Configuring Tailscale Serve..."
sudo tailscale serve reset
sudo tailscale serve --bg --set-path / https+insecure://192.168.178.151:443
sudo tailscale serve --bg --set-path /app http://127.0.0.1:4000

echo ""
echo "==> Deployment complete!"
echo ""
echo "To start the service:"
echo "  sudo systemctl start wol-service"
echo ""
echo "To view logs:"
echo "  sudo journalctl -u wol-service -f"
echo ""
echo "To check status:"
echo "  sudo systemctl status wol-service"
echo ""
echo "URLs:"
echo "  NAS:      https://raspi-large.tail8c06d8.ts.net/"
echo "  Admin UI: https://raspi-large.tail8c06d8.ts.net/app/"
echo "  WoL API:  https://raspi-large.tail8c06d8.ts.net/app/api/wake"
echo ""
