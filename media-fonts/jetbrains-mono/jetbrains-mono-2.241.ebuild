# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A free and open-source typeface for developers"
HOMEPAGE="https://www.jetbrains.com/lp/mono/"
SRC_URI="https://github.com/JetBrains/JetBrainsMono/releases/download/v2.241/JetBrainsMono-2.241.zip -> jetbrains-mono-2.241.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/fonts/ttf"
FONT_SUFFIX="ttf"