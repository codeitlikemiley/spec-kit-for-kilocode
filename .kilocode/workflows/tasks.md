# Tasks Workflow (v2.1 - Pure Native Tools)

Generate numbered task breakdown using Kilocode's always-available native tools.
Creates tasks in format: `- [ ] T001 - Task description` with no script dependencies.

## Usage:
```
/tasks
```

## Execution Steps:

1. **Get Current Branch**
   ```
   execute_command: git rev-parse --abbrev-ref HEAD
   ```
   Parse to get branch (e.g., "001-user-auth")

2. **Verify Plan Exists**
   ```
   read_file: specs/001-user-auth/plan.md
   ```
   If not found, error: "Run /plan first"

3. **Load All Design Documents**
   ```
   read_file: specs/001-user-auth/spec.md
   read_file: specs/001-user-auth/plan.md
   read_file: specs/001-user-auth/data-model.md
   list_files: specs/001-user-auth/contracts/
   ```
   
   For each contract file:
   ```
   read_file: specs/001-user-auth/contracts/auth-api.yaml
   ```

4. **Extract Information for Task Generation**
   From plan.md:
   - Tech stack (language, framework, database)
   - Component structure
   - Dependencies
   
   From data-model.md:
   - Entities → Model tasks (T201+)
   - Validation rules → Test tasks (T101+)
   
   From contracts:
   - Endpoints → Contract test tasks (T101+)
   - Endpoints → Implementation tasks (T203+)
   
   From spec.md:
   - Acceptance scenarios → Integration tests (T103+)
   - Requirements → Implementation tasks (T200+)

5. **Generate Numbered Task List**
   ```
   write_to_file: specs/001-user-auth/tasks.md
   content: |
     # Implementation Tasks: User Authentication
     
     **Total Tasks**: 26 | **Parallel Possible**: 11 tasks
     **Estimated Time**: 3-5 days with parallel execution
     
     ## Phase 3.1: Setup (T001-T010)
     - [ ] T001 - Create project structure per plan.md
     - [ ] T002 - Initialize Python project with poetry/pip
     - [ ] T003 - [P] Install FastAPI and core dependencies
     - [ ] T004 - [P] Configure pytest and testing structure
     - [ ] T005 - [P] Setup PostgreSQL with Docker Compose
     - [ ] T006 - [P] Configure SQLAlchemy and Alembic
     - [ ] T007 - [P] Setup environment variables (.env)
     - [ ] T008 - [P] Configure logging with structlog
     - [ ] T009 - [P] Setup linting (ruff) and formatting (black)
     - [ ] T010 - Create main FastAPI application file
     
     ## Phase 3.2: Tests First (T101-T110) ⚠️ MUST FAIL FIRST
     - [ ] T101 - [P] Write contract test for POST /api/auth/register
     - [ ] T102 - [P] Write contract test for POST /api/auth/login
     - [ ] T103 - [P] Write integration test for registration flow
     - [ ] T104 - [P] Write integration test for login flow
     - [ ] T105 - [P] Write test for password validation
     - [ ] T106 - [P] Write test for email validation
     - [ ] T107 - [P] Write test for JWT token generation
     - [ ] T108 - [P] Write test for JWT token validation
     - [ ] T109 - Write test for rate limiting
     - [ ] T110 - Verify all tests fail (Red phase confirmation)
     
     ## Phase 3.3: Core Implementation (T201-T210)
     - [ ] T201 - [P] Create User model (src/models/user.py)
     - [ ] T202 - [P] Create Session model (src/models/session.py)
     - [ ] T203 - Implement UserService (src/services/user_service.py)
     - [ ] T204 - Implement AuthService (src/services/auth_service.py)
     - [ ] T205 - Build POST /api/auth/register endpoint
     - [ ] T206 - Build POST /api/auth/login endpoint
     - [ ] T207 - Implement password hashing with bcrypt
     - [ ] T208 - Implement JWT token generation
     - [ ] T209 - Add input validation with Pydantic
     - [ ] T210 - Make all tests pass (Green phase)
     
     ## Phase 3.4: Integration (T301-T306)
     - [ ] T301 - Create database migrations with Alembic
     - [ ] T302 - Connect services to PostgreSQL
     - [ ] T303 - Implement authentication middleware
     - [ ] T304 - Configure CORS and security headers
     - [ ] T305 - Add rate limiting middleware
     - [ ] T306 - Setup structured error handling
     
     ## Phase 3.5: Polish & Documentation (T401-T408)
     - [ ] T401 - Refactor code for clarity (Refactor phase)
     - [ ] T402 - [P] Add unit tests for utilities
     - [ ] T403 - [P] Performance optimization (<200ms response)
     - [ ] T404 - [P] Generate API documentation (OpenAPI)
     - [ ] T405 - [P] Update README with setup instructions
     - [ ] T406 - Remove code duplication
     - [ ] T407 - Add deployment configuration (Docker)
     - [ ] T408 - Run quickstart validation
     
     ## Task Dependencies
     
     ### Critical Path
     ```
     T001 → T002 → T010 → T110 → T210 → T306 → T408
     ```
     
     ### Blocking Relationships
     - T001 must complete before all others
     - T101-T110 must complete before T201-T210 (TDD)
     - T201-T202 must complete before T203-T204
     - T203-T204 must complete before T205-T206
     - T301 must complete before T302
     - T303 must complete before T304-T305
     - All implementation before T401-T408
     
     ## Parallel Execution Groups
     
     ### Group A: Setup Tasks (5 parallel)
     Can run simultaneously: T003, T004, T005, T006, T007, T008, T009
     
     ### Group B: Test Writing (8 parallel)
     Can run simultaneously: T101-T108
     
     ### Group C: Models (2 parallel)
     Can run simultaneously: T201, T202
     
     ### Group D: Documentation (4 parallel)
     Can run simultaneously: T402, T403, T404, T405
     
     ## Task Legend
     - **[P]** = Can run in parallel (modifies different files)
     - **T001-T099** = Setup and configuration
     - **T100-T199** = Test tasks (must fail first)
     - **T200-T299** = Core implementation
     - **T300-T399** = Integration and middleware
     - **T400-T499** = Polish and documentation
     
     ## Progress Tracking
     - [ ] Phase 3.1: Setup (0/10 tasks)
     - [ ] Phase 3.2: Tests (0/10 tasks)
     - [ ] Phase 3.3: Implementation (0/10 tasks)
     - [ ] Phase 3.4: Integration (0/6 tasks)
     - [ ] Phase 3.5: Polish (0/8 tasks)
     
     **Overall**: 0/44 tasks complete (0%)
   ```

