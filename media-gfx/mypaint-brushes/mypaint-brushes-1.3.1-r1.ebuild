# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Default MyPaint brushes"
HOMEPAGE="https://github.com/mypaint/mypaint-brushes"
SRC_URI="https://api.github.com/repos/mypaint/mypaint-brushes/tarball/refs/tags/v1.3.1 -> mypaint-brushes-1.3.1-8a0124ac0675103eae8fa41fad533851768ae1ce.tar.gz"

LICENSE="CC0-1.0"

SLOT="1" # This tracks major version
KEYWORDS="*"
RDEPEND="!media-gfx/mypaint-brushes:1.0"

# Chosen to exclude README symlink
DOCS=( AUTHORS NEWS README.md )

post_src_unpack() {
	mv "${WORKDIR}/"mypaint-mypaint-brushes* "${S}" || die
}

src_prepare() {
	default
	eautoreconf
}