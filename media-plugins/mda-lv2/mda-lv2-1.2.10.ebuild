# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 meson

DESCRIPTION="LV2 port of the MDA plugins by Paul Kellett"
HOMEPAGE="http://drobilla.net/software/mda-lv2/"
SRC_URI="https://gitlab.com/drobilla/mda-lv2/-/archive/v1.2.10/mda-lv2-v1.2.10.tar.gz -> mda-lv2-v1.2.10.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

BDEPEND="dev-util/meson
	dev-util/ninja"
RDEPEND="media-libs/lv2"
DEPEND="${PYTHON_DEPS}"

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv "${WORKDIR}/${PN}-v${PV}" "${S}" || die
	fi
}