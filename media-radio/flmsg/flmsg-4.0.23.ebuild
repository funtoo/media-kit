EAPI=7

DESCRIPTION="Fldigi helper for creating radiograms"
HOMEPAGE="http://www.w1hkj.com"
SRC_URI="https://downloads.sourceforge.net/fldigi/flmsg/flmsg-4.0.23.tar.gz -> flmsg-4.0.23.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="media-radio/fldigi
		x11-libs/fltk:=
		x11-libs/libX11:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog INSTALL README )