# GitHub Copilot Instructions

This repository contains a Zsh completion script for perlbrew.

## Code Style

- Follow zsh completion conventions
- Use `_describe` for listing options
- Use `_arguments` for command argument parsing
- Keep completions efficient - avoid slow command executions
- Comment complex completion logic

## Key Patterns

- Completion functions start with `_` (e.g., `_perlbrew`)
- Use `#compdef` directive at the top of completion files
- State-based completion with `_arguments -C`
- Array format for options: `'command:description'`

## Testing

- Test with `zsh -f` for clean environment
- Clear completion cache: `rm -f ~/.zcompdump*`
- Verify with real perlbrew commands

## Documentation

- Documentation should be in Markdown format
- Include usage examples
- Provide installation instructions
- The Markdown should be clear and concise and should adhere to the Markdownlint style guide and best practices and should follow the rules outlined in: `.markdownlint.json`

## Context

- This is a learning/experimental project
- Priority is on common perlbrew commands (use, install, switch, uninstall)
- Focus on user experience and helpful descriptions
