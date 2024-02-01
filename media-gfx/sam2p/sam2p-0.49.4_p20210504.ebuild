# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Utility to convert raster images to EPS, PDF and many others"
HOMEPAGE="https://github.com/pts/sam2p"
SRC_URI="https://github.com/pts/sam2p/archive/f3e9cc0a2df1880a63f9f37c96e3595bca890cfa.zip -> sam2p-0.49.4_p20210504-f3e9cc0.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples gif"
RESTRICT="test"

BDEPEND="dev-lang/perl"
PATCHES=(
	"${FILESDIR}/sam2p-build-fixes.patch"
	"${FILESDIR}/sam2p-0.49.4_p20190718-fix-configure-clang.patch"
)

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/* "${S}" || die
	fi
}

src_prepare() {
	default

	# configure.in files are deprecated
	mv configure.{in,ac} || die

	# missing include for memset
	sed -i '1s;^;#include <string.h>\n;' pts_defl.c || die

	# eautoreconf is still needed or you get bad warnings
	eautoreconf
}

src_configure() {
	tc-export CC CXX

	econf \
		--enable-lzw \
		$(use_enable gif)
}

src_compile() {
	emake GCC_STRIP=
}

src_install() {
	dobin sam2p
	einstalldocs

	if use examples; then
		# clear pre-compressed files
		rm examples/*.gz || die

		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}