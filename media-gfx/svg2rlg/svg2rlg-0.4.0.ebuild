# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Converts SVG files to PDFs or reportlab graphics"
HOMEPAGE="https://github.com/sarnold/svg2rlg https://pypi.python.org/pypi/svg2rlg/"
SRC_URI="https://github.com/sarnold/svg2rlg/tarball/e5000410489c2ba74b06479ebbdd4f938823feba -> svg2rlg-0.4.0-e500041.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="dev-python/reportlab[${PYTHON_USEDEP}]"

distutils_enable_tests nose

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/sarnold-svg2rlg* "$S" || die
	fi
}

python_test() {
	nosetests -sx test_svg2rlg.py || die "Test failed with ${EPYTHON}"
}
# vim:filetype=etemplate