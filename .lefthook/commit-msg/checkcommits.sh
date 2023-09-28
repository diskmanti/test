#!/bin/bash

# Define the regex pattern for conventional commits
PATTERN="^(feat|fix|docs|style|refactor|perf|test|chore)(\([^)]+\))?: .+"

# Read the commit message from the parameter
commit_msg="$1"

# Function to print an error message and exit with a non-zero status
print_error() {
    echo "error: $1"
    exit 1
}

# Check if the commit message matches the pattern
if ! [[ $commit_msg =~ $PATTERN ]]; then
    print_error "Commit message does not follow the conventional commit format."
    print_error "Example commit messages:"
    print_error "  feat(core): add new feature"
    print_error "  fix(ui): resolve issue with button styling"
    print_error "  chore(deps): update dependencies"
fi

exit 0