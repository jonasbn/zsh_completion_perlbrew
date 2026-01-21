.PHONY: test test-parsers test-integration clean help

# Default target
help:
	@echo "Available targets:"
	@echo "  make test             - Run all tests"
	@echo "  make test-parsers     - Run parser function tests only"
	@echo "  make test-integration - Run integration tests only"
	@echo "  make clean            - Clean completion cache"

# Run all tests
test:
	@./run_tests.zsh

# Run parser tests only
test-parsers:
	@zsh tests/test_parsers.zsh

# Run integration tests only
test-integration:
	@zsh tests/test_completion.zsh

# Clean completion cache
clean:
	@rm -f ~/.zcompdump*
	@echo "✓ Cleaned completion cache"
