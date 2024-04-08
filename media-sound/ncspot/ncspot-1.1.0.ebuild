# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/6aa1cd981720d35fad8dc49c2b721f5df6b3cbec -> ncspot-1.1.0-6aa1cd9.tar.gz
https://direct.funtoo.org/54/83/1f/54831f5a5846faa09c70db297b2e883e2ca0873c9f32fe7bfff88eafe1ea4883e62285d0bec8add957f6d4662882d365d7dcaa49bee0c40084461549836fa561 -> ncspot-1.1.0-funtoo-crates-bundle-7523fc30e27948698034c30e85584f15071b1078da6ae4d14d5ec053528fbb4ac1c037f5f49734115af0a2e8f287589a16be2aa465c4547e008caafb40e556eb.tar.gz"

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