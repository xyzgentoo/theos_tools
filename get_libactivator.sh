#!/bin/bash

THEACTIVATOR=/opt/activator

# initial theos install directory check
if [ ! -d "$THEACTIVATOR" ]; then
    echo "making $THEACTIVATOR"
    mkdir -p $THEACTIVATOR
	mkdir -p $THEACTIVATOR/include/
	mkdir -p $THEACTIVATOR/lib/
    chown -R $USER:staff $THEACTIVATOR
fi

install_activator() {
    cd /tmp
    echo "Downloading Activator header and library..."
    BIGBOSS_REPO="http://apt.thebigboss.org/repofiles/cydia"
    curl -s -L "${BIGBOSS_REPO}/dists/stable/main/binary-iphoneos-arm/Packages.bz2" > Packages.bz2
    pkg_path=$(bzcat Packages.bz2 | grep "debs2.0/libactivator" | awk '{print $2}')
    pkg=$(basename $pkg_path)
	echo $pkg_path
    curl -s -L "${BIGBOSS_REPO}/${pkg_path}" > $pkg
    ar -p $pkg data.tar.gz | tar -zxf - ./usr/include/libactivator/libactivator.h ./usr/lib/libactivator.dylib
    if [ -d $THEACTIVATOR/include/libactivator ]; then
        mv -f ./usr/include/libactivator/libactivator.h $THEACTIVATOR/include/libactivator/
    else
        mv -f ./usr/include/libactivator $THEACTIVATOR/include
    fi
    mv ./usr/lib/libactivator.dylib $THEACTIVATOR/lib
    rm -rf usr Packages.bz2 $pkg
}

if [ $# -eq 0 ]; then
	install_activator
else
    for i in $@; do
        $i
    done
fi

echo "Done."
