#!/usr/bin/env zsh

# Get the directory where this script is located
SCRIPT_DIR="${0:A:h}"

# Source the test helper
source "$SCRIPT_DIR/test_helper.zsh"

# Load zsh completion system
autoload -Uz compinit
compinit

# Source the completion script
source "$SCRIPT_DIR/../_perlbrew"

echo "${YELLOW}Testing Completion Integration${NC}"
echo ""

# Mock perlbrew for testing
perlbrew() {
    case "$1" in
        list)
            echo "  perl-5.38.0"
            echo "* perl-5.36.0"
            echo "  perl-5.34.0"
            ;;
        available)
            echo "  perl-5.40.0"
            echo "  perl-5.38.2"
            ;;
    esac
}

# Test that the completion function is defined
test_completion_function_exists() {
    TESTS_RUN=$((TESTS_RUN + 1))
    if (( $+functions[_perlbrew] )); then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} Completion function _perlbrew exists"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} Completion function _perlbrew does not exist"
    fi
}

# Test parser functions exist
test_parser_functions_exist() {
    local funcs=(_perlbrew_parse_installed_unused _perlbrew_parse_installed_all _perlbrew_parse_available)

    for func in $funcs; do
        TESTS_RUN=$((TESTS_RUN + 1))
        if (( $+functions[$func] )); then
            TESTS_PASSED=$((TESTS_PASSED + 1))
            echo "${GREEN}✓${NC} Parser function $func exists"
        else
            TESTS_FAILED=$((TESTS_FAILED + 1))
            echo "${RED}✗${NC} Parser function $func does not exist"
        fi
    done
}

# Test that parser functions return expected data
test_parser_functions_work() {
    local result

    # Test installed unused
    result="$(_perlbrew_parse_installed_unused)"
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ -n "$result" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} _perlbrew_parse_installed_unused returns data"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} _perlbrew_parse_installed_unused returns empty"
    fi

    # Test installed all
    result="$(_perlbrew_parse_installed_all)"
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ -n "$result" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} _perlbrew_parse_installed_all returns data"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} _perlbrew_parse_installed_all returns empty"
    fi

    # Test available
    result="$(_perlbrew_parse_available)"
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ -n "$result" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} _perlbrew_parse_available returns data"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} _perlbrew_parse_available returns empty"
    fi
}

# Test that completion script has proper structure
test_completion_structure() {
    # Read the completion file
    local completion_file="$SCRIPT_DIR/../_perlbrew"

    # Check for #compdef directive
    TESTS_RUN=$((TESTS_RUN + 1))
    if grep -q '^#compdef perlbrew' "$completion_file"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} File has #compdef directive"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} File missing #compdef directive"
    fi

    # Check for _arguments usage
    TESTS_RUN=$((TESTS_RUN + 1))
    if grep -q '_arguments' "$completion_file"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} File uses _arguments"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} File does not use _arguments"
    fi

    # Check for _describe usage
    TESTS_RUN=$((TESTS_RUN + 1))
    if grep -q '_describe' "$completion_file"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✓${NC} File uses _describe"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}✗${NC} File does not use _describe"
    fi
}

# Test that main commands are present
test_main_commands_present() {
    local completion_file="$SCRIPT_DIR/../_perlbrew"
    local commands=('init' 'install' 'use' 'switch' 'list' 'available' 'uninstall')

    for cmd in $commands; do
        TESTS_RUN=$((TESTS_RUN + 1))
        if grep -q "'$cmd:" "$completion_file"; then
            TESTS_PASSED=$((TESTS_PASSED + 1))
            echo "${GREEN}✓${NC} Command '$cmd' is defined"
        else
            TESTS_FAILED=$((TESTS_FAILED + 1))
            echo "${RED}✗${NC} Command '$cmd' is missing"
        fi
    done
}

# Run tests
test_completion_function_exists
test_parser_functions_exist
test_parser_functions_work
test_completion_structure
test_main_commands_present

# Print summary
print_summary
exit $?
