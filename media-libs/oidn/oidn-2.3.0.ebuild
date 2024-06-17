# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit cmake python-single-r1

DESCRIPTION="Intel® Open Image Denoise library"
HOMEPAGE="https://www.openimagedenoise.org/ https://github.com/OpenImageDenoise/oidn"

SRC_URI="https://github.com/RenderKit/oidn/releases/download/v2.3.0/oidn-2.3.0.src.tar.gz -> oidn-2.3.0.src.tar.gz"
KEYWORDS="*"

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-cpp/tbb:=
	dev-lang/ispc"
DEPEND="${RDEPEND}"