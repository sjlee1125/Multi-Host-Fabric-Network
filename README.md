# Multi-Host-Fabric-Network
Hyperledger Fabric Multi Network Using Docker Swarm, Docker Stack



## Network Topology

* PC1 :  zookeeper1, kafka0, orderer0, 

* PC2 :  zookeeper2, kafka1, orderer1, 

* PC3 :  zookeeper3, kafka2, orderer2, 

* PC4 :  kafka3, ca1(org1), peer0-org1, peer1-org1, couchdb0, couchdb1, org1cli

* PC5 :  ca2(org2), peer0-org2, peer1-org2, couchdb2, couchdb3, org2cli



## 사전필요사항

* VM인스턴스 5대 (google cloud platform)
  * Ubuntu 18.04 LTS
  * sudo apt-get install build-essential (기본적인 라이브러리설치)
* NodeJS v.8.9.4
* npm 5.6
* go1.11.2
* Docker 18.09.01
* Docker-Compose 1.18.0
* python 2.7
* 이상 https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html 참조

* 5대 모두 사전필요사항 설치
* docker port개방



## NodeJS, npm 설치

nvm사용해서 NodeJS 설치

```shell
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash
$ source ~/.bashrc
$ nvm install v8.9.4
```

설치완료 확인

```sh
$ node -v
$ npm -v
```



## Docker  설치

아래의 명령어를 사용하여 설치에 필요한 패키지 설치

```sh
$ sudo apt-get update && sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```

아래의 명령어를 사용하여 패키지 저장소 추가

```sh
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

아래의 명렁어 사용하여 docker package 있는지 확인

```sh
$ sudo apt-get update && sudo apt-cache search docker-ce
```

Docker 설치

```sh
$ sudo apt-get update && sudo apt-get install docker-ce
```

아래의 명령어를 사용하여 docker에 계정추가후 재시작

```sh
$ sudo usermod -aG docker $USER
$ sudo reboot
```

아래의 명령어를 사용하여 설치확인

```sh
$ docker ps
```



## Docker-compose 설치

```sh
$ sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

아래의 명령어를 사용하여 설치확인

```sh
$ docker-compose -v
```



## GO 설치

```sh
$ curl -O https://storage.googleapis.com/golang/go1.11.2.linux-amd64.tar.gz
$ tar -xvf go1.11.2.linux-amd64.tar.gz
$ sudo mv go /usr/local
```

GOPATH 설정

```sh
$ vi ~/.bashrc
```

go 디렉토리 사용할것이기 때문에 맨 하단에 2줄 추가후 저장

```
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin
```

source 명령어 사용하여 수정된 값을 바로 적용

```sh
$ source ~/.bashrc
```

아래의 명령어 사용하여 버전 확인

```sh
$ go version
```



## Python 설치

```sh
$ sudo apt-get install python
$ python --version
```



---



## 네트워크 시작준비

**PC1**

* git repogitory clone

  ```sh
  $ mkdir go
  $ cd go
  $ git clone https://github.com/sjlee1125/Multi-Host-Fabric-Network.git
  $ cd Multi-Host-Fabric-Network
  ```

* Hyperledger Fabric 1.2 ,third-party image, binary file다운로드

  ```sh
  $ ./bootstrap.sh
  ```

* cryptogen 명령어로 인증서 및 키 생성

  ```sh
  $ ./cryptogen.sh
  ```

* configtxgen 명령어로 channel,  genesis block, anchorpeer설정파일 생성

  ```sh
  $ ./configtxgen.sh
  ```

---

**PC2, PC3, PC4, PC5**

* git repository clone

  ```sh
  $ mkdir go
  $ cd go
  $ git clone https://github.com/sjlee1125/Multi-Host-Fabric-Network.git
  $ cd Multi-Host-Fabric-Network
  ```

* Hyperledger Fabric 1.2 ,third-party image, binary file다운로드

  ```sh
  $ ./bootstrap.sh
  ```

* ssh로 전송하기 위해 /etc/ssh/sshd_config 파일의 PasswordAuthentication 부분 수정

  ```sh
  $ sudo vi /etc/ssh/sshd_config
  PasswordAuthentication no -> PasswordAuthentication yes 수정후 저장
  $ sudo systemctl restart ssh
  ```

* 계정 비밀번호설정

  ```sh
  $ sudo -i
  $ passwd "계정이름"
  ```

---

**PC1**

* PC2, PC3, PC4, PC5 instance에 **channel-artifacts**, **crypto-config** 디렉토리 같은경로에 복사

  ```sh
  $ scp -rq crypto-config/ channel-artifacts/ "계정이름"@"PC2호스트이름":/home/"계정이름"/go/Multi-Host-Fabric-Network/
  $ scp -rq crypto-config/ channel-artifacts/ "계정이름"@"PC3호스트이름":/home/"계정이름"/go/Multi-Host-Fabric-Network/
  $ scp -rq crypto-config/ channel-artifacts/ "계정이름"@"PC4호스트이름":/home/"계정이름"/go/Multi-Host-Fabric-Network/
  $ scp -rq crypto-config/ channel-artifacts/ "계정이름"@"PC5호스트이름":/home/"계정이름"/go/Multi-Host-Fabric-Network/
  ```

---

**PC4, PC5**

* ca1,ca2의 환경변수에 Private Key 삽입

  ```sh
  $ ./replacekey.sh
  ```

  

## 네트워크 시작 (docker swarm, docker stack)

**PC1**

* Initialize swarm

  ```sh
  $ docker swarm init
  ```

* 아래의 명령서 사용하여 PC2, PC3, PC4, PC5 swarm manage 등록

  ```sh
  $ docker swarm join-token manager
  ```

  명령어 사용후 나오는 아래와 같은 명령어 복사 후 PC2, PC3, PC4, PC5에 사용

  ```sh
  docker swarm join --token SWMTKN-1-23gxamkyfenf7ky3nl4f9if5ovmkmyh4jk5fepmhlseujpra65-06qfy2exlfc4m62frhgn3h55s 10.146.0.16:2377
  ```

  아래의 명령어로 잘추가가 되었나 swarm node 확인

  ```sh
  $ docker node ls
  ```

* fabric 이름으로 overlay network 생성

  ```sh
  $ docker network create --attachable --driver overlay fabric
  ```

---

**PC1, PC2, PC3, PC4, PC5**

* yaml파일의 hostname 수정

  ```sh
  $ vi change_hostname.sh
  ```

  10번째줄에 docker-compose-pc.yaml 부분을 각 PC Number에 맞추어 수정후 아래의 명령어 사용하여 hostname 변경 ex) docker-compose-pc.yaml -> docker-compose-pc1.yaml

  ```sh
  $ ./change_hostname.sh
  ```

* fabric이름의 stack 으로 각 PC 에서 docker-compose-pc파일 deploy

  * PC1

    ```sh
    $ docker stack deploy -c docker-compose-pc1.yaml fabric
    ```

  * PC2

    ```sh
    $ docker stack deploy -c docker-compose-pc2.yaml fabric
    ```

  * PC3

    ```sh
    $ docker stack deploy -c docker-compose-pc3.yaml fabric
    ```

  * PC4

    ```sh
    $ docker stack deploy -c docker-compose-pc4.yaml fabric
    ```

  * PC5

    ```sh
    $ docker stack deploy -c docker-compose-pc5.yaml fabric
    ```

* 아래 명령어로 docker stack service 확인

  ```sh
  docker service ls
  ```

  