6. **Create Complex Task Subtasks**
   For tasks needing breakdown:
   ```
   new_task:
     title: "T204 - Implement AuthService"
     description: |
       Complete authentication service implementation:
       - T204.1 - User registration logic
       - T204.2 - Login validation
       - T204.3 - Token generation
       - T204.4 - Token refresh logic
       - T204.5 - Logout handling
     tags: ["feature-001", "implementation", "T204", "backend"]
   ```
   
   ```
   new_task:
     title: "T303 - Authentication Middleware"
     description: |
       Implement FastAPI authentication middleware:
       - T303.1 - JWT token extraction from headers
       - T303.2 - Token validation
       - T303.3 - User context injection
       - T303.4 - Protected route decorator
     tags: ["feature-001", "integration", "T303", "middleware"]
   ```

7. **Document Task Patterns**
   ```
   add_task: Creating T100-series test tasks for FastAPI
   ```
   
   This saves the pattern:
   ```
   write_to_file: .kilocode/memory-bank/tasks.md
   content: |
     ## Creating T100-series Test Tasks for FastAPI
     
     **Files to Create:**
     - tests/contract/test_[endpoint].py
     - tests/integration/test_[flow].py
     
     **Task Pattern:**
     - T101-T110: Contract tests (one per endpoint)
     - T111-T120: Integration tests (user flows)
     - T121-T130: Unit tests (validators, utils)
     
     **Important:**
     - All tests must fail first (TDD)
     - Use pytest fixtures for setup
     - Mock external services only
     - Test actual database operations
   ```

