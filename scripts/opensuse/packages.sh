#!/bin/bash
echo "Installing packages for OpenSUSE distribution"

#common packages
zypper --non-interactive install \
    iptables \
    ebtables \
    nftables \
    iproute2 \
    liblxc1 \
    liblz4-1 \
    libuv1 