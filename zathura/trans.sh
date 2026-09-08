# trans :zh -b $(wl-paste | tr -d '/n' | sed "s/^[0-9]\+[[:space:]]\+//" | sed 's/^.*$/"&"/') | xargs -I {} notify-send  "Translation:" "{}"
trans :zh -j -b $(wl-paste | tr '/n' ' ' | sed "s/^[0-9]\+[[:space:]]\+//") | xargs -I {} notify-send  "Translation:" "{}"

