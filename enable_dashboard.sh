#!/bin/bash
set -e

kubectl -n kubernetes-dashboard create sa admin-user --dry-run=client -o yaml | kubectl apply -f -

kubectl create clusterrolebinding admin-user-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:admin-user \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl -n kubernetes-dashboard create token admin-user --duration=24h


echo "------------------------------------------------------------"
echo "✅ Dashboard setup is complete."
echo "   You can access the Kubernetes Dashboard using the token above."
echo "------------------------------------------------------------"

kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
