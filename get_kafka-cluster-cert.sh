#!/bin/bash
set -e

kubectl get secret kafka-cluster-cert -o jsonpath='{.data.ca\.crt}' -n kafka-prod | base64 --decode > root.crt
echo "Kafka cluster CA certificate has been saved to root.crt"
