# Spec-Kit for Kilocode - Native Implementation

## Overview
This is a complete port of GitHub's spec-kit to work natively within Kilocode, leveraging Kilocode's workflows, custom modes, rules, and memory bank features.

## Directory Structure

```
project/
├── .kilocode/
│   ├── workflows/           # Spec-driven workflows (replaces .claude/commands)
│   │   ├── specify.md
│   │   ├── plan.md
│   │   └── tasks.md
│   ├── modes               # Custom modes for each phase
│   ├── rules/
│   │   ├── spec-driven.md  # Core spec-driven rules
│   │   └── memory-bank/    # Project memory (replaces .specify/memory)
│   │       ├── constitution.md
│   │       └── constitution-update-checklist.md
│   ├── scripts/            # Support scripts (adapted for Kilocode)
│   │   ├── common.sh
│   │   ├── create-new-feature.sh
│   │   ├── setup-plan.sh
│   │   ├── check-task-prerequisites.sh
│   │   ├── get-feature-paths.sh
│   │   └── update-agent-context.sh
│   └── templates/          # Document templates
│       ├── spec-template.md
│       ├── plan-template.md
│       ├── tasks-template.md
│       └── agent-file-template.md
└── specs/                  # Feature specifications
    └── [001-feature-name]/
        ├── spec.md
        ├── plan.md
        ├── tasks.md
        ├── research.md
        ├── data-model.md
        ├── quickstart.md
        └── contracts/
```

## 1. Workflows (.kilocode/workflows/)

### specify.md
```markdown
# Specify Feature Workflow

Start a new feature by creating a specification and feature branch.
This is the first step in the Spec-Driven Development lifecycle.

## Execution Steps:

1. **Parse Feature Description**
   Use `ask_followup_question` if the feature description needs clarification:
   - What is the main goal?
   - Who are the target users?
   - What are the success criteria?

2. **Create Feature Branch**
   Execute the feature creation script:
   ```bash
   execute_command: bash .kilocode/scripts/create-new-feature.sh --json "$ARGUMENTS"
   ```
   Parse the JSON output for BRANCH_NAME and SPEC_FILE.

3. **Load Specification Template**
   Use `read_file` to load `.kilocode/templates/spec-template.md`

4. **Generate Specification**
   Write the specification to SPEC_FILE using `write_to_file`:
   - Replace placeholders with concrete details from feature description
   - Mark any ambiguities with [NEEDS CLARIFICATION]
   - Focus on WHAT not HOW

5. **Update Memory Bank**
   Add feature to `.kilocode/rules/memory-bank/active-features.md`:
   - Feature number and name
   - Branch name
   - Creation date

6. **Report Success**
   Output:
   - Branch name created
   - Spec file location
   - Next step: run /plan.md

## Usage:
Type `/specify.md` followed by your feature description.
```

### plan.md
```markdown
# Plan Feature Workflow

Create technical implementation plan from specification.
This is the second step in the Spec-Driven Development lifecycle.

## Execution Steps:

1. **Setup Planning Environment**
   ```bash
   execute_command: bash .kilocode/scripts/setup-plan.sh --json
   ```
   Parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH.

2. **Load Constitution**
   Use `read_file` to load `.kilocode/rules/memory-bank/constitution.md`
   Understand project principles and constraints.

3. **Analyze Specification**
   Use `read_file` to load the feature specification from FEATURE_SPEC:
   - Extract requirements and user stories
   - Identify technical constraints
   - Note any [NEEDS CLARIFICATION] markers

4. **Execute Plan Template**
   Load `.kilocode/templates/plan-template.md` with `read_file`
   Execute the template's execution flow:
   
   Phase 0 - Research:
   - Create research.md with technical decisions
   - Resolve all NEEDS CLARIFICATION items
   
   Phase 1 - Design:
   - Create data-model.md with entities
   - Create contracts/ with API specifications
   - Create quickstart.md with test scenarios
   
   Phase 2 - Task Planning (describe only):
   - Outline task generation strategy
   - DO NOT create tasks.md (that's for /tasks.md workflow)

5. **Constitution Check**
   Verify plan adheres to constitutional principles:
   - Library-first architecture
   - Test-driven development
   - Simplicity constraints

6. **Update Agent Context**
   ```bash
   execute_command: bash .kilocode/scripts/update-agent-context.sh
   ```

7. **Report Success**
   Output:
   - Plan created at IMPL_PLAN
   - Artifacts generated
   - Next step: run /tasks.md

## Usage:
Type `/plan.md` followed by technical implementation details.
```

