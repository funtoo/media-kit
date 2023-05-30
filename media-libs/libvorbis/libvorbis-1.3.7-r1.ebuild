EAPI=7

inherit autotools

DESCRIPTION="The Ogg Vorbis sound file format library"
HOMEPAGE="https://xiph.org/vorbis/"
SRC_URI="https://downloads.xiph.org/releases/vorbis/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs test"

RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
RDEPEND=">=media-libs/libogg-1.3.0"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.7-macro-wstrict-prototypes.patch
)

src_prepare() {
	default

	sed -i \
		-e '/CFLAGS/s:-O20::' \
		-e '/CFLAGS/s:-mcpu=750::' \
		-e '/CFLAGS/s:-mno-ieee-fp::' \
		configure.ac || die

	# Un-hack docdir redefinition.
	find -name 'Makefile.am' \
		-exec sed -i \
			-e 's:$(datadir)/doc/$(PACKAGE)-$(VERSION):@docdir@/html:' \
			{} + || die

	eautoreconf
}

src_configure() {
	local myconf=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable test oggtest)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
