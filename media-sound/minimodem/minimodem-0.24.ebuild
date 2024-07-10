# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="general-purpose software audio FSK modem"
HOMEPAGE="http://www.whence.com/minimodem/"
SRC_URI="https://github.com/kamalmostafa/minimodem/tarball/17e17b784ea83e97e84dacb813ccec25072dbd1d -> minimodem-0.24-17e17b7.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

RDEPEND="sci-libs/fftw
  media-libs/libsndfile
  || ( media-libs/alsa-lib media-sound/pulseaudio )"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

post_src_unpack() {
	default
	mv ${WORKDIR}/*${PN}* ${WORKDIR}/${P}
}

src_prepare() {
	default
}

src_configure() {
	eautoreconf

	if [[ $USE != *"alsa"* ]]; then
		local argtmp1="--without-alsa"
	fi
	if [[ $USE != *"pulseaudio"* ]]; then
		local argtmp2="--without-pulseaudio"
	fi

	local myeconfargs=(
		$argtmp1
		$argtmp2
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	make DESTDIR="${D}" install
}