EAPI=7

PYTHON_COMPAT=( python3+ )
LUA_COMPAT=( lua5-{2..5} )


inherit autotools python-single-r1 lua-single toolchain-funcs


DESCRIPTION="Ham radio backend rig control libraries"
HOMEPAGE="http://www.hamlib.org"
SRC_URI="https://github.com/hamlib/hamlib/tarball/413be5a4cfd32455eefe6a6ad2a2b150e6926e9f -> hamlib-4.5.5-413be5a.tar.gz"

LICENSE="LGPL-2 GPL-2"

MY_PV=$(ver_cut 1-2 )
SLOT="0/${MY_PV}"

KEYWORDS="*"
IUSE="doc perl python tcl lua"

RESTRICT="test"

RDEPEND="
	=virtual/libusb-0*
	dev-libs/libxml2
	sys-libs/readline:0=
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )
	lua? ( ${LUA_DEPS} )"

DEPEND=" ${RDEPEND}
	virtual/pkgconfig
	python? ( dev-lang/swig )
	>=sys-devel/libtool-2.2
	doc? ( app-doc/doxygen
		dev-util/source-highlight )"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"


DOCS=(AUTHORS NEWS PLAN README README.betatester README.developer)


post_src_unpack() {
	mv "${WORKDIR}"/Hamlib-Hamlib-* "${S}" || die
}


pkg_setup() {
	use python && python-single-r1_pkg_setup
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default

	# fix hardcoded libdir paths
	sed -i -e "s#fix}/lib#fix}/$(get_libdir)/hamlib#" \
		-e "s#fix}/include#fix}/include/hamlib#" \
		hamlib.pc.in || die "sed failed"

	# Correct install target to whatever INSTALLDIRS says and use vendor
	# installdirs everywhere (bug #611550)
	sed -i -e "s#install_site#install#"	\
	-e 's#MAKEFILE="Hamlib-pl.mk"#MAKEFILE="Hamlib-pl.mk" INSTALLDIRS=vendor#' \
	bindings/Makefile.am || die "sed failed patching for perl"

	# make building of documentation compatible with autotools-utils
	sed -i -e "s/doc:/html:/g" doc/Makefile.am || die "sed failed"

	
	eautoreconf
}

src_configure() {

	export LUA=${LUA}
	export LUA_LIB=$(lua_get_LIBS)
	export LUA_INCLUDE=-I$(lua_get_include_dir)

	econf \
		--libdir=/usr/$(get_libdir)/hamlib \
		--disable-static \
		--with-xml-support \
		$(use_with perl perl-binding) \
		$(use_with python python-binding) \
		$(use_with tcl tcl-binding) \
		$(use_with lua lua-binding)
}

src_compile() {
	emake
	use doc && emake html
}

src_install() {
	emake DESTDIR="${D}" install

	use python && python_optimize

	use doc && HTML_DOCS=( doc/html/ )
	einstalldocs

	insinto /usr/$(get_libdir)/pkgconfig
	doins hamlib.pc

	echo "LDPATH=/usr/$(get_libdir)/hamlib" > "${T}"/73hamlib
	doenvd "${T}"/73hamlib

	find "${ED}" -name '*.la' -delete || die
}