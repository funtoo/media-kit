# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Lightweight Spotify client using Qt"
HOMEPAGE="https://github.com/kraxarn/spotify-qt"
SRC_URI="https://github.com/kraxarn/spotify-qt/tarball/83bfc5df710cce95eefae96299be9839e209f605 -> spotify-qt-3.11-83bfc5d.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}/kraxarn-spotify-qt-83bfc5d"

RDEPEND="
  dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

src_prepare() {
  cmake_src_prepare
}