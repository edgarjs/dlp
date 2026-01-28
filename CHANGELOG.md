# Changelog

All notable changes to the Development Lifecycle Protocol will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0-beta.4] - 2026-01-25

### Added

- Constraint discovery and verification rules in `AGENTS.md`
- Templates directory with output artifact templates
- Mandatory dependency version enforcement

### Changed

- Condensed DLP by removing redundant and verbose sections

## [1.0.0-beta.3] - 2026-01-23

### Added

- `--ref` option to `install.sh` to install a specific commit/tag

### Changed

- Simplified documentation and install script

## [1.0.0-beta.2] - 2026-01-23

### Added

- Global installation system with intelligent path handling
- Automation principle: script and use on second occurrence
- Task execution protocol for agent workflow preferences
- Web search requirement for current dependency information
- Primary key guidance preferring UUIDs over integers
- Security requirements and SRP example to development docs
- Contributing guidelines

### Changed

- Improved robustness and reduced duplication of the install script
- Enforced strict agent compliance

### Fixed

- Install script no longer prints README.md content on install

## [1.0.0-beta] - 2026-01-22

### Added

- Initial protocol structure with four phases: Requirements, Design, Development, Testing
- Foundations phase with core principles and meta-guidance
- Cross-cutting concerns: Security, Performance, Accessibility, Observability
- Agent instructions (`AGENTS.md`) for LLM integration
- Install script for easy protocol adoption
- MIT license

[Unreleased]: https://github.com/edgarjs/dlp/compare/v1.0.0-beta.4...HEAD
[1.0.0-beta.4]: https://github.com/edgarjs/dlp/compare/v1.0.0-beta.3...v1.0.0-beta.4
[1.0.0-beta.3]: https://github.com/edgarjs/dlp/compare/v1.0.0-beta.2...v1.0.0-beta.3
[1.0.0-beta.2]: https://github.com/edgarjs/dlp/compare/v1.0.0-beta...v1.0.0-beta.2
[1.0.0-beta]: https://github.com/edgarjs/dlp/releases/tag/v1.0.0-beta
