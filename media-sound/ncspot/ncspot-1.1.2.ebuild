# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/7ce6e532fca311883bc855b43a83b8e8a7b9e616 -> ncspot-1.1.2-7ce6e53.tar.gz
https://direct.funtoo.org/a1/e8/11/a1e8114c0e69934a1a3abc4d7d5319dfc4c42d7b26cf87a70323a66b60c793bc75e352065ce4220feed35f5626e785e44c42bee050c20e3a6a8a587d299f0aca -> ncspot-1.1.2-funtoo-crates-bundle-dbfe11dcf358a640da377515fc30f5ae06d96d76d57457300c801754338fd1f1f8ef70ec79a47eb54fce7389ca01f5a6fe3a4e53af2ddfead49cb3ebe3449df5.tar.gz"

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