### tasks.md (Workflow)
```markdown
# Generate Tasks Workflow

Break down the plan into executable tasks.
This is the third step in the Spec-Driven Development lifecycle.

## Execution Steps:

1. **Check Prerequisites**
   ```bash
   execute_command: bash .kilocode/scripts/check-task-prerequisites.sh --json
   ```
   Parse FEATURE_DIR and AVAILABLE_DOCS.

2. **Load Design Documents**
   Use `read_file` for each available document:
   - Always: plan.md (tech stack, structure)
   - If exists: data-model.md (entities)
   - If exists: contracts/ (API endpoints)
   - If exists: research.md (decisions)
   - If exists: quickstart.md (test scenarios)

3. **Generate Task List**
   Load `.kilocode/templates/tasks-template.md` with `read_file`
   
   Create tasks based on available documents:
   - Setup tasks (T001-T003): Project initialization
   - Test tasks [P] (T004-T007): TDD tests that must fail first
   - Core tasks (T008-T014): Implementation
   - Integration tasks (T015-T018): System connections
   - Polish tasks [P] (T019-T023): Final improvements

4. **Apply Task Rules**
   - Mark [P] for parallel tasks (different files)
   - No [P] for sequential tasks (same file)
   - Tests MUST come before implementation
   - Number sequentially (T001, T002, etc.)

5. **Create Tasks Document**
   Use `write_to_file` to create FEATURE_DIR/tasks.md:
   - Include all numbered tasks
   - Show dependencies
   - Add parallel execution examples

6. **Create Kilocode Tasks**
   For integration with Kilocode's task system:
   ```bash
   execute_command: echo "# Feature Tasks" >> .kilocode/rules/memory-bank/tasks.md
   execute_command: echo "- [ ] Feature: $BRANCH" >> .kilocode/rules/memory-bank/tasks.md
   ```

7. **Report Success**
   Output:
   - Tasks created at FEATURE_DIR/tasks.md
   - Task count and categories
   - Ready for implementation

## Usage:
Type `/tasks.md` after completing the plan phase.
```

## 2. Scripts (.kilocode/scripts/)

### create-new-feature.sh
```bash
#!/usr/bin/env bash
# Create a new feature with branch, directory structure, and template
# Adapted for Kilocode paths

set -e

JSON_MODE=false
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) echo "Usage: $0 [--json] <feature_description>"; exit 0 ;;
        *) ARGS+=("$arg") ;;
    esac
done

FEATURE_DESCRIPTION="${ARGS[*]}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] <feature_description>" >&2
    exit 1
fi

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
SPECS_DIR="$REPO_ROOT/specs"

# Create specs directory if it doesn't exist
mkdir -p "$SPECS_DIR"

# Find the highest numbered feature directory
HIGHEST=0
if [ -d "$SPECS_DIR" ]; then
    for dir in "$SPECS_DIR"/*; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            number=$(echo "$dirname" | grep -o '^[0-9]\+' || echo "0")
            number=$((10#$number))
            if [ "$number" -gt "$HIGHEST" ]; then
                HIGHEST=$number
            fi
        fi
    done
fi

# Generate next feature number with zero padding
NEXT=$((HIGHEST + 1))
FEATURE_NUM=$(printf "%03d" "$NEXT")

# Create branch name from description
BRANCH_NAME=$(echo "$FEATURE_DESCRIPTION" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9]/-/g' | \
    sed 's/-\+/-/g' | \
    sed 's/^-//' | \
    sed 's/-$//')

# Extract 2-3 meaningful words
WORDS=$(echo "$BRANCH_NAME" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//')

# Final branch name
BRANCH_NAME="${FEATURE_NUM}-${WORDS}"

# Create and switch to new branch
git checkout -b "$BRANCH_NAME"

# Create feature directory
FEATURE_DIR="$SPECS_DIR/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

# Copy template if it exists (adjusted path for Kilocode)
TEMPLATE="$REPO_ROOT/.kilocode/templates/spec-template.md"
SPEC_FILE="$FEATURE_DIR/spec.md"

if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$SPEC_FILE"
else
    echo "Warning: Template not found at $TEMPLATE" >&2
    touch "$SPEC_FILE"
fi

if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s"}\n' \
        "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM"
else
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "SPEC_FILE: $SPEC_FILE"
    echo "FEATURE_NUM: $FEATURE_NUM"
fi
```

