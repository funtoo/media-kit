# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2+ )
inherit cmake python-single-r1

DESCRIPTION="Library for particle IO and manipulation"
HOMEPAGE="https://www.disneyanimation.com/technology/partio.html"
SRC_URI="https://api.github.com/repos/wdas/partio/tarball/refs/tags/v1.17.3 -> partio-1.17.3.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/freeglut
	sys-libs/zlib:=
	virtual/opengl
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-lang/swig
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"

src_unpack() {
	default
	rm -rf "${S}"
	mv "${WORKDIR}"/wdas-partio-* "${S}" || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
	)
	cmake_src_configure
}