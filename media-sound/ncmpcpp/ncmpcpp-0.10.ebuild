# Distributed under the terms of the GNU General Public License v2

EAPI=7


DESCRIPTION="Featureful ncurses based MPD client inspired by ncmpc"
HOMEPAGE="https://rybczak.net/ncmpcpp"
SRC_URI="https://github.com/ncmpcpp/ncmpcpp/tarball/1d7d5152c64eddab0eb8ebbfcbfd892a12ba3966 -> ncmpcpp-0.10-1d7d515.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="curl fftw taglib visualizer"

DEPEND=""
RDEPEND="
	dev-libs/boost
	sys-libs/ncurses
	sys-libs/readline
	curl? ( net-misc/curl )
	taglib? ( media-libs/taglib )
	visualizer? ( sci-libs/fftw )
	>=media-libs/libmpdclient-2.8
"
BDEPEND="
	dev-libs/boost
	sys-libs/ncurses
	sys-libs/readline
	curl? ( net-misc/curl )
	taglib? ( media-libs/taglib )
	visualizer? ( sci-libs/fftw )
	>=media-libs/libmpdclient-2.8
"


src_configure() {
	./autogen.sh || die
	opts="$(use_enable visualizer)"
	use fftw && opts+=" --with-fftw"
	use taglib && opts+=" --with-taglib"
	econf $opts
}

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv ${WORKDIR}/ncmpcpp-ncmpcpp* "${S}" || die
	fi
}