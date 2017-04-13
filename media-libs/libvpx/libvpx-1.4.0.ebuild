# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib toolchain-funcs multilib-minimal

LIBVPX_TESTDATA_VER=1.4.0

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="https://chromium.googlesource.com/webm/${PN}.git"
elif [[ ${PV} == *pre* ]]; then
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
else
	SRC_URI="http://storage.googleapis.com/downloads.webmproject.org/releases/webm/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi
# generated by: make LIBVPX_TEST_DATA_PATH=libvpx-testdata testdata + tar'ing
# it.
SRC_URI="${SRC_URI}
	test? ( mirror://gentoo/${PN}-testdata-${LIBVPX_TESTDATA_VER}.tar.bz2 )"

DESCRIPTION="WebM VP8 Codec SDK"
HOMEPAGE="http://www.webmproject.org"

LICENSE="BSD"
SLOT="0/2"
IUSE="altivec cpu_flags_x86_avx cpu_flags_x86_avx2 doc cpu_flags_x86_mmx postproc cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 static-libs test +threads"

RDEPEND="abi_x86_32? ( !app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
"

src_prepare() {
	epatch "${FILESDIR}/libvpx-1.3.0-sparc-configure.patch" # 501010
}

multilib_src_configure() {
	unset CODECS #357487

	# let the build system decide which AS to use (it honours $AS but
	# then feeds it with yasm flags without checking...) #345161
	tc-export AS
	case "${CHOST}" in
		i?86*) export AS=yasm;;
		x86_64*) export AS=yasm;;
	esac

	# https://bugs.gentoo.org/show_bug.cgi?id=384585
	# https://bugs.gentoo.org/show_bug.cgi?id=465988
	# copied from php-pear-r1.eclass
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/
	addpredict /var/lib/net-snmp/mib_indexes
	addpredict /session_mm_cli0.sem

	# Build with correct toolchain.
	tc-export CC CXX AR NM
	# Link with gcc by default, the build system should override this if needed.
	export LD="${CC}"

	local myconf
	if [ "${ABI}" = "${DEFAULT_ABI}" ] ; then
		myconf+=" $(use_enable doc install-docs) $(use_enable doc docs)"
	else
		# not needed for multilib and will be overwritten anyway.
		myconf+=" --disable-examples --disable-install-docs --disable-docs"
	fi

	# https://bugs.gentoo.org/569146
	export LC_COLLATE=C

	# #498364: sse doesn't work without sse2 enabled,
	"${S}/configure" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--enable-pic \
		--enable-vp8 \
		--enable-shared \
		--extra-cflags="${CFLAGS}" \
		$(use_enable altivec) \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable cpu_flags_x86_avx2 avx2) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable postproc) \
		$(use cpu_flags_x86_sse2 && use_enable cpu_flags_x86_sse sse || echo --disable-sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse4_1) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable static-libs static) \
		$(use_enable test unit-tests) \
		$(use_enable threads multithread) \
		${myconf} \
		|| die
}

multilib_src_compile() {
	# build verbose by default and do not build examples that will not be installed
	emake verbose=yes GEN_EXAMPLES=
}

multilib_src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}:${LD_LIBRARY_PATH}" \
		emake verbose=yes GEN_EXAMPLES=  LIBVPX_TEST_DATA_PATH="${WORKDIR}/${PN}-testdata" test
}

multilib_src_install() {
	emake verbose=yes GEN_EXAMPLES= DESTDIR="${D}" install
	[ "${ABI}" = "${DEFAULT_ABI}" ] && use doc && dohtml docs/html/*
}
