# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils meson

DESCRIPTION="A simple GTK+ frontend for mpv"
HOMEPAGE="https://github.com/gnome-mpv/gnome-mpv"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND=">=dev-libs/glib-2.44
	>=x11-libs/gtk+-3.20:3
	media-libs/libepoxy"
RDEPEND="${CDEPEND}
	x11-themes/gnome-icon-theme-symbolic
	>=media-video/mpv-0.21[libmpv]"
DEPEND="${CDEPEND}
	>=dev-util/meson-0.37.0
	dev-libs/appstream-glib"
RESTRICT="mirror"

PATCHES=( "${FILESDIR}"/${P}-fix_appdata_and_docs.patch )

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_icon_savelist
	gnome2_schemas_update
	gnome2_schemas_savelist
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
}

