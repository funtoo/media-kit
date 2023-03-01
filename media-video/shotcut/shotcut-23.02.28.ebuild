# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils kde5

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="https://www.shotcut.org/ https://github.com/mltframework/mltframework/"
SRC_URI="https://github.com/mltframework/shotcut/tarball/66b8b3e4f4143af8ab20417a47a2124b3cbc5204 -> shotcut-23.02.28-66b8b3e.tar.gz"
KEYWORDS="*"

IUSE="debug"

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	$(add_qt_dep linguist-tools)
"
COMMON_DEPEND="
	$(add_qt_dep qtcore)
	$(add_qt_dep qtdeclarative widgets)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtmultimedia)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtopengl)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtquickcontrols2)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwebsockets)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	media-libs/mlt[ffmpeg,frei0r,fftw(+),jack,opengl,qt5,sdl,xml]
	media-video/ffmpeg
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtx11extras)
"
RDEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtgraphicaleffects)
	$(add_qt_dep qtquickcontrols)
	virtual/jack
"

post_src_unpack() {
	mv "${WORKDIR}"/mltframework-shotcut-* "${S}" || die
}

src_prepare() {
	cmake-utils_src_prepare

    sed -i \
		-e 's|lib)|lib64)|g' \
		CuteLogger/CMakeLists.txt || break
}

src_configure() {
	local mycmakeargs=(
		-DQt5=ON
		-DCMAKE_INSTALL_PREFIX=/usr
		-DEFINES+=SHOTCUT_NOUPGRADE
	)

	cmake-utils_src_configure
}