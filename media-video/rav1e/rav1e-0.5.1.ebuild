# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.17.0
adler-1.0.2
adler32-1.2.0
aho-corasick-0.7.18
ansi_term-0.12.1
anyhow-1.0.53
aom-sys-0.3.1
arbitrary-0.4.7
arg_enum_proc_macro-0.3.2
arrayvec-0.7.2
assert_cmd-2.0.4
atty-0.2.14
autocfg-1.0.1
av-metrics-0.7.2
backtrace-0.3.64
bindgen-0.59.2
bitflags-1.3.2
bitstream-io-1.2.0
bstr-0.2.17
bumpalo-3.9.1
bytemuck-1.7.3
byteorder-1.4.3
cast-0.2.7
cc-1.0.72
cexpr-0.6.0
cfg-expr-0.7.4
cfg-expr-0.9.1
cfg-if-1.0.0
chrono-0.4.19
clang-sys-1.3.1
clap-2.34.0
cmake-0.1.48
color_quant-1.1.0
console-0.14.1
crc32fast-1.3.1
criterion-0.3.5
criterion-plot-0.4.4
crossbeam-0.8.1
crossbeam-channel-0.5.2
crossbeam-deque-0.8.1
crossbeam-epoch-0.9.7
crossbeam-queue-0.3.4
crossbeam-utils-0.8.7
csv-1.1.6
csv-core-0.1.10
ctor-0.1.21
dav1d-sys-0.3.5
deflate-0.8.6
diff-0.1.12
difflib-0.4.0
doc-comment-0.3.3
either-1.6.1
encode_unicode-0.3.6
env_logger-0.9.0
fern-0.6.0
getrandom-0.2.4
gimli-0.26.1
glob-0.3.0
half-1.8.2
heck-0.3.3
heck-0.4.0
hermit-abi-0.1.19
humantime-2.1.0
image-0.23.14
interpolate_name-0.2.3
itertools-0.8.2
itertools-0.10.3
itoa-0.4.8
itoa-1.0.1
jobserver-0.1.24
js-sys-0.3.56
lab-0.11.0
lazy_static-1.4.0
lazycell-1.3.0
libc-0.2.117
libfuzzer-sys-0.3.5
libloading-0.7.3
log-0.4.14
memchr-2.4.1
memoffset-0.6.5
minimal-lexical-0.2.1
miniz_oxide-0.3.7
miniz_oxide-0.4.4
nasm-rs-0.2.4
nom-7.1.0
noop_proc_macro-0.3.0
num-derive-0.3.3
num-integer-0.1.44
num-iter-0.1.42
num-rational-0.3.2
num-traits-0.2.14
num_cpus-1.13.1
object-0.27.1
oorandom-11.1.3
output_vt100-0.1.2
paste-1.0.6
peeking_take_while-0.1.2
pkg-config-0.3.24
plotters-0.3.1
plotters-backend-0.3.2
plotters-svg-0.3.1
png-0.16.8
ppv-lite86-0.2.16
predicates-2.1.1
predicates-core-1.0.3
predicates-tree-1.0.5
pretty_assertions-0.7.2
proc-macro2-1.0.36
quote-1.0.15
rand-0.8.4
rand_chacha-0.3.1
rand_core-0.6.3
rand_hc-0.3.1
rayon-1.5.1
rayon-core-1.9.1
regex-1.5.4
regex-automata-0.1.10
regex-syntax-0.6.25
rust_hawktracer-0.7.0
rust_hawktracer_normal_macro-0.4.1
rust_hawktracer_proc_macro-0.4.1
rust_hawktracer_sys-0.4.2
rustc-demangle-0.1.21
rustc-hash-1.1.0
rustc_version-0.4.0
ryu-1.0.9
same-file-1.0.6
scan_fmt-0.2.6
scopeguard-1.1.0
semver-1.0.5
serde-1.0.136
serde_cbor-0.11.2
serde_derive-1.0.136
serde_json-1.0.78
shlex-1.1.0
signal-hook-0.3.13
signal-hook-registry-1.4.0
simd_helpers-0.1.0
smallvec-1.8.0
strsim-0.8.0
strum-0.21.0
strum_macros-0.21.1
syn-1.0.86
system-deps-3.1.2
system-deps-6.0.1
termcolor-1.1.2
terminal_size-0.1.17
termtree-0.2.4
textwrap-0.11.0
thiserror-1.0.30
thiserror-impl-1.0.30
time-0.1.43
tinytemplate-1.2.1
toml-0.5.8
unicode-segmentation-1.8.0
unicode-width-0.1.9
unicode-xid-0.2.2
vec_map-0.8.2
version-compare-0.0.11
version-compare-0.1.0
version_check-0.9.4
wait-timeout-0.2.0
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.79
wasm-bindgen-backend-0.2.79
wasm-bindgen-macro-0.2.79
wasm-bindgen-macro-support-0.2.79
wasm-bindgen-shared-0.2.79
web-sys-0.3.56
which-4.2.4
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
y4m-0.7.0

"

inherit cargo

SRC_URI="
	https://api.github.com/repos/xiph/rav1e/tarball/v0.5.1 -> rav1e-0.5.1.tar.gz
	$(cargo_crate_uris ${CRATES})
"
KEYWORDS="*"

DESCRIPTION="The fastest and safest AV1 encoder"
HOMEPAGE="https://github.com/xiph/rav1e"
RESTRICT=""
LICENSE="BSD-2 Apache-2.0 MIT Unlicense"
SLOT="0"

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

	cargo build ${args} \
		|| die "cargo build failed"

	if use capi; then
		cargo cbuild ${args} --target-dir="capi" \
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