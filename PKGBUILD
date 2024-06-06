#
#Copyright (C) 2024  tete
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
 # Maintainer: tete <tetex7@outlook.com>
pkgname=libpregistry
pkgver=1.0.0
pkgrel=1
pkgdesc='the a registry lib for linux'
url='www.github.com/tetex7/l61bs'
provides=('libpregistry.so')
arch=('x86_64')
PACKAGER="TRS"
license=('GPL3')
makedepends=('glibc')
depends=('glibc')
options=('!strip' 'docs' 'libtool' 'staticlibs' 'emptydirs' 'zipman' '!purge' '!debug' '!lto')
#backup=("etc/l61confg.conf61")
prepare() {
cd ..
echo $PWD
#make clean
}

build () {
    cd ..
    echo $PWD
    make
}

package() {
  #cd "$srcdir/$pkgname-$pkgver"
  cd ..

  mkdir -p  "${pkgdir}/usr/include"
  cp -r ./include/libpregistry "${pkgdir}/usr/include/libpregistry"
  install -Dm755 ./bin/libpregistry.so "${pkgdir}/usr/lib/libpregistry.so"
}

