# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools flag-o-matic

DESCRIPTION="GD is an open source code library for the dynamic creation of images by programmers."
HOMEPAGE="https://libgd.github.io/"
SRC_URI="https://github.com/libgd/libgd/tarball/b5319a41286107b53daa0e08e402aa1819764bdc -> libgd-2.3.3-b5319a4.tar.gz"

LICENSE="gd IJG HPND BSD"
SLOT="2/3"
KEYWORDS="*"
IUSE="cpu_flags_x86_sse fontconfig jpeg png static-libs test tiff truetype webp xpm zlib heif avif"

RESTRICT="test"

# fontconfig has prefixed font paths, details see bug #518970
REQUIRED_USE="prefix? ( fontconfig )"
RDEPEND="fontconfig? ( >=media-libs/fontconfig-2.10.92 )
	jpeg? ( >=virtual/jpeg-0-r2:0= )
	png? ( >=media-libs/libpng-1.6.10:0= )
	tiff? ( media-libs/tiff:0 )
	truetype? ( >=media-libs/freetype-2.5.0.1 )
	webp? ( media-libs/libwebp )
	xpm? ( >=x11-libs/libXpm-3.5.10-r1 >=x11-libs/libXt-1.1.4 )
	zlib? ( >=sys-libs/zlib-1.2.8-r1 )
	heif? ( >=media-libs/libheif-1.12.0[x265] )
	avif? ( >=media-libs/libavif-0.11.1 )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/lib${P}"


post_src_unpack() {
	mv ${WORKDIR}/libgd-libgd-* ${S} || die
}

src_prepare() {
	default

	eautoreconf
}
src_configure() {
	# bug 603360, https://github.com/libgd/libgd/blob/fd06f7f83c5e78bf5b7f5397746b4e5ee4366250/docs/README.TESTING#L65
	if use cpu_flags_x86_sse ; then
		append-cflags -msse -mfpmath=sse
	else
		append-cflags -ffloat-store
	fi

	# bug 632076, https://github.com/libgd/libgd/issues/278
	if use arm64 || use ppc64 || use s390 ; then
		append-cflags -ffp-contract=off
	fi

	# we aren't actually {en,dis}abling X here ... the configure
	# script uses it just to add explicit -I/-L paths which we
	# don't care about on Gentoo systems.
	local myeconfargs=(
		--disable-werror
		--without-x
		--without-liq
		$(use_enable static-libs static)
		$(use_with fontconfig)
		$(use_with png)
		$(use_with tiff)
		$(use_with truetype freetype)
		$(use_with jpeg)
		$(use_with webp)
		$(use_with xpm)
		$(use_with zlib)
		$(use_with avif)
		$(use_with heif)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc README.md
}