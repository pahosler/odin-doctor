# odin-doctor

A safe, extensible doctor/installer/updater and maintenance tool for the Odin programming language.

## Concept

odin-doctor aims to be the reliable way to install, update, diagnose, and maintain Odin on your system. It emphasizes:

- **Safety first**: Never leave your system in a broken state. Uses staging, verification, backups, and rollback where appropriate.
- **User consent**: Explicit prompts before modifying shell configuration (e.g. .zshrc) or making significant changes.
- **Transparency**: Clear reporting of current state, existing configurations, and proposed actions. Markers like `# MANAGED BY ODIN-UPDATE` for traceability.
- **Subcommand-driven**: `odin-doctor check`, `update`, `install`, `status`, etc. (inspired by `odin` itself and tools like `flutter doctor`).
- **Support for complexity**: Multiple Odin installs/versions, different locations, cross-platform (macOS/Linux primarily), version pinning, shell integration management.

## Current Status

Early alpha / perpetual beta stage.

**Versioning**: Simple scheme — 0.1 through 0.9, then 0.10, 0.11, ... We only consider 1.0 once all open issues have been cleared and remained clear for a sustained period.

We're starting implementation by "playing with Odin":
- Local version check vs. latest from GitHub releases.
- File I/O (starting with a simple `~/.config/odin-doctor/odin-doctor.conf`).
- Basic tests using Odin's built-in `odin test` + `core:testing`.

See the GitHub Issues (labeled with `kanban:*`) for the full backlog of Q&A and features. We move one focused item at a time.

## Config

User configuration lives at `~/.config/odin-doctor/odin-doctor.conf` (simple `key=value` format for now).

The app populates sensible defaults. Users can override by editing the file directly or via future CLI flags/options. Keep it stupid simple.

Example (generated defaults):
```
default_command=check
```

## Language & Philosophy

We're experimenting with **Odin** as the implementation language (self-hosting appeal + ecosystem fit for Odin users who might contribute). Rust or Go are fallbacks if needed.

Development is incremental: start small (version check, file I/O, tests), add robustness and subcommands as we go. Safety and user consent remain non-negotiable.

## Getting Started (early)

(Coming soon — once basic `check` and config are solid.)

```bash
# After building
./odin-doctor --help
./odin-doctor check
```

Build with: `odin build main.odin -o:odin-doctor`

Test with: `odin test .`

## Contributing & Issues

See the kanban-style issues. We keep scope tight and discuss one thing at a time in chat before landing code or big decisions.

## License

To be decided (likely MIT).

## Project Tracking

This project uses GitHub Issues with labels to simulate a kanban board:

- `kanban:backlog`
- `kanban:ready`
- `kanban:in-progress` (aim for one at a time)
- `kanban:done`
- `kanban:discussion`

## Contributing

See issues for open discussions. We are keeping scope focused and moving one item at a time.

## License

To be determined (likely MIT or similar for a CLI tool).

## Project Tracking

This project uses GitHub Issues with labels to simulate a kanban board:

- `kanban:backlog`
- `kanban:ready`
- `kanban:in-progress` (aim for one at a time)
- `kanban:done`
- `kanban:discussion`

See the issues for detailed Q&A, feature discussions, and task breakdown. The main "Project Q&A and Open Decisions" issue is where pending answers will be captured.

Repo: https://github.com/pahosler/odin-doctor
