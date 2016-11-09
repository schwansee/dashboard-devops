#!/bin/bash

PACKAGE_PATH=${PACKAGE_PATH:-$HOME/dashboard_packages}
DOCKER_VERSION=${DOCKER_VERSION:-"1.9.1"}

source ./deploy-check-deps.sh
  
function get_docker_deps_deb() {
  echo "Package path: $PACKAGE_PATH"
  
  echo -n "get apt-transport-https"
  if [ ! -f ${PACKAGE_PATH}/docker/apt-transport-https_1.0.1ubuntu2.14_amd64.deb ]; then
    wget http://launchpadlibrarian.net/260146303/apt-transport-https_1.0.1ubuntu2.14_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null 
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - apt-transport-https_1.0.1ubuntu2.14_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"
  
  echo -n "get aufs-tools"
  if [ ! -f ${PACKAGE_PATH}/docker/aufs-tools_3.2+20130722-1.1_amd64.deb ]; then
    wget https://launchpad.net/ubuntu/+source/aufs-tools/1:3.2+20130722-1.1/+build/5854773/+files/aufs-tools_3.2+20130722-1.1_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - aufs-tools_3.2+20130722-1.1_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"
  
  echo -n "get ca-certificates"
  if [ ! -f ${PACKAGE_PATH}/docker/ca-certificates_20160104ubuntu0.14.04.1_all.deb ]; then
    wget http://launchpadlibrarian.net/236986509/ca-certificates_20160104ubuntu0.14.04.1_all.deb -P ${PACKAGE_PATH}/docker >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - ca-certificates_20160104ubuntu0.14.04.1_all.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"
  
  echo -n "get cgroup-lite"
  if [ ! -f ${PACKAGE_PATH}/docker/cgroup-lite_1.9_all.deb ]; then
    wget http://launchpadlibrarian.net/171403674/cgroup-lite_1.9_all.deb -P ${PACKAGE_PATH}/docker >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - cgroup-lite_1.9_all.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"

  echo -n "get docker-engine"
  if [ ! -f ${PACKAGE_PATH}/docker/docker-engine_1.9.1-0~trusty_amd64.deb ]; then
    wget https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.9.1-0~trusty_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - docker-engine_1.9.1-0~trusty_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"
  
  echo -n "get libltdl7"
  if [ ! -f ${PACKAGE_PATH}/docker/libltdl7_2.4.2-1.7ubuntu1_amd64.deb ]; then
    wget http://launchpadlibrarian.net/165627482/libltdl7_2.4.2-1.7ubuntu1_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - libltdl7_2.4.2-1.7ubuntu1_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"
 
  echo -n "get libsystemd-journal0"
  if [ ! -f ${PACKAGE_PATH}/docker/libsystemd-journal0_204-5ubuntu20.19_amd64.deb ]; then
    wget http://launchpadlibrarian.net/242858416/libsystemd-journal0_204-5ubuntu20.19_amd64.deb -P ${PACKAGE_PATH}/docker >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - libsystemd-journal0_204-5ubuntu20.19_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"
  
  echo -n "get linux-image-extra-virtual"
  if [ ! -f ${PACKAGE_PATH}/docker/linux-image-extra-virtual_3.13.0.93.100_amd64.deb ]; then
    wget http://launchpadlibrarian.net/273799511/linux-image-extra-virtual_3.13.0.93.100_amd64.deb -P ${PACKAGE_PATH}
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - linux-image-exists-virtual_3.13.0.93.100_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 110
    fi
  fi
  echo " ... done"
}

