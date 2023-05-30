# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

SRC_URI="https://github.com/strukturag/libheif/releases/download/v1.15.2/libheif-1.15.2.tar.gz -> libheif-1.15.2.tar.gz"
KEYWORDS="*"

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

LICENSE="GPL-3"
SLOT="0/1.12"
IUSE="+aom gdk-pixbuf rav1e +threads x265"
RESTRICT="( test )"

BDEPEND=""
DEPEND="
	media-libs/dav1d:=
	media-libs/libde265:=
	aom? ( >=media-libs/libaom-2.0.0:= )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf )
	rav1e? ( media-video/rav1e:= )
	x265? ( media-libs/x265:= )"

RDEPEND="${DEPEND}"


src_prepare() {
	cmake_src_prepare
}

# SvtEnc requires media-libs/svt-av1 https://gitlab.com/AOMediaCodec/SVT-AV1
# LIBSHARPYUV requires media-libs/libsharpyuv which needs to be compiled
# from the libwepb sources https://chromium.googlesource.com/webm/libwebp
src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=OFF
		-DENABLE_MULTITHREADING_SUPPORT=$(usex threads ON OFF)
		-DENABLE_PARALLEL_TILE_DECODING=$(usex threads ON OFF)
		-DWITH_DAV1D=ON
		-DWITH_EXAMPLES=OFF
		-DWITH_LIBDE265=ON
		-DWITH_LIBSHARPYUV=OFF
		-DWITH_SvtEnc=OFF
		-DWITH_AOM_DECODER=$(usex aom ON OFF)
		-DWITH_AOM_ENCODER=$(usex aom ON OFF)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf ON OFF)
		-DWITH_RAV1E=$(usex rav1e ON OFF)
		-DWITH_X265=$(usex x265 ON OFF)
	)

	cmake_src_configure @mycmakeargs
}
