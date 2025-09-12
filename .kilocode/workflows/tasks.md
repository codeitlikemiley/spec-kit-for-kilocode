# Tasks Workflow

Generate numbered task breakdown using Kilocode's native task tracking system.
Creates tasks with native checkbox format: `- [ ] T001 - Task description`

## Usage:
```
/tasks
```

## Native Kilocode Tools Used:

### Core Task Management
- **`update_todo_list`**: Create and manage task lists with checkboxes
- **`ask_followup_question`**: Get user clarification on requirements
- **Native checkboxes**: `- [ ] T001` format for task tracking

### File Operations
- **`read_file`**: Read specification and design documents
- **`write_to_file`**: Generate task files and documentation
- **`list_files`**: Discover contract and design files

### System Operations
- **`execute_command`**: Git operations and system commands
- **`search_files`**: Find patterns in codebase
- **`list_code_definition_names`**: Analyze code structure

## Execution Steps:

1. **Get Current Branch**
   ```
   execute_command: git rev-parse --abbrev-ref HEAD
   ```
   Parse to get branch (e.g., "003-axum-server")

2. **Verify Plan Exists**
   ```
   read_file: specs/003-axum-server/plan.md
   ```
   If not found, error: "Run /plan first"

3. **Load All Design Documents**
   ```
   read_file: specs/003-axum-server/spec.md
   read_file: specs/003-axum-server/plan.md
   read_file: specs/003-axum-server/data-model.md
   list_files: specs/003-axum-server/contracts/
   ```

   For each contract file:
   ```
   read_file: specs/003-axum-server/contracts/api-contracts.yaml
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

5. **Generate Numbered Task List with Native Checkboxes**
   ```
   update_todo_list: Create main task list with Kilocode native format
   content: |
     # Implementation Tasks: Axum Dual-Protocol Server

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
     - [ ] T002 - Initialize Rust project with Cargo ← T001 → T003
     - [ ] T003 - [P] Add Axum, Tonic, and core dependencies ← T002 → T010
     - [ ] T004 - [P] Configure testing with cargo test ← T002 → T011-T020
     - [ ] T005 - [P] Setup in-memory storage for development ← T002 → T031
     - [ ] T006 - [P] Configure JWT authentication ← T002 → T031
     - [ ] T007 - [P] Setup environment configuration ← T002
     - [ ] T008 - [P] Configure logging with tracing ← T002 → T036
     - [ ] T009 - [P] Setup code formatting and linting ← T002
     - [ ] T010 - Create main application entry point ← T003 → T011

     ## Phase 3.2: Tests First (T011-T020) ⚠️ MUST FAIL FIRST
     **PHASE GATE: ALL tests (T011-T020) must complete before ANY implementation (T021+)**

     - [ ] T011 - [P] Write contract test for user creation ← T004, T010 → T025
     - [ ] T012 - [P] Write contract test for user retrieval ← T004, T010 → T026
     - [ ] T013 - [P] Write integration test for user registration flow ← T004 → T021-T030
     - [ ] T014 - [P] Write integration test for user login flow ← T004 → T021-T030
     - [ ] T015 - [P] Write test for password validation ← T004 → T027
     - [ ] T016 - [P] Write test for email validation ← T004 → T029
     - [ ] T017 - [P] Write test for JWT token generation ← T004 → T028
     - [ ] T018 - [P] Write test for JWT token validation ← T004 → T028
     - [ ] T019 - Write test for authentication middleware ← T004 → T035
     - [ ] T020 - Verify all tests fail (Red phase gate) ← T011-T019 → T021

     ## Phase 3.3: Core Implementation (T021-T030)
     **PHASE GATE: Can only start after T020 (all tests failing)**

     - [ ] T021 - [P] Create User model with validation ← T020 → T023, T031
     - [ ] T022 - [P] Create AuthToken model with expiration ← T020 → T024
     - [ ] T023 - Implement UserService with CRUD operations ← T021 → T025, T026
     - [ ] T024 - Implement AuthService with login/logout ← T022 → T025, T026, T028
     - [ ] T025 - Build HTTP user CRUD endpoints ← T011, T023, T024 → T032
     - [ ] T026 - Build HTTP authentication endpoints ← T012, T023, T024 → T032
     - [ ] T027 - Implement password hashing with bcrypt ← T015 → T025
     - [ ] T028 - Implement JWT token generation ← T017, T018, T024 → T033
     - [ ] T029 - Add input validation with Serde ← T016 → T025, T026
     - [ ] T030 - Make all tests pass (Green phase gate) ← T021-T029 → T031

     ## Phase 3.4: Integration (T031-T036)
     - [ ] T031 - Create gRPC protobuf definitions ← T005, T006, T021, T030 → T032
     - [ ] T032 - Implement gRPC UserService handlers ← T025, T026, T031 → T039
     - [ ] T033 - Implement gRPC AuthService handlers ← T028 → T034, T035
     - [ ] T034 - Configure concurrent HTTP + gRPC servers ← T033
     - [ ] T035 - Add unified authentication middleware ← T019, T033
     - [ ] T036 - Setup structured error handling ← T008 → T037

     ## Phase 3.5: Polish & Documentation (T037-T044)
     **PHASE GATE: Can only start after T036 (integration complete)**

     - [ ] T037 - Refactor code for clarity (Refactor phase) ← T036 → T042
     - [ ] T038 - [P] Add unit tests for utilities ← T036
     - [ ] T039 - [P] Performance optimization ← T032
     - [ ] T040 - [P] Generate API documentation ← T036
     - [ ] T041 - [P] Update README with setup instructions ← T036
     - [ ] T042 - Remove code duplication ← T037
     - [ ] T043 - Add deployment configuration ← T042 → T044
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
   write_to_file: specs/003-axum-server/task-dependencies.md
   content: |
     # Task Dependency Graph

     ## Visual Flow
     ```mermaid
     graph TD
         T001[T001: Project Structure] --> T002[T002: Initialize Rust]
         T002 --> T003[T003: Add Dependencies]
         T002 --> T004[T004: Configure Testing]
         T002 --> T005[T005: Setup Storage]
         T003 --> T010[T010: Main App File]
         T004 --> T011[T011-T019: Write Tests]
         T010 --> T011
         T011 --> T020[T020: Verify Tests Fail]
         T020 --> T021[T021: User Model]
         T020 --> T022[T022: AuthToken Model]
         T021 --> T023[T023: UserService]
         T023 --> T025[T025: HTTP Endpoints]
         T025 --> T032[T032: gRPC Handlers]
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
   write_to_file: specs/003-axum-server/task-assignment.md
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
     Model → Service → HTTP Endpoint → gRPC Handler → Integration
     T021 → T023 → T025 → T032 → T036

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
   write_to_file: specs/003-axum-server/quick-commands.md
   content: |
     # Quick Implementation Commands

     ## Start Tasks
     ```bash
     # T001: Create structure
     mkdir -p src/{models,services,api,grpc} tests/{contract,integration,unit}

     # T002: Initialize project
     cargo init --lib

     # T003-T009: Parallel setup (can run simultaneously)
     cargo add axum tonic tokio serde jsonwebtoken bcrypt &
     cargo add --dev tokio-test &
     echo "DATABASE_URL=sqlite::memory:" > .env &
     cargo add tracing tracing-subscriber &
     ```

     ## Test First Commands
     ```bash
     # T011-T019: Create all test files first
     touch tests/contract/test_{user,auth}_api.rs
     touch tests/integration/test_{registration,login}_flow.rs

     # T020: Run tests to verify they fail
     cargo test  # Should show all failures
     ```

     ## Track Progress
     ```bash
     # Mark task complete using Kilocode native format
     # Use update_todo_list tool to update progress
     ```
   ```

