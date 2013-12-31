#!/bin/bash

THESUBSTRATE=/opt/substrate
SUBSTRATE_REPO="http://apt.saurik.com"

# initial theos install directory check
if [ ! -d "$THESUBSTRATE" ]; then
    echo "making $THESUBSTRATE"
    mkdir -p $THESUBSTRATE
	mkdir -p $THESUBSTRATE/include/
	mkdir -p $THESUBSTRATE/lib/
    chown -R $USER:staff $THESUBSTRATE
fi

retrieve_substrate() {
	cd /tmp
	echo "Downloading substrate header and library..."
	curl -s -L "${SUBSTRATE_REPO}/dists/tangelo-3.7/main/binary-iphoneos-arm/Packages.bz2" > Packages.bz2
	pkg_path=$(bzcat Packages.bz2 | grep "debs/mobilesubstrate" | awk '{print $2}')
	pkg=$(basename $pkg_path)
	curl -s -L "${SUBSTRATE_REPO}/${pkg_path}" > $pkg

	#old format - before iOS7 support
	#ar -p $pkg data.tar.gz | tar -zxf - ./Library/Frameworks/CydiaSubstrate.framework

	ar -p $pkg data.tar.lzma | tar -zxf - ./Library/Frameworks/CydiaSubstrate.framework
	mv ./Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h $THESUBSTRATE/include/substrate.h
	mv ./Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate  $THESUBSTRATE/lib/libsubstrate.dylib
	rm -rf Packages.bz2 $pkg /tmp/Library
}

if [ $# -eq 0 ]; then
	retrieve_substrate	
else
    for i in $@; do
        $i
    done
fi

echo "Done."
