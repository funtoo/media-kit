# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A community-driven collection of themes for spicetify"
HOMEPAGE="https://github.com/morpheusthewhite/spicetify-themes"
SRC_URI="https://github.com/morpheusthewhite/spicetify-themes/archive/7740b3b14d9f53e3da29f7ce04a98dccc13d2a67.tar.gz -> spicetify-themes-20210621.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	app-misc/spicetify-cli
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	mv spicetify-themes-* ${S} || die
}

src_prepare() {
	default
	rm -rf .gitignore CODE_OF_CONDUCT.md LICENSE README.md .github
}

src_install() {
	insinto /opt/spicetify-cli/Themes
	doins -r *

	insinto /opt/spicetify-cli/Extensions
	doins Dribbblish/dribbblish.js
}