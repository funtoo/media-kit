# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="LV2 port of the MDA plugins by Paul Kellett"
HOMEPAGE="http://drobilla.net/software/mda-lv2/"
SRC_URI="http://download.drobilla.net/mda-lv2-1.2.6.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/lv2"
DEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig"