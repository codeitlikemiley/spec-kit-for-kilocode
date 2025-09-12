# Spec-Orchestrate Workflow

Orchestrate the complete spec-driven development lifecycle using Kilocode's Orchestrator mode.

## What This Does:
Manages all four phases (Specify, Plan, Tasks, Implement) as coordinated subtasks.

## Usage:
```
/spec-orchestrate.md Create a user authentication system with email/password
```

## Execution Steps:

1. **Parse Feature Request**
   Extract feature description from user input.
   Use `ask_followup_question` if needed for:
   - Technical preferences (language, framework)
   - Deployment target
   - Scale requirements

2. **Create Specification Subtask**
   ```
   new_task:
     description: "Create specification for: $FEATURE_DESCRIPTION"
     mode: spec-writer
     initial_message: |
       Create a feature specification for: $FEATURE_DESCRIPTION
       Run the /specify.md workflow to:
       1. Create feature branch (001-feature-name)
       2. Generate spec.md with user stories and requirements
       3. Return summary with branch name and key requirements
   ```
   
   Wait for subtask completion and extract:
   - Branch name
   - Feature number
   - Key requirements

3. **Create Planning Subtask**
   ```
   new_task:
     description: "Create technical plan for feature $FEATURE_NUMBER"
     mode: tech-planner
     initial_message: |
       Create technical implementation plan.
       Context from specification:
       - Branch: $BRANCH_NAME
       - Requirements: $REQUIREMENTS_SUMMARY
       Tech stack: $TECH_PREFERENCES
       
       Run the /plan.md workflow to:
       1. Create plan.md with technical decisions
       2. Generate research.md, data-model.md, contracts/
       3. Return summary with architecture and tech choices
   ```
   
   Wait for subtask completion and extract:
   - Technology stack
   - Architecture decisions
   - Created artifacts

4. **Create Task Generation Subtask**
   ```
   new_task:
     description: "Generate implementation tasks"
     mode: task-generator
     initial_message: |
       Generate implementation tasks from plan.
       Context:
       - Tech stack: $TECH_STACK
       - Architecture: $ARCHITECTURE
       
       Run the /tasks.md workflow to:
       1. Create tasks.md with numbered tasks
       2. Identify parallel execution opportunities
       3. Return summary with task counts and categories
   ```
   
   Wait for subtask completion and extract:
   - Total task count
   - Task categories
   - Parallel tasks

5. **Create Implementation Subtasks**
   Based on task categories, create multiple implementation subtasks:
   
   ```
   new_task:
     description: "Implement setup and structure (T001-T003)"
     mode: spec-implementer
     initial_message: |
       Implement project setup tasks:
       - T001: Create project structure
       - T002: Initialize dependencies
       - T003: Configure linting/formatting
       
       Follow TDD principles. Update task checkboxes as completed.
   ```
   
   ```
   new_task:
     description: "Implement tests (T004-T007)"
     mode: spec-implementer
     initial_message: |
       Implement test tasks following TDD:
       - T004-T007: Contract and integration tests
       
       Tests must fail first (Red phase).
       Update task checkboxes as completed.
   ```
   
   ```
   new_task:
     description: "Implement core features (T008-T014)"
     mode: spec-implementer
     initial_message: |
       Implement core functionality:
       - T008-T014: Models, services, endpoints
       
       Make tests pass (Green phase).
       Update task checkboxes as completed.
   ```

6. **Update Progress Tracking**
   After each subtask completes:
   ```bash
   execute_command: sed -i "s/.*$BRANCH_NAME.*/- [ ] $BRANCH_NAME - Phase complete/" .kilocode/rules/memory-bank/tasks.md
   ```

7. **Final Summary**
   Compile results from all subtasks:
   - Feature branch created
   - Specification documented
   - Technical plan created
   - Tasks generated
   - Implementation progress
   
   Output final status and next steps.

## Context Passing Strategy:

- **To Specification**: Only feature description
- **To Planning**: Requirements summary + tech preferences
- **To Tasks**: Tech stack + architecture decisions
- **To Implementation**: Specific task numbers + TDD requirements

## Error Handling:

If any subtask fails:
1. Capture error details
2. Determine if blocking
3. Offer to retry or adjust approach
4. Update memory bank with status

## Notes:

- Each subtask runs in isolation with its own context
- Only summaries return to the orchestrator
- Subtasks can be approved automatically via settings
- Implementation can be parallelized for efficiency