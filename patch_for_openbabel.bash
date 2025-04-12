#!/usr/bin/env bash

set -eu -o pipefail

# patch_for_openbabel.bash: Installing the Open Babel < 3.2.0 Python package
# only works when it is able to link against system-installed Open Babel
# compiled libraries, since these older versions don't have wheels.  The conda
# package provides both, so ignore the PyPI one and use conda for the older
# versions (Python < 3.10).
PYTHON_MINOR_VERSION="$(python -c 'import sys; print(sys.version_info.minor)')"
if ((PYTHON_MINOR_VERSION < 10)); then
	sed -i '/openbabel/d' pyproject.toml
fi
