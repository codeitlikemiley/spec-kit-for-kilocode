# Tasks Workflow

Generate numbered task breakdown with clear dependency arrows using Kilocode's native tools.
Creates tasks with dependency notation: `- [ ] T001 - Task description ← T000 → T002`

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
   - Entities → Model tasks
   - Validation rules → Test tasks
   
   From contracts:
   - Endpoints → Contract test tasks
   - Endpoints → Implementation tasks
   
   From spec.md:
   - Acceptance scenarios → Integration tests
   - Requirements → Implementation tasks

5. **Generate Numbered Task List with Dependencies**
   ```
   write_to_file: specs/001-user-auth/tasks.md
   content: |
     # Implementation Tasks: User Authentication
     
     **Total Tasks**: 44 | **Parallel Possible**: 21 tasks
     **Estimated Time**: 3-5 days with parallel execution
     
     ## Task Format Legend
     - **T001**: Task ID (sequential)
     - **[P]**: Can run in parallel with other [P] tasks
     - **←**: Depends on (must wait for these)
     - **→**: Blocks (these tasks wait for this)
     - **File path**: Exact location for changes
     
     ## Phase 3.1: Setup (T001-T010)
     - [ ] T001 - Create project structure per plan.md → ALL
     - [ ] T002 - Initialize Python project with poetry/pip ← T001 → T003
     - [ ] T003 - [P] Install FastAPI and core dependencies ← T002 → T010
     - [ ] T004 - [P] Configure pytest and testing structure ← T002 → T011-T020
     - [ ] T005 - [P] Setup PostgreSQL with Docker Compose ← T002 → T031
     - [ ] T006 - [P] Configure SQLAlchemy and Alembic ← T002 → T031
     - [ ] T007 - [P] Setup environment variables (.env) ← T002
     - [ ] T008 - [P] Configure logging with structlog ← T002 → T036
     - [ ] T009 - [P] Setup linting (ruff) and formatting (black) ← T002
     - [ ] T010 - Create main FastAPI application file ← T003 → T011
     
     ## Phase 3.2: Tests First (T011-T020) ⚠️ MUST FAIL FIRST
     **PHASE GATE: ALL tests (T011-T020) must complete before ANY implementation (T021+)**
     
     - [ ] T011 - [P] Write contract test for POST /api/auth/register ← T004, T010 → T025
     - [ ] T012 - [P] Write contract test for POST /api/auth/login ← T004, T010 → T026
     - [ ] T013 - [P] Write integration test for registration flow ← T004 → T021-T030
     - [ ] T014 - [P] Write integration test for login flow ← T004 → T021-T030
     - [ ] T015 - [P] Write test for password validation ← T004 → T027
     - [ ] T016 - [P] Write test for email validation ← T004 → T029
     - [ ] T017 - [P] Write test for JWT token generation ← T004 → T028
     - [ ] T018 - [P] Write test for JWT token validation ← T004 → T028
     - [ ] T019 - Write test for rate limiting ← T004 → T035
     - [ ] T020 - Verify all tests fail (Red phase gate) ← T011-T019 → T021
     
     ## Phase 3.3: Core Implementation (T021-T030)
     **PHASE GATE: Can only start after T020 (all tests failing)**
     
     - [ ] T021 - [P] Create User model (src/models/user.py) ← T020 → T023, T031
     - [ ] T022 - [P] Create Session model (src/models/session.py) ← T020 → T024
     - [ ] T023 - Implement UserService (src/services/user_service.py) ← T021 → T025, T026
     - [ ] T024 - Implement AuthService (src/services/auth_service.py) ← T022 → T025, T026, T028
     - [ ] T025 - Build POST /api/auth/register endpoint ← T011, T023, T024 → T032
     - [ ] T026 - Build POST /api/auth/login endpoint ← T012, T023, T024 → T032
     - [ ] T027 - Implement password hashing with bcrypt ← T015 → T025
     - [ ] T028 - Implement JWT token generation ← T017, T018, T024 → T033
     - [ ] T029 - Add input validation with Pydantic ← T016 → T025, T026
     - [ ] T030 - Make all tests pass (Green phase gate) ← T021-T029 → T031
     
     ## Phase 3.4: Integration (T031-T036)
     - [ ] T031 - Create database migrations with Alembic ← T005, T006, T021, T030 → T032
     - [ ] T032 - Connect services to PostgreSQL ← T025, T026, T031 → T039
     - [ ] T033 - Implement authentication middleware ← T028 → T034, T035
     - [ ] T034 - Configure CORS and security headers ← T033
     - [ ] T035 - Add rate limiting middleware ← T019, T033
     - [ ] T036 - Setup structured error handling ← T008 → T037
     
     ## Phase 3.5: Polish & Documentation (T037-T044)
     **PHASE GATE: Can only start after T036 (integration complete)**
     
     - [ ] T037 - Refactor code for clarity (Refactor phase) ← T036 → T042
     - [ ] T038 - [P] Add unit tests for utilities ← T036
     - [ ] T039 - [P] Performance optimization (<200ms response) ← T032
     - [ ] T040 - [P] Generate API documentation (OpenAPI) ← T036
     - [ ] T041 - [P] Update README with setup instructions ← T036
     - [ ] T042 - Remove code duplication ← T037
     - [ ] T043 - Add deployment configuration (Docker) ← T042 → T044
     - [ ] T044 - Run quickstart validation ← T043
     
     ## 🔴 Critical Path (Longest Sequential Chain)
     ```
     T001 → T002 → T010 → T020 → T021 → T023 → T025 → T032 → T036 → T037 → T042 → T043 → T044
     ```
     **13 sequential tasks** = Minimum completion time
     
     ## 🟢 Parallel Execution Opportunities
     
     ### Group A: Setup Tools (After T002)
     Can run simultaneously: T003, T004, T005, T006, T007, T008, T009
     **Saves**: 6 task times
     
     ### Group B: Test Writing (After T010)
     Can run simultaneously: T011-T019
     **Saves**: 8 task times
     
     ### Group C: Models (After T020)
     Can run simultaneously: T021, T022
     **Saves**: 1 task time
     
     ### Group D: Documentation (After T036)
     Can run simultaneously: T038, T039, T040, T041
     **Saves**: 3 task times
     
     **Total Time Savings**: 18 tasks worth (~45% reduction)
     
     ## 📊 Dependency Quick Reference
     
     | Task | Depends On | Unlocks | Critical? |
     |------|------------|---------|-----------|
     | T001 | - | ALL | ✅ |
     | T002 | T001 | T003-T009 | ✅ |
     | T010 | T003 | T011-T019 | ✅ |
     | T020 | T011-T019 | T021-T022 | ✅ |
     | T021 | T020 | T023, T031 | ✅ |
     | T023 | T021 | T025, T026 | ✅ |
     | T025 | T011, T023, T024 | T032 | ✅ |
     | T030 | T021-T029 | T031 | ⚠️ |
     | T032 | T025, T026, T031 | T039 | ✅ |
     | T036 | T008 | T037-T041 | ✅ |
     | T044 | T043 | COMPLETE | ✅ |
     
     ## ⚠️ Phase Gates (TDD Enforcement)
     
     1. **Test Writing Gate (T020)**
        - Must verify ALL tests fail before proceeding
        - Blocks: All implementation tasks (T021-T030)
        
     2. **Implementation Gate (T030)**
        - Must verify ALL tests pass before proceeding
        - Blocks: Integration tasks (T031-T036)
        
     3. **Integration Gate (T036)**
        - Must complete all integration before polish
        - Blocks: Polish tasks (T037-T044)
     
     ## 📈 Progress Tracking
     - [ ] Phase 3.1: Setup (0/10 tasks)
     - [ ] Phase 3.2: Tests (0/10 tasks) ⚠️ Must fail first
     - [ ] Phase 3.3: Implementation (0/10 tasks)
     - [ ] Phase 3.4: Integration (0/6 tasks)
     - [ ] Phase 3.5: Polish (0/8 tasks)
     
     **Overall**: 0/44 tasks complete (0%)
   ```

