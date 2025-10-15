# K8s Strimzi with cert-manager kafka-cluster playground

## 개요
미니쿠베(쿠버네티스 v1.34), kubectl v1.34.1, helm v3.19.0에서 테스트 되었다.
맥북 14 M3 Pro 36GB macOS 26.0.1로 테스트되었다.
VM은 UTM로 설치된 ubuntu server 24.04.3 ARM64 2Core, 8GB의 사양에서 테스트 되었다.
그 외의 쿠버네티스 의존성은 [여기를 참고](dependency/README.md)할 것

strimzi와 cert-manager 솔루션을 이용하여 kafka-cluster(tls, SHA-SCRAM-512 비밀번호 인증)를 배포하는 환경이다.

쿠버네티스는 VM 우분투에서 돌리며, 호스트 맥에서 쿠버네티스 파드까지 접근하는 과정은 [여기를 참고](how_to_connect_k8s.md)할 것


## 미니쿠베 시작
```sh
minikube start --memory=6144 --cpus=2
```

## 미니쿠베 중지 및 전체 프로필 삭제(모든 프로필의 잔여 파일을 삭제한다)
```sh
minikube stop && minikube delete --all
```


## 쿠버네티스 의존성 설치

쿠버네티스 인프라를 설치한다.
```sh
./bootstrap_infra.sh
```

쿠버네티스 앱을 설치한다.
```sh
./bootstrap_app.sh
```


## 쿠버네티스 대시보드

디버깅을 쉽게 하고 싶다면 아래의 대시보드를 설치하자.
```sh
./install_dashboard.sh
```

쿠버네티스 대시보드의 auth 키를 발급 받고 포트포워딩을 켜는 스크립트를 실행하자.
```sh
./enable_dashboard.sh
```
