# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Default MyPaint brushes"
HOMEPAGE="https://github.com/mypaint/mypaint-brushes"
SRC_URI="https://api.github.com/repos/mypaint/mypaint-brushes/tarball/refs/tags/v2.0.2 -> mypaint-brushes-2.0.2-0df6d130152a94c3bd67709941978074a1303cc5.tar.gz"

LICENSE="CC0-1.0"

SLOT="2" # This tracks major version
KEYWORDS="*"

# Chosen to exclude README symlink
DOCS=( AUTHORS NEWS README.md )

post_src_unpack() {
	mv "${WORKDIR}/"mypaint-mypaint-brushes* "${S}" || die
}

src_prepare() {
	default
	eautoreconf
}