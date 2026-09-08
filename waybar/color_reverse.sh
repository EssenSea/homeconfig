# !/bin/bash

reverse_hex_color () {
  local color=$1

  color=${color:1}

  reversed_color=$(echo $color | tr '0123456789abcdef' 'fedcba9876543210')

  echo "#$reversed_color"
}

if [ -f "everforest.css" ]; then

  sed -r  -i.bk -e '/#[0-9a-fA-F]{6}/ s//$(reverse_hex_color "\1")/g' everforest.css
  echo "Done"

else 
  echo "debug please"
fi
