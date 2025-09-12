# Plan Feature Workflow

Create technical implementation plan from specification.
This is the second step in the Spec-Driven Development lifecycle.

## What This Creates:
- `plan.md` - Technical implementation plan
- `research.md` - Technical research and decisions
- `data-model.md` - Entity definitions and relationships
- `quickstart.md` - Quick start guide and test scenarios
- `contracts/` - API contracts and specifications

## Prerequisites:
- Must be on a feature branch (001-feature-name)
- `spec.md` must exist (created by /specify.md)

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

4. **Execute Plan Template - Phase 0 (Research)**
   Create `research.md` using `write_to_file`:
   ```
   write_to_file: $SPECS_DIR/research.md
   ```
   Content includes:
   - Technical decisions
   - Technology choices
   - Architecture patterns
   - Resolved NEEDS CLARIFICATION items

5. **Execute Plan Template - Phase 1 (Design)**
   
   Create `data-model.md`:
   ```
   write_to_file: $SPECS_DIR/data-model.md
   ```
   - Entity definitions
   - Field specifications
   - Relationships
   - Validation rules
   
   Create `contracts/` directory and files:
   ```
   execute_command: mkdir -p $SPECS_DIR/contracts
   write_to_file: $SPECS_DIR/contracts/api.yaml  # or .wit, .json based on tech
   ```
   - API specifications
   - Request/response schemas
   - Error contracts
   
   Create `quickstart.md`:
   ```
   write_to_file: $SPECS_DIR/quickstart.md
   ```
   - Setup instructions
   - Test scenarios
   - Validation steps

6. **Create Implementation Plan**
   Copy template and fill:
   ```
   execute_command: cp .kilocode/templates/plan-template.md $SPECS_DIR/plan.md
   ```
   Then use `write_to_file` to populate with:
   - Technical context
   - Constitution check results
   - Phase descriptions
   - Task generation strategy (describe only, don't create tasks.md)

7. **Update Agent Context**
   ```bash
   execute_command: bash .kilocode/scripts/update-agent-context.sh
   ```

8. **Update Memory Bank Status**
   ```bash
   execute_command: sed -i "s/| $BRANCH | Specification |/| $BRANCH | Planning |/" .kilocode/rules/memory-bank/active-features.md
   ```

9. **Report Success**
   Output:
   - Plan created at: `specs/[001-feature-name]/plan.md`
   - Research documented at: `specs/[001-feature-name]/research.md`
   - Data model at: `specs/[001-feature-name]/data-model.md`
   - Contracts at: `specs/[001-feature-name]/contracts/`
   - Quickstart at: `specs/[001-feature-name]/quickstart.md`
   - Next step: Run `/tasks.md` to generate task list

## Usage:
Type `/plan.md` followed by technical implementation details.

## Example:
```
/plan.md Using Python FastAPI with PostgreSQL database, pytest for testing, targeting Linux deployment
```

## Output Structure:
```
specs/
└── 001-user-auth/
    ├── spec.md          # Already exists
    ├── plan.md          # Created by this workflow
    ├── research.md      # Created by this workflow
    ├── data-model.md    # Created by this workflow
    ├── quickstart.md    # Created by this workflow
    └── contracts/       # Created by this workflow
        └── api.yaml     # API specifications
```

Note: `tasks.md` is created by the next workflow (/tasks.md).