# Perlbrew Zsh Completion

Basic tab completion for [perlbrew](https://perlbrew.pl/).

It is a reimplementation of the [my Bash completion script for perlbrew](https://github.com/jonasbn/bash_completion_perlbrew), adapted to Zsh.

## Usage

The completion scripts provides tab completion for the `perlbrew` command, including subcommands and their arguments.

The implementation is not exhaustive, but covers the most commonly used commands and options, such as:

- `perlbrew use <version>`, , (excluding currently active version)
- `perlbrew switch <version>`, list installed versions for switching, (excluding currently active version)
- `perlbrew install <version>`, lists available versions for installation (using `perlbrew available`)
- `perlbrew uninstall <version>`, lists installed versions for uninstalling (including currently active version)

Add the same time it offers completion for other commands like:

- `list`
- `available`
- `init`, etc.

## Installation

This Zsh completion script is loaded by placing the `_perlbrew` file in a directory listed in your `$fpath` and then running `autoload -Uz _perlbrew`.

You can also symlink the `_perlbrew` file to a directory in your `$fpath`, e.g.:

```sh
ln -s /path/to/zsh_completion_perlbrew/_perlbrew ~/.zsh/completions/_perlbrew
```

Then add the following to your `.zshrc`:

```sh
fpath+=(${HOME}/.zsh/completions)
autoload -Uz _perlbrew
```

## Motivation

I have for a long time been using [perlbrew](https://perlbrew.pl/) to manage multiple Perl installations on my development machine and implementing the Bash completion script greatly improved my workflow.

Now I have switched to Zsh as my primary shell and I do not use Bash or `perlbrew` as much as before, but out of curiosity as to how the Zsh completion system works, I decided to reimplement the Bash completion script for Zsh. Then it was not all unfamiliar territory and I know the use-case and commands well already.

Zsh has a Bash completion compatibility mode, but I wanted to learn how to write native Zsh completion scripts and the native Zsh completion system is more powerful and flexible than the Bash completion system.

The implementation is pretty basic and there are possibly a lot of room for improvements and additions, for now I regard this as experimental, a learning exercise and a proof of concept, meaning alpha software.

## Notes

- The completion script assumes that `perlbrew` is installed and available in your `$PATH`.
- `shellcheck` is disabled for the repository as it does not support Zsh.
- The parser functions (`_perlbrew_parse_*`) are extracted for testability and can be tested independently.
- A comprehensive test suite is available in the `tests/` directory - see [tests/README.md](tests/README.md).
- Some interesting candidates for future improvements:
  - `install-multiple` command completion.
  - `clone-modules` command completion.

## Testing

Run the test suite to verify the completion script:

```bash
./run_tests.zsh
```

Or using Make:

```bash
make test
```

See [tests/README.md](tests/README.md) for more details about the test suite.

## Development

During development, you can with success use `entr` to run tests automatically on file changes:

```bash
ls _perlbrew tests/*.zsh | entr ./run_tests.zsh
```

## Datasheet

- The completion was developed and testing tested on:
  - macOS Tahoe 26.2
  - Zsh 5.9 (arm64-apple-darwin25.0)
  - App::perlbrew 0.98

- Implementation has been supported by Claude Sonnet 4.5.

## Security

See [SECURITY.md](SECURITY.md) for security policy and reporting vulnerabilities and other security related issues.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.

## See Also

- [perlbrew](https://perlbrew.pl/)
- [Bash completion script for perlbrew](https://github.com/jonasbn/bash_completion_perlbrew)
- [Zsh Completion System](http://zsh.sourceforge.net/Doc/Release/Completion-System.html)

## License

This is made available under the MIT license, see separate license file.

## Copyright

:copyright: jonasbn 2026
