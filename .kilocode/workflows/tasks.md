# Generate Tasks Workflow

Break down the plan into executable tasks.
This is the third step in the Spec-Driven Development lifecycle.

## Execution Steps:

1. **Check Prerequisites**
   ```bash
   execute_command: bash .kilocode/scripts/check-task-prerequisites.sh --json
   ```
   Parse FEATURE_DIR and AVAILABLE_DOCS list.
   If no plan.md exists, ERROR: "No implementation plan found. Run /plan.md first"

2. **Load Design Documents**
   
   **Required:**
   ```
   read_file: $FEATURE_DIR/plan.md
   ```
   Extract: tech stack, project structure, libraries
   
   **Conditional (if in AVAILABLE_DOCS):**
   ```
   read_file: $FEATURE_DIR/data-model.md
   list_files: $FEATURE_DIR/contracts/
   read_file: $FEATURE_DIR/research.md
   read_file: $FEATURE_DIR/quickstart.md
   ```

3. **Load Task Template**
   ```
   read_file: .kilocode/templates/tasks-template.md
   ```

4. **Generate Task List**
   
   Create specific tasks based on what was found:
   
   **Setup Tasks (T001-T003):**
   - Project structure creation
   - Dependency installation  
   - Linting/formatting setup
   
   **Test Tasks [P] (T004-T00X):**
   - One per contract file found
   - One per user story from spec
   - Mark with [P] for parallel execution
   - Tests MUST fail first (TDD)
   
   **Core Tasks (T00X-T0XX):**
   - One per entity in data-model
   - One per service/library
   - One per API endpoint
   - CLI interfaces for libraries
   
   **Integration Tasks (T0XX-T0XX):**
   - Database connections
   - Middleware setup
   - Logging configuration
   
   **Polish Tasks [P] (T0XX-T0XX):**
   - Unit tests
   - Performance testing
   - Documentation updates

5. **Check Task Specificity**
   
   For each generated task, verify it includes:
   - Exact file path to create/modify
   - Specific function/class names
   - Clear acceptance criteria
   
   If any task is too vague:
   ```
   ask_followup_question: "Task T[number] needs more specificity. What should the [specific aspect] include?"
   ```
   
   Example vague task that triggers followup:
   - "Create user model" → Ask: "What fields should the User model include?"
   - "Add validation" → Ask: "What validation rules are needed?"

6. **Apply Task Rules**
   - Mark [P] for tasks in different files (can run parallel)
   - No [P] for tasks in same file (must be sequential)
   - Tests MUST come before implementation
   - Number sequentially (T001, T002, etc.)
   - Include exact file paths

7. **Create Tasks Document**
   ```
   write_to_file: $FEATURE_DIR/tasks.md
   ```
   
   Include:
   - Feature name from plan
   - All numbered tasks with checkboxes
   - Dependency notes
   - Parallel execution examples
   - Specific file paths for each task

8. **Update Context in Memory Bank**
   ```
   write_to_file: .kilocode/rules/memory-bank/context.md
   ```
   
   Update the context with:
   - Current phase: "Tasks generated"
   - Task count: Total number of tasks
   - Next steps: "Begin with T001 in @spec-implementer mode"
   
   Note: Do NOT update memory-bank/tasks.md (that's for repetitive workflows only)

9. **Report Success**
   
   Output summary:
   ```
   ✅ Tasks created at: specs/[branch]/tasks.md
   
   Task Breakdown:
   - Setup: T001-T003 (3 tasks)
   - Tests: T004-T007 (4 tasks) [P] - Write these first!
   - Core: T008-T014 (7 tasks)
   - Integration: T015-T018 (4 tasks)
   - Polish: T019-T023 (5 tasks) [P]
   
   Total: 23 tasks (9 can run in parallel)
   
   Next Steps:
   1. Review tasks.md for completeness
   2. Switch to @spec-implementer mode
   3. Start with T001 (project setup)
   4. Then T004-T007 (tests - must fail first!)
   5. Then T008+ (implementation)
   
   Remember: Tests before implementation (TDD)
   ```

## Tool Usage Summary

This workflow uses Kilocode tools effectively:
- **execute_command**: Run prerequisite checks
- **read_file**: Load templates and documents
- **list_files**: Check contracts directory
- **write_to_file**: Create tasks.md and update context
- **ask_followup_question**: Clarify vague requirements

## Error Handling

- Missing plan.md → ERROR and stop
- Vague tasks → Use ask_followup_question
- Missing optional docs → Continue with what's available
- Conflicting info → Plan.md is source of truth

## Usage
```
/tasks.md
```

No additional arguments needed - reads from existing plan and design docs.