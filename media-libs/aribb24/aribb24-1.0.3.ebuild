# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library for decoding ARIB STD-B24 subtitles"
HOMEPAGE="https://github.com/nkoriyama/aribb24"
SRC_URI="https://github.com/nkoriyama/aribb24/tarball/bc45f1406899603033218c2cc6d611ddcc5b3720 -> aribb24-1.0.3-bc45f14.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/libpng"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
PATCHES=(
	"${FILESDIR}"/"${P}"-reset-control_time.patch
	"${FILESDIR}"/"${P}"-fix-default-macros.patch
	"${FILESDIR}"/"${P}"-add-missing-curly-braces.patch
	"${FILESDIR}"/"${P}"-add-png_cflags.patch
	"${FILESDIR}"/"${P}"-add-missing-libm-in-pkgconfig.patch
)

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/nkoriyama-aribb24* "${S}" || die
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}