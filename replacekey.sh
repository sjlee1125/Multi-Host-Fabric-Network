CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-org1.yaml
cd crypto-config/peerOrganizations/org2.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-org2.yaml
# If MacOSX, remove the temporary backup of the docker-compose file
if [ "$ARCH" == "Darwin" ]; then
  rm docker-compose-org1.yamlt
  rm docker-compose-org2.yamlt
fi
