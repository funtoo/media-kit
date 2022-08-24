# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Skin themes for SMPlayer."
HOMEPAGE="https://smplayer.info/"
SRC_URI="https://github.com/smplayer-dev/smplayer-skins/tarball/3cd5c6aed8539614ff949c4a8ac8b543e007e3f2 -> smplayer-skins-20.11.0-3cd5c6a.tar.gz"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="*"


post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/smplayer-dev-smplayer-skins* "${S}" || die
	fi
}

src_prepare() {
	default
		sed -i -e 's/make/$(MAKE)/' Makefile || die
}