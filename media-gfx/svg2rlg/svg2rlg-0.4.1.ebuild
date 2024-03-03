# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Converts SVG files to PDFs or reportlab graphics"
HOMEPAGE="https://github.com/sarnold/svg2rlg https://pypi.python.org/pypi/svg2rlg/"
SRC_URI="https://github.com/sarnold/svg2rlg/tarball/c29c146bffc580c52d4c56ecfcff7a19f4d9b81f -> svg2rlg-0.4.1-c29c146.tar.gz"

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