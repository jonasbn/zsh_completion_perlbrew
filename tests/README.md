# Test Suite

This directory contains the test suite for the perlbrew Zsh completion script.

## Structure

- `test_helper.zsh` - Common test utilities and assertion functions
- `test_parsers.zsh` - Unit tests for parser functions
- `test_completion.zsh` - Integration tests for the completion system

## Running Tests

### Run all tests

```bash
./run_tests.zsh
```

Or using Make:

```bash
make test
```

### Run specific test suites

```bash
# Parser tests only
make test-parsers

# Integration tests only
make test-integration
```

## Test Features

### Parser Function Tests

Tests the three parser functions that extract data from perlbrew output:

- `_perlbrew_parse_installed_unused()` - Parses installed versions excluding the current one
- `_perlbrew_parse_installed_all()` - Parses all installed versions
- `_perlbrew_parse_available()` - Parses available versions for installation

Test cases include:

- Normal operation with multiple versions
- Empty list handling
- Whitespace trimming
- Edge cases (single version, no active version, etc.)
- Version names with lib suffixes

### Integration Tests

Tests the overall completion system:

- Verifies completion functions exist
- Checks for proper Zsh completion structure
- Validates main commands are defined
- Tests that parsers return data correctly

## Mocking

The tests use mocked `perlbrew` commands to avoid dependencies on actual perlbrew installation. This makes tests:

- Fast - no external command execution
- Reliable - consistent test data
- Portable - works without perlbrew installed

## Continuous Integration

Tests are automatically run on push via GitHub Actions. See [.github/workflows/test.yml](../.github/workflows/test.yml).

## Writing New Tests

### Adding a parser test

1. Add a new test function in `test_parsers.zsh`
2. Create appropriate mocked perlbrew output
3. Call the parser function and assert the result
4. Add the test to the test execution section

Example:

```zsh
test_my_new_case() {
    perlbrew() { echo "  perl-5.40.0"; }
    local result="$(_perlbrew_parse_available)"
    assert_equal "perl-5.40.0" "$result" "Test description"
}
```

### Available assertions

- `assert_equal <expected> <actual> <test_name>` - Check exact equality
- `assert_array_equal <expected> <actual> <test_name>` - Compare arrays
- `assert_contains <haystack> <needle> <test_name>` - Check substring
- `assert_not_empty <value> <test_name>` - Verify non-empty value

## Troubleshooting

### Clean completion cache

```bash
make clean
```

### Test in clean environment

```bash
zsh -f tests/test_parsers.zsh
```

### Debug a specific test

Edit the test file and run it directly:

```bash
zsh tests/test_parsers.zsh
```
