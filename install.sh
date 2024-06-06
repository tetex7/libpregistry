#!/usr/bin/env bash

if [ -e "/usr/bin/doas" ] ; then
    DOAS=doas
else
    DOAS=sudo
fi

yes | ${DOAS} pacman -R libpregistry
makepkg -f
yes | ${DOAS} pacman -U ./*-x86_64.pkg.tar.zst
