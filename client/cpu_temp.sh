#!/bin/bash

TEMP_FILE="/var/lib/node_exporter/textfile_collector/cpu_temp.prom"

# Clear the previous contents of the temp file
rm -f "$TEMP_FILE"

# Get JSON output from sensors
SENSORS_JSON=$(sensors -j)

# Check if sensors output contains Intel or AMD CPU information
IS_INTEL=$(echo "$SENSORS_JSON" | jq 'keys[] | test("coretemp-isa-")' | grep -q "true" && echo "true" || echo "false")
IS_AMD=$(echo "$SENSORS_JSON" | jq 'keys[] | test("k10temp-pci-")' | grep -q "true" && echo "true" || echo "false")

if [ "$IS_INTEL" = "true" ]; then
  # Intel CPU(s)

  INTEL_KEYS=$(echo "$SENSORS_JSON" | jq -r 'keys[] | select(test("coretemp-isa-"))')

  PACKAGE_COUNTER=0
  for p in $INTEL_KEYS; do
    PACKAGE_TEMP=$(echo "$SENSORS_JSON" | jq ".\"$p\".\"Package id $PACKAGE_COUNTER\".temp1_input")
    echo "node_cpu_temperature{package=\"$PACKAGE_COUNTER\"} $PACKAGE_TEMP" >> "$TEMP_FILE"
    PACKAGE_COUNTER=$((PACKAGE_COUNTER + 1))
  done

elif [ "$IS_AMD" = "true" ]; then
  # AMD CPU(s)

  AMD_KEYS=$(echo "$SENSORS_JSON" | jq -r 'keys[] | select(test("k10temp-pci-"))')

  PACKAGE_COUNTER=0
  for p in $AMD_KEYS; do
    PACKAGE_TEMP=$(echo "$SENSORS_JSON" | jq ".\"$p\".Tdie.temp1_input")
    echo "node_cpu_temperature{package=\"$PACKAGE_COUNTER\"} $PACKAGE_TEMP" >> "$TEMP_FILE"
    PACKAGE_COUNTER=$((PACKAGE_COUNTER + 1))
  done

else
  echo "No Intel or AMD CPU information found in sensors output." > "$TEMP_FILE"
  exit 1
fi
