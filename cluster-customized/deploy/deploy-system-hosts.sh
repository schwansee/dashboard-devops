#!/bin/bash

function install_system_hosts() {
  if [ ! -f /etc/hosts.bak ]; then 
    sudo cp /etc/hosts{,.bak}
  fi

  if [ ! -f /etc/host.gcr ]; then
    sudo bash -c 'cat << EOF >> /etc/hosts

# gcr
64.233.162.83   www.gcr.io gcr.io
64.233.162.83   https://gcr.io/
64.233.162.83   accounts.google.com
64.233.162.83   storage.googleapis.com
EOF'

    sudo cp /etc/hosts{,.gcr}
  fi
}

function uninstall_system_hosts() {
  if [ -f /etc/hosts.gcr -a -f /etc/hosts.bak ]; then 
    sudo cp /etc/hosts{.bak,}
    sudo rm /etc/hosts.{gcr,bak}
  fi
}
