# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic toolchain-funcs

MY_PN=OpenEXR

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://www.openexr.com/"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/tarball/b63929420545f811f9ba778a72b0d5ed6a4837e6 -> openexr-3.3.1-b639294.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE="cpu_flags_x86_avx examples large-stack static-libs utils threads"
RESTRICT="( test )"

# FL-9012: blocker below to address an earlier version of openexr having a incorrect SLOT of 2.
RDEPEND="
	>=dev-libs/imath-3.1.0:=
	sys-libs/zlib
	app-arch/libdeflate
	!!media-libs/openexr:2
	!!media-libs/ilmbase
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGES.md GOVERNANCE.md PATENTS README.md SECURITY.md website/SymbolVisibility.rst )

post_src_unpack() {
	mv "${WORKDIR}/"AcademySoftwareFoundation-openexr* "${S}" || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=OFF
		-DOPENEXR_BUILD_TOOLS=$(usex utils)
		-DOPENEXR_ENABLE_LARGE_STACK=$(usex large-stack)
		-DOPENEXR_ENABLE_THREADING=$(usex threads)
		-DOPENEXR_INSTALL_EXAMPLES=$(usex examples)
		-DOPENEXR_INSTALL_PKG_CONFIG=ON
		-DOPENEXR_INSTALL_TOOLS=$(usex utils)
		-DOPENEXR_USE_CLANG_TIDY=OFF		# don't look for clang-tidy
	)

	cmake_src_configure
}

src_install() {
	use examples && docompress -x /usr/share/doc/${PF}/examples
	cmake_src_install
}