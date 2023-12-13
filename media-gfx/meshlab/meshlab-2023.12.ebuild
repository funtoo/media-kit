# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

S="${WORKDIR}"/${P}/src

DESCRIPTION=""
HOMEPAGE="http://www.meshlab.net"
SRC_URI="
	https://github.com/cnr-isti-vclab/meshlab/tarball/2dbd2f4b12df3b47d8777b2b4a43cabd9e425735 -> meshlab-2023.12-2dbd2f4.tar.gz
	https://github.com/cnr-isti-vclab/vcglib/tarball/6ac9e0c647a63e0e037813a1e92bd050d13efc85 -> vcglib-2023.12-6ac9e0c.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="double-precision minimal"

DEPEND="
	dev-libs/xerces-c
	dev-libs/gmp:=
	>=dev-qt/qtcore-5.12:5
	>=dev-qt/qtdeclarative-5.12:5
	>=dev-qt/qtopengl-5.12:5
	>=dev-qt/qtscript-5.12:5
	>=dev-qt/qtxml-5.12:5
	>=dev-qt/qtxmlpatterns-5.12:5
	sci-mathematics/cgal"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/meshlab-2020.12-disable-updates.patch"
	"${FILESDIR}/meshlab-2021.10-find-plugins.patch"
)

post_src_unpack() {
	cd "${WORKDIR}"
	if [ ! -d "${S}" ]; then
		mv cnr-isti-vclab-meshlab-* "${P}" || die
	fi
	mv cnr-isti-vclab-vcglib-*/* "${P}"/src/vcglib/ || die
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DBUILD_WITH_DOUBLE_SCALAR=$(usex double-precision)
		-Wno-dev
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}