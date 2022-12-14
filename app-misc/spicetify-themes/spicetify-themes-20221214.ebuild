# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A community-driven collection of themes for spicetify"
HOMEPAGE="https://github.com/morpheusthewhite/spicetify-themes"
SRC_URI="https://github.com/morpheusthewhite/spicetify-themes/archive/bf288f8d226f1528a4a91a86fde2687c1a3d8035.tar.gz -> spicetify-themes-20221214.tar.gz"

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
	find . -type f -name "*.js" -exec doins {} \;
}