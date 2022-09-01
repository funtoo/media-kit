# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="A youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp"
SRC_URI="https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="+ffmpeg certifi"

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-lang/python-3.7
	ffmpeg? ( media-video/ffmpeg )
	certifi? ( dev-python/certifi )"
BDEPEND=""

src_unpack() {
	[ ! -d ${S} ] && mkdir ${S} || die
	cp "${DISTDIR}"/yt-dlp "${S}"/ || die
}

src_install() {
	dobin yt-dlp
}

pkg_postinst() {
	optfeature "embedding metadata thumbnails in MP4/M4A files" media-libs/mutagen
	optfeature "using aria2c as external downloader" net-misc/aria2
	optfeature "decrypting AES-128 HLS streams and various other data" dev-python/pycryptodome
	optfeature "writing metadata" dev-python/pyxattr
}