### common.sh
```bash
#!/usr/bin/env bash
# Common functions for spec-kit scripts in Kilocode

# Get repository root
get_repo_root() {
    git rev-parse --show-toplevel
}

# Get current branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Check if current branch is a feature branch
check_feature_branch() {
    local branch="$1"
    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch"
        echo "Feature branches should be named like: 001-feature-name"
        return 1
    fi
    return 0
}

# Get feature directory path
get_feature_dir() {
    local repo_root="$1"
    local branch="$2"
    echo "$repo_root/specs/$branch"
}

# Get all standard paths for a feature
get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local feature_dir=$(get_feature_dir "$repo_root" "$current_branch")
    
    echo "REPO_ROOT='$repo_root'"
    echo "CURRENT_BRANCH='$current_branch'"
    echo "FEATURE_DIR='$feature_dir'"
    echo "FEATURE_SPEC='$feature_dir/spec.md'"
    echo "IMPL_PLAN='$feature_dir/plan.md'"
    echo "TASKS='$feature_dir/tasks.md'"
    echo "RESEARCH='$feature_dir/research.md'"
    echo "DATA_MODEL='$feature_dir/data-model.md'"
    echo "QUICKSTART='$feature_dir/quickstart.md'"
    echo "CONTRACTS_DIR='$feature_dir/contracts'"
}

# Check if a file exists and report
check_file() {
    local file="$1"
    local description="$2"
    if [[ -f "$file" ]]; then
        echo "  ✓ $description"
        return 0
    else
        echo "  ✗ $description"
        return 1
    fi
}

# Check if a directory exists and has files
check_dir() {
    local dir="$1"
    local description="$2"
    if [[ -d "$dir" ]] && [[ -n "$(ls -A "$dir" 2>/dev/null)" ]]; then
        echo "  ✓ $description"
        return 0
    else
        echo "  ✗ $description"
        return 1
    fi
}
```

## 3. Custom Modes (.kilocode/modes)

```yaml
customModes:
  - slug: spec-writer
    name: 📋 Spec Writer
    description: Creates detailed specifications from requirements
    roleDefinition: |
      You are a product specification expert following spec-driven development.
      You focus on WHAT needs to be built, not HOW.
      You identify ambiguities and mark them clearly.
      You write for business stakeholders, not developers.
    whenToUse: Creating or refining feature specifications
    customInstructions: |
      - Always use the spec-template.md structure
      - Mark ambiguities with [NEEDS CLARIFICATION]
      - Focus on user stories and acceptance criteria
      - No implementation details (no tech stack, APIs, code)
    groups:
      - read
      - - edit
        - fileRegex: specs/.*\.md$
          description: Only edit specification files
      - command

  - slug: tech-planner
    name: 🏗️ Tech Planner
    description: Creates technical plans from specifications
    roleDefinition: |
      You are a senior architect who transforms specifications into technical plans.
      You follow constitutional principles strictly.
      You make pragmatic technology choices.
      You document all decisions with rationale.
    whenToUse: Creating implementation plans from specifications
    customInstructions: |
      - Read constitution from memory bank
      - Ensure TDD approach (tests first)
      - Follow library-first architecture
      - Document all NEEDS CLARIFICATION resolutions
    groups:
      - read
      - - edit
        - fileRegex: (specs|plans)/.*\.md$
          description: Edit specs and plans
      - command

  - slug: task-generator
    name: ✅ Task Generator
    description: Breaks down plans into executable tasks
    roleDefinition: |
      You are a project manager who creates detailed, actionable tasks.
      You understand dependencies and parallel execution.
      You follow TDD principles strictly.
    whenToUse: Creating task lists from technical plans
    customInstructions: |
      - Number tasks sequentially (T001, T002...)
      - Mark parallel tasks with [P]
      - Tests MUST come before implementation
      - Include exact file paths
    groups:
      - read
      - - edit
        - fileRegex: (specs|tasks)/.*\.md$
          description: Edit specs and task files
      - command
```

## 4. Rules (.kilocode/rules/)

### spec-driven.md
```markdown
# Spec-Driven Development Rules

## Core Principles
1. **Specification First**: No code without a specification
2. **Plan Before Implementation**: Technical plan required after spec
3. **Tasks Before Coding**: Break down plan into tasks
4. **Test-Driven Development**: Tests must be written and fail first

## File Organization
- All specifications in `specs/[number]-[name]/`
- Feature numbers are sequential (001, 002, 003...)
- Each feature has its own Git branch
- Branch names: `[number]-[feature-name]`

## Workflow Enforcement
1. `/specify.md` creates spec and branch
2. `/plan.md` creates technical plan and artifacts
3. `/tasks.md` generates task list
4. Implementation follows task list

## Quality Gates
- Specifications must have user stories
- Plans must pass constitution check
- Tasks must specify file paths
- Tests must fail before implementation

## Documentation Standards
- Use Markdown for all documentation
- Mark uncertainties with [NEEDS CLARIFICATION]
- Include acceptance criteria for all features
- Document all technical decisions with rationale
```

