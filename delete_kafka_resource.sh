#!/bin/bash
set -e

echo "Deleting Kafka resources..."
kubectl delete kafkatopic orders-topic -n kafka-prod
kubectl delete kafkauser kafka-user -n kafka-prod
kubectl delete kafkanodepool broker -n kafka-prod
kubectl delete kafkanodepool controller -n kafka-prod

# 클러스터를 반드시 마지막에 삭제해야 orders-topic 리소스가 정상적으로 삭제된다.
kubectl delete kafka kafka-cluster -n kafka-prod
kubectl delete secret kafka-user -n kafka-prod

sleep 5
kubectl delete pvc -n kafka-prod -l strimzi.io/cluster=kafka-cluster
