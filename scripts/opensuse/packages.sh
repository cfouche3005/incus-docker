#!/bin/bash
echo "Installing packages for OpenSUSE distribution"

#common packages
zypper --non-interactive install \
    iptables \
    ebtables \
    nftables 