#! /bin/bash

suit=kui
newroot=$suit
fstar=rootfs.tar.xz

dmirror=http://10.1.10.21/server-dev
cfunctions=/usr/share/debootstrap/functions

if [[ $(lsb_release -c -s) != $suit ]] ; then
	# hostnamectl?
	echo "You should bootstrap rootfs on Deepin Linux Server Edition"
	exit 1
fi

if [[ ! -f $cfunctions ]] ; then
	echo "no debootstrap found"
	exit 1
fi

source $cfunctions
exec 4>&1

if [[ -d $newroot ]]; then
	warning ROOTFS "Removing old target"
	rm -rf $newroot
fi

info "BOOTSTRAPING" "Bootstraping new deepin $suit target in $newroot"
debootstrap --include=iproute2 --exclude=dash --variant=minbase $suit $newroot $dmirror

info "CLEANING" "Clean up package cache in target $newroot"
chroot $newroot /usr/bin/apt-get clean && tar vfcJ rootfs.tar.xz -C kui .

if [[ -f $fstar ]] ; then
	info "ROOTFS" "rootfs build successfully: $fstar"
else
	error 1 "PACKAGING" "failed to package rootfs"
fi
