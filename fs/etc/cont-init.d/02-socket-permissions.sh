#!/usr/bin/with-contenv ash

if [ -e "/var/run/docker.sock" ]; then
  echo "changing ownership of the docker socket..."
  chown -R "$PUID:$PGID" /var/run/docker.sock
else
  echo "Docker socket does not exist, skipping..."
fi