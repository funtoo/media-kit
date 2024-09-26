# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Libraries for standards-based RTP/RTCP/RTSP multimedia streaming"
HOMEPAGE="http://www.live555.com/"
SRC_URI="http://www.live555.com/liveMedia/public/live.2024.09.25.tar.gz -> live.2024.09.25.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="*"
IUSE="libressl ssl"

BDEPEND="virtual/pkgconfig"
DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
RDEPEND="${DEPEND}"

DOCS=( "live-shared/README" )

# Alexis Ballier <aballier@gentoo.org>, Sam James <sam@gentoo.org>
# Be careful, bump this everytime you bump the package and the ABI has changed.
# If you don't know, ask someone.
# You may wish to use a site like https://abi-laboratory.pro/index.php?view=timeline&l=live555
LIVE_ABI_VERSION=9
SLOT="0/${LIVE_ABI_VERSION}"

S="${WORKDIR}/live"

src_prepare() {
	cp "${FILESDIR}/config.funtoo" ${S}/ || die
	default
}

src_configure() {
	# This ebuild uses its own build system
	# We don't want to call ./configure or anything here.
	# The only thing we can do is honour the user's SSL preference.
	if use ssl ; then
		sed -i 's/-DNO_OPENSSL=1//' "${S}/config.funtoo" || die
	fi

	# Bug 718912
	tc-export CC CXX

	# And defer to the scripts that upstream provide.
	./genMakefiles funtoo || die
}

src_compile() {
	export suffix="${LIVE_ABI_VERSION}.so"
	local link_opts="$(usex ssl "$(pkg-config --libs libssl libcrypto)" '') -L. ${LDFLAGS}"
	local lib_suffix="${suffix#.}"

	einfo "Beginning shared library build"
	emake LINK_OPTS="${link_opts}" LIB_SUFFIX="${lib_suffix}"

	for i in liveMedia groupsock UsageEnvironment BasicUsageEnvironment ; do
		cd "${S}/${i}" || die
		ln -s "lib${i}.${suffix}" "lib${i}.so" || die
	done

	einfo "Beginning programs build"
	for i in proxyServer mediaServer ; do
		cd "${S}/${i}" || die
		emake LINK_OPTS="${link_opts}"
	done
}

src_install() {
	for library in UsageEnvironment liveMedia BasicUsageEnvironment groupsock ; do
		dolib.so "${S}/${library}/lib${library}.${suffix}"
		dosym "lib${library}.${suffix}" "/usr/$(get_libdir)/lib${library}.so"

		insinto /usr/include/"${library}"
		doins "${S}/${library}"/include/*h
	done

	dobin "${S}"/mediaServer/live555MediaServer
	dobin "${S}"/proxyServer/live555ProxyServer
}