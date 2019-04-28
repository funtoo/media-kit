# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DEADBEEF_GUI="yes"

inherit deadbeef-plugins git-r3

DESCRIPTION="DeaDBeeF waveform seekbar plugin"
HOMEPAGE="https://github.com/cboxdoerfer/ddb_waveform_seekbar"
EGIT_REPO_URI="https://github.com/cboxdoerfer/ddb_waveform_seekbar.git"

LICENSE="GPL-2"
KEYWORDS=""

RDEPEND+=" dev-db/sqlite:3"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-cflags-lm-${PV}.patch"
)

src_compile() {
	use gtk2 && emake gtk2
	use gtk3 && emake gtk3
}
