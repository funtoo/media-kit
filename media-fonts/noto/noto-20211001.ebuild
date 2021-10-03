# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlefonts/noto-fonts"

SRC_URI="https://github.com/googlei18n/noto-fonts/archive/8569898c6822bbcbbd4ad71e2baf6c4f8f4e095a.tar.gz -> noto-fonts-20211001-8569898c6822bbcbbd4ad71e2baf6c4f8f4e095a.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="*"

IUSE="cjk +extra"

RDEPEND="cjk? ( media-fonts/noto-cjk )"
DEPEND=""

RESTRICT="binchecks strip"

FILESDIR="${REPODIR}/media-fonts/noto-gen/files"

FONT_SUFFIX="ttf"
FONT_CONF=(
	# From ArchLinux
	"${FILESDIR}/66-noto-serif.conf"
	"${FILESDIR}/66-noto-mono.conf"
	"${FILESDIR}/66-noto-sans.conf"
)

post_src_unpack() {
	mv ${WORKDIR}/noto-fonts-* ${S} || die
}

src_install() {
	mkdir install-unhinted install-hinted || die
	mv unhinted/ttf/Noto*/*.tt[fc] install-unhinted/. ||  die
	mv hinted/ttf/Noto*/*.tt[fc] install-hinted/. || die

	FONT_S="${S}/install-unhinted/" font_src_install
	FONT_S="${S}/install-hinted/" font_src_install

	# Allow to drop some fonts optionally for people that want to save
	# disk space. Following ArchLinux options.
	use extra || rm -rf "${ED}"/usr/share/fonts/noto/Noto*{Condensed,SemiBold,Extra}*.ttf
}