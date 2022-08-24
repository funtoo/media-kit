# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Icon themes for SMPlayer."
HOMEPAGE="https://smplayer.info/"
SRC_URI="https://github.com/smplayer-dev/smplayer-themes/tarball/a5345e67553cc3829dee210040c584da5448cd08 -> smplayer-themes-20.11.0-a5345e6.tar.gz"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 CC0-1.0 GPL-2 GPL-3+ LGPL-3"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/smplayer-dev-smplayer-themes* "${S}" || die
	fi
}

src_prepare() {
	default
		sed -i -e 's/make/$(MAKE)/' Makefile || die
}