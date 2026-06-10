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

This project is in early planning / alpha stage (target 0.1.0).

Core ideas evolved from the original `odin-update` script, which provided robust install/update with staging and verification.

## Direction

See GitHub Issues and the project kanban (via labels or Projects board) for detailed Q&A, feature discussions, and task breakdown.

High-level goals include:
- Subcommands for install, update, check/diagnostics, configuration, maintenance.
- Strong handling of ODIN_ROOT, PATH, and shell rc files with consent and management markers.
- Support for --dry-run, --to for alternate locations, --version, etc.
- Diagnostics and "fix" capabilities.
- Clear separation of concerns and incremental development.

## Getting Started (future)

(Placeholder - will be filled as the tool is built.)

## Contributing

See issues for open discussions. We are keeping scope focused and moving one item at a time.

## License

To be determined (likely MIT or similar for a CLI tool).