10. **Commit Generated Tasks**

    ```
    execute_command: git add specs/003-axum-server/tasks.md
    execute_command: git add specs/003-axum-server/task-dependencies.md
    execute_command: git add specs/003-axum-server/task-assignment.md
    execute_command: git add specs/003-axum-server/quick-commands.md
    execute_command: git commit -m "📝 Tasks: Generated 44 tasks with Kilocode native format"
    ```

11. **Report Success with Dependency Summary**

    ```
    ✅ Task breakdown complete with Kilocode native integration!

    📋 Tasks Generated: specs/003-axum-server/tasks.md

    ## Summary
    Total: 44 tasks (T001-T044)

    ## Kilocode Native Tools Integration
    - ✅ update_todo_list: Task list management
    - ✅ ask_followup_question: User clarification
    - ✅ Native checkboxes: - [ ] T001 format
    - ✅ read_file/write_to_file: Document processing
    - ✅ execute_command: System operations

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
    1. Review native checkbox format in tasks.md
    2. Check critical path for optimization
    3. Assign parallel tasks to team members
    4. Start with: T001 - Create project structure

    ## Quick Start
    ```bash
    # View tasks with native format
    cat specs/003-axum-server/tasks.md | grep "T0"

    # Start implementation
    @spec-implementer
    # Execute T001
    ```

    Files created:
    - tasks.md (main task list with native checkboxes)
    - task-dependencies.md (visual graph)
    - task-assignment.md (team distribution)
    - quick-commands.md (implementation helpers)