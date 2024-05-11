# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/2f614700ab173a1d5b9569d33995f1870e5ed63e -> ncspot-1.1.1-2f61470.tar.gz
https://direct.funtoo.org/c3/fc/e8/c3fce8682f8fb865eabe13867db65204ff52c66e5434ebbd65739b5d874a354ca76b49f3b03bb6e0069c0d266eba5e01935a1618ba1fbd0ed7b985f6220ec8d5 -> ncspot-1.1.1-funtoo-crates-bundle-b8138c43eae175b78329d45a17b13a429a8bbe2d9655a302d627a56031cb89841d38dd3fa72200e23e308e9de23b0f855c28931791f24ffe37cd441555406be4.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND=""
BDEPEND="virtual/rust"

DOCS=( README.md CHANGELOG.md )

QA_FLAGS_IGNORED="/usr/bin/ncspot"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/hrkfdn-ncspot-* ${S} || die
}