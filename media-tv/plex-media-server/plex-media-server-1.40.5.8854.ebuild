# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit user unpacker python-single-r1

URI="https://downloads.plex.tv/plex-media-server-new"

DESCRIPTION="A free media library that is intended for use with a plex client."
HOMEPAGE="http://www.plex.tv/"
SRC_URI="
	amd64? ( https://downloads.plex.tv/plex-media-server-new/1.40.5.8854-f36c552fd/debian/plexmediaserver_1.40.5.8854-f36c552fd_amd64.deb -> plexmediaserver_1.40.5.8854-f36c552fd_amd64.deb )
	x86? ( https://downloads.plex.tv/plex-media-server-new/1.40.5.8854-f36c552fd/debian/plexmediaserver_1.40.5.8854-f36c552fd_i386.deb -> plexmediaserver_1.40.5.8854-f36c552fd_i386.deb )
"

SLOT="0"
LICENSE="Plex"
RESTRICT="bindist"
KEYWORDS="*"

DEPEND=""

RDEPEND="${DEPEND}"

QA_DESKTOP_FILE="usr/share/applications/plexmediamanager.desktop"
QA_PREBUILT="*"
QA_MULTILIB_PATHS=(
	"usr/lib/plexmediaserver/lib/.*"
	"usr/lib/plexmediaserver/Resources/Python/lib/python2.7/.*"
	"usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload/_hashlib.so"
)

S="${WORKDIR}"

pkg_setup() {
	enewgroup plex
	enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex,video"
	python-single-r1_pkg_setup
}

src_install() {
	# Remove Debian specific files
	rm -rf "usr/share/doc" || die

	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}" || die

	# Make sure the logging directory is created
	local LOGGING_DIR="/var/log/pms"
	dodir "${LOGGING_DIR}"
	chown plex:plex "${ED%/}/${LOGGING_DIR}" || die
	keepdir "${LOGGING_DIR}"

	# Create default library folder with correct permissions
	local DEFAULT_LIBRARY_DIR="/var/lib/plexmediaserver"
	dodir "${DEFAULT_LIBRARY_DIR}"
	chown plex:plex "${ED%/}/${DEFAULT_LIBRARY_DIR}" || die
	keepdir "${DEFAULT_LIBRARY_DIR}"

	# Install the OpenRC init/conf files
	doinitd "${FILESDIR}/init.d/${PN}"
	doconfd "${FILESDIR}/conf.d/${PN}"

	# Mask Plex libraries so that revdep-rebuild doesn't try to rebuild them.
	# Plex has its own precompiled libraries.
	_mask_plex_libraries_revdep
}

pkg_postinst() {
	einfo ""
	elog "Plex Media Server is now installed. Please check the configuration file in /etc/plex/plexmediaserver to verify the default settings."
	elog "To start the Plex Server, run 'rc-config start plex-media-server', you will then be able to access your library at http://<ip>:32400/web/"
}

# Adds the precompiled plex libraries to the revdep-rebuild's mask list
# so it doesn't try to rebuild libraries that can't be rebuilt.
_mask_plex_libraries_revdep() {
	dodir /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/usr/$(get_libdir)/plexmediaserver\"" > "${ED}"/etc/revdep-rebuild/80plexmediaserver
}

