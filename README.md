# Minimal transmission download monitor

Real-time terminal monitor for Transmission BitTorrent client showing active torrents with progress bars and download speeds.

## Setup

Set environment variables (you can set these to .bashrc alongside your alias):
```bash
export TRANSMISSION_URL='https://your-server.com:443/transmission/'
export TRANSMISSION_USER='your-username'
export TRANSMISSION_PASS='your-password'
```

## Usage

```bash
./transmission-monitor.sh
```

Press `Ctrl+C` to exit.