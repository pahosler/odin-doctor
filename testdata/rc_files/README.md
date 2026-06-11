# rc_files - Test Fixtures for Shell Configuration

This directory contains realistic but controlled copies of shell rc files (`.zshrc`, `.bashrc`, `config.fish`, `.profile`, etc.).

## Purpose

These fixtures are used by tests to verify the shell integration logic in odin-doctor, including:

- Detecting existing ODIN_ROOT settings
- Inserting or updating the `# MANAGED BY ODIN-UPDATE` marker
- Commenting out old/stale Odin configuration blocks
- Adding correct `export` / `set -gx` lines for the current installation
- Handling different shells (zsh, bash, fish)
- Preserving user customizations outside the managed block

## Why fixtures?

All tests that touch shell configuration **must** use temporary directories + copies of these files. This ensures:

- Tests never modify the developer's real rc files
- Behavior is reproducible across machines and CI
- We can exercise every edge case (clean, old unmanaged, already managed correct/wrong, mixed, etc.)

## Usage in tests

Typical pattern (in test code):

1. Create a temp directory.
2. Copy the desired fixture into it (e.g. as `.zshrc` or `config.fish`).
3. Run the relevant odin-doctor logic (or the built binary) pointing at the temp location.
4. Read the modified file back and assert the expected state (marker present, correct path, old lines commented, etc.).
5. Clean up.

## File naming convention

- `<shell>_<state>.ext` or descriptive (e.g. `zshrc_already_managed_wrong_path`)
- Keep files without leading dot so they are easy to manage in git and when copying.

## Adding new fixtures

When you need to test a new scenario (e.g. a very long rc file, specific escape sequences, multiple previous Odin blocks), add a new file here and reference it from the test.

Do not put real user configuration or secrets in these files.

## Fresh / Pristine Testdata via Tarball (Recommended)

A pristine copy of these fixtures is also available as a tarball:

```
testdata/pristine-rc-files.tar.gz
```

This tarball is the recommended way to obtain a completely clean set of rc files for testing.

### Why a tarball?

Once the individual files in `rc_files/` are used in development or testing, it is easy for them to become "polluted" (extra lines added during debugging, permissions changed, etc.). The tarball always represents the known-good committed state.

### How to get a fresh copy

Use the helper script:

```bash
RC_DIR=$(scripts/fresh-testdata.sh)
echo "Using fresh rc files from: $RC_DIR"
```

The script:
- Creates a unique temporary directory
- Extracts the tarball into it
- Prints the path to the extracted `rc_files/` directory

You can then point `odin-doctor` (or the code under test) at `$RC_DIR` as if it were `$HOME` or `$ZDOTDIR`.

Example in a test:

```bash
RC_DIR=$(scripts/fresh-testdata.sh)
# ... configure odin-doctor to use $RC_DIR as the shell config location ...
# ... run the command ...
# ... assert state of files under $RC_DIR ...
# temp dir is cleaned up by the test harness
```

### Manual alternative

```bash
mkdir -p /tmp/fresh-odin-rc
tar -xzf testdata/pristine-rc-files.tar.gz -C /tmp/fresh-odin-rc
# Use /tmp/fresh-odin-rc/rc_files ...
```

**Important rule**: Tests should *always* work on a copy extracted into a temporary directory. Never modify the committed files under `testdata/rc_files/` directly. This keeps the source fixtures pristine for everyone.
