# Project Constitution

## Core Principles

### I. Library-First Architecture
- Every feature starts as a standalone library
- Libraries must be self-contained and independently testable
- Each library exposes a CLI interface
- Clear purpose required - no organizational-only libraries

### II. Test-First Development (NON-NEGOTIABLE)
- TDD mandatory: Tests written → Tests fail → Then implement
- Red-Green-Refactor cycle strictly enforced
- Test order: Contract → Integration → E2E → Unit
- Real dependencies used (actual DBs, not mocks)

### III. Simplicity
- Maximum 3 projects per feature
- Use frameworks directly (no wrapper classes)
- Single data model (no DTOs unless needed)
- YAGNI principle enforced

### IV. Observability
- Structured logging required
- Error context must be sufficient
- Performance metrics tracked

### V. Versioning
- MAJOR.MINOR.BUILD format
- BUILD increments on every change
- Breaking changes require migration plan

## Governance
- Constitution supersedes all other practices
- Amendments require documentation and approval
- All PRs must verify constitutional compliance

**Version**: 1.0.0 | **Ratified**: 2024-01-01