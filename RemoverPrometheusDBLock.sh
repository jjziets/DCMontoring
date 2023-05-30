#!/bin/bash

# Location of the lock file
LOCKFILE=/var/lib/docker/volumes/prometheuse_prometheus-data/_data/data/lock #update to the location of the lock file

# If the lock file exists, remove it
if [ -f "$LOCKFILE" ]; then
    echo "Lock file exists, removing..."
    rm -f "$LOCKFILE"
    echo "Lock file removed."
else
    echo "No lock file found."
fi
