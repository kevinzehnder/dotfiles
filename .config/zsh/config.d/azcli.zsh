function aks() {
  if [[ -n "$AKS_CLUSTER" && -n "$AKS_RG" ]]; then
     # Customize the appearance of the segment
     az aks "$@" --name $AKS_CLUSTER --resource-group $AKS_RG
 else
     echo "Error: Configure ENV variables AKS_CLUSTER and AKS_RG"
 fi
}

