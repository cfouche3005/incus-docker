#!/bin/bash

#check if the build is multiarch or not

if [[ $(ls -1 /import/build | wc -l) -eq 0 ]]; then
    echo "No files found in build directory"
    exit 1
elif [[ $(ls -1 /import/build | wc -l) -eq 1 ]]; then
    echo "Single arch build"
    singlearch
else
    echo "Multi arch build"
    multiarch
fi

singlearch(){
    cp -r /import/linux_${TARGETARCH}/* /export/
    rm /export/bin/incus-agent.linux.$(uname -m)
}

multiarch(){
    cp -r /import/linux_${TARGETARCH}/* /export/
    for arch in /import ; do
        cp /import/${arch}/incus-agent.linux.* /export/bin/incus-agent.linux.*
    done
    rm /export/bin/incus-agent
}
