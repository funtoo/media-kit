EAPI=7

inherit cmake edos2unix flag-o-matic

DESCRIPTION="Weak signal ham radio communication"
HOMEPAGE="https://wsjt.sourceforge.io/wsjtx.html"
SRC_URI="https://downloads.sourceforge.net/wsjt-x-improved/WSJT-X_v2.7.0/Source%20code/wsjtx-2.7.0-rc1_improved_widescreen_PLUS.tgz -> wsjtx-2.7.0-rc1_improved_widescreen_PLUS.tgz"
S=${WORKDIR}/wsjtx

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND="
	!!media-radio/wsjtx
	dev-libs/boost:=[nls,python]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtserialport:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	dev-qt/qtprintsupport:5
	virtual/libusb:1
	>=media-libs/hamlib-4.0:=
	media-libs/portaudio
	sci-libs/fftw:3.0[threads,fortran]
	virtual/fortran
	app-text/asciidoc
	doc? ( dev-ruby/asciidoctor )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools"

if [ "${PN}" != "wsjtx_improved" ]; then
	# force to install resource and aditional tools
	PDEPEND="=media-radio/wsjtx_improved-${PV}"
fi



DOCS=( AUTHORS BUGS NEWS README THANKS )

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}/wsjtx-${PV}/src/wsjtx.tgz"
}

src_prepare() {
	edos2unix "${S}/message_aggregator.desktop"
	edos2unix "${S}/wsjtx.desktop"
	edos2unix "${S}/CMakeLists.txt"
	sed -i -e "s/COMMAND \${GZIP_EXECUTABLE}/#  COMMAND/" \
								manpages/CMakeLists.txt || die

	# if it is not plain wsjtx_improved, only install executable and set name
	if [ "${PN}" != "wsjtx_improved" ]; then
		eapply "${FILESDIR}/wsjtx_improved-2.6.2-install-only-wsjtx.patch"
		echo "set_target_properties(wsjtx PROPERTIES OUTPUT_NAME \"${PN}\")" >> "${S}/CMakeLists.txt"
	fi

	cmake_src_prepare
}

src_configure() {
	# fails to complie with -flto (bug #860417)
	filter-lto


	# change default "rig" name to enable run muiltiple different version of jstx
	sed -i "s/a.setApplicationName (\"WSJT-X\");/a.setApplicationName (\"${PN}\");/g" main.cpp

	local mycmakeargs=(
		-DWSJT_GENERATE_DOCS="$(usex doc)"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	
	if [ "${PN}" ==  "wsjtx_improved" ];then
		mycmakeargs+=( 
			-DWSJT_SKIP_MANPAGES=off
			-DWSJT_BUILD_UTILS=on
			)
	else
		mycmakeargs+=( 
			-DWSJT_SKIP_MANPAGES=on
			-DWSJT_BUILD_UTILS=off
			)
		# replace _ with __ to make .desktop link happy
		dubled=$(echo ${PN} | sed "s/_/__/g")

		sed -i "s/wsjtx$/${PN}/g" "${S}/wsjtx.desktop"
		sed -i "s/Name=${PN}/Name=${dubled}/g" "${S}/wsjtx.desktop"

	fi

	append-ldflags -no-pie
	cmake_src_configure
}

src_install() {
		cmake_src_install
	if [ "${PN}" ==  "wsjtx_improved" ];then
		rm "${D}"/usr/bin/rigctl{,d,com}-wsjtx || die
		rm "${D}"/usr/share/man/man1/rigctl{,d,com}-wsjtx.1 || die
	else
		install -m644 -D "${S}/wsjtx.desktop" "${D}/usr/share/applications/${PN}.desktop"
	fi
}


pkg_postinst() {
	elog "by default wjstx have 'WSJT-X' rig name, but current install changes it to accomodiate different flavours"
	elog "default rig name is changed to: '${PN}'"
	if [ "${PN}" !=  "wsjtx_improved" ];then
		elog "all utilities and resources are used from media-radio/wsjtx_improved package"
	fi
}