#!/bin/sh

mkdir -p /var/lib/node_exporter/textfile_collector
gosu nobody sh -c "/usr/local/bin/cpu_temp.sh" &

while true; do
  gosu nobody sh -c "/usr/local/bin/cpu_temp.sh"
  sleep 5
done &

exec gosu nobody /usr/local/bin/node_exporter --collector.textfile.directory=/var/lib/node_exporter/textfile_collector "$@"
