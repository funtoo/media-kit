# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="libharu - free PDF library"
HOMEPAGE="http://www.libharu.org/ https://github.com/libharu/libharu"
SRC_URI="https://github.com/libharu/libharu/tarball/8dbcfe470581edc4bc52c3ef132d410e66cadc20 -> libharu-2.4.3-8dbcfe4.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="*"

DEPEND="
	media-libs/libpng:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"

post_src_unpack() {
	mv ${WORKDIR}/libharu-libharu-* ${S} || die
}

src_configure() {
	local mycmakeargs=(
		-DLIBHPDF_EXAMPLES=NO # Doesn't work
		-DLIBHPDF_STATIC=NO
	)
	cmake_src_configure
}