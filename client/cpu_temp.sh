#!/bin/bash

# Get the number of CPUs
CPU_COUNT=$(sensors | grep -Ec '^Package id [0-9]+:')

for CPU_INDEX in $(seq 0 $(($CPU_COUNT - 1))); do
  # Get the temperature for the current CPU
  CPU_TEMP=$(sensors | grep -oP "Package id $CPU_INDEX:\s+\+\K[\d.]+")

  # Output the metric for the current CPU
  echo "node_cpu_${CPU_INDEX}_temperature_celsius ${CPU_TEMP}"
done > /var/lib/node_exporter/textfile_collector/cpu_temp.prom
