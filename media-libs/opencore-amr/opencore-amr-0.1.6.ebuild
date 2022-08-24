# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implementation of Adaptive Multi Rate Narrowband and Wideband speech codec"
HOMEPAGE="https://sourceforge.net/projects/opencore-amr/"
SRC_URI="https://downloads.sourceforge.net/opencore-amr/opencore-amr/opencore-amr-0.1.6.tar.gz -> opencore-amr-0.1.6.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}