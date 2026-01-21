#!/usr/bin/env zsh

# Get the directory where this script is located
SCRIPT_DIR="${0:A:h}"

# Source the test helper
source "$SCRIPT_DIR/test_helper.zsh"

# Source the completion script
source "$SCRIPT_DIR/../_perlbrew"

echo "${YELLOW}Testing Parser Functions${NC}"
echo ""

# Mock perlbrew command for testing
perlbrew() {
    case "$1" in
        list)
            cat << 'EOF'
  perl-5.38.0
* perl-5.36.0
  perl-5.34.0
  perl-5.32.0
EOF
            ;;
        available)
            cat << 'EOF'
# perl
  perl-5.40.0
  perl-5.38.2
  perl-5.36.3
  perl-5.40.0.tar.bz2
  perl-5.38.2.tar.bz2
EOF
            ;;
    esac
}

# Test 1: _perlbrew_parse_installed_unused
test_parse_installed_unused() {
    local result="$(_perlbrew_parse_installed_unused)"
    local expected="perl-5.38.0
perl-5.34.0
perl-5.32.0"

    assert_equal "$expected" "$result" "Parse installed unused versions (excludes current)"
}

# Test 2: _perlbrew_parse_installed_all
test_parse_installed_all() {
    local result="$(_perlbrew_parse_installed_all)"
    local expected="perl-5.38.0
perl-5.36.0
perl-5.34.0
perl-5.32.0"

    assert_equal "$expected" "$result" "Parse all installed versions (includes current)"
}

# Test 3: _perlbrew_parse_available
test_parse_available() {
    local result="$(_perlbrew_parse_available)"
    local expected="perl-5.40.0
perl-5.38.2
perl-5.36.3"

    assert_equal "$expected" "$result" "Parse available versions (excludes tarballs and comments)"
}

# Test 4: Empty list handling
test_parse_empty_list() {
    perlbrew() { echo ""; }
    local result="$(_perlbrew_parse_installed_unused)"

    assert_equal "" "$result" "Handle empty list gracefully"
}

# Test 5: Single version in list
test_parse_single_version() {
    perlbrew() { echo "* perl-5.38.0"; }
    local result="$(_perlbrew_parse_installed_unused)"

    assert_equal "" "$result" "Handle single active version (should return empty)"
}

# Test 6: Whitespace handling
test_parse_whitespace() {
    perlbrew() {
        case "$1" in
            list)
                echo "  perl-5.38.0  "
                echo "    perl-5.36.0    "
                ;;
        esac
    }

    local result="$(_perlbrew_parse_installed_all)"
    local expected="perl-5.38.0
perl-5.36.0"

    assert_equal "$expected" "$result" "Trim leading and trailing whitespace correctly"
}

# Test 7: Multiple active versions (edge case)
test_parse_multiple_with_asterisk() {
    perlbrew() {
        case "$1" in
            list)
                echo "  perl-5.38.0"
                echo "* perl-5.36.0"
                echo "  perl-5.34.0"
                ;;
        esac
    }

    local result="$(_perlbrew_parse_installed_unused)"
    assert_contains "$result" "perl-5.38.0" "Contains non-active version"
    assert_contains "$result" "perl-5.34.0" "Contains another non-active version"
}

# Test 8: Available list with various formats
test_parse_available_edge_cases() {
    perlbrew() {
        case "$1" in
            available)
                cat << 'EOF'
# perl
  perl-5.40.0
  perl-5.40.0.tar.bz2
  perl-5.38.2
  perl-5.36.3.tar.bz2
EOF
                ;;
        esac
    }

    local result="$(_perlbrew_parse_available)"
    local expected="perl-5.40.0
perl-5.38.2"

    assert_equal "$expected" "$result" "Filter out tarballs and # perl comments"
}

# Test 9: No asterisk in list
test_parse_no_active_version() {
    perlbrew() {
        case "$1" in
            list)
                echo "  perl-5.38.0"
                echo "  perl-5.36.0"
                ;;
        esac
    }

    local result="$(_perlbrew_parse_installed_unused)"
    assert_contains "$result" "perl-5.38.0" "Contains first version when no active"
    assert_contains "$result" "perl-5.36.0" "Contains second version when no active"
}

# Test 10: Version with lib suffix
test_parse_version_with_lib() {
    perlbrew() {
        case "$1" in
            list)
                echo "  perl-5.38.0"
                echo "  perl-5.38.0@mylib"
                echo "* perl-5.36.0"
                ;;
        esac
    }

    local result="$(_perlbrew_parse_installed_unused)"
    assert_contains "$result" "perl-5.38.0" "Handles versions with lib suffix"
}

# Run all tests
test_parse_installed_unused
test_parse_installed_all
test_parse_available
test_parse_empty_list
test_parse_single_version
test_parse_whitespace
test_parse_multiple_with_asterisk
test_parse_available_edge_cases
test_parse_no_active_version
test_parse_version_with_lib

# Print summary
print_summary
exit $?
