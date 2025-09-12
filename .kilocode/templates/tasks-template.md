# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)

```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. Generate tasks by category:
   → Setup: project init, dependencies, linting
   → Tests: contract tests, integration tests
   → Core: models, services, CLI commands
   → Integration: DB, middleware, logging
   → Polish: unit tests, performance, docs
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph with arrows
7. Create parallel execution examples
8. Validate task completeness:
   → All contracts have tests?
   → All entities have models?
   → All endpoints implemented?
9. Return: SUCCESS (tasks ready for execution)
```

## Task Format Legend
- **T001**: Task ID (sequential numbering)
- **[P]**: Can run in parallel with other [P] tasks in same phase
- **←**: Depends on (must wait for these tasks)
- **→**: Blocks (these tasks wait for this one)
- **File path**: Exact location for changes

## Path Conventions
- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

## Phase 3.1: Setup (T001-T003)
- [ ] T001 - Create project structure per implementation plan → ALL
- [ ] T002 - Initialize [language] project with [framework] dependencies ← T001
- [ ] T003 - [P] Configure linting and formatting tools ← T002

## Phase 3.2: Tests First (T004-T007) ⚠️ MUST FAIL FIRST
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
**Phase Rule: ALL tests (T004-T007) must complete before ANY implementation (T008+)**

- [ ] T004 - [P] Contract test POST /api/users in tests/contract/test_users_post.py ← T003 → T011
- [ ] T005 - [P] Contract test GET /api/users/{id} in tests/contract/test_users_get.py ← T003 → T012
- [ ] T006 - [P] Integration test user registration in tests/integration/test_registration.py ← T003 → T008-T014
- [ ] T007 - [P] Integration test auth flow in tests/integration/test_auth.py ← T003 → T008-T014

## Phase 3.3: Core Implementation (T008-T014)
**Phase Rule: Can only start after ALL tests are written and failing (T004-T007 complete)**

- [ ] T008 - [P] User model in src/models/user.py ← T007 → T009, T015
- [ ] T009 - UserService CRUD in src/services/user_service.py ← T008 → T011, T012
- [ ] T010 - [P] CLI --create-user in src/cli/user_commands.py ← T008
- [ ] T011 - POST /api/users endpoint ← T004, T009 → T015
- [ ] T012 - GET /api/users/{id} endpoint ← T005, T009 → T015
- [ ] T013 - Input validation ← T009 → T014
- [ ] T014 - Error handling and logging ← T013

## Phase 3.4: Integration (T015-T018)
- [ ] T015 - Connect UserService to DB ← T008, T011, T012 → T020
- [ ] T016 - Auth middleware ← T014 → T018
- [ ] T017 - [P] Request/response logging ← T014
- [ ] T018 - CORS and security headers ← T016

## Phase 3.5: Polish (T019-T023)
**Phase Rule: Can only start after integration complete (T018)**

- [ ] T019 - [P] Unit tests for validation in tests/unit/test_validation.py ← T013
- [ ] T020 - Performance tests (<200ms) ← T015
- [ ] T021 - [P] Update docs/api.md ← T018
- [ ] T022 - Remove duplication ← T018
- [ ] T023 - Run manual-testing.md ← T022

## 🔴 Critical Path
Tasks that must be done sequentially (longest dependency chain):
```
T001 → T002 → T003 → T007 → T008 → T009 → T011 → T015 → T020 → T023
```
**Minimum time**: Sum of critical path tasks only

## 🟢 Parallel Execution Groups

### Group A: All Tests (after T003)
Can run simultaneously: T004, T005, T006, T007
**Requirement**: T003 complete

### Group B: Models and CLI (after T007)
Can run simultaneously: T008, T010
**Requirement**: All tests written

### Group C: Documentation (after T018)
Can run simultaneously: T019, T021
**Requirement**: Integration complete

## Dependency Summary

### Hard Dependencies (Must Complete First)
- **T001**: Blocks everything (project structure needed)
- **T007**: Last test blocks all implementation
- **T008**: User model blocks most services
- **T018**: Last integration blocks all polish tasks

### Phase Gates (TDD Enforcement)
1. **Test Gate**: T004-T007 MUST complete before T008-T014
2. **Integration Gate**: T015-T018 MUST complete before T019-T023

### Task Dependency Quick Reference
| Task | Wait For | Unlocks | Parallel? |
|------|----------|---------|-----------|
| T001 | None | T002 | No |
| T002 | T001 | T003 | No |
| T003 | T002 | T004-T007 | Yes |
| T004-T007 | T003 | T008 | Yes (group) |
| T008 | T007 | T009, T010, T015 | Yes (with T010) |
| T009 | T008 | T011, T012 | No |
| T011 | T004, T009 | T015 | No |
| T015 | T008, T011, T012 | T020 | No |

## Implementation Notes
- **[P] tasks** = Different files, no shared dependencies
- **Red Phase**: Verify ALL tests fail before implementing
- **Green Phase**: Implement minimum code to pass tests
- **Refactor Phase**: Only after tests pass (T022)
- **Commit Rule**: After each task completion

## Task Generation Rules
*Applied during main() execution*

1. **From Contracts**:
   - Each contract file → contract test task [P]
   - Each endpoint → implementation task (depends on test)
   
2. **From Data Model**:
   - Each entity → model creation task [P]
   - Relationships → service layer tasks (sequential)
   
3. **From User Stories**:
   - Each story → integration test [P]
   - Quickstart scenarios → validation tasks

4. **Dependency Assignment**:
   - Tests depend on setup completion
   - Models depend on tests completion
   - Services depend on models
   - Endpoints depend on services + contract tests
   - Integration depends on endpoints
   - Polish depends on integration

## Validation Checklist
*GATE: Checked by main() before returning*

- [ ] All contracts have corresponding tests
- [ ] All entities have model tasks
- [ ] All tests come before implementation
- [ ] Dependencies clearly marked with ← →
- [ ] Critical path identified
- [ ] Parallel groups documented
- [ ] Each task specifies exact file path
- [ ] No [P] task modifies same file as another [P] task
- [ ] Phase gates enforce TDD
