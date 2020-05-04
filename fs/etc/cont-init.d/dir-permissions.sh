#!/usr/bin/with-contenv ash

echo "Changing ownership of /app directory..."
chown -R "$PUID:$PGID" /app

echo "Creating & changing ownership of /certs directory..."
mkdir -p /certs
chown -R "$PUID:$PGID" /certs

echo "Creating & changing ownership of /data directory..."
mkdir -p /data
chown -R "$PUID:$PGID" /data