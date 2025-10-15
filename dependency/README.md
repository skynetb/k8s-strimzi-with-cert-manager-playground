# 의존성 (Dependencies)

이 문서는 쿠버네티스 클러스터에 배포되는 주요 Helm Chart 의존성과 버전을 정리합니다.  

---

## Kubernetes Infrastructure
| 의존성                    | 버전    | Namespace     |
|----------------------------|---------|---------------|
| kubernetes-dashboard       | v7.13.0 | kubernetes-dashboard |

## Kubernetes Loadbalancer
| 의존성                    | 버전    | Namespace     |
|----------------------------|---------|---------------|
| metallb                    | v0.15.2 | metallb       |

## PKI Infrastructure

| 의존성                    | 버전    | Namespace     |
|----------------------------|---------|---------------|
| cert-manager               | v1.18.2 | cert-manager  |
| trust-manager              | v0.18.0 | cert-manager  |

---

## Kafka Infrastructure

| 의존성                    | 버전    | Namespace   |
|----------------------------|---------|-------------|
| strimzi-kafka-operator     | 0.48.0  | kafka-infra |

---

## 의존성 Pull 방법

```bash
# kubernetes-dashboard
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm pull kubernetes-dashboard/kubernetes-dashboard --version v7.13.0 --untar

# metallb
helm repo add metallb https://metallb.github.io/metallb
helm repo update
helm pull metallb/metallb --version 0.15.2 --untar

# cert-manager
helm pull oci://quay.io/jetstack/charts/cert-manager --version v1.18.2 --untar

# trust-manager
helm pull oci://quay.io/jetstack/charts/trust-manager --version v0.18.0 --untar

# strimzi-kafka-operator
helm pull oci://quay.io/strimzi-helm/strimzi-kafka-operator --version 0.48.0 --untar
```
