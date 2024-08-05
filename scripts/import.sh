#!/bin/bash
singlearch(){
    cp -r /import/linux_${TARGETARCH}/* /export/
    rm /export/bin/incus-agent.linux.$(uname -m)
}

multiarch(){
    ls /import
    cp -r /import/linux_${TARGETARCH}/* /export/
    for arch in /import/* ; do
        echo "Copying incus-agent.linux.* from ${arch}"
        ls -1 ${arch}
        cp ${arch}/incus-agent.linux.* /export/bin/
    done
    rm /export/bin/incus-agent
}

#check if the build is multiarch or not

if [[ $(ls -1 /import | wc -l) -eq 0 ]]; then
    echo "No files found in build directory"
    exit 1
elif [[ $(ls -1 /import | wc -l) -eq 1 ]]; then
    echo "Single arch build"
    singlearch
elif [[ $(ls -1 /import | wc -l) -gt 1 ]]; then
    echo "Multi arch build"
    multiarch
else
    echo "Unknown error"
    exit 1
fi
