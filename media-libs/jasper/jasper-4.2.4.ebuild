# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="https://www.ece.uvic.ca/~mdadams/jasper/"

SRC_URI="https://github.com/jasper-software/jasper/tarball/7529861d66a2195d36395b3d93b9889b6bf4d1a3 -> jasper-4.2.4-7529861.tar.gz"

# We limit memory usage to 128 MiB by default, specified in bytes
: ${JASPER_MEM_LIMIT:=134217728}

LICENSE="JasPer2.0"
SLOT="0/4"
KEYWORDS="*"
IUSE="doc jpeg opengl"

RDEPEND="
	jpeg? ( >=virtual/jpeg-0-r2:0 )
	opengl? (
		>=virtual/opengl-7.0-r1:0
		>=media-libs/freeglut-2.8.1:0
		virtual/glu
		x11-libs/libXi
		x11-libs/libXmu
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/jasper-software-jasper* "$S" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DALLOW_IN_SOURCE_BUILD=OFF
		-DBASH_PROGRAM="${EPREFIX}"/bin/bash
		-DJAS_ENABLE_ASAN=OFF
		-DJAS_ENABLE_LSAN=OFF
		-DJAS_ENABLE_MSAN=OFF
		-DJAS_ENABLE_SHARED=ON
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		# JPEG
		-DJAS_ENABLE_LIBJPEG=$(usex jpeg)

		# OpenGL
		-DJAS_ENABLE_OPENGL=$(usex opengl)

		# Doxygen
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex doc OFF ON)
		
		# Build docs
		-DJAS_ENABLE_DOC=$(usex doc)
	)
	cmake_src_configure
}