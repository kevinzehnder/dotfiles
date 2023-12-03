function aks() {
  if [[ -n "$AKS_CLUSTER" && -n "$AKS_RG" ]]; then
     # Customize the appearance of the segment
     az aks "$@" --name $AKS_CLUSTER --resource-group $AKS_RG | gojq
 else
     echo "Error: Configure ENV variables AKS_CLUSTER and AKS_RG"
 fi
}

function prompt_aks_context() {
  p10k segment -i '⎈' -f 208 -t "$AKS_CLUSTER ($AKS_RG)"
}

function aks-toggle() {
  if (( ${+POWERLEVEL9K_AKS_CONTEXT_SHOW_ON_COMMAND} )); then
    unset POWERLEVEL9K_AKS_CONTEXT_SHOW_ON_COMMAND
  else
    POWERLEVEL9K_AKS_CONTEXT_SHOW_ON_COMMAND='aks'
  fi
  p10k reload
  if zle; then
    zle push-input
    zle accept-line
  fi
}

zle -N aks-toggle

