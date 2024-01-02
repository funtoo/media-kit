EAPI=7

inherit flag-o-matic

DESCRIPTION="Transceiver control program for Amateur Radio use"
HOMEPAGE="http://www.w1hkj.com/flrig-help/index.html"
SRC_URI="https://downloads.sourceforge.net/fldigi/flrig/flrig-2.0.05.tar.gz -> flrig-2.0.05.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="nls"

DOCS=(AUTHORS ChangeLog README)

RDEPEND="x11-libs/libX11
	x11-libs/fltk:1
	x11-misc/xdg-utils"

DEPEND="${RDEPEND}
	sys-devel/gettext"


src_configure() {
	#fails to compile with -flto (bug #860408)
	filter-lto

	econf
}