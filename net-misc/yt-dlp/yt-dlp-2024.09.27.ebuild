# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3+ )

inherit optfeature python-single-r1

DESCRIPTION="A youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp"
SRC_URI="https://github.com/yt-dlp/yt-dlp/tarball/5945fc1945a4001537072e39f03725f944437834 -> yt-dlp-2024.09.27-5945fc1.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="brotli certifi +ffmpeg xattr"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-lang/python-3.7
	|| (
		app-text/pandoc-bin
		app-text/pandoc
	)
	brotli? ( app-arch/brotli )
	certifi? ( dev-python/certifi )
	ffmpeg? ( media-video/ffmpeg )
	xattr? ( dev-python/pyxattr )
"
BDEPEND="
	app-arch/zip
"

post_src_unpack() {
	mv "${WORKDIR}"/yt-dlp-yt-dlp-* "${S}" || die
}

src_compile() {
	emake PREFIX="${ED}/usr" MANDIR="${ED}/usr/share/man"
}

src_install() {
	emake install PREFIX="${ED}/usr" MANDIR="${ED}/usr/share/man"
}

pkg_postinst() {
	optfeature "embedding metadata thumbnails in MP4/M4A files" media-libs/mutagen
	optfeature "using aria2c as external downloader" net-misc/aria2
	optfeature "decrypting AES-128 HLS streams and various other data" dev-python/pycryptodome
}