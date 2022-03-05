# Maintainer: Madan Bhat <imadanbhat@gmail.com>
pkgname=sword-linux-xmonad
_pkgname=sword-linux-xmonad
_destname1="/etc/skel/"
pkgver=1.0
pkgrel=1
pkgdesc="Xmonad Configurations for Sword OS"
arch=('x86_64')
url="https://github.com/Madan-bhat/sword-linux-xmonad"
license=('MIT')
depends=(xmonad-contrib xmonad polybar)
makedepends=('git')
provides=("${pkgname}")
options=(!strip !emptydirs)
source=("git+$url.git")
sha256sums=('SKIP')
install='post.install'

package() {
	install -dm755 ${pkgdir}${_destname1}
	cp -r ${srcdir}/${_pkgname}${_destname1}.xmonad/ ${pkgdir}${_destname1}
}