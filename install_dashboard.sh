#!/bin/bash
set -e

helm install kubernetes-dashboard ./dependency/kubernetes-dashboard \
  --namespace kubernetes-dashboard \
  --create-namespace \
  --wait \
  --timeout 120s
