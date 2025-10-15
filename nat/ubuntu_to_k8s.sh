#!/bin/bash
set -e

METALLB_IP_RANGE=10.100.100.0/24

NODE_IP=$(minikube ip)

NET_PREFIX=$(echo $NODE_IP | cut -d. -f1-3)
BR_NETWORK_INTERFACE=$(ip -o -4 addr show | awk -v prefix="$NET_PREFIX" '$4 ~ "^"prefix {print $2}')
SPEAKER_POD_IP=$(kubectl get pods -n metallb-system -o jsonpath='{range .items[?(@.metadata.name contains "metallb-speaker")]}{.status.hostIP}{"\n"}{end}' | head -n1)

echo "Node IP: $NODE_IP"
echo "Pod IP Range: $METALLB_IP_RANGE"
echo "Bridge Network Interface: $BR_NETWORK_INTERFACE"
echo "Speaker Pod IP: $SPEAKER_POD_IP"

if [[ -z "$NODE_IP" || -z "$METALLB_IP_RANGE" || -z "$BR_NETWORK_INTERFACE" || -z "$SPEAKER_POD_IP" ]]; then
  echo "❌ Error: One or more required variables are empty:"
  [[ -z "$NODE_IP" ]] && echo "  - NODE_IP"
  [[ -z "$METALLB_IP_RANGE" ]] && echo "  - METALLB_IP_RANGE"
  [[ -z "$BR_NETWORK_INTERFACE" ]] && echo "  - BR_NETWORK_INTERFACE"
  [[ -z "$SPEAKER_POD_IP" ]] && echo "  - SPEAKER_POD_IP"
  echo "⚠️ Please make sure all variables are set before running this script."
  exit 1
fi

sudo ip route add $METALLB_IP_RANGE via $SPEAKER_POD_IP dev $BR_NETWORK_INTERFACE
