# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit deadbeef-plugins

GITHUB_COMMIT="d3990d772b02cdc6206f067748f5d1f9650616fb"

DESCRIPTION="DeaDBeeF simple stereo widener plugin"
HOMEPAGE="https://github.com/Alexey-Yakovenko/stereo-widener"
SRC_URI="https://github.com/Alexey-Yakovenko/stereo-widener/archive/${GITHUB_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/stereo-widener-${GITHUB_COMMIT}"

PATCHES=(
	"${FILESDIR}/${PN}-api.patch"
	"${FILESDIR}/${PN}-build.patch"
)