### memory-bank/constitution.md
```markdown
# Project Constitution

## Core Principles

### I. Library-First Architecture
- Every feature starts as a standalone library
- Libraries must be self-contained and independently testable
- Each library exposes a CLI interface
- Clear purpose required - no organizational-only libraries

### II. Test-First Development (NON-NEGOTIABLE)
- TDD mandatory: Tests written → Tests fail → Then implement
- Red-Green-Refactor cycle strictly enforced
- Test order: Contract → Integration → E2E → Unit
- Real dependencies used (actual DBs, not mocks)

### III. Simplicity
- Maximum 3 projects per feature
- Use frameworks directly (no wrapper classes)
- Single data model (no DTOs unless needed)
- YAGNI principle enforced

### IV. Observability
- Structured logging required
- Error context must be sufficient
- Performance metrics tracked

### V. Versioning
- MAJOR.MINOR.BUILD format
- BUILD increments on every change
- Breaking changes require migration plan

## Governance
- Constitution supersedes all other practices
- Amendments require documentation and approval
- All PRs must verify constitutional compliance

**Version**: 1.0.0 | **Ratified**: 2024-01-01
```

### memory-bank/active-features.md
```markdown
# Active Features

Track all features currently in development.

| Feature # | Name | Branch | Status | Created |
|-----------|------|--------|--------|---------|
| 001 | User Authentication | 001-user-auth | In Progress | 2024-01-15 |
| 002 | Dashboard | 002-dashboard | Planning | 2024-01-20 |

## Feature States
- **Specification**: Writing spec
- **Planning**: Creating technical plan
- **Tasks**: Breaking down into tasks
- **In Progress**: Implementation ongoing
- **Testing**: Implementation complete, testing
- **Complete**: Merged to main
```

### memory-bank/tasks.md
```markdown
# Project Tasks

Integration with Kilocode's task management system.

## Active Tasks

### Feature: 001-user-auth
- [x] T001: Create project structure
- [x] T002: Initialize dependencies
- [ ] T003: Configure linting
- [ ] T004: Contract test POST /api/users
- [ ] T005: Contract test GET /api/users/{id}

### Feature: 002-dashboard
- [ ] Specification complete
- [ ] Technical plan approved
- [ ] Task breakdown ready

## Task Guidelines
- Tasks marked [P] can run in parallel
- Tests must fail before implementation
- Each task should take 2-8 hours
- Update status after completion
```

## 5. Templates (Keep existing templates from spec-kit)

The templates remain the same as provided in your upload:
- `spec-template.md`
- `plan-template.md`
- `tasks-template.md`
- `agent-file-template.md`

## Usage Instructions

### Initial Setup

1. **Create the directory structure**:
```bash
mkdir -p .kilocode/{workflows,scripts,templates,rules/memory-bank,modes}
mkdir -p specs
```

2. **Copy all files to their locations**:
- Place workflows in `.kilocode/workflows/`
- Place scripts in `.kilocode/scripts/` and make executable
- Place templates in `.kilocode/templates/`
- Place constitution in `.kilocode/rules/memory-bank/`
- Configure custom modes in `.kilocode/modes`

3. **Initialize Git if needed**:
```bash
git init
git add .
git commit -m "Initial spec-kit setup for Kilocode"
```

### Using Spec-Kit in Kilocode

1. **Start a new feature**:
```
/specify.md Create a user authentication system with email/password login
```

2. **Plan the implementation**:
```
/plan.md Using Python FastAPI with PostgreSQL database and pytest for testing
```

3. **Generate tasks**:
```
/tasks.md
```

4. **Switch modes for implementation**:
```
@spec-implementer
Now implement task T001
```

### Key Differences from Original Spec-Kit

1. **Workflows instead of commands**: Uses Kilocode's `/workflow.md` syntax
2. **Memory Bank integration**: Constitution and tracking in `.kilocode/rules/memory-bank/`
3. **Custom Modes**: Specialized modes for each phase
4. **Kilocode Tools**: Uses `execute_command`, `read_file`, `write_to_file`
5. **Task Integration**: Connects with Kilocode's task management

### Advanced Features

1. **Parallel Task Execution**: Tasks marked [P] can be given to multiple Kilocode instances
2. **Mode Switching**: Automatic mode recommendations based on phase
3. **Memory Persistence**: All decisions tracked in memory bank
4. **Git Integration**: Automatic branch management
5. **Progress Tracking**: Visual progress in tasks.md

## Troubleshooting

### Common Issues

1. **Scripts not executing**: Ensure scripts have execute permissions:
```bash
chmod +x .kilocode/scripts/*.sh
```

2. **Paths not found**: All scripts use absolute paths from repo root

3. **Template not loading**: Check `.kilocode/templates/` directory exists

4. **Branch creation fails**: Ensure you're in a Git repository

5. **Mode not switching**: Reload VS Code window after adding custom modes

This implementation fully leverages Kilocode's native features while maintaining the spec-driven development workflow from GitHub's spec-kit.
