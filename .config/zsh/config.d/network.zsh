digall() {
    local domain=$1
    local -a types=(A AAAA CNAME MX NS TXT)
    
    echo "🔍 resolving $domain"
    for type in $types; do
        echo "\n$type records:"
        dog $domain $type
    done
}

function wifi(){
nmcli -f 'bssid,signal,bars,freq,ssid' --color yes device wifi |
  fzf \
  --with-nth=2.. \
  --ansi \
  --height=40% \
  --reverse \
  --cycle \
  --inline-info \
  --header-lines=1 \
  --bind="enter:execute:sudo nmcli -a device wifi connect {1}"
}

function net() {
  local device=$(sudo nmcli -f DEVICE,TYPE,STATE,CONNECTION device | tail -n +2 | \
      fzf --header-lines=0 \
          --preview 'echo -e "\033[1;36mIP Info:\033[0m"; \
                    sudo ip -c a show {1}; \
                    echo -e "\n\033[1;36mDNS Settings:\033[0m"; \
                    nmcli device show {1} | rg -i dns | choose 1; \
                    echo -e "\n\033[1;36mGateway:\033[0m"; \
                    nmcli device show {1} | rg -i gateway | choose 1; \
                    echo -e "\n\033[1;36mLink Status:\033[0m"; \
                    ethtool {1} 2>/dev/null | rg -i "speed|duplex|link detected" | choose 0.. || echo "No link info"' \
          --preview-window=right:50%:wrap)
  [ -z "$device" ] && return 1
  
  device=$(echo "$device" | awk '{print $1}')
  
  local action=$(echo -e "edit\nup\ndown" | fzf --header="What to do with $device?")
  
  case $action in
      "edit")
          local conn=$(sudo nmcli -f NAME,DEVICE connection show | grep "$device" | awk '{print $1}')
          sudo nmcli connection edit "$conn"
          ;;
      "up")
          sudo nmcli device connect "$device"
          ;;
      "down")
          sudo nmcli device disconnect "$device"
          ;;
  esac
}
