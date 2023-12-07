# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Image decoding for many popular formats for SDL."
HOMEPAGE="https://www.libsdl.org/projects/SDL_image/"
SRC_URI="https://github.com/libsdl-org/SDL_image/tarball/859357d2e5e82e002f54f440cc031e174e58e749 -> SDL_image-2.8.0-859357d.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="gif jpeg png static-libs tiff webp"

RDEPEND="
	media-libs/libsdl2
	sys-libs/zlib
	png? ( media-libs/libpng )
	jpeg? ( virtual/jpeg )
	tiff? ( media-libs/tiff )
	webp? ( media-libs/libwebp )"
DEPEND=${RDEPEND}

post_src_unpack() {
	mv "${WORKDIR}"/libsdl-org-SDL_image-* "$S" || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--disable-sdltest
		--enable-bmp
		$(use_enable gif)
		$(use_enable jpeg jpg)
		--disable-jpg-shared
		--enable-lbm
		--enable-pcx
		$(use_enable png)
		--disable-png-shared
		--enable-pnm
		--enable-tga
		$(use_enable tiff tif)
		--disable-tif-shared
		--enable-xcf
		--enable-xpm
		--enable-xv
		$(use_enable webp)
		--disable-webp-shared
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc {CHANGES,README}.txt
	find "${ED}" -type f -name "*.la" -delete || die
}