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
	"golang.org/x/net v0.11.0"
	"golang.org/x/net v0.11.0/go.mod"
	"golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod"
	"golang.org/x/sys v0.9.0"
	"golang.org/x/sys v0.9.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="Commandline tool to customize Spotify client."
HOMEPAGE="https://github.com/khanhas/spicetify-cli"
SRC_URI="https://github.com/spicetify/spicetify-cli/tarball/138d5522160ce3189520f4e5e8970ac687961f7e -> spicetify-cli-2.20.1-138d552.tar.gz
https://direct.funtoo.org/bb/1a/9a/bb1a9a349820f4b8d937bd8b5066044a86c4f639b785cc002517a27e6e1af919bcdc601ee0ed993bb39ae24d989fd28739a8c2b1fac812f265051757caaba5d7 -> spicetify-cli-2.20.1-funtoo-go-bundle-0ebfa83b57fe4c09f63faab40f6cbf3c8ae67d54373b7600affb892be2792ecedb82af340f2cac3198451ec1659945e76f4fadc682ab4064953a112d1a32a946.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="hook"
S="${WORKDIR}/spicetify-spicetify-cli-138d552"

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