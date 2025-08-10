# Minimal transmission download monitor

Real-time terminal monitor for Transmission BitTorrent client showing active torrents with progress bars and download speeds.

<img width="605" height="184" alt="image" src="https://github.com/user-attachments/assets/27c21eeb-436d-44f8-a900-45a57fb9c4b2" />

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
