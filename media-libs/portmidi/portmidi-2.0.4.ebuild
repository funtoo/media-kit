# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="portmidi is a cross-platform MIDI input/output library"
HOMEPAGE="https://github.com/PortMidi/portmidi"
SRC_URI="https://github.com/PortMidi/portmidi/tarball/b808babecdc5d05205467dab5c1006c5ac0fdfd4 -> portmidi-2.0.4-b808bab.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="debug test-programs"
# Per pm-test/README:
# "Because device numbers depend on the system, there is no automated
# script to run all tests on PortMidi."
RESTRICT="test"

RDEPEND="
	media-libs/alsa-lib
"
DEPEND="
	${DEPEND}
"
BDEPEND="
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.4-cmake.patch
)

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv ${WORKDIR}/PortMidi-portmidi-* ${S} || die
	fi
}

src_prepare(){
	cmake_src_prepare
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	# Python bindings dropped b/c of bug #855077
	local mycmakeargs=(
		-DBUILD_PORTMIDI_TESTS=$(usex test-programs)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc CHANGELOG.txt README.txt pm_linux/README_LINUX.txt

	if use test-programs ; then
		exeinto /usr/$(get_libdir)/${PN}
		local app
		for app in latency midiclock midithread midithru mm qtest sysex ; do
			doexe "${BUILD_DIR}"/pm_test/${app}
		done
	fi
}