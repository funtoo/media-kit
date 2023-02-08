# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.19.0
adler-1.0.2
aho-corasick-0.7.20
anes-0.1.6
anyhow-1.0.69
aom-sys-0.3.2
arbitrary-0.4.7
arg_enum_proc_macro-0.3.2
arrayvec-0.7.2
assert_cmd-2.0.8
atty-0.2.14
autocfg-1.1.0
av-metrics-0.9.0
av1-grain-0.2.2
backtrace-0.3.67
bindgen-0.61.0
bitflags-1.3.2
bitstream-io-1.6.0
bstr-1.2.0
built-0.5.3
bumpalo-3.12.0
bytemuck-1.13.0
byteorder-1.4.3
cargo-lock-8.0.3
cast-0.3.0
cc-1.0.79
cexpr-0.6.0
cfg-expr-0.11.0
cfg-if-1.0.0
ciborium-0.2.0
ciborium-io-0.2.0
ciborium-ll-0.2.0
clang-sys-1.4.0
clap-3.2.23
clap-4.1.4
clap_complete-4.1.1
clap_derive-4.1.0
clap_lex-0.2.4
clap_lex-0.3.1
cmake-0.1.49
color_quant-1.1.0
console-0.15.5
const_fn_assert-0.1.2
crc32fast-1.3.2
criterion-0.4.0
criterion-plot-0.5.0
crossbeam-0.8.2
crossbeam-channel-0.5.6
crossbeam-deque-0.8.2
crossbeam-epoch-0.9.13
crossbeam-queue-0.3.8
crossbeam-utils-0.8.14
ctor-0.1.26
dav1d-sys-0.7.0
diff-0.1.13
difflib-0.4.0
doc-comment-0.3.3
either-1.8.1
encode_unicode-0.3.6
env_logger-0.8.4
errno-0.2.8
errno-dragonfly-0.1.2
fern-0.6.1
flate2-1.0.25
form_urlencoded-1.1.0
getrandom-0.2.8
gimli-0.27.1
git2-0.16.1
glob-0.3.1
half-1.8.2
hashbrown-0.12.3
heck-0.4.1
hermit-abi-0.1.19
hermit-abi-0.2.6
hermit-abi-0.3.1
idna-0.3.0
image-0.24.5
indexmap-1.9.2
interpolate_name-0.2.3
io-lifetimes-1.0.5
is-terminal-0.4.3
itertools-0.8.2
itertools-0.10.5
itoa-1.0.5
jobserver-0.1.25
js-sys-0.3.61
lab-0.11.0
lazy_static-1.4.0
lazycell-1.3.0
libc-0.2.139
libfuzzer-sys-0.3.5
libgit2-sys-0.14.2+1.5.1
libloading-0.7.4
libz-sys-1.1.8
linux-raw-sys-0.1.4
log-0.4.17
maybe-rayon-0.1.1
memchr-2.5.0
memoffset-0.7.1
minimal-lexical-0.2.1
miniz_oxide-0.6.2
nasm-rs-0.2.4
new_debug_unreachable-1.0.4
nom-7.1.3
noop_proc_macro-0.3.0
num-bigint-0.4.3
num-derive-0.3.3
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.15
num_cpus-1.15.0
object-0.30.3
once_cell-1.17.0
oorandom-11.1.3
os_str_bytes-6.4.1
output_vt100-0.1.3
paste-1.0.11
peeking_take_while-0.1.2
percent-encoding-2.2.0
pkg-config-0.3.26
plotters-0.3.4
plotters-backend-0.3.4
plotters-svg-0.3.3
png-0.17.7
ppv-lite86-0.2.17
predicates-2.1.5
predicates-core-1.0.5
predicates-tree-1.0.7
pretty_assertions-1.3.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.51
quickcheck-1.0.3
quickcheck_macros-1.0.0
quote-1.0.23
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rayon-1.6.1
rayon-core-1.10.2
regex-1.7.1
regex-automata-0.1.10
regex-syntax-0.6.28
rust_hawktracer-0.7.0
rust_hawktracer_normal_macro-0.4.1
rust_hawktracer_proc_macro-0.4.1
rust_hawktracer_sys-0.4.2
rustc-demangle-0.1.21
rustc-hash-1.1.0
rustc_version-0.4.0
rustix-0.36.8
ryu-1.0.12
same-file-1.0.6
scan_fmt-0.2.6
scopeguard-1.1.0
semver-1.0.16
serde-1.0.152
serde-big-array-0.4.1
serde_derive-1.0.152
serde_json-1.0.92
shlex-1.1.0
signal-hook-0.3.14
signal-hook-registry-1.4.0
simd_helpers-0.1.0
smallvec-1.10.0
syn-1.0.107
system-deps-6.0.3
termcolor-1.2.0
terminal_size-0.2.3
termtree-0.4.0
textwrap-0.16.0
thiserror-1.0.38
thiserror-impl-1.0.38
tinytemplate-1.2.1
tinyvec-1.6.0
tinyvec_macros-0.1.1
toml-0.5.11
unicode-bidi-0.3.10
unicode-ident-1.0.6
unicode-normalization-0.1.22
unicode-width-0.1.10
url-2.3.1
v_frame-0.3.3
vcpkg-0.2.15
version-compare-0.1.1
version_check-0.9.4
wait-timeout-0.2.0
walkdir-2.3.2
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.84
wasm-bindgen-backend-0.2.84
wasm-bindgen-macro-0.2.84
wasm-bindgen-macro-support-0.2.84
wasm-bindgen-shared-0.2.84
web-sys-0.3.61
which-4.4.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.42.0
windows-sys-0.45.0
windows-targets-0.42.1
windows_aarch64_gnullvm-0.42.1
windows_aarch64_msvc-0.42.1
windows_i686_gnu-0.42.1
windows_i686_msvc-0.42.1
windows_x86_64_gnu-0.42.1
windows_x86_64_gnullvm-0.42.1
windows_x86_64_msvc-0.42.1
y4m-0.7.0
yansi-0.5.1

"

inherit cargo

SRC_URI="
	https://api.github.com/repos/xiph/rav1e/tarball/v0.6.3 -> rav1e-0.6.3.tar.gz
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