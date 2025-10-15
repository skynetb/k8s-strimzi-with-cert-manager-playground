# 호스트 맥에서 VM 우분투의 컨테이너 기반 쿠버네티스 파드에 접근

# 개요

맥에서 UTM으로 동작하는 우분투 VM에 미니쿠베를 설치하고 호스트 맥과 VM 우분투에서 미니쿠베 내부 파드에 접근하는 방법을 살펴본다.

미니쿠베와 MetalLB로 할당되는 외부 IP를 호스트 맥과 VM 우분투에서 둘 다 접근 가능하게 만들기 위해서는 NAT 기술(구체적으로는 iptables로 라우팅 걸기)을 간단하게 사용 할 것이다.

아래의 망 구성도를 참고해서 이해하자.
외부에 할당되는 MetalLB IP 대역은 base/ip.yaml에 정의되어 있으며, 10.100.100.0/24 대역이며 대역이 겹치지 않게 유의해야 한다.
브릿지 네트워크 인터페이스, 미니 쿠베의 브릿지 네트워크 인터페이스와 cni0로 부터 할당 받는 ip는 모든 환경이 다르다.
오직, 외부로 할당 받는 MetalLB IP만 고정이다.
```yaml
[Mac 호스트]
   │
   │ enp0s8 (Host-VM Bridge Network Interface)
   │
[VM Ubuntu]
   ├─ enp0s8 (Mac ↔ VM)
   ├─ brXXXX (Minikube bridge)
   │     └─ [Minikube Node: kubelet, pods...]
   │             └─ cni0 (pod network, e.g. 10.244.100.0/24)
   │                   └─ [speaker pod] → [app pod]
```

## 맥에서 VM으로 트래픽 라우팅

맥에서 파드의 대역 ip를 vm의 ip로 보내기 위해 아래 명령 실행

맥에 라우팅 등록, VM 우분투의 브릿지 네트워크 ip(192.168.1.4)는 환경마다 모두 다르니 자기 환경에 맞게 적용할 것
```sh
sudo route -n add -net 10.100.100.0/24 192.168.1.4
```


맥에 라우팅 삭제
```sh
sudo route -n delete -net 10.100.100.0/24 192.168.1.4
```

라우팅 테이블 보기
```sh
netstat -rn
```

## VM 우분투에서 쿠버네티스 파드 IP의 트래픽을 브릿지 인터페이스로 매핑

VM 우분투에서 Cluster IP 대역을 k8s 브릿지로 포트포워딩

`nat/ubuntu_to_k8s.sh` VM 우분투에서 수행

VM 우분투에서 access_test의 nginx 파드 서비스에 접근해본다.
```sh
curl http://10.100.100.1
```


## VM 우분투에서 맥 호스트의 트래픽을 쿠버네티스 파드로 라우팅

VM 우분투에서 맥 호스트에서 들어오는 트래픽을 k8s 브릿지로 포트포워딩

호스트 맥과 VM 우분투을 연결하는 네트워크 인터페이스는 모두 다르니 쉘 스크립트를 참고해서 수정할 것
`nat/mac_to_ubuntu.sh` VM 우분투에서 수행


mac_to_ubuntu.sh에서 등록된 룰 확인
```sh
sudo iptables -L FORWARD -v --line-numbers
```

호스트 맥에서 access_test의 배포된 nginx 파드 서비스에 접근해본다.
```sh
curl http://10.100.100.1
```


# 포워딩 삭제
포워드 룰 삭제는 반드시 뒷 번호 부터 삭제해야 된다.
앞번호 부터 삭제하면 뒷번호가 앞으로 큐된다.

```sh
sudo iptables -D FORWARD 2
sudo iptables -D FORWARD 1
```
