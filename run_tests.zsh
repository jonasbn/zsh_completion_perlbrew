#!/usr/bin/env zsh

set -e

echo "Running Zsh Completion Test Suite"
echo "===================================="
echo ""

# Track overall results
OVERALL_EXIT=0

# Run parser tests
echo "Running Parser Tests..."
echo "----------------------"
if zsh tests/test_parsers.zsh; then
    echo ""
else
    OVERALL_EXIT=1
fi

# Run integration tests
echo "Running Integration Tests..."
echo "----------------------------"
if zsh tests/test_completion.zsh; then
    echo ""
else
    OVERALL_EXIT=1
fi

# Final summary
if [[ $OVERALL_EXIT -eq 0 ]]; then
    echo "✅ All test suites passed!"
else
    echo "❌ Some tests failed"
fi

exit $OVERALL_EXIT
