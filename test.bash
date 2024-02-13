#!/usr/bin/env -S bash --login

set -euo pipefail
set -x

bash ./.github/scripts/run_pytest.bash
bash ./.github/scripts/run_pytest_methods.bash

set +x
