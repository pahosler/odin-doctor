#!/usr/bin/env bash
#
# fresh-testdata.sh
#
# Extracts a pristine copy of the testdata/rc_files fixtures into a temporary
# directory and prints the path to the extracted rc_files directory.
#
# Usage in tests:
#   RC_DIR=$(scripts/fresh-testdata.sh)
#   # Now use $RC_DIR as a fake $HOME or $ZDOTDIR containing the rc files
#   # Run odin-doctor against it, inspect results, then rm -rf the temp dir
#
# This ensures tests always start from a known-clean set of fixtures
# and never modify the committed source files under testdata/.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARBALL="$PROJECT_ROOT/testdata/pristine-rc-files.tar.gz"

if [[ ! -f "$TARBALL" ]]; then
    echo "Error: pristine tarball not found at $TARBALL" >&2
    exit 1
fi

TMPDIR=$(mktemp -d -t odin-doctor-testdata-XXXXXX)

# Extract the tarball. The tar contains the 'rc_files' directory at the top level.
tar -xzf "$TARBALL" -C "$TMPDIR"

# The tar was created with: tar -czf ... -C testdata rc_files
# So inside the tar is rc_files/...
# Print the path to the rc_files directory so callers can use it directly.
echo "$TMPDIR/rc_files"