6. **Create Dependency Visualization**
   ```
   write_to_file: specs/001-user-auth/task-dependencies.md
   content: |
     # Task Dependency Graph
     
     ## Visual Flow
     ```mermaid
     graph TD
         T001[T001: Project Structure] --> T002[T002: Initialize Python]
         T002 --> T003[T003: Install FastAPI]
         T002 --> T004[T004: Configure pytest]
         T002 --> T005[T005: Setup PostgreSQL]
         T003 --> T010[T010: Main App File]
         T004 --> T011[T011-T019: Write Tests]
         T010 --> T011
         T011 --> T020[T020: Verify Tests Fail]
         T020 --> T021[T021: User Model]
         T020 --> T022[T022: Session Model]
         T021 --> T023[T023: UserService]
         T023 --> T025[T025: Register Endpoint]
         T025 --> T032[T032: Connect to DB]
         T032 --> T036[T036: Error Handling]
         T036 --> T037[T037-T044: Polish]
     ```
     
     ## Bottleneck Analysis
     - **T001**: Blocks everything (100% blocking)
     - **T020**: Test gate (blocks 50% of tasks)
     - **T023**: Service bottleneck (blocks endpoints)
     - **T036**: Polish gate (blocks final 18%)
   ```

7. **Create Task Assignment Matrix**
   ```
   write_to_file: specs/001-user-auth/task-assignment.md
   content: |
     # Task Assignment for Parallel Execution
     
     ## Developer 1 (Critical Path)
     - T001, T002, T010, T020, T021, T023, T025, T032, T036, T037, T042, T043, T044
     
     ## Developer 2 (Testing)
     - T004, T011-T019, T038
     
     ## Developer 3 (Infrastructure)
     - T005, T006, T031, T033-T035
     
     ## Developer 4 (Supporting Features)
     - T003, T007-T009, T022, T024, T026-T029, T039-T041
     
     ## Synchronization Points
     1. After T002: All developers can start
     2. After T020: Wait for test verification
     3. After T030: Integration can begin
     4. After T036: Polish phase starts
   ```

