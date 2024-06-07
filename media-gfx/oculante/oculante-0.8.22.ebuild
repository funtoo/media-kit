# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A fast and simple image viewer / editor for many operating systems"
HOMEPAGE="https://github.com/woelper/oculante"
SRC_URI="https://github.com/woelper/oculante/tarball/530d9414ce7381cc8dd8774dc044bad07e1ba1c7 -> oculante-0.8.22-530d941.tar.gz
https://direct.funtoo.org/87/f0/cf/87f0cf6b64d0589bfef01079e68ef2f6d16001a028cb12d9f6905c43a9aef7ad3f8dbc0c3a636468c1dcddf99a49a6ad3934c02413149a9974757cec5a46a59e -> oculante-0.8.22-funtoo-crates-bundle-36851e79902f8182537f884197c25956a3119a0e43f8c32e7f85949008354f883a1dd8d0fd652bc64411aabe7d704251de4a15381db52f2e55fd3f0d8005d834.tar.gz"

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