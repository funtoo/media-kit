# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit cmake-utils python-any-r1

DESCRIPTION="Collection of tools, libraries and tests for shader compilation"
HOMEPAGE="https://github.com/shaderc/google"
SRC_URI="https://api.github.com/repos/google/shaderc/tarball/refs/tags/v2024.1 -> shaderc-2024.1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc test"

RDEPEND="
	dev-util/glslang
	dev-util/spirv-tools
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/spirv-headers
	doc? ( dev-ruby/asciidoctor )
	test? (
		dev-cpp/gtest
		$(python_gen_any_dep 'dev-python/nose[${PYTHON_USEDEP}]')
	)
"

# https://github.com/google/shaderc/issues/470
RESTRICT=test

python_check_deps() {
	if use test; then
		has_version --host-root "dev-python/nose[${PYTHON_USEDEP}]"
	fi
}

post_src_unpack() {
	mv "${WORKDIR}"/google-shaderc-* "${S}" || die
}

src_prepare() {
	cmake_comment_add_subdirectory examples

	# Unbundle glslang, spirv-headers, spirv-tools
	cmake_comment_add_subdirectory third_party
	sed -i \
		-e "s|\$<TARGET_FILE:spirv-dis>|${EPREFIX}/usr/bin/spirv-dis|" \
		glslc/test/CMakeLists.txt || die

	# Disable git versioning
	sed -i -e '/build-version/d' glslc/CMakeLists.txt || die

	# Manually create build-version.inc as we disabled git versioning
	cat <<- EOF > glslc/src/build-version.inc || die
		"${P}\n"
		"$(best_version dev-util/spirv-tools)\n"
		"$(best_version dev-util/glslang)\n"
	EOF

	# Fix GlslangToSpv.h path
	sed -i \
		-e 's|#include "SPIRV/GlslangToSpv.h"|#include "glslang/SPIRV/GlslangToSpv.h"|' \
		libshaderc_util/src/compiler.cc || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSHADERC_SKIP_TESTS="$(usex !test)"
		-DSHADERC_ENABLE_WERROR_COMPILE="false"
	)
	cmake-utils_src_configure
}

src_compile() {
	use doc && cmake-utils_src_make glslc_doc_README

	cmake-utils_src_compile
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}/glslc/README.html" )

	cmake-utils_src_install
}