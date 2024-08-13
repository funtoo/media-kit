# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
SRC_URI="https://github.com/libsdl-org/SDL/tarball/ba2f78a0069118a6c583f1fbf1420144ffa35bad -> SDL-2.30.6-ba2f78a.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"

IUSE="alsa aqua cpu_flags_ppc_altivec cpu_flags_x86_3dnow cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 custom-cflags dbus doc fcitx gles1 gles2 haptic ibus jack +joystick kms libsamplerate nas opengl oss pipewire pulseaudio sndio +sound static-libs +threads udev +video video_cards_vc4 vulkan wayland X xscreensaver"
REQUIRED_USE="
	alsa? ( sound )
	fcitx? ( dbus )
	gles1? ( video )
	gles2? ( video )
	haptic? ( joystick )
	ibus? ( dbus )
	jack? ( sound )
	nas? ( sound )
	opengl? ( video )
	pulseaudio? ( sound )
	sndio? ( sound )
	vulkan? ( video )
	wayland? ( gles2 )
	xscreensaver? ( X )"

CDEPEND="
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	fcitx? ( app-i18n/fcitx )
	gles1? ( media-libs/mesa[gles1] )
	gles2? ( media-libs/mesa[gles2] )
	ibus? ( app-i18n/ibus )
	jack? ( virtual/jack )
	kms? (
		x11-libs/libdrm
		media-libs/mesa[gbm(+)]
	)
	libsamplerate? ( media-libs/libsamplerate )
	nas? (
		media-libs/nas
		x11-libs/libXt
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)
	pipewire? ( media-video/pipewire )
	pulseaudio? ( media-sound/pulseaudio )
	sndio? ( media-sound/sndio )
	udev? ( virtual/libudev )
	wayland? (
		dev-libs/wayland
		media-libs/mesa[egl(+),gles2,wayland]
		x11-libs/libxkbcommon
	)
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		xscreensaver? ( x11-libs/libXScrnSaver )
	)"
RDEPEND="${CDEPEND}
	vulkan? ( media-libs/vulkan-loader )"
DEPEND="${CDEPEND}
	ibus? ( dev-libs/glib:2 )
	vulkan? ( dev-util/vulkan-headers )
	X? ( x11-base/xorg-proto )"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	wayland? ( dev-util/wayland-scanner )"

post_src_unpack() {
	mv "${WORKDIR}"/libsdl-org-SDL-* "$S" || die
}


src_configure() {
	use custom-cflags || strip-flags

	local myeconfargs=(
		$(use_enable static-libs static)
		--enable-atomic
		$(use_enable sound audio)
		$(use_enable video)
		--enable-render
		--enable-events
		$(use_enable joystick)
		$(use_enable haptic)
		--enable-power
		--enable-filesystem
		$(use_enable threads pthreads)
		--enable-timers
		--enable-file
		--enable-loadso
		--enable-cpuinfo
		--enable-assembly
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_sse ssemath)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_3dnow 3dnow)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable oss)
		$(use_enable alsa)
		--disable-alsa-shared
		$(use_enable jack)
		--disable-jack-shared
		--disable-esd
		$(use_enable pipewire)
		--disable-pipewire-shared
		$(use_enable pulseaudio)
		--disable-pulseaudio-shared
		--disable-arts
		$(use_enable libsamplerate)
		$(use_enable nas)
		--disable-nas-shared
		$(use_enable sndio)
		--disable-sndio-shared
		$(use_enable sound diskaudio)
		$(use_enable sound dummyaudio)
		$(use_enable wayland video-wayland)
		--disable-wayland-shared
		$(use_enable video_cards_vc4 video-rpi)
		$(use_enable X video-x11)
		--disable-x11-shared
		$(use_enable X video-x11-xcursor)
		$(use_enable X video-x11-xdbe)
		$(use_enable X video-x11-xfixes)
		$(use_enable X video-x11-xinput)
		$(use_enable X video-x11-xrandr)
		$(use_enable xscreensaver video-x11-scrnsaver)
		$(use_enable X video-x11-xshape)
		$(use_enable aqua video-cocoa)
		--disable-video-directfb
		--disable-fusionsound
		--disable-fusionsound-shared
		$(use_enable kms video-kmsdrm)
		--disable-kmsdrm-shared
		$(use_enable video video-dummy)
		$(use_enable opengl video-opengl)
		$(use_enable gles1 video-opengles1)
		$(use_enable gles2 video-opengles2)
		$(use_enable vulkan video-vulkan)
		$(use_enable udev libudev)
		$(use_enable dbus)
		$(use_enable fcitx)
		$(use_enable ibus)
		--disable-directx
		--disable-rpath
		--disable-render-d3d
		$(use_with X x)
	)

	econf "${myeconfargs[@]}"
}
src_compile() {
	default
	if use doc; then
		cd docs || die
		doxygen || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -type f -name "*.la" -delete || die

	dodoc {BUGS,CREDITS,README-SDL,TODO,WhatsNew}.txt README.md docs/README*.md
	use doc && dodoc -r docs/output/html/
}