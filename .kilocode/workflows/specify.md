# Specify Feature Workflow

Start a new feature by creating a specification and feature branch.
This is the first step in the Spec-Driven Development lifecycle.

## What This Creates:
- New Git branch: `[001-feature-name]`
- New directory: `specs/[001-feature-name]/`
- Initial file: `spec.md` (specification only)

## Execution Steps:

1. **Parse Feature Description**
   Use `ask_followup_question` if the feature description needs clarification:
   - What is the main goal?
   - Who are the target users?
   - What are the success criteria?

2. **Create Feature Branch**
   Execute the feature creation script:
   ```bash
   execute_command: bash .kilocode/scripts/create-new-feature.sh --json "$ARGUMENTS"
   ```
   Parse the JSON output for BRANCH_NAME and SPEC_FILE.

3. **Load Specification Template**
   Use `read_file` to load `.kilocode/templates/spec-template.md`

4. **Generate Specification**
   Write the specification to SPEC_FILE using `write_to_file`:
   - Replace placeholders with concrete details from feature description
   - Mark any ambiguities with [NEEDS CLARIFICATION]
   - Focus on WHAT not HOW
   - No technical implementation details

5. **Update Memory Bank**
   Add feature to `.kilocode/rules/memory-bank/active-features.md`:
   ```bash
   execute_command: echo "| $FEATURE_NUM | $FEATURE_NAME | $BRANCH_NAME | Specification | $(date +%Y-%m-%d) |" >> .kilocode/rules/memory-bank/active-features.md
   ```

6. **Report Success**
   Output:
   - Branch created: `[001-feature-name]`
   - Spec created at: `specs/[001-feature-name]/spec.md`
   - Next step: Run `/plan.md` to create technical plan

## Usage:
Type `/specify.md` followed by your feature description.

## Example:
```
/specify.md Create a user authentication system with email/password login
```

## Output Structure:
```
specs/
└── 001-user-auth/
    └── spec.md    # Only this file created by /specify.md
```

Note: Other files (plan.md, research.md, etc.) are created by subsequent workflows.