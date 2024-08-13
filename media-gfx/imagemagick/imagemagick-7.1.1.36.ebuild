EAPI="7"

inherit flag-o-matic libtool perl-functions toolchain-funcs

SRC_URI="https://api.github.com/repos/ImageMagick/ImageMagick/tarball/7.1.1-36 -> imagemagick-7.1.1-36.tar.gz"
KEYWORDS="*"

DESCRIPTION="A collection of tools and libraries for many image formats"
HOMEPAGE="https://www.imagemagick.org/"

LICENSE="imagemagick"
SLOT="0/${PV}"
IUSE="bzip2 corefonts +cxx djvu fftw fontconfig fpx graphviz hdri heif jbig jpeg jpeg2k lcms lqr lzma opencl openexr openmp pango perl +png postscript q32 q8 raw static-libs svg tiff truetype webp wmf X xml zip zlib"

REQUIRED_USE="corefonts? ( truetype )
	svg? ( xml )"

RESTRICT="test"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	dev-libs/libltdl:0
	bzip2? ( app-arch/bzip2 )
	corefonts? ( media-fonts/corefonts )
	djvu? ( app-text/djvu )
	fftw? ( sci-libs/fftw:3.0 )
	fontconfig? ( media-libs/fontconfig )
	fpx? ( >=media-libs/libfpx-1.3.0-r1 )
	graphviz? ( media-gfx/graphviz )
	heif? ( media-libs/libheif:=[x265] )
	jbig? ( >=media-libs/jbigkit-2:= )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( >=media-libs/openjpeg-2.1.0:2 )
	lcms? ( media-libs/lcms:2= )
	lqr? ( media-libs/liblqr )
	opencl? ( virtual/opencl )
	openexr? ( >=media-libs/openexr-3:= )
	pango? ( x11-libs/pango )
	perl? ( >=dev-lang/perl-5.8.8:0= )
	png? ( media-libs/libpng:0= )
	postscript? ( app-text/ghostscript-gpl )
	raw? ( media-libs/libraw:= )
	svg? (
		gnome-base/librsvg
		media-gfx/potrace
		)
	tiff? ( media-libs/tiff:0= )
	truetype? (
		media-fonts/urw-fonts
		>=media-libs/freetype-2
		)
	webp? ( media-libs/libwebp:0= )
	wmf? ( media-libs/libwmf )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXext
		x11-libs/libXt
		)
	xml? ( dev-libs/libxml2:= )
	lzma? ( app-arch/xz-utils )
	zip? ( dev-libs/libzip:= )
	zlib? ( sys-libs/zlib:= )"

DEPEND="${RDEPEND}
	!media-gfx/graphicsmagick[imagemagick]
	X? ( x11-base/xorg-proto )"


post_src_unpack() {
	mv "${WORKDIR}"/ImageMagick-ImageMagick-* "${S}" || die
}

src_configure() {
	local depth=16
	use q8 && depth=8
	use q32 && depth=32

	local openmp=disable
	use openmp && { tc-has-openmp && openmp=enable; }

	use perl && perl_check_env

	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lnsl -lsocket

	local myeconfargs=(
		--with-security-policy=open
		$(use_enable static-libs static)
		$(use_enable hdri)
		$(use_enable opencl)
		--with-threads
		--with-modules
		--with-quantum-depth=${depth}
		$(use_with cxx magick-plus-plus)
		$(use_with perl)
		--with-perl-options='INSTALLDIRS=vendor'
		--with-gs-font-dir="${EPREFIX}"/usr/share/fonts/urw-fonts
		$(use_with bzip2 bzlib)
		$(use_with X x)
		$(use_with zip)
		$(use_with zlib)
		--without-autotrace
		$(use_with postscript dps)
		$(use_with djvu)
		--with-dejavu-font-dir="${EPREFIX}"/usr/share/fonts/dejavu
		$(use_with fftw)
		$(use_with fpx)
		$(use_with fontconfig)
		$(use_with truetype freetype)
		$(use_with postscript gslib)
		$(use_with graphviz gvc)
		$(use_with heif heic)
		$(use_with jbig)
		$(use_with jpeg)
		$(use_with jpeg2k openjp2)
		--without-jxl
		$(use_with lcms)
		$(use_with lqr)
		$(use_with lzma)
		$(use_with openexr)
		$(use_with pango)
		$(use_with png)
		$(use_with raw)
		$(use_with svg rsvg)
		$(use_with tiff)
		$(use_with webp)
		$(use_with corefonts windows-font-dir "${EPREFIX}"/usr/share/fonts/corefonts)
		$(use_with wmf)
		$(use_with xml)
		--${openmp}-openmp
		--with-gcc-arch=no-automagic
	)
	CONFIG_SHELL=$(type -P bash) econf "${myeconfargs[@]}"
}

src_install() {
	# Ensure documentation installation files and paths with each release!
	emake \
		DESTDIR="${D}" \
		DOCUMENTATION_PATH="${EPREFIX}"/usr/share/doc/${PF}/html \
		install

	rm -f "${ED}"/usr/share/doc/${PF}/html/{ChangeLog,LICENSE,NEWS.txt}
	for doc in [ {AUTHORS,README}.txt ChangeLog* ]; do
		if [ -f ${doc} ]; then
			dodoc ${doc}
		fi
	done

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -exec rm -f {} +
		find "${ED}" -depth -mindepth 1 -type d -empty -exec rm -rf {} +
	fi

	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
	# .la files in parent are not needed, keep plugin .la files
	find "${ED}"/usr/$(get_libdir)/ -maxdepth 1 -name "*.la" -delete || die

	if use opencl; then
		cat <<-EOF > "${T}"/99${PN}
		SANDBOX_PREDICT="/dev/nvidiactl:/dev/nvidia-uvm:/dev/ati/card:/dev/dri/card:/dev/dri/card0:/dev/dri/renderD128"
		EOF

		insinto /etc/sandbox.d
		doins "${T}"/99${PN} #472766
	fi

	insinto /usr/share/${PN}
	doins config/*icm
}