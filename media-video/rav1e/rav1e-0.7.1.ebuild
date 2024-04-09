# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The fastest and safest AV1 encoder."
HOMEPAGE="https://github.com/xiph/rav1e"
SRC_URI="https://github.com/xiph/rav1e/tarball/a8d05d0c43826a465b60dbadd0ab7f1327d75371 -> rav1e-0.7.1-a8d05d0.tar.gz
https://direct.funtoo.org/05/71/0d/05710de699c83ac2f17a5627a726d7b0dacbc95eae87d8933bd78440f92193c463451c99048e33ac94c6a0fcdfe263e2fc8446a80078a1146d1ca5d995f32473 -> rav1e-0.7.1-funtoo-crates-bundle-0e9f3f59759fa1e499106fb9fcb5cc0910a86ee73d67c0337cfaec6f30e76b4a1528d7c3de11ddede38ce4452ac661530867ff877f4c0cc57cff1d5c03a9a75f.tar.gz"

RESTRICT=""
LICENSE="BSD-2 Apache-2.0 MIT Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="+capi"

ASM_DEP=">=dev-lang/nasm-2.15"
BDEPEND="
	amd64? ( ${ASM_DEP} )
	capi? ( dev-util/cargo-c )
"

src_unpack() {
	default
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/xiph-rav1e-* ${S} || die
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug "" --release)

	RUSTFLAGS="-C target-cpu=native" cargo build ${args} \
		|| die "cargo build failed"

	if use capi; then
		RUSTFLAGS="-C target-cpu=native" cargo cbuild ${args} --target-dir="capi" \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" \
			|| die "cargo cbuild failed"
	fi
}

src_install() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug --debug "")

	if use capi; then
		cargo cinstall $args --target-dir="capi" \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" --destdir="${ED%/}" \
			|| die "cargo cinstall failed"
	fi

	cargo_src_install
}