function install_docker_deps_apt() {
  sudo apt-get update
  result=`check_deps apt-transport-https`
  if [ $result == "no" ]; then
    sudo apt-get -y install apt-transport-https >& /dev/null
  fi

  result=`check_deps ca-certificates`
  if [ $result == "no" ]; then
    sudo apt-get -y install ca-certificates >& /dev/null
  fi

  result=`check_deps linux-image-extra-$(uname -r)`
  if [ $result == "no" ]; then
    sudo apt-get -y install linux-image-extra-$(uname -r) >& /dev/null
  fi
  result=`check_deps linux-image-extra-virtual`
  if [ $result == "no" ]; then
    sudo apt-get -y install linux-image-extra-virtual >& /dev/null
  fi

  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' | sudo tee /etc/apt/sources.list.d/docker.list

  sudo apt-get update

  result=`check_deps lxc-docker`
  if [ $result == "no" ]; then
    sudo apt-get purge lxc-docker
  fi

  sudo apt-cache policy docker-engine


  result=`check_deps docker-engine`
  if [ $result == "no" ]; then
    sudo apt-get -y install docker-engine >& /dev/null
  fi
}

function install_docker_deps_dpkg() {
  result=`check_deps apt-transport-https`
  if [ $result == "no" ]; then
    echo -n "Install apt-transport-https"
    sudo dpkg -i ${PACKAGE_PATH}/docker/apt-transport-https_1.0.1ubuntu2.14_amd64.deb >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - apt-transport-https_1.0.1ubuntu2.14_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 125
    fi
    echo " ... done"
  fi

  result=`check_deps ca-certificates`
  if [ $result == "no" ]; then
    echo -n "Install ca-certificates"
    sudo dpkg -i ${PACKAGE_PATH}/docker/ca-certificates_20160104ubuntu0.14.04.1_all.deb >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - ca-certificates_20160104ubuntu0.14.04.1_all.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 125
    fi
    echo " ... done"
  fi
  
  #sudo dpkg -i ${PACKAGE_PATH}/linux-image-extra-$(uname -r).deb
  #sudo dpkg -i ${PACKAGE_PATH}/linux-image-extra-virtual_3.13.0.93.100_amd64.deb
  
  echo "Purge the old repo if it exists."
  sudo apt-get purge lxc-docker >& /dev/null
  
  result=`check_deps aufs-tools`
  if [ $result == "no" ]; then
    echo "Install extra packages:  aufs-tools"
    sudo dpkg -i ${PACKAGE_PATH}/docker/aufs-tools_3.2+20130722-1.1_amd64.deb >& /dev/null
  fi

  result=`check_deps cgroup-lite`
  if [ $result == "no" ]; then
    echo "Install extra packages: cgroup-lite"
    sudo dpkg -i ${PACKAGE_PATH}/docker/cgroup-lite_1.9_all.deb >& /dev/null
  fi

  result=`check_deps libltdl7`
  if [ $result == "no" ]; then
    echo "Install extra packages: libltdl7"
    sudo dpkg -i ${PACKAGE_PATH}/docker/libltdl7_2.4.2-1.7ubuntu1_amd64.deb >& /dev/null
  fi
 
  result=`check_deps libsystemd-journal0`
  if [ $result == "no" ]; then
    echo "Install extra packages: libsystemd-journal0"
    sudo dpkg -i ${PACKAGE_PATH}/docker/libsystemd-journal0_204-5ubuntu20.19_amd64.deb >& /dev/null
  fi
  
  result=`check_deps docker-engine`
  if [ $result == "no" ]; then
    echo -n "Install Docker"
    sudo dpkg -i ${PACKAGE_PATH}/docker/docker-engine_${DOCKER_VERSION}-0~trusty_amd64.deb >& /dev/null
    if [ $? -ne 0 ]; then
      echo " ... failed"
      echo " please find another resource for the package - docker-engine_${DOCKER_VERSION}-0~trusty_amd64.deb"
      echo " download it and put it to the path: ${PACKAGE_PATH}/docker"
      exit 125
    fi
    echo " ... done"
  fi
}

function uninstall_docker_deps() {
  #echo "Uninstall apt-transport-https ca-certificates"
  #sudo apt-get -y remove --purge apt-transport-https ca-certificates

  echo "Uninstall aufs-tools cgroup-lite libltdl7 libsystemd-journal0 docker-engine"
  sudo apt-get remove --purge aufs-tools cgroup-lite docker-engine libltdl7 libsystemd-journal0
}
