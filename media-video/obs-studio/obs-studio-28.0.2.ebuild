# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_REMOVE_MODULES_LIST=( FindFreetype )
PYTHON_COMPAT=( python3+ )

inherit cmake-utils python-single-r1 xdg-utils

SRC_URI="
	https://api.github.com/repos/obsproject/obs-studio/tarball/28.0.2 -> obs-studio-28.0.2.tar.gz
	browser? ( https://github.com/obsproject/obs-browser/archive/d1fa35dcbc384136e9e883f2d6071b14fd8f9a65.tar.gz -> d1fa35dcbc384136e9e883f2d6071b14fd8f9a65.tar.gz https://cdn-fastly.obsproject.com/downloads/cef_binary_4280_linux64.tar.bz2 -> cef_binary_4280_linux64.tar.bz2 )
"
KEYWORDS="*"

DESCRIPTION="Software for Recording and Streaming Live Video Content"
HOMEPAGE="https://obsproject.com"

LICENSE="GPL-2"
SLOT="0"
IUSE="+alsa browser fdk jack luajit nvenc pipewire pulseaudio python speex +ssl truetype v4l vlc wayland"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	luajit? ( dev-lang/swig )
	python? ( dev-lang/swig )
"
DEPEND="
	>=dev-libs/jansson-2.5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5[wayland?]
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/x264
	media-video/ffmpeg:=[x264]
	net-misc/curl
	sys-apps/dbus
	sys-libs/zlib
	virtual/udev
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libxcb
	alsa? ( media-libs/alsa-lib )
	browser? (
		app-accessibility/at-spi2-atk
		dev-libs/atk
		dev-libs/expat
		dev-libs/glib
		dev-libs/nspr
		dev-libs/nss
		media-libs/fontconfig
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXScrnSaver
		x11-libs/libXtst
	)
	fdk? ( media-libs/fdk-aac:= )
	jack? ( virtual/jack )
	luajit? ( dev-lang/luajit:2 )
	nvenc? (
		|| (
			<media-video/ffmpeg-4[nvenc]
			>=media-video/ffmpeg-4[video_cards_nvidia]
		)
	)
	pipewire? ( media-video/pipewire )
	pulseaudio? ( media-sound/pulseaudio )
	python? ( ${PYTHON_DEPS} )
	speex? ( media-libs/speexdsp )
	ssl? ( net-libs/mbedtls:= )
	truetype? (
		media-libs/fontconfig
		media-libs/freetype
	)
	v4l? ( media-libs/libv4l )
	vlc? ( media-video/vlc:= )
	wayland? ( dev-libs/wayland )
"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	mv ${WORKDIR}/obsproject-obs-studio-??????? ${P} || die
	if use browser; then
		rm -d "${P}/plugins/obs-browser" || die
		mv ${WORKDIR}/obs-browser-* ${P}/plugins/obs-browser || die
	fi
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DDISABLE_ALSA=$(usex !alsa)
		-DBUILD_BROWSER=$(usex browser)
		-DENABLE_WAYLAND=$(usex wayland)
		-DDISABLE_FREETYPE=$(usex !truetype)
		-DDISABLE_JACK=$(usex !jack)
		-DDISABLE_LIBFDK=$(usex !fdk)
		-DENABLE_PIPEWIRE=$(usex pipewire)
		-DDISABLE_PULSEAUDIO=$(usex !pulseaudio)
		-DDISABLE_SPEEXDSP=$(usex !speex)
		-DDISABLE_V4L2=$(usex !v4l)
		-DDISABLE_VLC=$(usex !vlc)
		# FL-8476: imagemagick support is going away upstream, so we need to
		# force disable it in our ebuild to avoid failures.
		-DLIBOBS_PREFER_IMAGEMAGICK=0
		-DOBS_MULTIARCH_SUFFIX=${libdir#lib}
		-DUNIX_STRUCTURE=1
		-DWITH_RTMPS=$(usex ssl)
		-DOBS_VERSION_OVERRIDE=${PV}
		# FIXME: No info about this in the install instructions?
		-DBUILD_VST=OFF
	)

	if use browser; then
		mycmakeargs+=(
			-DCEF_ROOT_DIR="../cef_binary_4280_linux64"
		)
	fi

	if use luajit || use python; then
		mycmakeargs+=(
			-DDISABLE_LUA=$(usex !luajit)
			-DDISABLE_PYTHON=$(usex !python)
			-DENABLE_SCRIPTING=yes
		)
	else
		mycmakeargs+=( -DENABLE_SCRIPTING=no )
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update

	if ! use alsa && ! use pulseaudio; then
		elog
		elog "For the audio capture features to be available,"
		elog "either the 'alsa' or the 'pulseaudio' USE-flag needs to"
		elog "be enabled."
		elog
	fi

	if ! has_version "sys-apps/dbus"; then
		elog
		elog "The 'sys-apps/dbus' package is not installed, but"
		elog "could be used for disabling hibernating, screensaving,"
		elog "and sleeping.  Where it is not installed,"
		elog "'xdg-screensaver reset' is used instead"
		elog "(if 'x11-misc/xdg-utils' is installed)."
		elog
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}