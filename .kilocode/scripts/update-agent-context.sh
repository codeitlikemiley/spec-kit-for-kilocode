#!/usr/bin/env bash
# Update Kilocode memory bank based on new feature plan
# Works with Kilocode's memory bank system in .kilocode/rules/memory-bank/

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
FEATURE_DIR="$REPO_ROOT/specs/$CURRENT_BRANCH"
NEW_PLAN="$FEATURE_DIR/plan.md"

# Memory bank location
MEMORY_BANK="$REPO_ROOT/.kilocode/rules/memory-bank"

if [ ! -f "$NEW_PLAN" ]; then
    echo "ERROR: No plan.md found at $NEW_PLAN"
    exit 1
fi

echo "=== Updating Kilocode memory bank for feature $CURRENT_BRANCH ==="

# Create memory bank directory if it doesn't exist
mkdir -p "$MEMORY_BANK"

# Extract tech info from new plan
NEW_LANG=$(grep "^**Language/Version**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**Language\/Version**: //' | grep -v "NEEDS CLARIFICATION" || echo "")
NEW_FRAMEWORK=$(grep "^**Primary Dependencies**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**Primary Dependencies**: //' | grep -v "NEEDS CLARIFICATION" || echo "")
NEW_TESTING=$(grep "^**Testing**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**Testing**: //' | grep -v "NEEDS CLARIFICATION" || echo "")
NEW_DB=$(grep "^**Storage**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**Storage**: //' | grep -v "N/A" | grep -v "NEEDS CLARIFICATION" || echo "")
NEW_PROJECT_TYPE=$(grep "^**Project Type**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**Project Type**: //' || echo "")
NEW_PLATFORM=$(grep "^**Target Platform**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**Target Platform**: //' || echo "")

# Update product.md (NOT project.md)
update_product_file() {
    local product_file="$MEMORY_BANK/product.md"
    
    if [ ! -f "$product_file" ]; then
        echo "Creating new product.md..."
        cat > "$product_file" << EOF
# Product Overview

## Why This Exists
Building a software product using spec-driven development methodology.

## Problems Being Solved
- Ensuring features are fully specified before implementation
- Maintaining consistency between specification and code
- Following TDD principles throughout development

## How It Works
1. Features start with comprehensive specifications
2. Technical plans guide implementation
3. Tasks are broken down and executed systematically
4. All code follows test-driven development

## Current Features
- $CURRENT_BRANCH: ${CURRENT_BRANCH#*-}

## User Experience Goals
- Clear, documented features
- Reliable, tested implementation
- Maintainable codebase

Last updated: $(date +%Y-%m-%d)
EOF
    else
        echo "Updating existing product.md..."
        # Add new feature if not already listed
        if ! grep -q "$CURRENT_BRANCH" "$product_file"; then
            sed -i "/## Current Features/a - $CURRENT_BRANCH: ${CURRENT_BRANCH#*-}" "$product_file"
        fi
        
        # Update last updated date
        sed -i "s/Last updated: .*/Last updated: $(date +%Y-%m-%d)/" "$product_file"
    fi
    echo "✅ product.md updated"
}

# Update context.md
update_context_file() {
    local context_file="$MEMORY_BANK/context.md"
    
    cat > "$context_file" << EOF
# Current Context

## Active Work
- Feature: $CURRENT_BRANCH
- Phase: Planning complete, ready for task generation
- Branch: $CURRENT_BRANCH

## Recent Changes
- Created specification for ${CURRENT_BRANCH#*-}
- Completed technical planning
- Technology stack decided: $NEW_LANG with $NEW_FRAMEWORK

## Technical Decisions
- Language: $NEW_LANG
- Framework: $NEW_FRAMEWORK
- Testing: $NEW_TESTING
- Storage: $([ "$NEW_DB" != "N/A" ] && echo "$NEW_DB" || echo "None required")

## Next Steps
1. Run /tasks.md to generate task list
2. Switch to @spec-implementer mode
3. Begin implementation with T001

## Important Files
- Specification: specs/$CURRENT_BRANCH/spec.md
- Technical Plan: specs/$CURRENT_BRANCH/plan.md
- Research: specs/$CURRENT_BRANCH/research.md

Last updated: $(date +%Y-%m-%d)
EOF
    echo "✅ context.md updated"
}

# Update architecture.md
update_architecture_file() {
    local arch_file="$MEMORY_BANK/architecture.md"
    
    if [ ! -f "$arch_file" ]; then
        echo "Creating new architecture.md..."
        cat > "$arch_file" << EOF
# System Architecture

## Key Decisions
- Spec-driven development methodology
- Test-driven implementation
- Feature branches for isolation

## Design Patterns
- Library-first architecture
- CLI interfaces for all libraries
- Contract testing for APIs

## Component Structure
$(if [[ "$NEW_PROJECT_TYPE" == *"web"* ]]; then
    echo "### Web Application"
    echo "- backend/ - API server ($NEW_FRAMEWORK)"
    echo "- frontend/ - Web UI"
    echo "- tests/ - Test suites ($NEW_TESTING)"
elif [[ "$NEW_PROJECT_TYPE" == *"mobile"* ]]; then
    echo "### Mobile Application"
    echo "- api/ - Backend API ($NEW_FRAMEWORK)"
    echo "- ios/ or android/ - Mobile app"
    echo "- tests/ - Test suites ($NEW_TESTING)"
else
    echo "### Application"
    echo "- src/ - Source code ($NEW_LANG)"
    echo "- tests/ - Test suites ($NEW_TESTING)"
fi)

## Critical Paths
- All features must have specifications
- Tests must be written before implementation
- Code review required for merges

Last updated: $(date +%Y-%m-%d)
EOF
    else
        echo "ℹ️ architecture.md already exists, preserving existing content"
    fi
    echo "✅ architecture.md checked"
}

# Update tech.md
update_tech_file() {
    local tech_file="$MEMORY_BANK/tech.md"
    
    cat > "$tech_file" << EOF
# Technology Stack

## Languages & Frameworks
- Primary Language: $NEW_LANG
- Framework: $NEW_FRAMEWORK
- Testing: $NEW_TESTING
$([ -n "$NEW_DB" ] && [ "$NEW_DB" != "N/A" ] && echo "- Database: $NEW_DB")

## Development Setup
- Git with feature branches
- Spec-driven development workflow
- Test-driven development

## Dependencies
See plan.md in specs/$CURRENT_BRANCH/ for detailed dependencies.

## Tool Configurations
$(if [[ "$NEW_LANG" == *"Python"* ]]; then
    echo "- pytest for testing"
    echo "- ruff for linting"
    echo "- pip for package management"
elif [[ "$NEW_LANG" == *"JavaScript"* ]] || [[ "$NEW_LANG" == *"TypeScript"* ]]; then
    echo "- Jest/Vitest for testing"
    echo "- ESLint for linting"
    echo "- npm/yarn for package management"
elif [[ "$NEW_LANG" == *"Rust"* ]]; then
    echo "- cargo test for testing"
    echo "- clippy for linting"
    echo "- cargo for package management"
fi)

## Constraints
- Must follow TDD principles
- All code must pass linting
- Tests required for all features

Last updated: $(date +%Y-%m-%d)
EOF
    echo "✅ tech.md updated"
}

# Update tasks.md (for repetitive workflows, not individual tasks)
update_tasks_workflows_file() {
    local tasks_file="$MEMORY_BANK/tasks.md"
    
    if [ ! -f "$tasks_file" ]; then
        echo "Creating new tasks.md for repetitive workflows..."
        cat > "$tasks_file" << EOF
# Repetitive Task Workflows

## Adding a New Feature
1. Run /specify.md with feature description
2. Run /plan.md with technical choices
3. Run /tasks.md to generate task list
4. Switch to @spec-implementer mode
5. Work through tasks sequentially

## Creating API Endpoints
1. Define contract in specs/*/contracts/
2. Write contract test (must fail)
3. Implement endpoint
4. Make test pass
5. Add integration tests

## Adding New Entity
1. Define in data-model.md
2. Create model file
3. Add validation
4. Create service layer
5. Add tests

## Files to Modify for Common Tasks
- New feature: Create branch, specs directory
- New endpoint: contracts/, src/api/, tests/contract/
- New model: data-model.md, src/models/, tests/unit/
- New service: src/services/, tests/integration/

## Important Considerations
- Always write tests first (TDD)
- Update task checkboxes as you complete
- Commit after each task
- Run full test suite before marking complete

Last updated: $(date +%Y-%m-%d)
EOF
        echo "✅ tasks.md created (for workflows, not feature tasks)"
    fi
}

# Execute all updates
update_product_file
update_context_file
update_architecture_file
update_tech_file
update_tasks_workflows_file

echo ""
echo "=== Summary of Updates ==="
echo "Memory bank location: $MEMORY_BANK"
echo "Updated files:"
ls -la "$MEMORY_BANK"/*.md 2>/dev/null | awk '{print "  - " $NF}'

if [ -n "$NEW_LANG" ]; then
    echo ""
    echo "Technology additions:"
    echo "  - Language: $NEW_LANG"
    [ -n "$NEW_FRAMEWORK" ] && echo "  - Framework: $NEW_FRAMEWORK"
    [ -n "$NEW_TESTING" ] && echo "  - Testing: $NEW_TESTING"
    [ -n "$NEW_DB" ] && [ "$NEW_DB" != "N/A" ] && echo "  - Database: $NEW_DB"
fi

echo ""
echo "Next steps:"
echo "  1. Review memory bank files in $MEMORY_BANK"
echo "  2. Run /tasks.md to generate task list"
echo "  3. Begin implementation with @spec-implementer mode"