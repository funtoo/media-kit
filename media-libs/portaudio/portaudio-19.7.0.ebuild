# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A free, cross-platform, open-source, audio I/O library"
HOMEPAGE="http://www.portaudio.com/"
SRC_URI="https://github.com/PortAudio/portaudio/tarball/147dd722548358763a8b649b3e4b41dfffbcfbb6 -> portaudio-19.7.0-147dd72.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="alsa +cxx debug doc jack oss static-libs"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2 )
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

DOCS=( README.md )

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}"/*-${PN}-* "${S}"
}

src_prepare() {
	default

	# AR patch
	sed -i "s/AC_PATH_PROG(AR, ar, no)/AC_CHECK_PROG(AR, ar, no)/" "${S}"/configure.in

	eautoconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-output)
		$(use_enable cxx)
		$(use_enable static-libs static)
		$(use_with alsa)
		$(use_with jack)
		$(use_with oss)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_compile() {
	# Workaround for parallel build issue
	emake lib/libportaudio.la
	emake

	if use doc; then
		doxygen -u Doxyfile || die
		doxygen Doxyfile || die
	fi
}

src_install() {
	default

	use doc && dodoc -r doc/html

	find "${ED}" -name "*.la" -delete || die
}