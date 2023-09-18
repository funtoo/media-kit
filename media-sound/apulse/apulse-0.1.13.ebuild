# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="PulseAudio emulation for ALSA"
HOMEPAGE="https://github.com/i-rinat/apulse"
SRC_URI="https://github.com/i-rinat/apulse/tarball/23a721dab5d3befb9d8cc09a19ec05d6bebf8d8a -> apulse-0.1.13-23a721d.tar.gz"

LICENSE="MIT LGPL-2.1"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}/i-rinat-apulse-23a721d"

IUSE="debug +sdk"

DEPEND="
	dev-libs/glib:2
	media-libs/alsa-lib
	sdk? (
		!media-libs/libpulse 
		!media-sound/pulseaudio
	)
"
RDEPEND="
	${DEPEND}
	!media-plugins/alsa-plugins[pulseaudio]
"

PATCHES=(
	"${FILESDIR}/sdk.patch"
	"${FILESDIR}/check-key-before-remove.patch"
	"${FILESDIR}/man.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DINSTALL_SDK=$(usex sdk)"
		"-DLOG_TO_STDERR=$(usex debug)"
		"-DWITH_TRACE=$(usex debug)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
}