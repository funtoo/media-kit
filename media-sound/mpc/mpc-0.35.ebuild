# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 meson

DESCRIPTION="Commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/mpc"
SRC_URI="https://github.com/MusicPlayerDaemon/mpc/tarball/a063eb2ea0c36291bb5bc6fa7d7f1002b9862a2b -> mpc-0.35-a063eb2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc iconv test"

BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	iconv? ( virtual/libiconv )
	test? ( dev-libs/check )
"
DEPEND="media-libs/libmpdclient"
RDEPEND="${DEPEND}"

RESTRICT="!test? ( test )"
PATCHES=(
	"${FILESDIR}"/"${PN}"-0.35-nodoc.patch
)

S="${WORKDIR}/MusicPlayerDaemon-mpc-a063eb2"

src_prepare() {
	default

	# use correct docdir
	sed -e "/install_dir:.*contrib/s/meson.project_name()/'${PF}'/" \
		-i meson.build || die

	# use correct (html) docdir
	sed -e "/install_dir:.*doc/s/meson.project_name()/'${PF}'/" \
		-i doc/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocumentation=$(usex doc enabled disabled)
		-Diconv=$(usex iconv enabled disabled)
		-Dtest=$(usex test true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	newbashcomp contrib/mpc-completion.bash mpc
}