EAPI=7

inherit desktop qmake-utils xdg-utils

DESCRIPTION="Amateur radio SSTV software"
HOMEPAGE="http://users.telenet.be/on4qz/ https://github.com/ON4QZ/QSSTV"
SRC_URI="https://github.com/ON4QZ/QSSTV/archive/fefeedffd5b2351f13ed19b9a61586e63b11f0bf.tar.gz -> QSSTV-9.5.11.20230715103538.tar.gz"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

CDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/hamlib:=
	media-libs/openjpeg:2
	media-libs/alsa-lib
	media-libs/libv4l
	sci-libs/fftw:3.0=
	media-sound/pulseaudio
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils"

post_src_unpack() {
	mv "${WORKDIR}"/QSSTV-*/src "${S}" || die
	mv "${WORKDIR}"/QSSTV-*/documentation "${WORKDIR}"/QSSTV-*/qsstv.desktop "${S}" || die
	mv "${WORKDIR}"/QSSTV-*/README.md "${S}" || die
}

src_prepare() {
	eapply_user
	# fix docdirectory, install path and hamlib search path
	sed -i -e "s:/doc/\$\$TARGET:/doc/${PF}:" \
		-e "s:-lhamlib:-L/usr/$(get_libdir)/hamlib -lhamlib:g" \
		qsstv.pro || die
}

src_configure() {
	eqmake5 PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	domenu qsstv.desktop
	doicon icons/qsstv.png
	dodoc README.md
}


pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}