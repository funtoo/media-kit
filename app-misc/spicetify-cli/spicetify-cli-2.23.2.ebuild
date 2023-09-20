# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/go-ini/ini v1.67.0"
	"github.com/go-ini/ini v1.67.0/go.mod"
	"github.com/mattn/go-colorable v0.1.13"
	"github.com/mattn/go-colorable v0.1.13/go.mod"
	"github.com/mattn/go-isatty v0.0.16"
	"github.com/mattn/go-isatty v0.0.16/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.7.1"
	"github.com/stretchr/testify v1.7.1/go.mod"
	"golang.org/x/net v0.15.0"
	"golang.org/x/net v0.15.0/go.mod"
	"golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod"
	"golang.org/x/sys v0.12.0"
	"golang.org/x/sys v0.12.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="Commandline tool to customize Spotify client."
HOMEPAGE="https://github.com/khanhas/spicetify-cli"
SRC_URI="https://github.com/spicetify/spicetify-cli/tarball/3321a5bcbcd9ea3638d061086a0e0ae03e6526fc -> spicetify-cli-2.23.2-3321a5b.tar.gz
https://direct.funtoo.org/18/d0/58/18d058de26b1e00903151095ddeb76f51376dae1b4319a5faa2215a448e80fc3a6ab188b69a8d2ba649b1ac850fa57e0e4d605f779ad2848bdb19506919d48eb -> spicetify-cli-2.23.2-funtoo-go-bundle-3605c71748cd4d5caab6ded96f4a8eebb22ad8a0456c9937626d00919eaa1cdf75ca2e08953c46b31c96f8d7eecc73a29abe348d17912580f5c6ec67e7dce326.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="hook"
S="${WORKDIR}/spicetify-spicetify-cli-3321a5b"

INSTALLDIR="/opt/${PN}"

PATCHES=(
	"${FILESDIR}/${PN}-recognize_funtoo_install_path.patch"
)

src_compile() {
	go build \
        -ldflags="-s -w -X main.version=${PV}" \
        -mod=mod . || die "compile failed"
}

src_install() {
	insinto "${INSTALLDIR}"
	doins -r {CustomApps,Extensions,Themes,jsHelper,spicetify-cli}
	fperms +x "${INSTALLDIR}/spicetify-cli"
	dosym /opt/spicetify-cli/spicetify-cli /usr/bin/spicetify

	if use hook; then
		insinto "/etc/portage/env/media-sound"
		newins "${FILESDIR}"/spotify-hook spotify
	fi
}