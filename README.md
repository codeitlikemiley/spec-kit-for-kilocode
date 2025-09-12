# Spec-Kit for Kilocode - Native Implementation

## Overview
This is a complete port of GitHub's spec-kit to work natively within Kilocode, leveraging Kilocode's workflows, custom modes, rules, and memory bank features.

## Directory Structure

```
project/
├── .kilocode/
│   ├── workflows/           # Spec-driven workflows (replaces .claude/commands)
│   │   ├── specify.md
│   │   ├── plan.md
│   │   └── tasks.md
│   ├── modes               # Custom modes for each phase
│   ├── rules/
│   │   ├── spec-driven.md  # Core spec-driven rules
│   │   └── memory-bank/    # Project memory (replaces .specify/memory)
│   │       ├── constitution.md
│   │       └── constitution-update-checklist.md
│   ├── scripts/            # Support scripts (adapted for Kilocode)
│   │   ├── common.sh
│   │   ├── create-new-feature.sh
│   │   ├── setup-plan.sh
│   │   ├── check-task-prerequisites.sh
│   │   ├── get-feature-paths.sh
│   │   └── update-agent-context.sh
│   └── templates/          # Document templates
│       ├── spec-template.md
│       ├── plan-template.md
│       ├── tasks-template.md
│       └── agent-file-template.md
└── specs/                  # Feature specifications
    └── [001-feature-name]/
        ├── spec.md
        ├── plan.md
        ├── tasks.md
        ├── research.md
        ├── data-model.md
        ├── quickstart.md
        └── contracts/
```


### Using Spec-Kit in Kilocode

1. **Start a new feature**:
```
/specify Create a user authentication system with email/password login
```

2. **Plan the implementation**:
```
/plan Using Python FastAPI with PostgreSQL database and pytest for testing
```

3. **Generate tasks**:
```
/tasks
```

4. **Switch modes for implementation**:
```
@spec-implementer
Now implement task T001
```

### Key Differences from Original Spec-Kit

1. **Workflows instead of commands**: Uses Kilocode's `/workflow.md` syntax
2. **Memory Bank integration**: Constitution and tracking in `.kilocode/rules/memory-bank/`
3. **Custom Modes**: Specialized modes for each phase
4. **Kilocode Tools**: Uses `execute_command`, `read_file`, `write_to_file`
5. **Task Integration**: Connects with Kilocode's task management

### Advanced Features

1. **Parallel Task Execution**: Tasks marked [P] can be given to multiple Kilocode instances
2. **Mode Switching**: Automatic mode recommendations based on phase
3. **Memory Persistence**: All decisions tracked in memory bank
4. **Git Integration**: Automatic branch management
5. **Progress Tracking**: Visual progress in tasks.md

## Troubleshooting

### Make Scripts Executable

1. **Scripts not executing**: Ensure scripts have execute permissions:
```bash
chmod +x .kilocode/scripts/*.sh
```

