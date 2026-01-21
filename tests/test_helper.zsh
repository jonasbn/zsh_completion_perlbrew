#!/usr/bin/env zsh

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Assert function
assert_equal() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$expected" == "$actual" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} $test_name"
        echo "  Expected: $expected"
        echo "  Got:      $actual"
        return 1
    fi
}

# Assert array equal
assert_array_equal() {
    local -a expected=("${(@f)1}")
    local -a actual=("${(@f)2}")
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "${#expected[@]}" -ne "${#actual[@]}" ]]; then
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} $test_name"
        echo "  Array length mismatch: ${#expected[@]} vs ${#actual[@]}"
        return 1
    fi

    local i
    for i in {1..${#expected[@]}}; do
        if [[ "${expected[$i]}" != "${actual[$i]}" ]]; then
            TESTS_FAILED=$((TESTS_FAILED + 1))
            echo "${RED}✗${NC} $test_name"
            echo "  Element $i differs:"
            echo "    Expected: ${expected[$i]}"
            echo "    Got:      ${actual[$i]}"
            return 1
        fi
    done

    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo "${GREEN}✓${NC} $test_name"
    return 0
}

# Assert contains
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ "$haystack" == *"$needle"* ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} $test_name"
        echo "  Expected to contain: $needle"
        echo "  In: $haystack"
        return 1
    fi
}

# Assert not empty
assert_not_empty() {
    local value="$1"
    local test_name="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    if [[ -n "$value" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} $test_name"
        echo "  Expected non-empty value"
        return 1
    fi
}

# Print test summary
print_summary() {
    echo ""
    echo "=========================================="
    echo "Tests run: $TESTS_RUN"
    echo "${GREEN}Passed: $TESTS_PASSED${NC}"
    [[ $TESTS_FAILED -gt 0 ]] && echo "${RED}Failed: $TESTS_FAILED${NC}" || echo "Failed: $TESTS_FAILED"
    echo "=========================================="

    return $TESTS_FAILED
}
