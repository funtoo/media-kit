EAPI=7

inherit autotools

DESCRIPTION="Secret Rabbit Code (aka libsamplerate) is a Sample Rate Converter for audio"
HOMEPAGE="https://libsndfile.github.io/libsamplerate/"

SRC_URI="https://github.com/libsndfile/libsamplerate/tarball/b9c20b93660c3683fda12e3c2a01f0021bf96c56 -> libsamplerate-0.2.2-b9c20b9.tar.gz"

KEYWORDS="*"

LICENSE="BSD-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# Alsa/FFTW are only required for tests
# libsndfile is only used by examples and tests
DEPEND="
	test? (
		media-libs/alsa-lib
		media-libs/libsndfile
		sci-libs/fftw:3.0
	)"

BDEPEND="virtual/pkgconfig"

post_src_unpack() {
	mv "${WORKDIR}"/libsndfile-libsamplerate-* "${S}" || die
}
src_prepare() {
	default
	eautoreconf
}

src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable test alsa) \
		$(use_enable test fftw) \
		$(use_enable test sndfile)
}

src_install() {
	default
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}