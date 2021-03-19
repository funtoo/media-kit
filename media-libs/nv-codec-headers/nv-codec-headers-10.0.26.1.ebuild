# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FFmpeg version of headers required to interface with Nvidias codec APIs"
HOMEPAGE="https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git"
SRC_URI="https://api.github.com/repos/FFmpeg/nv-codec-headers/tarball/refs/tags/n10.0.26.1 -> nv-codec-headers-10.0.26.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=x11-drivers/nvidia-drivers-445.87"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/FFmpeg-nv-codec-headers"* "${S}" || die
}

src_compile() {
	make PREFIX=/usr
}

src_install() {
	make PREFIX=/usr DESTDIR="${D}" install || die
}