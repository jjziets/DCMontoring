#!/bin/bash
while true; do

  TEMP_FILE="/var/lib/node_exporter/textfile_collector/cpu_temp.prom"

  # Remove the previous temp file
  rm -f "$TEMP_FILE"

  # Get JSON output from sensors
  SENSORS_JSON=$(sensors -j)

  # Check if sensors output contains Intel or AMD CPU information
  IS_INTEL=$(echo "$SENSORS_JSON" | jq 'keys[] | test("coretemp-isa-")' | grep -q "true" && echo "true" || echo "false")
  IS_AMD=$(echo "$SENSORS_JSON" | jq 'keys[] | test("k10temp-pci-")' | grep -q "true" && echo "true" || echo "false")
  IS_BNXT=$(echo "$SENSORS_JSON" | jq 'keys[] | test("bnxt_en-pci-")' | grep -q "true" && echo "true" || echo "false")


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
    PACKAGE_TEMP=$(echo "$SENSORS_JSON" | jq ".\"$p\".Tctl.temp1_input")
    if [ "$PACKAGE_TEMP" == "null" ]; then
      PACKAGE_TEMP=$(echo "$SENSORS_JSON" | jq ".\"$p\".Tdie.temp1_input")
    fi
    echo "node_cpu_temperature{package=\"$PACKAGE_COUNTER\"} $PACKAGE_TEMP" >> "$TEMP_FILE"
    PACKAGE_COUNTER=$((PACKAGE_COUNTER + 1))
  done

elif [ "$IS_BNXT" = "true" ]; then
  # bnxt_en-pci-

  BNXT_KEYS=$(echo "$SENSORS_JSON" | jq -r 'keys[] | select(test("bnxt_en-pci-"))' | head -1)

  PACKAGE_TEMP=$(echo "$SENSORS_JSON" | jq ".\"$BNXT_KEYS\".temp1.temp1_input")
  echo "node_cpu_temperature{package=\"0\"} $PACKAGE_TEMP" >> "$TEMP_FILE"

else
  echo "No Intel or AMD CPU information found in sensors output." > "$TEMP_FILE"
  exit 1
fi 
sleep 5
done &
