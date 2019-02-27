# Multi-Host-Fabric-Network
Hyperledger Fabric Multi Network Using Docker Swarm, Docker Stack



## Network Topology

* pc1 :  zookeeper1, kafka0, orderer0, 

* pc2 :  zookeeper2, kafka1, orderer1, 

* pc3 :  zookeeper3, kafka2, orderer2, 

* pc4 :  kafka3, ca1(org1), peer0-org1, peer1-org1, couchdb0, couchdb1, org1cli

* pc5 :  ca2(org2), peer0-org2, peer1-org2, couchdb2, couchdb3, org2cli



## 사전필요사항

* NodeJS v.8.9.4
* go1.11.2
* Docker 18.09.1
* Docker-Compose 1.18.0
* python 2.7
* 이상 https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html 참조



