#!/bin/bash

CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-pc4.yaml
cd crypto-config/peerOrganizations/org2.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-pc5.yaml
