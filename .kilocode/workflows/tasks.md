# Generate Tasks Workflow

Break down the plan into executable tasks.
This is the third step in the Spec-Driven Development lifecycle.

## What This Creates:
- `tasks.md` - Numbered task list with dependencies

## Prerequisites:
- Must be on a feature branch (001-feature-name)
- `plan.md` must exist (created by /plan.md)
- Optional but helpful: research.md, data-model.md, contracts/, quickstart.md

## Execution Steps:

1. **Check Prerequisites**
   ```bash
   execute_command: bash .kilocode/scripts/check-task-prerequisites.sh --json
   ```
   Parse FEATURE_DIR and AVAILABLE_DOCS list.

2. **Load Design Documents**
   Use `read_file` for each available document:
   - **Required**: `$FEATURE_DIR/plan.md` (tech stack, structure)
   - **If exists**: `$FEATURE_DIR/data-model.md` (entities)
   - **If exists**: `$FEATURE_DIR/contracts/` files (API endpoints)
   - **If exists**: `$FEATURE_DIR/research.md` (technical decisions)
   - **If exists**: `$FEATURE_DIR/quickstart.md` (test scenarios)

3. **Load Task Template**
   ```
   read_file: .kilocode/templates/tasks-template.md
   ```

4. **Generate Task List**
   Create tasks based on available documents:
   
   **Setup Tasks (T001-T003)**:
   - Project structure creation
   - Dependency installation
   - Linting/formatting setup
   
   **Test Tasks [P] (T004-T007)**:
   - One task per contract file found
   - One task per user story from spec
   - Mark with [P] for parallel execution
   - Tests MUST fail first (TDD)
   
   **Core Implementation (T008-T014)**:
   - One task per entity in data-model
   - One task per service/module
   - One task per API endpoint
   - CLI commands if applicable
   
   **Integration Tasks (T015-T018)**:
   - Database connections
   - Middleware setup
   - Logging configuration
   - Security headers
   
   **Polish Tasks [P] (T019-T023)**:
   - Unit tests
   - Performance testing
   - Documentation updates
   - Code cleanup

5. **Apply Task Rules**
   - Mark [P] for tasks in different files (can run parallel)
   - No [P] for tasks in same file (must be sequential)
   - Tests MUST come before implementation
   - Number sequentially (T001, T002, T003...)
   - Include exact file paths

6. **Create Tasks Document**
   ```
   write_to_file: $FEATURE_DIR/tasks.md
   ```
   Include:
   - Feature name from plan
   - All numbered tasks with checkboxes
   - Dependency notes
   - Parallel execution examples
   - File paths for each task

7. **Update Memory Bank (High-Level Only)**
   Update feature status in memory bank:
   ```bash
   # Check if feature exists in memory bank
   execute_command: grep -q "$BRANCH" .kilocode/rules/memory-bank/tasks.md || echo "- [ ] $BRANCH - Tasks ready for implementation (see specs/$BRANCH/tasks.md)" >> .kilocode/rules/memory-bank/tasks.md
   
   # If it exists, update its status
   execute_command: sed -i "s/.*$BRANCH.*/- [ ] $BRANCH - Tasks ready for implementation (see specs\/$BRANCH\/tasks.md)/" .kilocode/rules/memory-bank/tasks.md
   ```

8. **Update Memory Bank Status**
   ```bash
   execute_command: sed -i "s/| $BRANCH | Planning |/| $BRANCH | Tasks Ready |/" .kilocode/rules/memory-bank/active-features.md
   ```

9. **Report Success**
   Output:
   - Tasks created at: `specs/[001-feature-name]/tasks.md`
   - Total task count
   - Parallel tasks identified
   - Next step: Switch to `@spec-implementer` mode and begin T001

## Usage:
Type `/tasks.md` after completing the plan phase.

## Example:
```
/tasks.md
```
(No additional arguments needed - reads from existing plan and design docs)

## Output Structure:
```
specs/
└── 001-user-auth/
    ├── spec.md          # Already exists
    ├── plan.md          # Already exists
    ├── research.md      # Already exists
    ├── data-model.md    # Already exists
    ├── quickstart.md    # Already exists
    ├── contracts/       # Already exists
    │   └── api.yaml
    └── tasks.md         # Created by this workflow
```

## Sample Tasks Output:
```markdown
# Tasks: User Authentication

## Phase 3.1: Setup
- [ ] T001: Create project structure per implementation plan
- [ ] T002: Initialize Python project with FastAPI dependencies
- [ ] T003 [P]: Configure pytest and ruff

## Phase 3.2: Tests First (TDD)
- [ ] T004 [P]: Contract test POST /api/auth/register
- [ ] T005 [P]: Contract test POST /api/auth/login
- [ ] T006 [P]: Integration test user registration flow
- [ ] T007 [P]: Integration test login with JWT

## Phase 3.3: Core Implementation
- [ ] T008 [P]: User model in src/models/user.py
- [ ] T009 [P]: AuthService in src/services/auth.py
- [ ] T010: POST /api/auth/register endpoint
- [ ] T011: POST /api/auth/login endpoint

...
```

Note: After this workflow, switch to `@spec-implementer` mode to begin implementation.