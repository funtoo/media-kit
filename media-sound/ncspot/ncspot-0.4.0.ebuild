# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.14.1
adler-0.2.3
aes-0.3.2
aes-ctr-0.3.0
aes-soft-0.3.3
aesni-0.6.0
ahash-0.6.3
aho-corasick-0.7.15
alga-0.9.3
alsa-0.2.2
alsa-sys-0.1.2
ansi_term-0.11.0
approx-0.3.2
array-macro-1.0.5
arrayref-0.3.6
arrayvec-0.5.2
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.1
backtrace-0.3.56
base64-0.9.3
base64-0.10.1
base64-0.13.0
bindgen-0.56.0
bit-set-0.5.2
bit-vec-0.6.3
bitflags-0.9.1
bitflags-1.2.1
blake2b_simd-0.5.11
block-0.1.6
block-buffer-0.7.3
block-cipher-trait-0.6.2
block-padding-0.1.5
bumpalo-3.6.0
byte-tools-0.3.1
byteorder-1.4.2
bytes-0.4.12
bytes-0.5.6
bytes-1.0.1
cc-1.0.66
cexpr-0.4.0
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clang-sys-1.0.3
clap-2.33.3
clipboard-0.5.0
clipboard-win-2.2.0
cloudabi-0.0.3
constant_time_eq-0.1.5
cookie-0.12.0
cookie_store-0.7.0
core-foundation-0.9.1
core-foundation-sys-0.5.1
core-foundation-sys-0.8.2
coreaudio-rs-0.9.1
coreaudio-sys-0.2.8
cpal-0.8.2
crc32fast-1.2.1
crossbeam-channel-0.5.0
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.2.3
crossbeam-utils-0.7.2
crossbeam-utils-0.8.1
crypto-mac-0.7.0
ctr-0.3.2
cursive-0.16.3
cursive_core-0.2.2
darling-0.9.0
darling-0.10.2
darling_core-0.9.0
darling_core-0.10.2
darling_macro-0.9.0
darling_macro-0.10.2
dbus-0.9.1
dbus-tree-0.9.0
derive_builder-0.7.2
derive_builder_core-0.5.0
digest-0.8.1
dirs-1.0.5
dirs-next-1.0.2
dirs-sys-next-0.1.2
dotenv-0.13.0
dtoa-0.4.7
either-1.6.1
encoding_rs-0.8.26
enum-map-0.6.4
enum-map-derive-0.4.6
env_logger-0.6.2
error-chain-0.12.4
failure-0.1.8
failure_derive-0.1.8
fake-simd-0.1.2
fern-0.6.0
flate2-1.0.20
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.0.0
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.30
futures-0.3.12
futures-channel-0.3.12
futures-core-0.3.12
futures-cpupool-0.1.8
futures-executor-0.3.12
futures-io-0.3.12
futures-macro-0.3.12
futures-sink-0.3.12
futures-task-0.3.12
futures-util-0.3.12
generic-array-0.12.3
getrandom-0.1.16
getrandom-0.2.2
gimli-0.23.0
glob-0.3.0
h2-0.1.26
h2-0.2.7
hashbrown-0.9.1
heck-0.3.2
hermit-abi-0.1.18
hmac-0.7.1
http-0.1.21
http-0.2.3
http-body-0.1.0
http-body-0.3.1
httparse-1.3.5
httpdate-0.3.2
humantime-1.3.0
hyper-0.11.27
hyper-0.12.35
hyper-0.13.9
hyper-proxy-0.4.1
hyper-tls-0.3.2
hyper-tls-0.4.3
ident_case-1.0.1
idna-0.1.5
idna-0.2.0
indexmap-1.6.1
iovec-0.1.4
ipnet-2.3.0
itertools-0.8.2
itoa-0.4.7
js-sys-0.3.47
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-1.4.0
lazycell-1.3.0
lewton-0.9.4
libc-0.2.85
libdbus-sys-0.2.1
libloading-0.6.7
libm-0.2.1
libpulse-sys-0.0.0
librespot-audio-0.1.3
librespot-core-0.1.3
librespot-metadata-0.1.3
librespot-playback-0.1.3
librespot-protocol-0.1.3
linear-map-1.2.0
lock_api-0.3.4
log-0.3.9
log-0.4.14
mac-notification-sys-0.3.0
malloc_buf-0.0.6
maplit-1.0.2
matches-0.1.8
matrixmultiply-0.2.4
maybe-uninit-2.0.0
memchr-2.3.4
memoffset-0.5.6
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.4.3
mio-0.6.23
mio-uds-0.6.8
miow-0.2.2
nalgebra-0.18.1
native-tls-0.2.7
ncurses-5.100.0
net2-0.2.37
nix-0.9.0
nom-5.1.2
notify-rust-4.2.2
num-0.3.1
num-bigint-0.2.6
num-complex-0.2.4
num-complex-0.3.1
num-integer-0.1.44
num-iter-0.1.42
num-rational-0.2.4
num-rational-0.3.2
num-traits-0.2.14
num_cpus-1.13.0
numtoa-0.1.0
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
object-0.23.0
ogg-0.7.1
once_cell-1.5.2
opaque-debug-0.2.3
openssl-0.10.32
openssl-probe-0.1.2
openssl-sys-0.9.60
owning_ref-0.4.1
pancurses-0.16.1
parking_lot-0.9.0
parking_lot_core-0.6.2
pbkdf2-0.3.0
pdcurses-sys-0.7.1
peeking_take_while-0.1.2
percent-encoding-1.0.1
percent-encoding-2.1.0
pin-project-0.4.27
pin-project-1.0.4
pin-project-internal-0.4.27
pin-project-internal-1.0.4
pin-project-lite-0.1.11
pin-project-lite-0.2.4
pin-utils-0.1.0
pkg-config-0.3.19
platform-dirs-0.3.0
portaudio-rs-0.3.2
portaudio-sys-0.1.1
ppv-lite86-0.2.10
proc-macro-hack-0.5.19
proc-macro-nested-0.1.7
proc-macro2-0.4.30
proc-macro2-1.0.24
protobuf-2.14.0
protobuf-codegen-2.14.0
protobuf-codegen-pure-2.14.0
publicsuffix-1.5.4
quick-error-1.2.3
quote-0.3.15
quote-0.6.13
quote-1.0.8
rand-0.3.23
rand-0.4.6
rand-0.5.6
rand-0.6.5
rand-0.7.3
rand-0.8.3
rand_chacha-0.1.1
rand_chacha-0.2.2
rand_chacha-0.3.0
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_core-0.6.1
rand_hc-0.1.0
rand_hc-0.2.0
rand_hc-0.3.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
random-0.12.2
rawpointer-0.2.1
rdrand-0.4.0
redox_syscall-0.1.57
redox_syscall-0.2.4
redox_termios-0.1.2
redox_users-0.3.5
redox_users-0.4.0
regex-1.4.3
regex-syntax-0.6.22
relay-0.1.1
remove_dir_all-0.5.3
reqwest-0.9.24
reqwest-0.10.10
rodio-0.9.0
rspotify-0.10.0
rust-argon2-0.8.3
rustc-demangle-0.1.18
rustc-hash-1.1.0
rustc-serialize-0.3.24
rustc_version-0.2.3
ryu-1.0.5
safemem-0.3.3
schannel-0.1.19
scoped-tls-0.1.2
scopeguard-1.1.0
security-framework-2.0.0
security-framework-sys-2.0.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.123
serde_derive-1.0.123
serde_json-1.0.61
serde_urlencoded-0.5.5
serde_urlencoded-0.7.0
sha-1-0.8.2
sha2-0.8.2
shannon-0.2.0
shell-words-0.1.0
shlex-0.1.1
signal-hook-0.3.4
signal-hook-registry-1.3.0
slab-0.3.0
slab-0.4.2
smallvec-0.2.1
smallvec-0.6.14
socket2-0.3.19
stable_deref_trait-1.2.0
stdweb-0.1.3
stream-cipher-0.3.2
string-0.2.1
strsim-0.7.0
strsim-0.8.0
strsim-0.9.3
strum-0.8.0
strum-0.20.0
strum_macros-0.8.0
strum_macros-0.20.1
subtle-1.0.0
syn-0.11.11
syn-0.15.44
syn-1.0.60
synom-0.11.3
synstructure-0.12.4
take-0.1.0
tempfile-3.2.0
term_size-0.3.2
termcolor-1.1.2
termion-1.5.6
textwrap-0.11.0
thiserror-1.0.23
thiserror-impl-1.0.23
thread_local-1.1.2
time-0.1.43
tinyvec-1.1.1
tinyvec_macros-0.1.0
tokio-0.1.22
tokio-0.2.25
tokio-buf-0.1.1
tokio-codec-0.1.2
tokio-core-0.1.18
tokio-current-thread-0.1.7
tokio-executor-0.1.10
tokio-fs-0.1.7
tokio-io-0.1.13
tokio-proto-0.1.1
tokio-reactor-0.1.12
tokio-service-0.1.0
tokio-socks-0.3.0
tokio-sync-0.1.8
tokio-tcp-0.1.4
tokio-threadpool-0.1.18
tokio-timer-0.2.13
tokio-tls-0.3.1
tokio-udp-0.1.6
tokio-uds-0.2.7
tokio-util-0.3.1
toml-0.5.8
tower-service-0.3.1
tracing-0.1.22
tracing-core-0.1.17
tracing-futures-0.2.4
try-lock-0.1.0
try-lock-0.2.3
try_from-0.3.2
typenum-1.12.0
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.16
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.0.4
unicode-xid-0.1.0
unicode-xid-0.2.1
url-1.7.2
url-2.2.0
uuid-0.7.4
vcpkg-0.2.11
vec_map-0.8.2
vergen-3.1.0
version_check-0.9.2
void-1.0.2
want-0.0.4
want-0.2.0
want-0.3.0
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.70
wasm-bindgen-backend-0.2.70
wasm-bindgen-futures-0.4.20
wasm-bindgen-macro-0.2.70
wasm-bindgen-macro-support-0.2.70
wasm-bindgen-shared-0.2.70
wasmer_enumset-1.0.1
wasmer_enumset_derive-0.5.0
web-sys-0.3.47
webbrowser-0.5.5
widestring-0.4.3
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.5.1
winreg-0.6.2
winreg-0.7.0
winrt-0.4.0
winrt-notification-0.2.2
ws2_32-sys-0.2.1
x11-clipboard-0.3.3
xcb-0.8.2
xi-unicode-0.3.0
xml-rs-0.6.1
"

inherit cargo

DESCRIPTION="ncurses Spotify client written in Rust using librespot, inspired by ncmpc and the likes"
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://api.github.com/repos/hrkfdn/ncspot/tarball/v0.4.0 -> ncspot-v0.4.0.tar.gz
	$(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/hrkfdn-ncspot-* ${S} || die
}