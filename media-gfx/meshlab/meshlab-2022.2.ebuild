# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

S="${WORKDIR}"/${P}/src

DESCRIPTION=""
HOMEPAGE="http://www.meshlab.net"
SRC_URI="
	https://github.com/cnr-isti-vclab/meshlab/tarball/58731df6d68e4edeb45d36e7c8828a9d46f8799a -> meshlab-2022.02-58731df.tar.gz
	https://github.com/cnr-isti-vclab/vcglib/tarball/e4950d12e2db7f6ec3e587b06b2a0474b4f08d96 -> vcglib-2022.02-e4950d1.tar.gz
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