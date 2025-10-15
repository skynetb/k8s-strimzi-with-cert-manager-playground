#!/bin/bash
set -e

POD_NET="10.100.100.0/24"
HOST_EX_NETWORK_INTERFACE="enp0s1" # Mac Host Network Interface

NODE_IP=$(minikube ip)

NET_PREFIX=$(echo $NODE_IP | cut -d. -f1-3)
BR_NETWORK_INTERFACE=$(ip -o -4 addr show | awk -v prefix="$NET_PREFIX" '$4 ~ "^"prefix {print $2}')


echo "Node IP: $NODE_IP"
echo "Pod Net: $POD_NET"
echo "Bridge Network Interface: $BR_NETWORK_INTERFACE"
echo "Host Network Interface: $HOST_EX_NETWORK_INTERFACE"

if [[ -z "$NODE_IP" || -z "$POD_NET" || -z "$BR_NETWORK_INTERFACE" || -z "$HOST_EX_NETWORK_INTERFACE" ]]; then
  echo "❌ Error: One or more required variables are empty:"
  [[ -z "$NODE_IP" ]] && echo "  - NODE_IP"
  [[ -z "$POD_NET" ]] && echo "  - POD_NET"
  [[ -z "$BR_NETWORK_INTERFACE" ]] && echo "  - BR_NETWORK_INTERFACE"
  [[ -z "$HOST_EX_NETWORK_INTERFACE" ]] && echo "  - HOST_EX_NETWORK_INTERFACE"
  echo "⚠️ Please make sure all variables are set before running this script."
  exit 1
fi

sudo iptables -I FORWARD 1 \
  -i "$HOST_EX_NETWORK_INTERFACE" \
  -o "$BR_NETWORK_INTERFACE" \
  -d "$POD_NET" \
  -j ACCEPT

sudo iptables -I FORWARD 2 \
  -i "$BR_NETWORK_INTERFACE" \
  -o "$HOST_EX_NETWORK_INTERFACE" \
  -s "$POD_NET" \
  -j ACCEPT