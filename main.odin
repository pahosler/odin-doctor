package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:mem"

// VERSION follows the simple scheme: 0.1 to 0.9, then 0.10, 0.11...
// Perpetual beta until all issues cleared and stable for a while.
VERSION :: "0.1"

// Config holds user preferences. Defaults are set in code.
// Stored in ~/.config/odin-doctor/odin-doctor.conf as simple key=value.
// User can edit manually or we'll add CLI options later.
Config :: struct {
	default_command: string, // e.g. "check" or "update"
	// Add more as needed, keep stupid simple.
}

// crash course notes (Odin basics for the user):
// - package main + main proc is the entry point (like C).
// - import "core:xxx" for standard library. No "use" or qualified imports by default.
// - strings are immutable; use strings.Builder for efficient mutation.
// - os package for files, env, etc. Error handling often uses or_else or explicit checks.
// - defer runs on scope exit (great for cleanup like close files).
// - structs are value types; use ^ for pointers when needed.
// - testing is built-in with @(test) and core:testing.
// - Odin is systems-level: you control memory/allocators, but core:mem helps.
// - For CLI, we'll build simple arg parsing ourselves at first (no heavy deps).
// See https://odin-lang.org/docs/ for full docs. Ask me for specific explanations!

main :: proc() {
	fmt.println("odin-doctor", VERSION)
	fmt.println("A safe tool for Odin. (Perpetual beta for now)")

	// Demo: load or create default config
	config_path := get_config_path()
	config := load_config(config_path)
	if config.default_command == "" {
		config.default_command = "check" // sensible default
		save_config(config_path, config)
		fmt.println("Created default config at", config_path)
	}

	fmt.printf("Default command: %s\n", config.default_command)

	// TODO next: implement actual "check" (local odin version vs online)
	// For now, stub:
	fmt.println("\n[stub] Would check local 'odin version' vs https://api.github.com/repos/odin-lang/Odin/releases/latest")
	fmt.println("Local version stub: dev-2026-06 (replace with real exec later)")
	fmt.println("Online version stub: dev-2026-06")

	// Play with file I/O example (the config itself)
	fmt.println("\nConfig file I/O demo complete (see load/save below).")

	// TODO: real subcommands, --help, etc.
	fmt.println("\nRun with subcommand ideas: check, update, install, status, etc.")
}

// get_config_path returns ~/.config/odin-doctor/odin-doctor.conf
// Creates the directory if needed. Simple and stupid.
get_config_path :: proc() -> string {
	home := os.get_env("HOME")
	if home == "" {
		home = os.get_env("USERPROFILE") // Windows fallback
	}
	if home == "" {
		fmt.eprintln("Could not determine home directory")
		os.exit(1)
	}

	config_dir := strings.concatenate({home, "/.config/odin-doctor"})
	defer delete(config_dir)

	if !os.is_dir(config_dir) {
		err := os.make_directory(config_dir)
		if err != os.ERROR_NONE {
			fmt.eprintf("Failed to create config dir %s: %v\n", config_dir, err)
			os.exit(1)
		}
	}

	return strings.concatenate({config_dir, "/odin-doctor.conf"})
}

// load_config reads simple key=value file.
// Very basic parser for now (no quotes, no sections).
// Returns zero value + false on any error (caller can set defaults).
load_config :: proc(path: string) -> (config: Config, ok: bool) {
	data, read_ok := os.read_entire_file(path)
	if !read_ok {
		return {}, false
	}
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	for line in lines {
		line = strings.trim_space(line)
		if line == "" || strings.has_prefix(line, "#") {
			continue
		}
		parts := strings.split(line, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.trim_space(parts[0])
		value := strings.trim_space(parts[1])

		switch key {
		case "default_command":
			config.default_command = value
		}
	}

	return config, true
}

// save_config writes the config in simple key=value format.
// Overwrites the file.
save_config :: proc(path: string, config: Config) -> bool {
	builder := strings.builder_make()
	defer strings.builder_destroy(&builder)

	if config.default_command != "" {
		strings.write_string(&builder, "default_command=")
		strings.write_string(&builder, config.default_command)
		strings.write_string(&builder, "\n")
	}

	data := strings.to_string(builder)
	return os.write_entire_file(path, transmute([]byte)data)
}

// TODO (file I/O play area):
// - Add more robust conf parser (handle comments better, defaults).
// - Experiment with os.open, os.read, os.write for finer control.
// - Use strings.Builder for building config output (avoids many allocations).
// - Error handling pattern: if err != os.ERROR_NONE { ... }

// Next plays:
// - Real version check: exec "odin version", parse output, compare to GitHub API (use vendor:curl or core:net later).
// - Subcommand dispatcher (simple if/else or map for now).
// - Tests in main_test.odin using core:testing.
// - Config via CLI flags (parse os.args).

// Crash course reminders while we code:
// - Odin strings are (data: ^byte, len: int). Use core:strings for ops.
// - defer is your friend for resource cleanup.
// - Context (context.allocator) controls memory; default is fine to start.
// - Build with: odin run main.odin
// - Test with: odin test . (or odin test main_test.odin)
// - For release binary: odin build main.odin -o:odin-doctor
