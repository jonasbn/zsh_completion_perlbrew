# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2016-01-21

### Added

- Comprehensive test suite with 29 tests covering parser functions and completion integration
- Test framework with color-coded output and assertion helpers in `tests/test_helper.zsh`
- Unit tests for parser functions in `tests/test_parsers.zsh` (12 tests)
- Integration tests for completion system in `tests/test_completion.zsh` (17 tests)
- Test runner script `run_tests.zsh` for executing all tests
- Makefile with targets for running tests (`test`, `test-parsers`, `test-integration`, `clean`)
- GitHub Actions CI workflow for automated testing on push and pull requests
- Test documentation in `tests/README.md` with usage examples and troubleshooting guide
- Mocked perlbrew commands in tests for reliable testing without external dependencies

### Changed

- Refactored parser logic into separate, testable functions:
  - `_perlbrew_parse_installed_unused()` - Parse installed versions excluding current
  - `_perlbrew_parse_installed_all()` - Parse all installed versions
  - `_perlbrew_parse_available()` - Parse available versions for installation
- **Performance**: Optimized `_perlbrew_parse_installed_all()` from two piped `sed` commands to one
- **Performance**: Optimized `_perlbrew_parse_available()` from two `grep` + one `sed` to single `sed` command
- Updated README.md with test suite documentation and usage instructions
- Added GitHub Copilot instructions for test suite patterns

### Fixed

- Improved code maintainability by extracting parsing logic into reusable functions

## [0.1.0] - 2026-01-18

### Added

- Initial implementation of Zsh completion for perlbrew
- Completion for main perlbrew commands: `init`, `info`, `install`, `uninstall`, `available`, `lib`, `alias`, `upgrade-perl`, `list`, `use`, `off`, `switch`, `switch-off`, `exec`, `list-modules`, `clone-modules`, `self-install`, `self-upgrade`, `install-patchperl`, `install-cpanm`, `install-cpm`, `install-multiple`, `download`, `clean`, `version`, `help`
- Smart completion for command arguments:
  - `use` and `switch` complete with installed versions (excluding current)
  - `install` completes with available versions from `perlbrew available`
  - `uninstall` completes with all installed versions
- Basic project infrastructure:
  - MIT License
  - README.md with usage and installation instructions
  - CONTRIBUTING.md with contribution guidelines
  - EditorConfig for consistent code style
  - Markdownlint configuration
  - Spellcheck configuration with custom wordlist
  - GitHub Actions workflows for linting and validation
  - Dependabot configuration for keeping GitHub Actions up to date

### Documentation

- Comprehensive README with motivation, usage examples, and installation instructions
- Notes on experimental/learning project status
- Datasheet documenting development and testing environment

[0.2.0]: https://github.com/jonasbn/zsh_completion_perlbrew/compare/0.1.0...HEAD
[0.1.0]: https://github.com/jonasbn/zsh_completion_perlbrew/releases/tag/0.1.0
