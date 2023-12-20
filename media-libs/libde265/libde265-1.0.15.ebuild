# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

KEYWORDS="*"

DESCRIPTION="Open h.265 video codec implementation"
HOMEPAGE="https://github.com/strukturag/libde265"
SRC_URI="https://api.github.com/repos/strukturag/libde265/tarball/refs/tags/v1.0.15 -> libde265-1.0.15-17bb8d9fcea62db8cdeb0fc7ef8d15dbd19a22e4.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="enc265 dec265 sdl tools debug cpu_flags_x86_sse4_1 cpu_flags_arm_neon cpu_flags_arm_thumb"
# IUSE+=" sherlock265" # Require libvideogfx or libswscale

RDEPEND="
	dec265? (
		sdl? ( media-libs/libsdl )
	)"

# Sherlock265 require libvideogfx or libswscale
#RDEPEND+="
#	sherlock265? (
#		media-libs/libsdl
#		dev-qt/qtcore:5
#		dev-qt/qtgui:5
#		dev-qt/qtwidgets:5
#		media-libs/libswscale
#	)
#"

DEPEND="${RDEPEND}"
BDEPEND="dec265? ( virtual/pkgconfig )"

# Sherlock265 require libvideogfx or libswscale
#BDEPEND+=" sherlock265? ( virtual/pkgconfig )"

PATCHES=( "${FILESDIR}"/${PN}-1.0.2-qtbindir.patch )

post_src_unpack() {
	mv "${WORKDIR}/"strukturag-libde265* "${S}" || die
}

src_prepare() {
	default

	eautoreconf

	# without this, headers would be missing and make would fail
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		--enable-log-error
		ax_cv_check_cflags___msse4_1=$(usex cpu_flags_x86_sse4_1)
		ax_cv_check_cflags___mfpu_neon=$(usex cpu_flags_arm_neon)
		$(use_enable cpu_flags_arm_thumb thumb)
		$(use_enable debug log-info)
		$(use_enable debug log-debug)
		$(use_enable debug log-trace)
		$(multilib_native_use_enable enc265 encoder)
		$(multilib_native_use_enable dec265)
	)

	# myeconfargs+=( $(multilib_native_use_enable sherlock265) ) # Require libvideogfx or libswscale
	myeconfargs+=( --disable-sherlock265 )

	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		# Remove useless, unready and test tools
		rm "${ED}"/usr/bin/{tests,gen-enc-table,yuv-distortion} || die
		if ! use tools; then
			rm "${ED}"/usr/bin/{bjoentegaard,block-rate-estim,rd-curves} || die
			rm "${ED}"/usr/bin/acceleration_speed || die
		fi
	else
		# Remove all non-native binary tools
		rm "${ED}"/usr/bin/* || die
	fi
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die
	einstalldocs
}