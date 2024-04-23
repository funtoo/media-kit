EAPI=7

inherit flag-o-matic

DESCRIPTION="Sound card based multimode software modem for Amateur Radio use"
HOMEPAGE="http://www.w1hkj.com"
SRC_URI="https://downloads.sourceforge.net/fldigi/fldigi/fldigi-4.2.05.tar.gz -> fldigi-4.2.05.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="hamlib nls pulseaudio"
IUSE_CPU_FLAGS=" sse sse2 sse3 avx avx2"
IUSE+=" ${IUSE_CPU_FLAGS// / cpu_flags_x86_}"

RDEPEND="x11-libs/fltk:1[threads,xft]
	media-libs/libsamplerate
	media-libs/libpng:0
	x11-misc/xdg-utils
	dev-perl/RPC-XML
	dev-perl/Term-ReadLine-Perl
	media-libs/portaudio[alsa]
	hamlib? ( media-libs/hamlib:= )
	pulseaudio? ( media-sound/pulseaudio )
	>=media-libs/libsndfile-1.0.10"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	#fails to compile with -flto (bug #860405)
	filter-lto

	append-cxxflags $(test-flags-CXX -std=c++14)
	local myconf=""

	# technically it only takes one value
	use cpu_flags_x86_sse && myconf="${myconf} --enable-optimizations=sse"
	use cpu_flags_x86_sse2 && myconf="${myconf} --enable-optimizations=sse2"
	use cpu_flags_x86_sse3 && myconf="${myconf} --enable-optimizations=sse3"
	use cpu_flags_x86_avx && myconf="${myconf} --enable-optimizations=avx"
	use cpu_flags_x86_avx2 && myconf="${myconf} --enable-optimizations=avx2"

	econf ${myconf} \
		--with-sndfile \
		$(use_with hamlib) \
		$(use_enable nls) \
		$(use_with pulseaudio) \
		--without-asciidoc
}