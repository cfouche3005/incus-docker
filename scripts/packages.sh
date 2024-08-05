#!/bin/bash

opensuse-tumbleweed(){
    
}

ubuntu(){
    echo "Installing packages for Ubuntu"
    #common packages
    apt-get update
    apt-get install -y \
        iptables \
        ebtables \
        nftables
}

debian(){
    echo "Installing packages for Debian"
    #common packages
    apt-get update
    apt-get install -y \
        iptables \
        ebtables \
        nftables
}

if [[ -f /etc/*-release ]]; then
    $DISTRO=$(cat /etc/*-release | grep -Po "(?<=^ID=).+" | sed 's/"//g')
else
    echo "No release file found"
    exit 1
fi

case $DISTRO in
    "opensuse-tumbleweed")
        opensuse-tumbleweed
        ;;
    "ubuntu")
        ubuntu
        ;;
    "debian")
        debian
        ;;
    *)
        echo "Unsupported linux distribution"
        exit 1
        ;;
esac