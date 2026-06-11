package main

import "core:testing"
import "core:os"
import "core:strings"

// Example tests to get the testing habit started.
// Run with: odin test .

@(test)
test_config_roundtrip :: proc(t: ^testing.T) {
	// Use a temp file so we don't touch real config.
	temp_path := "temp_test_config.conf"
	defer os.remove(temp_path) // clean up even on failure

	test_config := Config{
		default_command = "update",
	}

	if !save_config(temp_path, test_config) {
		testing.error(t, "save_config failed")
		return
	}

	loaded, ok := load_config(temp_path)
	if !ok {
		testing.error(t, "load_config failed")
		return
	}

	testing.expect_value(t, loaded.default_command, test_config.default_command)
}

// TODO more tests:
// - Test version comparison logic (once implemented).
// - Test file I/O edge cases (missing file, bad format).
// - Integration style: use fresh testdata rc_files via the script, run "logic", verify output files.

// Note on testing in Odin (crash course):
// - Files ending in _test.odin are excluded from normal builds.
// - @(test) marks a proc that receives ^testing.T.
// - Use testing.expect, testing.expect_value, testing.expectf for assertions.
// - testing.cleanup(t, proc() { ... }) for teardown.
// - odin test . will discover and run them.
// - Keep tests focused on behavior, not implementation details.
// - For this tool, prioritize tests around config, version checks, and safe file operations (the "don't break the user" parts).

// Future: black-box tests that build the binary and exec it against temp dirs + copied fixtures.
