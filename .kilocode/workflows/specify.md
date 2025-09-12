# Specify Feature Workflow

Start a new feature using ONLY Kilocode's native tools - zero bash scripts required.

## Usage:
```
/specify Create a user authentication system with email/password login
```

## Execution Steps:

1. **Get Feature Details**
   Store the feature description from user input.
   
   If unclear:
   ```
   ask_followup_question: "What specific features do you need? (e.g., 2FA, password reset, social login)"
   ```

2. **Calculate Next Feature Number**
   Use native tools to find the highest feature number:
   ```
   list_files: specs/
   ```
   
   Parse the output to find directories matching pattern `XXX-*`:
   - If specs/ is empty → Use 001
   - If specs/ has 001-user-auth, 002-dashboard → Use 003
   - Format with zero padding: 001, 002, 003, etc.

3. **Generate Branch Name**
   From feature description "Create user authentication system":
   - Convert to lowercase: "create user authentication system"
   - Replace spaces with hyphens: "create-user-authentication-system"
   - Take first 2-3 meaningful words: "user-authentication"
   - Combine with number: "001-user-authentication"

4. **Create and Switch to Branch**
   ```
   execute_command: git checkout -b 001-user-authentication
   ```
   
   If branch exists (error from git), increment number:
   ```
   execute_command: git checkout -b 001-user-authentication-v2
   ```

5. **Create Feature Directory**
   ```
   execute_command: mkdir -p specs/001-user-authentication
   ```

6. **Load or Create Specification Template**
   First, check if template exists:
   ```
   read_file: .kilocode/templates/spec-template.md
   ```
   
   If template doesn't exist, use default template:
   ```
   DEFAULT_TEMPLATE = """
   # Feature Specification: [FEATURE NAME]
   
   **Feature Branch**: `[BRANCH]`
   **Created**: [DATE]
   **Status**: Draft
   
   ## User Scenarios & Testing
   
   ### Primary User Story
   As a [user type], I want to [action] so that [benefit].
   
   ### Acceptance Scenarios
   1. **Given** [initial state], **When** [action], **Then** [expected outcome]
   2. **Given** [initial state], **When** [action], **Then** [expected outcome]
   
   ### Edge Cases
   - What happens when [boundary condition]?
   - How does system handle [error scenario]?
   
   ## Requirements
   
   ### Functional Requirements
   - **FR-001**: System MUST [specific capability]
   - **FR-002**: System MUST [specific capability]
   
   ### Key Entities
   - **[Entity]**: [Description]
   
   ## Review Checklist
   - [ ] No implementation details
   - [ ] User-focused requirements
   - [ ] Testable acceptance criteria
   - [ ] Clear scope boundaries
   """
   ```

7. **Generate Specification Content**
   Process the template, replacing placeholders:
   - [FEATURE NAME] → User Authentication
   - [BRANCH] → 001-user-authentication
   - [DATE] → Current date
   - Fill in user stories based on description
   - Add specific requirements
   
   ```
   write_to_file: specs/001-user-authentication/spec.md
   content: |
     # Feature Specification: User Authentication
     
     **Feature Branch**: `001-user-authentication`
     **Created**: 2024-01-20
     **Status**: Draft
     
     ## User Scenarios & Testing
     
     ### Primary User Story
     As a user, I want to login with email/password
     so that I can access my account securely.
     
     ### Acceptance Scenarios
     1. **Given** valid credentials, **When** user logs in, **Then** access granted
     2. **Given** invalid credentials, **When** user logs in, **Then** access denied
     3. **Given** no account exists, **When** user registers, **Then** account created
     
     ### Edge Cases
     - What happens when email doesn't exist?
     - How does system handle rate limiting?
     - What if password reset token expires?
     
     ## Requirements
     
     ### Functional Requirements
     - **FR-001**: System MUST validate email format
     - **FR-002**: System MUST hash passwords securely
     - **FR-003**: Users MUST be able to reset passwords
     - **FR-004**: System MUST implement rate limiting
     - **FR-005**: System MUST support session management
     
     ### Key Entities
     - **User**: Email, password hash, created date, status
     - **Session**: User ID, token, expiry, device info
     - **PasswordReset**: User ID, token, expiry, used flag
     
     ## Review Checklist
     - [x] No implementation details
     - [x] User-focused requirements
     - [x] Testable acceptance criteria
     - [x] Clear scope boundaries
   ```

