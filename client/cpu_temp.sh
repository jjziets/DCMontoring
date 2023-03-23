#!/bin/bash

CPU_COUNT=$(sensors | grep -c "Package id")

for p in $(seq 0 "$((CPU_COUNT - 1))"); do
  CPU_TEMP=$(sensors | grep -oP "Package id $p:\s+\+\K[\d.]+")

  echo "node_cpu_temperature{package=\"$p\"} $CPU_TEMP"
done > /var/lib/node_exporter/textfile_collector/cpu_temp.prom
