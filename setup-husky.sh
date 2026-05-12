#!/bin/bash

# setup-husky.sh
# Script to set up Husky with pre-commit and commit-msg hooks for Laravel/Vue projects

set -e  # Exit on any error

# Default project path (current directory)
PROJECT_PATH="${1:-.}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a valid project directory
check_project_directory() {
    print_status "Checking project directory: $PROJECT_PATH"
    
    # Change to the project directory
    if [ ! -d "$PROJECT_PATH" ]; then
        print_error "Project directory '$PROJECT_PATH' does not exist."
        exit 1
    fi
    
    cd "$PROJECT_PATH"
    
    if [ ! -f "package.json" ]; then
        print_error "package.json not found in '$PROJECT_PATH'. Please specify a valid project directory."
        exit 1
    fi
    
    if [ ! -f "composer.json" ]; then
        print_warning "composer.json not found in '$PROJECT_PATH'. This might not be a Laravel project."
    fi
    
    print_success "Project directory validated: $(pwd)"
}

# Install required packages
install_packages() {
    print_status "Installing required packages..."
    
    # Install husky if not already installed
    print_status "Installing eslint prettier husky lint-staged @commitlint/cli @commitlint/config-conventional"
    
    yarn add --dev eslint prettier husky lint-staged @commitlint/cli @commitlint/config-conventional
}

# Create .husky directory
create_husky_directory() {
    print_status "Creating .husky directory..."
    mkdir -p .husky
    print_success ".husky directory created"
}

# Create pre-commit hook
create_pre_commit_hook() {
    print_status "Creating pre-commit hook..."
    
    touch .husky/pre-commit
    echo "npx lint-staged" > .husky/pre-commit
    
    chmod +x .husky/pre-commit
    print_success "Pre-commit hook created and made executable"
}

# Create commit-msg hook
create_commit_msg_hook() {
    print_status "Creating commit-msg hook..."
    
    touch .husky/commit-msg
    echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg
    
    chmod +x .husky/commit-msg
    print_success "Commit-msg hook created and made executable"
}

# Create commitlint configuration
create_commitlint_config() {
    print_status "Creating commitlint configuration..."
    
    cat > commitlint.config.js << 'EOF'
export default {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'type-enum': [
            2,
            'always',
            [
                'feat',     // A new feature
                'fix',      // A bug fix
                'docs',     // Documentation only changes
                'style',    // Changes that do not affect the meaning of the code
                'refactor', // A code change that neither fixes a bug nor adds a feature
                'perf',     // A code change that improves performance
                'test',     // Adding missing tests or correcting existing tests
                'build',    // Changes that affect the build system or external dependencies
                'ci',       // Changes to our CI configuration files and scripts
                'chore',    // Other changes that don't modify src or test files
                'revert',   // Reverts a previous commit
            ],
        ],
        'type-case': [2, 'always', 'lower-case'],
        'type-empty': [2, 'never'],
        'scope-case': [2, 'always', 'lower-case'],
        'subject-case': [2, 'always', 'lower-case'],
        'subject-empty': [2, 'never'],
        'subject-full-stop': [2, 'never', '.'],
        'header-max-length': [2, 'always', 100],
    },
};
EOF
    
    print_success "Commitlint configuration created"
}

# Create lint-staged configuration
create_lint_staged_config() {
    print_status "Creating lint-staged configuration..."
    
    cat > .lintstagedrc.js << 'EOF'
export default {
    // JavaScript/TypeScript/Vue files
    '*.{js,jsx,ts,tsx,vue}': ['eslint --fix', 'prettier --write'],

    // CSS/SCSS files
    '*.{css,scss}': ['prettier --write'],

    // PHP files
    '*.php': ['vendor/bin/pint'],

    // JSON, YAML, Markdown files
    '*.{json,yaml,yml,md}': ['prettier --write'],
};
EOF
    
    print_success "Lint-staged configuration created"
}

# Update package.json scripts
update_package_scripts() {
    print_status "Updating package.json scripts..."
    
    # Check if prepare script exists
    if ! grep -q '"lint:staged": "lint-staged"' package.json; then
        print_status "Adding prepare script to package.json..."
        
        # add the following scripts to the package.json
        # "lint:staged": "lint-staged",
        # "lint:all": "yarn lint && yarn format:check && vendor/bin/pint --test"
        
        if command -v jq > /dev/null 2>&1; then
            tmpfile=$(mktemp)
            jq '.scripts["lint:staged"] = "lint-staged" | .scripts["lint:all"] = "yarn lint && yarn format:check && vendor/bin/pint --test"' package.json > "$tmpfile" && mv "$tmpfile" package.json
        else
            print_warning "jq is not installed. Please add the scripts manually to package.json."
        fi
        
        print_success "Added/updated scripts: lint:staged, and lint:all in package.json"
    else
        print_success "Prepare script already exists in package.json"
    fi
}

# Initialize husky
initialize_husky() {
    print_status "Initializing husky..."
    npx husky init
    print_success "Husky initialized"
}

# Test the setup
test_setup() {
    print_status "Testing the setup..."
    
    # Test commitlint
    echo "feat: test commit message" | npx commitlint
    if [ $? -eq 0 ]; then
        print_success "Commitlint test passed"
    else
        print_error "Commitlint test failed"
    fi
    
    # Test lint-staged (dry run)
    npx lint-staged --help > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_success "Lint-staged test passed"
    else
        print_error "Lint-staged test failed"
    fi
}

# Show usage information
show_usage() {
    echo "Usage: $0 [PROJECT_PATH]"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_PATH    Path to the project directory (default: current directory)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Setup husky in current directory"
    echo "  $0 ./my-project       # Setup husky in ./my-project directory"
    echo "  $0 /path/to/project   # Setup husky in /path/to/project directory"
    echo ""
    echo "This script sets up Husky with pre-commit and commit-msg hooks for Laravel/Vue projects."
}

# Main execution
main() {
    # Check for help flag
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
        exit 0
    fi
    
    print_status "Starting Husky setup for Laravel/Vue project..."
    print_status "Target project: $PROJECT_PATH"
    
    check_project_directory
    install_packages
    initialize_husky
    create_husky_directory
    create_pre_commit_hook
    create_commit_msg_hook
    create_commitlint_config
    create_lint_staged_config
    update_package_scripts
    test_setup
    
    print_success "Husky setup completed successfully!"
    print_status "Your project now has:"
    print_status "  ✓ Pre-commit hook (runs lint-staged)"
    print_status "  ✓ Commit-msg hook (validates conventional commits)"
    print_status "  ✓ Commitlint configuration"
    print_status "  ✓ Lint-staged configuration"
    print_status ""
    print_status "Example commit messages:"
    print_status "  feat: add new user authentication"
    print_status "  fix: resolve login validation issue"
    print_status "  docs: update API documentation"
    print_status "  style: format code with prettier"
    print_status "  refactor: improve user service logic"
}

# Run main function
main "$@"