# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A color management framework for visual effects and animation."
HOMEPAGE="https://github.com/AcademySoftwareFoundation/OpenColorIO"
SRC_URI="https://github.com/AcademySoftwareFoundation/OpenColorIO/tarball/e670cd98d794e83cd5a9d079f8979d9204466128 -> OpenColorIO-2.1.2-e670cd9.tar.gz"

KEYWORDS="*"
LICENSE="BSD"
SLOT="0"
IUSE="cpu_flags_x86_sse2 doc opengl python static-libs"

REQUIRED_USE="
	doc? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

# For versions v2.2.0 and beyond OpenColorIO requires sys-libs/minizip-ng.
# Right now it does not configure properly due to errors around minizip, zlib, and zlib-ng
# Funtoo Bug is tracking this effort: https://bugs.funtoo.org/browse/FL-10885
# Once this is resolved, the autogen version can be unlocked
# and sys-libs/minizip-ng can be added to RDEPEND
RDEPEND="
	dev-cpp/pystring
	dev-python/pybind11
    dev-libs/imath
	dev-cpp/yaml-cpp:=
	dev-libs/tinyxml
	opengl? (
		media-libs/lcms:2
		>=media-libs/openimageio-2.2.13.0
		media-libs/glew:=
		media-libs/freeglut
		virtual/opengl
	)
	>=dev-libs/imath-3:=
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-3.16.2-r1
	virtual/pkgconfig
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/testresources[${PYTHON_USEDEP}]
		')
	)
"

# Restricting tests, bugs #439790 and #447908
RESTRICT="test"

CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	default
	rm -rf "${S}"
	mv "${WORKDIR}"/AcademySoftwareFoundation-OpenColorIO-* "${S}" || die
}

src_prepare() {
	cmake_src_prepare

	sed -i -e "s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)|g" {,src/bindings/python/,src/OpenColorIO/,src/libutils/,src/libutils/oglapphelpers/}CMakeLists.txt || die
	sed -i -e "s|ARCHIVE DESTINATION lib|ARCHIVE DESTINATION $(get_libdir)|g" {,src/bindings/python/,src/OpenColorIO/,src/libutils/,src/libutils/oglapphelpers/}CMakeLists.txt || die
}

src_configure() {
	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	# Notes:
	# - OpenImageIO is required for building ociodisplay and ocioconvert (USE opengl)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE opengl)
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DOCIO_BUILD_STATIC=$(usex static-libs)
		-DOCIO_BUILD_DOCS=$(usex doc)
		-DOCIO_BUILD_APPS=$(usex opengl)
		-DOCIO_BUILD_PYTHON=$(usex python)
		-DOCIO_BUILD_JAVA=OFF
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse2)
		-DOCIO_BUILD_TESTS=OFF
		-DOCIO_BUILD_GPU_TESTS=OFF
		-DOCIO_BUILD_FROZEN_DOCS=$(usex doc)
		-DOCIO_INSTALL_EXT_PACKAGES=NONE
		-DOCIO_USE_OPENEXR_HALF=OFF
	)

	# We need this to work around asserts that can trigger even in proper use cases.
	# See https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1235
	append-flags  -DNDEBUG

	cmake_src_configure
}