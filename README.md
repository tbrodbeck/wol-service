# WoL Service

A Wake-on-LAN service with web admin UI, built with Phoenix LiveView and designed to run behind Tailscale on a Raspberry Pi.

## Features

- **Web Admin UI** - One-click wake buttons for known devices
- **REST API** - Programmatic access to wake functionality
- **Tailscale Integration** - Secure access from anywhere on your tailnet
- **NAS Proxy** - Secure gateway to legacy/unsupported devices

## Architecture

```
Internet → Tailscale → Raspberry Pi → Local Network
                           │
                           ├── /     → QNAP NAS (proxied)
                           └── /app  → Phoenix WoL Service
```

The Pi acts as a secure gateway: only supported/updated devices are exposed to the Tailnet, while legacy devices (like unsupported NAS) stay isolated on the local network.

## URLs (Tailnet only)

| URL | Description |
|-----|-------------|
| `https://<hostname>/` | NAS web interface |
| `https://<hostname>/app/` | WoL Admin UI |
| `https://<hostname>/app/api/wake` | WoL REST API |

## API

### Wake a device

```bash
curl -X POST https://<hostname>/app/api/wake \
  -H "Content-Type: application/json" \
  -d {mac: 00:11:22:33:44:55}
```

**Response:**
```json
{"status": "ok", "message": "Magic packet sent to 00:11:22:33:44:55"}
```

## Prerequisites

- Raspberry Pi (or any Linux device) on the same network as target devices
- [Tailscale](https://tailscale.com/) installed and configured
- Erlang/OTP 27+ and Elixir 1.18+

## Installation

### Development Mode

1. Clone the repository:
   ```bash
   git clone https://github.com/tbrodbeck/wol-service.git
   cd wol-service
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Configure Tailscale Serve:
   ```bash
   sudo tailscale serve --bg --set-path /app http://127.0.0.1:4000
   ```

4. Start the development server:
   ```bash
   mix phx.server
   ```

### Production Mode (Docker)

The service runs in Docker on the Raspberry Pi. Deployment is automated via GitHub Actions on push to `main`.

**Manual deployment:**
```bash
make build                    # Build image locally
docker compose up -d          # Run with docker-compose
```

**CI/CD Pipeline:**
1. Push to `main` triggers GitHub Actions
2. Tests run via `make check`
3. Docker image built for `linux/arm64`
4. Pushed to GitHub Container Registry
5. Deployed to Pi via SSH

## Configuration

### Adding Known Devices

Edit `lib/wol_service_web/live/admin_live.ex`:

```elixir
@known_devices [
  %{name: "My NAS", mac: "00:11:22:33:44:55", description: "Storage server"},
  %{name: "Desktop", mac: "AA:BB:CC:DD:EE:FF", description: "Main workstation"}
]
```

### Tailscale Serve Configuration

See `infrastructure/tailscale-serve.json` for the current configuration.

## Development

Run `make` to see all available commands:

```bash
make              # Show all commands
make test         # Run tests
make format       # Format code
make check        # Run all checks (compile, credo, format, test, dialyzer)
make build        # Build Docker image locally
make run          # Run Docker container locally
```

## Tech Stack

- **Elixir 1.18** / **Erlang/OTP 27**
- **Phoenix 1.8** with LiveView
- **Tailwind CSS** with DaisyUI
- **Tailscale** for secure networking

## License

MIT
