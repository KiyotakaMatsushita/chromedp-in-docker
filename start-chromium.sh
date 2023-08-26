#!/bin/sh
# start-chromium.sh

# Start Chromium in the background
nohup chromium --headless --disable-gpu --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --no-sandbox > /dev/null 2>&1 &

# Wait for Chromium to start
while ! curl -s http://0.0.0.0:9222/json/version > /dev/null; do
  echo "Waiting for Chromium to start..."
  sleep 1
done

# Start the Go application
exec "$@"