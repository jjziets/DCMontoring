#!/bin/bash

# Check if sensors output contains Intel or AMD CPU information
IS_INTEL=$(sensors | grep -E "Package id")
IS_AMD=$(sensors | grep -E "Tdie")

if [ -n "$IS_INTEL" ]; then
  # Intel CPU(s)

  # Get the number of CPU packages
  PACKAGES=$(sensors | grep -E "Package id [0-9]:" | wc -l)

  # Loop over each package
  for p in $(seq 0 "$((PACKAGES - 1))"); do
    # Get the package temperature
    PACKAGE_TEMP=$(sensors | grep "Package id $p:" | awk '{print $4}' | sed 's/+//' | sed 's/°C//')
    echo "node_cpu_temperature{package=\"$p\"} ${PACKAGE_TEMP}"
  done

elif [ -n "$IS_AMD" ]; then
  # AMD CPU(s)

  # Get the number of CPU packages
  PACKAGES=$(sensors | grep -E "Tdie" | wc -l)

  # Loop over each package
  for p in $(seq 0 "$((PACKAGES - 1))"); do
    # Get the package temperature
    PACKAGE_TEMP=$(sensors | grep -A1 "k10temp-pci" | grep "Tdie" | awk '{print $2}' | sed 's/+//' | sed 's/°C//' | awk "NR==$(($p+1))")
    echo "node_cpu_temperature{package=\"$p\"} ${PACKAGE_TEMP}"
  done

else
  echo "No Intel or AMD CPU information found in sensors output."
  exit 1
fi > /var/lib/node_exporter/textfile_collector/cpu_temp.prom
