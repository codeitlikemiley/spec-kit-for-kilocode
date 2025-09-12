# Plan Feature Workflow (v2.1 - Pure Native Tools)

Create technical implementation plan using Kilocode's always-available native tools.
Direct tool usage without bash script intermediaries.

## Usage:
```
/plan Using Python FastAPI with PostgreSQL database and pytest for testing
```

## Execution Steps:

1. **Get Current Branch**
   ```
   execute_command: git rev-parse --abbrev-ref HEAD
   ```
   Parse output to get branch name (e.g., "001-user-auth")

2. **Verify Specification Exists**
   ```
   read_file: specs/001-user-auth/spec.md
   ```
   If not found, error: "Run /specify first"

3. **Extract Requirements**
   From spec.md, identify:
   - Functional requirements → Implementation tasks
   - Acceptance scenarios → Test tasks
   - Key entities → Model tasks
   - Edge cases → Integration test tasks

4. **Load Constitution**
   ```
   read_file: .kilocode/memory-bank/constitution.md
   ```
   Check project principles and constraints.

5. **Parse Technology Choices**
   From user input, extract:
   - Language: Python 3.11
   - Framework: FastAPI
   - Database: PostgreSQL
   - Testing: pytest
   
   If unclear:
   ```
   ask_followup_question: "Which testing framework do you prefer? (pytest, unittest, nose2)"
   ```

6. **Generate Technical Plan**
   ```
   write_to_file: specs/001-user-auth/plan.md
   content: |
     # Implementation Plan: User Authentication
     
     **Branch**: `001-user-auth` | **Date**: 2024-01-20
     
     ## Summary
     User authentication system with email/password login using JWT tokens.
     
     ## Technical Context
     **Language/Version**: Python 3.11
     **Framework**: FastAPI 0.104
     **Database**: PostgreSQL 15
     **Testing**: pytest 7.4
     **Authentication**: PyJWT + bcrypt
     
     ## Constitution Check
     - [x] Test-first development (TDD)
     - [x] Task numbering (T001-T499)
     - [x] Native tool usage
     - [x] Maximum 3 projects (backend only)
     
     ## Architecture
     
     ### Component Structure
     ```
     src/
     ├── models/
     │   └── user.py          # T201
     ├── services/
     │   └── auth_service.py  # T202
     ├── api/
     │   └── auth.py          # T203-T204
     └── middleware/
         └── auth.py          # T302
     
     tests/
     ├── contract/
     │   └── test_auth.py     # T101-T102
     └── integration/
         └── test_flow.py     # T103-T104
     ```
     
     ## Task Generation Strategy
     - Each endpoint → Contract test (T101+)
     - Each entity → Model task (T201+)
     - Each service → Implementation task (T202+)
     - Each integration → Integration task (T301+)
     
     ## Dependencies
     - FastAPI==0.104.1
     - SQLAlchemy==2.0.23
     - bcrypt==4.1.2
     - PyJWT==2.8.0
     - pytest==7.4.3
   ```

7. **Create Research Document**
   ```
   write_to_file: specs/001-user-auth/research.md
   content: |
     # Technical Research: User Authentication
     
     ## Authentication Method Decision
     **Choice**: JWT tokens
     **Rationale**: Stateless, scalable, standard
     **Alternatives considered**: Sessions (stateful), OAuth2 (complex)
     
     ## Password Hashing
     **Choice**: bcrypt
     **Rationale**: Industry standard, salt included
     **Alternatives considered**: Argon2 (newer), PBKDF2 (older)
     
     ## Database Schema
     **Choice**: UUID primary keys
     **Rationale**: Distributed friendly, secure
     **Alternatives considered**: Auto-increment (predictable)
   ```

8. **Create Data Model**
   ```
   write_to_file: specs/001-user-auth/data-model.md
   content: |
     # Data Model: User Authentication
     
     ## Entities
     
     ### User
     - id: UUID (primary key)
     - email: String (unique, indexed)
     - password_hash: String
     - is_active: Boolean (default: true)
     - created_at: DateTime
     - updated_at: DateTime
     
     ### Session (optional, for refresh tokens)
     - id: UUID
     - user_id: UUID (foreign key)
     - refresh_token: String (indexed)
     - expires_at: DateTime
     - created_at: DateTime
     
     ## Relationships
     - User 1:N Sessions
     
     ## Validation Rules
     - Email: RFC 5322 compliant
     - Password: Min 8 chars, 1 upper, 1 lower, 1 digit
     - Token expiry: 15 minutes (access), 7 days (refresh)
   ```

