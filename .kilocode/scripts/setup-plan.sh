#!/usr/bin/env bash
# Setup implementation plan structure for current branch
# For use with Kilocode spec-kit implementation

set -e

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) echo "Usage: $0 [--json]"; exit 0 ;;
    esac
done

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get all paths
eval $(get_feature_paths)

# Check if on feature branch
check_feature_branch "$CURRENT_BRANCH" || exit 1

# Create specs directory if it doesn't exist
mkdir -p "$FEATURE_DIR"

# Copy plan template from KILOCODE directory (not .specify/templates)
TEMPLATE="$REPO_ROOT/.kilocode/templates/plan-template.md"
if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$IMPL_PLAN"
else
    echo "Warning: Plan template not found at $TEMPLATE" >&2
    echo "Creating empty plan file" >&2
    touch "$IMPL_PLAN"
fi

if $JSON_MODE; then
    printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s"}\n' \
        "$FEATURE_SPEC" "$IMPL_PLAN" "$FEATURE_DIR" "$CURRENT_BRANCH"
else
    # Output all paths for LLM use
    echo "FEATURE_SPEC: $FEATURE_SPEC"
    echo "IMPL_PLAN: $IMPL_PLAN"
    echo "SPECS_DIR: $FEATURE_DIR"
    echo "BRANCH: $CURRENT_BRANCH"
fi