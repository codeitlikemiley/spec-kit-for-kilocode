# Spec-Driven Development Rules

## Core Principles
1. **Specification First**: No code without a specification
2. **Plan Before Implementation**: Technical plan required after spec
3. **Tasks Before Coding**: Break down plan into tasks
4. **Test-Driven Development**: Tests must be written and fail first

## File Organization
- All specifications in `specs/[number]-[name]/`
- Feature numbers are sequential (001, 002, 003...)
- Each feature has its own Git branch
- Branch names: `[number]-[feature-name]`

## Workflow Enforcement
1. `/specify.md` creates spec and branch
2. `/plan.md` creates technical plan and artifacts
3. `/tasks.md` generates task list
4. Implementation follows task list

## Quality Gates
- Specifications must have user stories
- Plans must pass constitution check
- Tasks must specify file paths
- Tests must fail before implementation

## Documentation Standards
- Use Markdown for all documentation
- Mark uncertainties with [NEEDS CLARIFICATION]
- Include acceptance criteria for all features
- Document all technical decisions with rationale