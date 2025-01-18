# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A fast and simple image viewer / editor for many operating systems"
HOMEPAGE="https://github.com/woelper/oculante"
SRC_URI="https://github.com/woelper/oculante/tarball/45caafa71eb69831475d06324da4dedd33edc20f -> oculante-0.9.2-45caafa.tar.gz
https://direct.funtoo.org/b4/68/0b/b4680b57c1d3a27ab2ed2306620881cf59c287f96d0247e1b432859dc6bd8260c78a62d013072f75981cc1dccf1cb55343b02e9d9d157d9e595fa5e76e4a4770 -> oculante-0.9.2-funtoo-crates-bundle-2eb9e645af39de898a0ed05e499205732ca0ad623caf541179ecef9f92f12f233c35e7436ac535775ff6e47c80f45a008c0b5e3a1338d8421ab12944aadd1a16.tar.gz"

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