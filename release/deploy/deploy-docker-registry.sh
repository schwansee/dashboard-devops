#!/bin/bash

PACKAGE_PATH=${PACKAGE_PATH:-$HOME/dashboard_packages}

IMAGE_PATH=$PACKAGE_PATH/images

DOCKER_REGISTRY_VERSION=${DOCKER_REGISTRY_VERSION:-2}

function install_docker_registry() {
  echo "load registry image"
#  sudo docker load < ${IMAGE_PATH}/registry-${DOCKER_REGISTRY_VERSION}.tar >& /dev/null
  
  echo "run registry and expose 5000 port"
  sudo docker stop registry && sudo docker rm registry
  sudo docker run -d -p 5000:5000 --restart=always --name registry registry:${DOCKER_REGISTRY_VERSION}
}

function push_image_to_registry() {
  IMAGE_NAME=$1
  IMAGE_VERSION=$2

  echo "load specified image - ${IMAGE_NAME}-${IMAGE_VERSION}.tar"
  sudo docker load < ${IMAGE_PATH}/${IMAGE_NAME}-${IMAGE_VERSION}.tar >& /dev/null

  echo "tag it and push to registry"
  sudo docker tag -f ${IMAGE_NAME}:${IMAGE_VERSION} localhost:5000/${IMAGE_NAME}-${IMAGE_VERSION}

  local counter=0
  sudo docker push localhost:5000/${IMAGE_NAME}-${IMAGE_VERSION}
  while [ $? -ne 0 ]
  do
    ((counter=counter+1))
    if [ $counter -lt 2 ]; then
      echo "try again $counter"
      sudo docker push localhost:5000/${IMAGE_NAME}-${IMAGE_VERSION}
    else
      echo "push image failed for $counter times"
      break
    fi
  done
}

function uninstall_docker_registry() {
  echo "stop and remove registry container"
  sudo docker stop registry && docker rm -v registry

  echo "remove registry image"
  sudo docker rmi register:${DOCKER_REGISTRY_VERSION}
}