8. **Initialize or Update Memory Bank**
   Check if memory bank exists:
   ```
   list_files: .kilocode/memory-bank/
   ```
   
   If constitution.md doesn't exist, create it:
   ```
   write_to_file: .kilocode/memory-bank/constitution.md
   content: |
     # Project Constitution
     
     ## Core Principles
     - Specification before code
     - Test-driven development (TDD)
     - Task numbering system (T001-T499)
     - Native Kilocode tools only
     - No bash scripts required
     
     ## Task Ranges
     - T001-T099: Setup and configuration
     - T100-T199: Test tasks (must fail first)
     - T200-T299: Core implementation
     - T300-T399: Integration
     - T400-T499: Polish and documentation
     
     ## Governance
     All development follows these principles.
     
     **Version**: 2.2.0 | **Updated**: 2024-01-20
   ```
   
   Create or update active features:
   ```
   read_file: .kilocode/memory-bank/active-features.md
   ```
   
   If exists, append new feature. If not, create:
   ```
   write_to_file: .kilocode/memory-bank/active-features.md
   content: |
     # Active Features
     
     | Feature # | Name | Branch | Status | Created |
     |-----------|------|--------|--------|---------|
     | 001 | User Authentication | 001-user-authentication | Specification | 2024-01-20 |
   ```

9. **Update Context**
   ```
   write_to_file: .kilocode/memory-bank/context.md
   content: |
     # Current Context
     
     ## Active Work
     - Feature: User Authentication
     - Feature #: 001
     - Branch: 001-user-authentication
     - Phase: Specification complete
     - Next: Run /plan to create technical plan
     
     ## Files Created
     - Specification: specs/001-user-authentication/spec.md
     
     ## Next Steps
     1. Review specification for completeness
     2. Run: /plan Using [technology choices]
     3. Example: /plan Using Python FastAPI with PostgreSQL
     
     ## Feature Description
     Original request: Create a user authentication system with email/password login
     
     Last updated: 2024-01-20
   ```

10. **Create Planning Task**
    ```
    new_task:
      title: "Plan User Authentication Implementation"
      description: |
        Feature 001 ready for planning:
        1. Run: /plan Using [technology stack]
        2. Define architecture
        3. Create design documents
        4. Check constitution compliance
      tags: ["feature-001", "planning", "next-step"]
    ```

11. **Document Pattern (if new type)**
    ```
    add_task: Creating authentication feature specifications
    ```

12. **Commit Changes**
    ```
    execute_command: git add specs/001-user-authentication/spec.md
    execute_command: git add .kilocode/memory-bank/
    execute_command: git commit -m "📝 Specify: User Authentication feature (#001)"
    ```

13. **Report Success**
    ```
    ✅ Feature specification created!
    
    📋 Feature Details
    - Number: 001
    - Name: User Authentication
    - Branch: 001-user-authentication
    
    📁 Files Created
    - Specification: specs/001-user-authentication/spec.md
    - Memory Bank: Updated
    
    📊 Specification Summary
    - User Stories: 1 primary
    - Acceptance Scenarios: 3
    - Requirements: 5
    - Key Entities: 3
    
    ✓ Git Operations
    - Branch created and switched
    - Changes committed
    
    📌 Next Steps
    1. Review: specs/001-user-authentication/spec.md
    2. Plan: /plan Using Python FastAPI with PostgreSQL
    3. Tasks: /tasks (after planning)
    
    💡 Quick Plan Command
    /plan Using Python FastAPI with PostgreSQL, pytest for testing
    ```
