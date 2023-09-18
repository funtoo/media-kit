# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
SRC_URI="https://github.com/glfw/glfw/tarball/1b54c498e5a26550e85d7cc8520d81f1ea837517 -> glfw-3.3.8-1b54c49.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="wayland-only"

RDEPEND="
	x11-libs/libxkbcommon
	wayland-only? (
		dev-libs/wayland
		media-libs/mesa[egl(+),wayland]
	)
	!wayland-only? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXxf86vm
	)
"
DEPEND="
	${RDEPEND}
	wayland-only? ( dev-libs/wayland-protocols )
	!wayland-only? (
		x11-base/xorg-proto
		x11-libs/libXi
	)
"
BDEPEND="
	wayland-only? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

src_unpack() {
	default
	rm -rf "${S}"
	mv "${WORKDIR}"/glfw-glfw-* "${S}" || die
}

src_configure() {
	local mycmakeargs=(
		-DGLFW_BUILD_EXAMPLES=no
		-DGLFW_USE_WAYLAND="$(usex wayland-only)"
		-DBUILD_SHARED_LIBS=1
	)
	cmake_src_configure
}