8. **Update Memory Bank with Dependency Info**
   ```
   write_to_file: .kilocode/memory-bank/task-patterns.md
   content: |
     # Task Dependency Patterns
     
     ## Common Dependency Chains
     
     ### Setup Chain
     Project Structure → Initialize → Dependencies → Main File
     T001 → T002 → T003 → T010
     
     ### TDD Chain
     Tests Written → Tests Fail → Implementation → Tests Pass
     T011-T019 → T020 → T021-T029 → T030
     
     ### Service Chain
     Model → Service → Endpoint → Integration
     T021 → T023 → T025 → T032
     
     ## Dependency Notation Guide
     - Use ← for "depends on"
     - Use → for "blocks/unlocks"
     - Mark [P] for parallel-capable
     - Add phase gates between major sections
     
     ## Critical Path Identification
     1. Find T001 (always first)
     2. Follow longest → chain
     3. Include all gate tasks (T020, T030, T036)
     4. End at final validation (T044)
   ```

9. **Generate Implementation Commands**
   ```
   write_to_file: specs/001-user-auth/quick-commands.md
   content: |
     # Quick Implementation Commands
     
     ## Start Tasks
     ```bash
     # T001: Create structure
     mkdir -p src/{models,services,api} tests/{contract,integration,unit}
     
     # T002: Initialize project
     python -m venv venv && source venv/bin/activate
     pip install poetry && poetry init
     
     # T003-T009: Parallel setup (can run simultaneously)
     poetry add fastapi uvicorn[standard] &
     poetry add --dev pytest pytest-asyncio &
     docker-compose up -d postgres &
     poetry add sqlalchemy alembic &
     ```
     
     ## Test First Commands
     ```bash
     # T011-T019: Create all test files first
     touch tests/contract/test_{register,login}.py
     touch tests/integration/test_{registration,login}_flow.py
     
     # T020: Run tests to verify they fail
     pytest -v  # Should show all red/failures
     ```
     
     ## Track Progress
     ```bash
     # Mark task complete
     sed -i 's/\[ \] T001/\[x\] T001/' specs/001-user-auth/tasks.md
     
     # Check remaining tasks
     grep -c "\[ \]" specs/001-user-auth/tasks.md
     ```
   ```

10. **Commit Generated Tasks**

    ```
    execute_command: git add specs/001-user-auth/tasks.md
    execute_command: git add specs/001-user-auth/task-dependencies.md
    execute_command: git add specs/001-user-auth/task-assignment.md
    execute_command: git add specs/001-user-auth/quick-commands.md
    execute_command: git commit -m "📝 Tasks: Generated 44 tasks with dependency arrows"
    ```

11. **Report Success with Dependency Summary**

    ```
    ✅ Task breakdown complete with dependency mapping!
    
    📋 Tasks Generated: specs/001-user-auth/tasks.md
    
    ## Summary
    Total: 44 tasks (T001-T044)
    
    ## Dependency Analysis
    - Critical Path: 13 sequential tasks
    - Parallel Opportunities: 21 tasks (48%)
    - Phase Gates: 3 (T020, T030, T036)
    - Time Savings: ~45% with parallelization
    
    ## Key Dependencies
    🔴 Bottlenecks:
    - T001 → ALL (100% blocking)
    - T020 → T021-T030 (test gate)
    - T023 → T025, T026 (service dependency)
    
    🟢 Parallel Groups:
    - Setup: T003-T009 (7 parallel)
    - Tests: T011-T019 (9 parallel)
    - Docs: T038-T041 (4 parallel)
    
    ## ⚠️ TDD Enforcement
    Phase gates ensure test-first development:
    1. T020: Verify tests fail before implementation
    2. T030: Verify tests pass after implementation
    3. T037: Refactor only with green tests
    
    ## Next Steps
    1. Review dependency arrows in tasks.md
    2. Check critical path for optimization
    3. Assign parallel tasks to team members
    4. Start with: T001 - Create project structure
    
    ## Quick Start
    ```bash
    # View tasks with dependencies
    cat specs/001-user-auth/tasks.md | grep "T0"
    
    # Start implementation
    @spec-implementer
    # Execute T001
    ```
    
    Files created:
    - tasks.md (main task list with ← → notation)
    - task-dependencies.md (visual graph)
    - task-assignment.md (team distribution)
    - quick-commands.md (implementation helpers)
    ```
