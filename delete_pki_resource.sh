#!/bin/bash
set -e

echo "Deleting PKI resources..."
kubectl delete -R -f base/pki/
