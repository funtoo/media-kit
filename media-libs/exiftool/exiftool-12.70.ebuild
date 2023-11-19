# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_NAME=Image-ExifTool
inherit perl-module

DESCRIPTION="Read and write meta information in image, audio and video files"
HOMEPAGE="https://${PN}.org/ https://${PN}.sourceforge.net https://github.com/exiftool/exiftool"
SRC_URI="https://github.com/exiftool/exiftool/tarball/bec8a1bff8a97ea8f2895e7e5c5e396e0e48d419 -> exiftool-12.70-bec8a1b.tar.gz"

SLOT="0"
KEYWORDS="*"
IUSE="doc"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv exiftool-exiftool* "${S}" || die
	fi
}

src_install() {
	perl-module_src_install
	use doc && dodoc -r html/

	insinto /usr/share/${PN}
	doins -r fmt_files config_files arg_files
}