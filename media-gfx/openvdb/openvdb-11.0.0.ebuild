# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
SRC_URI="https://github.com/AcademySoftwareFoundation/openvdb/tarball/6c044e628a1ac3546eed48b6f5e9c76dfaa2143e -> openvdb-11.0.0-6c044e6.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="cpu_flags_x86_avx cpu_flags_x86_sse4_2 +blosc doc numpy python static-libs test utils zlib abi9-compat abi10-compat +abi11-compat"
RESTRICT="test"

REQUIRED_USE="
	numpy? ( python )
	^^ ( abi9-compat abi10-compat abi11-compat )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-cpp/tbb
	dev-libs/boost:=
	dev-libs/c-blosc:=
	dev-libs/jemalloc:=
	dev-libs/log4cplus:=
	media-libs/glfw
	media-libs/glu
	>=dev-libs/imath-3:=
	>=media-libs/openexr-3:=
	sys-libs/zlib:=
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	blosc? ( dev-libs/c-blosc:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[numpy?,python?,${PYTHON_USEDEP}]
			numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
		')
	)
	zlib? ( sys-libs/zlib )
"

DEPEND="${RDEPEND}"

BDEPEND="
	>=dev-util/cmake-3.16.2-r1
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? ( dev-util/cppunit dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${PN}-8.1.0-glfw-libdir.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	default
	rm -rf "${S}"
	mv "${WORKDIR}"/AcademySoftwareFoundation-openvdb-* "${S}" || die
}

src_configure() {
	local myprefix="${EPREFIX}/usr/"

	local version
	if use abi9-compat; then
		version=9
	elif use abi10-compat; then
		version=10
	elif use abi11-compat; then
		version=11
	else
		die "Openvdb abi version is not compatible"
	fi

	local mycmakeargs=(
		-DCHOST="${CHOST}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"
		-DOPENVDB_ABI_VERSION_NUMBER="${version}"
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_BUILD_VDB_LOD=$(usex utils)
		-DOPENVDB_BUILD_VDB_RENDER=$(usex utils)
		-DOPENVDB_BUILD_VDB_VIEW=$(usex utils)
		-DOPENVDB_CORE_SHARED=ON
		-DOPENVDB_CORE_STATIC=$(usex static-libs)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DUSE_BLOSC=$(usex blosc)
		-DUSE_ZLIB=$(usex zlib)
		-DUSE_CCACHE=OFF
		-DUSE_COLORED_OUTPUT=ON
		-DUSE_IMATH_HALF=ON
		-DUSE_LOG4CPLUS=ON
	)

	if use python; then
		mycmakeargs+=(
			-DOPENVDB_BUILD_PYTHON_MODULE=ON
			-DUSE_NUMPY=$(usex numpy)
			-DOPENVDB_BUILD_PYTHON_UNITTESTS=$(usex test)
			-DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DPython_EXECUTABLE="${PYTHON}"
			-DPython_INCLUDE_DIR="$(python_get_includedir)"
		)
	fi

	if use cpu_flags_x86_avx; then
		mycmakeargs+=( -DOPENVDB_SIMD=AVX )
	elif use cpu_flags_x86_sse4_2; then
		mycmakeargs+=( -DOPENVDB_SIMD=SSE42 )
	fi

	cmake_src_configure
}