8. **Create Task Checklist Summary**
   ```
   write_to_file: specs/001-user-auth/task-summary.md
   content: |
     # Task Summary: User Authentication
     
     ## Quick Reference
     
     | Phase | Start | End | Count | Parallel | Time |
     |-------|-------|-----|-------|----------|------|
     | Setup | T001 | T010 | 10 | 7 | 2 hrs |
     | Tests | T101 | T110 | 10 | 8 | 3 hrs |
     | Core | T201 | T210 | 10 | 2 | 4 hrs |
     | Integration | T301 | T306 | 6 | 0 | 2 hrs |
     | Polish | T401 | T408 | 8 | 4 | 3 hrs |
     
     ## Critical Tasks
     - T110: Confirm all tests fail
     - T210: Make all tests pass
     - T306: Complete integration
     - T408: Final validation
     
     ## Daily Goals
     - Day 1: T001-T010 (Setup) + T101-T110 (Tests)
     - Day 2: T201-T210 (Implementation)
     - Day 3: T301-T306 (Integration)
     - Day 4: T401-T408 (Polish)
   ```

9. **Update Memory Bank**
   ```
   write_to_file: .kilocode/memory-bank/context.md
   content: |
     # Current Context
     
     ## Active Work
     - Feature: User Authentication
     - Branch: 001-user-auth
     - Phase: Tasks generated
     - Total Tasks: 44 (T001-T408)
     - Next: Start with T001
     
     ## Task Breakdown
     - Setup: T001-T010 (10 tasks)
     - Tests: T101-T110 (10 tasks)
     - Implementation: T201-T210 (10 tasks)
     - Integration: T301-T306 (6 tasks)
     - Polish: T401-T408 (8 tasks)
     
     ## Parallel Opportunities
     - 21 tasks can run in parallel
     - Estimated 40% time reduction
     
     ## Critical Path
     T001 → T110 → T210 → T306 → T408
     
     ## Next Actions
     1. Start with T001 - Create project structure
     2. Complete setup phase (T001-T010)
     3. Write all tests (T101-T110) before implementation
   ```

10. **Create Implementation Start Task**
    ```
    new_task:
      title: "Start Implementation - T001"
      description: |
        Begin feature implementation:
        1. Create project structure (T001)
        2. Use: @spec-implementer mode
        3. Follow TDD strictly
        4. Update checkboxes as tasks complete
      tags: ["feature-001", "start", "implementation"]
    ```

11. **Commit Tasks**
    ```
    execute_command: git add specs/001-user-auth/tasks.md
    execute_command: git add specs/001-user-auth/task-summary.md
    execute_command: git add .kilocode/memory-bank/
    execute_command: git commit -m "📝 Tasks: Generated 44 tasks (T001-T408)"
    ```

12. **Report Success**
    ```
    ✅ Task breakdown complete!
    
    📋 Tasks Generated: specs/001-user-auth/tasks.md
    
    ## Summary
    Total: 44 tasks (T001-T408)
    
    By Phase:
    - Setup: T001-T010 (10 tasks) - 7 parallel
    - Tests: T101-T110 (10 tasks) - 8 parallel ⚠️
    - Core: T201-T210 (10 tasks) - 2 parallel
    - Integration: T301-T306 (6 tasks) - sequential
    - Polish: T401-T408 (8 tasks) - 4 parallel
    
    Parallel Execution: 21/44 tasks (48%)
    Estimated Time: 3-4 days (vs 5-7 sequential)
    
    ## ⚠️ TDD Reminder
    1. Start with T101-T110 (tests MUST fail)
    2. Then T201-T210 (make tests pass)
    3. Finally T401 (refactor with green tests)
    
    ## Next Steps
    1. Review tasks.md for completeness
    2. Switch to implementation mode:
       @spec-implementer
    3. Start with: T001 - Create project structure
    4. Mark complete: - [x] T001 - Create project structure ✅
    
    ## Quick Start
    To begin implementation immediately:
    1. Check out tasks: read_file: specs/001-user-auth/tasks.md
    2. Start with T001
    3. Commit after each task completion
    ```

## Native Tools Used:
- `execute_command` - Git operations
- `read_file` - Load all design documents
- `write_to_file` - Create task list and summary
- `list_files` - Check contracts directory
- `new_task` - Create subtasks for complex items
- `add_task` - Document task patterns

## Benefits of Native Approach:
- No bash scripts needed
- Direct file operations
- Better error handling
- Cleaner workflow
- Full Kilocode integration
- Automatic tool availability

## Task Tracking:
Update tasks by reading, modifying, and writing back:
```
content = read_file: specs/001-user-auth/tasks.md
updated = content.replace("- [ ] T001", "- [x] T001")
write_to_file: specs/001-user-auth/tasks.md
content: updated
```