# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A fast and simple image viewer / editor for many operating systems"
HOMEPAGE="https://github.com/woelper/oculante"
SRC_URI="https://github.com/woelper/oculante/tarball/6e412ecba9f837f096b433d9f8db06bdb8f96477 -> oculante-0.9.1-6e412ec.tar.gz
https://direct.funtoo.org/0a/c2/2e/0ac22e03b527f85179727235aed4f0b73fbf33afa09deea85e592a0645c8ed3c5ad437b3cd359417c33929decb2cf676be925dc482735da220e82910bc22c885 -> oculante-0.9.1-funtoo-crates-bundle-f2b2a1281e460dc5996e90563439e40ce2f2ba5c33bb5d08681363d2946494bca7e110ade0decdc1fb57c2d6ae9f1b1d01a97e171919022b18f7ae313b8d18a8.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

ASM_DEP=">=dev-lang/nasm-2.15"
DEPEND="
	app-arch/bzip2
	app-arch/brotli
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/libffi
	media-libs/freetype
	media-libs/fontconfig
	media-libs/harfbuzz
	media-libs/libglvnd
	media-libs/libpng
	media-gfx/graphite2
	sys-apps/dbus
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gtk+
	x11-libs/pango
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXfixes
"
RDEPEND="${DEPEND}"
BDEPEND="
	amd64? ( ${ASM_DEP} )
	dev-util/cmake
	virtual/rust
"

DOCS=( README.md CHANGELOG.md )

QA_FLAGS_IGNORED="/usr/bin/oculante"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/woelper-oculante-* ${S} || die
}

src_install() {
	cargo_src_install
	einstalldocs
}