# Multi-Host-Fabric-Network
Hyperledger Fabric Multi Network Using Docker Swarm, Docker Stack



## Network Topology

* pc1 :  zookeeper1, kafka0, orderer0, 

* pc2 :  zookeeper2, kafka1, orderer1, 

* pc3 :  zookeeper3, kafka2, orderer2, 

* pc4 :  kafka3, ca1(org1), peer0-org1, peer1-org1, couchdb0, couchdb1, org1cli

* pc5 :  ca2(org2), peer0-org2, peer1-org2, couchdb2, couchdb3, org2cli



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



##Docker  설치

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

아래의 명령어를 사용하여 docker에 계정추가후 도커재시작

```sh
$ sudo usermod -aG docker $USER
$ sudo service docker restart
```

아래의 명령어를 사용하여 설치확인

```sh
$ docker -v
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



## 네트워크 시작

**Hyperledger Fabric 1.2 ,third-party image, binary file다운로드**

```sh
$ ./bootstrap.sh
```

**cryptogen 명령어로 인증서 및 키 생성**

```sh
$ ./cryptogen.sh
```

**configtxgen 명령어로 channel,  genesis block, anchorpeer설정파일 생성**

```sh
$ ./configtxgen.sh
```

**ca1,ca2의 환경변수에 Private Key 삽입**

```sh
$ ./replacekey.sh
```





