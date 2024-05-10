# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake java-pkg-opt-2

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="https://github.com/libjpeg-turbo/libjpeg-turbo/tarball/7fa4b5b762c9a99b46b0b7838f5fd55071b92ea5 -> libjpeg-turbo-3.0.3-7fa4b5b.tar.gz"

LICENSE="BSD IJG ZLIB"
SLOT="0/0.2"
KEYWORDS="*"
IUSE="cpu_flags_arm_neon java static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"

COMMON_DEPEND="!media-libs/jpeg:0
	!media-libs/jpeg:62"

BDEPEND=">=dev-util/cmake-3.16.5
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.8:*[-headless-awt] )"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv ${WORKDIR}/libjpeg-turbo* ${S} || die
	fi
}

src_prepare() {
	cmake_src_prepare
	java-pkg-opt-2_src_prepare
}

src_configure() {
	if use java ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_STATIC="$(usex static-libs)"
		-DWITH_JAVA="$(usex java)"
		-DWITH_MEM_SRCDST=ON
	)

	# Avoid ARM ABI issues by disabling SIMD for CPUs without NEON. #792810
	if use arm || use arm64; then
		mycmakeargs+=(
			-DWITH_SIMD=$(usex cpu_flags_arm_neon)
			-DNEON_INTRINSICS=$(usex cpu_flags_arm_neon)
		)
	fi

	# We should tell the test suite which floating-point flavor we are
	# expecting: https://github.com/libjpeg-turbo/libjpeg-turbo/issues/597
	# For now, mark loong as fp-contract.
	#if use loong; then
	#	mycmakeargs+=(
	#		-DFLOATTEST=fp-contract
	#	)
	#fi

	# mostly for Prefix, ensure that we use our yasm if installed and
	# not pick up host-provided nasm
	if has_version -b dev-lang/yasm && ! has_version -b dev-lang/nasm; then
		mycmakeargs+=(
			-DCMAKE_ASM_NASM_COMPILER=$(type -P yasm)
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use java ; then
		rm -rf "${ED}"/usr/share/java || die
		java-pkg_dojar ${BUILD_DIR}/java/turbojpeg.jar
	fi

	find "${ED}" -type f -name '*.la' -delete || die

	local -a DOCS=( README.md ChangeLog.md )
	einstalldocs

	docinto html
	dodoc -r "${S}"/doc/html/.

	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/.
		newdoc "${S}"/java/README README.java
	fi
}