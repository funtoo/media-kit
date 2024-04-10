# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Commandline tool to take screenshots of the desktop"
HOMEPAGE="https://github.com/naelstrof/maim"

SRC_URI="https://github.com/naelstrof/maim/tarball/36a56dd7ea1888f99f237e5d79d0887efd40aaa3 -> maim-5.8.0-36a56dd.tar.gz"
KEYWORDS="*"

LICENSE="GPL-3+ MIT"
SLOT="0"
IUSE="icu"

DEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/libwebp:=
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-misc/slop-7.5:=
	icu? ( dev-libs/icu:= )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	mv naelstrof-maim-* "${S}"
}

src_configure() {
	local mycmakeargs=(
		-DMAIM_UNICODE=$(usex icu)
	)
	cmake_src_configure
}
