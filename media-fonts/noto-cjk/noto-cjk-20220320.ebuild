# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Google's CJK font family"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-cjk"
SRC_URI="https://github.com/googlefonts/noto-cjk/tarball/a99a4354c68964f6bfac488d01010b1fb6d9178a -> noto-cjk-20220320-a99a4354c68964f6bfac488d01010b1fb6d9178a.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="*"
IUSE=""

RESTRICT="binchecks strip"

FILESDIR="${REPODIR}/media-fonts/noto-gen/files"

FONT_CONF=( "${FILESDIR}/70-noto-cjk.conf" ) # From ArchLinux
FONT_SUFFIX="ttc"

FONT_S=(Sans/OTC Sans/Variable/OTC Serif/OTC Serif/Variable/OTC)

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv ${WORKDIR}/googlefonts-noto-cjk-* ${S} || die
	fi
}