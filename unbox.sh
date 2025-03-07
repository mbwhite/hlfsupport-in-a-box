#!/bin/bash

set -e -u -o pipefail
ROOTDIR=$(cd "$(dirname "$0")" && pwd)
: ${IMAGE_NAME:=ghcr.io/hyperledgendary/hlfsupport-in-a-box:main}

mkdir -p ${ROOTDIR}/_cfg

if [ ! -f cfg.env ]; then
  echo "Please ensure a cfg.env file is present"
  exit 1
fi

# attach these to the host network so it's easier for networking and map in the kubeconfig location
docker run --env-file cfg.env -it --network=host -v ${HOME}/.kube/:/root/.kube/ -v ${ROOTDIR}/_cfg:/workspace/_cfg ${IMAGE_NAME} console
docker run --env-file cfg.env -it --network=host -v ${HOME}/.kube/:/root/.kube/ -v ${ROOTDIR}/_cfg:/workspace/_cfg ${IMAGE_NAME} network

echo 
echo -----------------------------------------------------------------------------------------------------
echo
echo "Console is available at this URL = " $(cat _cfg/auth-vars.yml | grep api_endpoint | cut -c 15-)
echo
echo "Username = nobody@ibm.com"
echo "Password = new42day"
