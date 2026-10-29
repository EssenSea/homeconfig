#!/bin/sh
# Waybar custom module: report CPU temperature.
#
# The hwmonN index of coretemp is not stable across reboots, so resolve the
# sensor by its `name` attribute instead of hardcoding a path.
# Output is JSON so that the CSS class can follow warning/critical levels.

SENSOR=${WAYBAR_TEMP_SENSOR:-coretemp}
WARN=${WAYBAR_TEMP_WARN:-75}
CRIT=${WAYBAR_TEMP_CRIT:-85}

emit() {
    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$1" "$2" "$3"
}

for hw in /sys/class/hwmon/hwmon*; do
    read -r name < "$hw/name" 2>/dev/null || continue
    [ "$name" = "$SENSOR" ] || continue

    read -r milli < "$hw/temp1_input" 2>/dev/null || continue
    temp=$((milli / 1000))

    class=normal
    [ "$temp" -ge "$WARN" ] && class=warning
    [ "$temp" -ge "$CRIT" ] && class=critical

    emit "T: ${temp}°C" "$class" "${SENSOR} ${temp}°C\n${hw}"
    exit 0
done

emit "T: n/a" "normal" "${SENSOR} sensor not found"
