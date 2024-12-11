# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Lightweight Spotify client using Qt"
HOMEPAGE="https://github.com/kraxarn/spotify-qt"
SRC_URI="https://github.com/kraxarn/spotify-qt/tarball/94a60199c167f46e14e35283624da7d780c19174 -> spotify-qt-3.12-94a6019.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}/kraxarn-spotify-qt-94a6019"

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