# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python3+ )

inherit meson python-any-r1

DESCRIPTION="Reusable library for GPU-accelerated image processing primitives"
HOMEPAGE="https://code.videolan.org/videolan/libplacebo"
SRC_URI="https://direct.funtoo.org/79/76/8f/79768f158c46055cfdf64ec60a67c024be95a55df88d26624262b6b704720cb22e3932242223e25ccdde89992fa71e02cbe327448ade225d9da2f85cdf43aeae -> libplacebo-5.229.2-with-submodules.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/$(ver_cut 2)" # libplacebo.so version
KEYWORDS="*"
IUSE="glslang lcms +opengl +shaderc +vulkan"

REQUIRED_USE="vulkan? ( || ( glslang shaderc ) )"
RESTRICT="test"
S=${WORKDIR}/libplacebo

RDEPEND="glslang? ( dev-util/glslang )
	lcms? ( media-libs/lcms:2 )
	opengl? ( media-libs/libepoxy )
	shaderc? ( >=media-libs/shaderc-2017.2 )
	vulkan? (
		dev-util/vulkan-headers
		media-libs/vulkan-loader
	)"
DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig
	vulkan? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/mako[${PYTHON_USEDEP}]')
	)"

#src_unpack() {
#	cd ${WORKDIR} && tar xf ${DISTDIR}/${A} || die
#}

post_src_unpack() {
	sed -i "s:\(#include <vulkan/vulkan.h>\):\1\n#include <vulkan/vulkan_metal.h>:" "${S}"/src/include/${PN}/vulkan.h || die
}

python_check_deps() {
	has_version -b "dev-python/mako[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use vulkan && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_feature glslang)
		$(meson_feature lcms)
		$(meson_feature opengl)
		$(meson_feature shaderc)
		$(meson_feature vulkan)
		-Dtests=false
		# hard-code path from dev-util/vulkan-headers
		-Dvulkan-registry=/usr/share/vulkan/registry/vk.xml
	)
	meson_src_configure
}