9. **Create API Contracts**
   ```
   execute_command: mkdir -p specs/001-user-auth/contracts
   ```
   
   ```
   write_to_file: specs/001-user-auth/contracts/auth-api.yaml
   content: |
     openapi: 3.0.0
     info:
       title: Authentication API
       version: 1.0.0
     
     paths:
       /api/auth/register:
         post:
           summary: Register new user
           requestBody:
             required: true
             content:
               application/json:
                 schema:
                   type: object
                   required: [email, password]
                   properties:
                     email:
                       type: string
                       format: email
                     password:
                       type: string
                       minLength: 8
           responses:
             201:
               description: User created
               content:
                 application/json:
                   schema:
                     type: object
                     properties:
                       id:
                         type: string
                       email:
                         type: string
       
       /api/auth/login:
         post:
           summary: Login user
           requestBody:
             required: true
             content:
               application/json:
                 schema:
                   type: object
                   required: [email, password]
                   properties:
                     email:
                       type: string
                     password:
                       type: string
           responses:
             200:
               description: Login successful
               content:
                 application/json:
                   schema:
                     type: object
                     properties:
                       access_token:
                         type: string
                       refresh_token:
                         type: string
                       token_type:
                         type: string
                         default: Bearer
   ```

10. **Create Quickstart Guide**
    ```
    write_to_file: specs/001-user-auth/quickstart.md
    content: |
      # Quickstart: User Authentication
      
      ## Setup
      ```bash
      # Install dependencies
      pip install -r requirements.txt
      
      # Setup database
      docker-compose up -d postgres
      alembic upgrade head
      
      # Run tests (should fail initially)
      pytest tests/
      ```
      
      ## Test Scenarios
      
      ### 1. User Registration
      ```bash
      curl -X POST http://localhost:8000/api/auth/register \
        -H "Content-Type: application/json" \
        -d '{"email": "user@example.com", "password": "SecurePass123"}'
      ```
      
      ### 2. User Login
      ```bash
      curl -X POST http://localhost:8000/api/auth/login \
        -H "Content-Type: application/json" \
        -d '{"email": "user@example.com", "password": "SecurePass123"}'
      ```
      
      ## Validation
      - [ ] Registration creates user in database
      - [ ] Login returns valid JWT token
      - [ ] Invalid credentials rejected
      - [ ] Token validates correctly
    ```

11. **Check for Makefile**
    ```
    read_file: Makefile
    ```
    
    If exists, extract build commands and update plan.

12. **Update Memory Bank**
    ```
    write_to_file: .kilocode/memory-bank/tech.md
    content: |
      # Technology Stack
      
      ## Current Stack
      - Language: Python 3.11
      - Framework: FastAPI 0.104
      - Database: PostgreSQL 15
      - Testing: pytest 7.4
      - Auth: JWT + bcrypt
      
      ## Build Commands
      - Test: pytest tests/ -v
      - Run: uvicorn src.main:app --reload
      - Lint: ruff check src/ tests/
      - Format: black src/ tests/
    ```
    
    ```
    write_to_file: .kilocode/memory-bank/context.md
    content: |
      # Current Context
      
      ## Active Work
      - Feature: User Authentication
      - Branch: 001-user-auth
      - Phase: Planning complete
      - Next: Run /tasks to generate task breakdown
      
      ## Technical Decisions
      - JWT for authentication
      - bcrypt for password hashing
      - PostgreSQL for persistence
      - FastAPI for REST API
      
      ## Created Artifacts
      - Technical plan: specs/001-user-auth/plan.md
      - Data model: specs/001-user-auth/data-model.md
      - API contracts: specs/001-user-auth/contracts/
      - Quickstart: specs/001-user-auth/quickstart.md
    ```

13. **Document Planning Pattern**
    ```
    add_task: Planning FastAPI authentication features
    ```

14. **Create Next Steps Task**
    ```
    new_task:
      title: "Generate Task Breakdown"
      description: |
        Run /tasks to create numbered task list:
        - T001-T099: Setup tasks
        - T100-T199: Test tasks
        - T200-T299: Implementation
        - T300-T399: Integration
        - T400-T499: Polish
      tags: ["feature-001", "tasks", "next"]
    ```

15. **Commit Plan**
    ```
    execute_command: git add specs/001-user-auth/
    execute_command: git add .kilocode/memory-bank/
    execute_command: git commit -m "📋 Plan: User Authentication technical design"
    ```

16. **Report Success**
    ```
    ✅ Technical plan created!
    
    📁 Artifacts Created:
    - Plan: specs/001-user-auth/plan.md
    - Research: specs/001-user-auth/research.md
    - Data Model: specs/001-user-auth/data-model.md
    - Contracts: specs/001-user-auth/contracts/auth-api.yaml
    - Quickstart: specs/001-user-auth/quickstart.md
    
    Tech Stack Confirmed:
    - Language: Python 3.11
    - Framework: FastAPI
    - Database: PostgreSQL
    - Testing: pytest
    
    Constitution Check: ✅ All principles followed
    
    Memory Bank Updated:
    - Tech stack documented
    - Context updated
    - Planning pattern saved
    
    Next Steps:
    1. Review plan and design documents
    2. Run: /tasks
    3. This will generate T001-T499 numbered tasks
    ```

## Native Tools Used:
- `execute_command` - Git operations, directory creation
- `read_file` - Load spec, constitution, check Makefile
- `write_to_file` - Create all plan documents
- `ask_followup_question` - Clarify tech choices
- `new_task` - Create next steps task
- `add_task` - Document planning pattern

## Benefits:
- No bash scripts needed
- Direct file operations
- Native error handling
- Clean execution flow
- Better Kilocode integration