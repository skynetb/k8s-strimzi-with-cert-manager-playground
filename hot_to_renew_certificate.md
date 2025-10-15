# cmctl 사용

아래의 문서를 참고

[cert-manager cmctl](https://cert-manager.io/v1.18-docs/reference/cmctl/)

[cmctl github](https://github.com/cert-manager/cmctl)


# cert-manager로 발급된 인증서 가져오기

```sh
/get_kafka-cluster-cert.sh

Kafka cluster CA certificate has been saved to root.crt
```

# cert-manager의 certificate 리소스 확인

```sh
kubectl get certificate -n kafka-prod

NAME                 READY   SECRET               AGE
kafka-cluster-cert   True    kafka-cluster-cert   15h
```

# cmctl로 수동 갱신

```sh
cmctl renew kafka-cluster-cert -n kafka-prod

Manually triggered issuance of Certificate kafka-prod/kafka-cluster-cert
```

인증서 갱신 확인
```sh
kubectl describe certificate -n kafka-prod

kubectl get secret -n kafka-prod kafka-cluster-cert
```
