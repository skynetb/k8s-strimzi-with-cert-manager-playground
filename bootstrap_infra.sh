#!/bin/bash
set -e

echo "------------------------------------------------------------"
echo "🔎 Starting Infra Bootstrapping..."
echo "------------------------------------------------------------"

kubectl apply -f app/namespace.yaml

helm install metallb ./dependency/metallb \
  --namespace metallb-system \
  --create-namespace \
  --wait \
  --timeout 120s

kubectl apply -f base/ip.yaml

echo "------------------------------------------------------------"
echo "🪛 Installing PKI"
echo "------------------------------------------------------------"

helm install cert-manager ./dependency/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true \
  --wait \
  --timeout 120s

kubectl patch deployment \
  cert-manager \
  --namespace cert-manager  \
  --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--enable-certificate-owner-ref"}]'


helm install trust-manager ./dependency/trust-manager \
  --namespace cert-manager \
  --create-namespace \
  --set secretTargets.enabled=true \
  --set secretTargets.authorizedSecretsAll=true \
  --wait \
  --timeout 120s

# 일단 이걸로
kubectl apply -R -f base/pki

# helm install pki ./base/pki \
#   --namespace cert-manager \
#   --wait \
#   --timeout 120s


echo "------------------------------------------------------------"
echo "🪛 Installing Kafka Operator"
echo "------------------------------------------------------------"
helm install strimzi-kafka-operator ./dependency/strimzi-kafka-operator \
  --wait \
  --timeout 180s \
  --namespace kafka-infra \
  --create-namespace \
  --set watchNamespaces={kafka-prod}
