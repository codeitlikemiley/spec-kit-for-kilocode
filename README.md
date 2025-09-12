# Spec-Kit for Kilocode - Native Integration

A powerful specification-driven development (SDD) framework that fully leverages Kilocode's native task management, memory bank, and workflow features for structured software development.

## 🎯 What is Spec-Kit?

Spec-Kit enforces a disciplined approach to software development through four phases:
1. **Specify** - Clear requirements and user stories before any code
2. **Plan** - Technical architecture and design decisions documented
3. **Tasks** - Break down into executable, trackable tasks
4. **Implement** - Follow TDD principles with native task tracking

## ✨ Spec Kit for Kilo Code

### Full Native Kilocode Integration
- ✅ **Native Task Checkboxes**: `- [ ]` for tracking progress
- ✅ **Memory Bank Commands**: Automatic context updates
- ✅ **Subtask Creation**: Complex tasks using `new_task` tool
- ✅ **Pattern Documentation**: Save workflows with `add task`
- ✅ **Makefile Integration**: Extract build info automatically
- ✅ **5 Custom Modes**: Specialized modes for each phase

## 📁 File Structure

```
your-project/
├── .kilocode/
│   ├── workflows/                    # Pure native tool workflows
│   │   ├── specify.md               # Feature specification
│   │   ├── plan.md                  # Technical planning
│   │   └── tasks.md                 # Task generation
│   │
│   ├── templates/                   # Optional templates
│   │   ├── spec-template.md        # Specification template
│   │   ├── plan-template.md        # Plan template
│   │   └── tasks-template.md       # Tasks template
│   │
│   ├── memory-bank/                # Kilocode native memory
│   │   ├── constitution.md         # Core principles (required)
│   │   ├── context.md              # Current state (auto-created)
│   │   ├── tasks.md                # Patterns (auto-created via add_task)
│   │   ├── tech.md                 # Tech stack (auto-created)
│   │   ├── product.md              # Features (auto-created)
│   │   └── active-features.md      # Feature tracking (auto-created)
│   │
│   └── .kilocodemodes              # Custom modes (2 essential)
│
├── specs/                           # Feature specifications (auto-created)
│   └── 001-user-auth/              # Example feature
│       ├── spec.md                 # What to build
│       ├── plan.md                 # How to build
│       ├── tasks.md                # T001-T499 checklist
│       ├── research.md             # Decisions
│       ├── data-model.md           # Entities
│       ├── quickstart.md           # Validation
│       └── contracts/              # API specs
│
└── [Your application files...]      # Created during implementation
```

### 📝 What Each Directory Contains
`.kilocode/workflows/`
Pure native tool workflows - no bash script dependencies:

- specify.md - Uses: read_file, write_to_file, execute_command, ask_followup_question
- plan.md - Uses: read_file, write_to_file, list_files, add_task
- tasks.md - Uses: read_file, write_to_file, new_task, add_task

`.kilocode/templates/`
Markdown templates for consistent documentation:

- spec-template.md - User stories, requirements, acceptance criteria
- plan-template.md - Technical decisions, architecture, constitution check
- tasks-template.md - T001-T499 task structure with phases

`.kilocode/scripts/`

- common.sh - Shared functions (optional, can be removed)
- create-new-feature.sh - Complex branch logic (optional, can use execute_command)

## 🚀 Installation

### Manual Install

```bash
git clone https://github.com/codeitlikemiley/spec-kit.git
cd spec-kit
mv README.md spec-kit-README.md
mv * ../
```

## 📚 Core Workflows

### 1. Initialize Memory Bank (First Time Only)
```
initialize memory bank
```
Sets up Kilocode's memory bank structure for your project.

### 2. Create Feature Specification
```
/specify Create a user authentication system with email/password login
```

### 3. Plan Technical Implementation
```
/plan Using Python FastAPI with PostgreSQL database and pytest for testing
```

### 4. Generate Task Breakdown
```
/tasks
```


## 🎭 Custom Modes

Spec-Kit includes 5 specialized Kilocode modes:

### 1. @spec-implementer
**Purpose:** Implement features with native task tracking
```
@spec-implementer
Let's implement the first task from specs/001-user-auth/tasks.md
```
- Uses native checkbox tracking
- Updates memory bank automatically
- Documents patterns with `add task`
- Follows TDD principles


## 🧠 Memory Bank Integration

### Core Commands

#### Initialize Memory Bank
```
initialize memory bank
```
First-time setup for your project.

#### Update Memory Bank
```
update memory bank
```
Updates context after completing milestones.

#### Extract from Makefile
```
update memory bank using information from @/Makefile
```
Pulls build configuration and dependencies.

#### Document Patterns
```
add task: Creating REST API endpoint
```
Saves repetitive workflows for future reuse.


## 📋 Complete Example Workflow

### Building a User Authentication Feature

#### 1. Initialize (First Time Only)
```
initialize memory bank
```

#### 2. Specify the Feature
```
/specify Create user authentication with email/password login and JWT tokens
```
Creates `specs/001-user-auth/spec.md` with user stories.

#### 3. Plan the Implementation
```
/plan Using Python FastAPI with PostgreSQL, bcrypt for passwords, PyJWT for tokens
```
Creates technical plan and design documents.

#### 4. Generate Tasks
```
/tasks
```
Creates `specs/001-user-auth/tasks.md` with checkboxes:
```markdown
- [ ] Setup FastAPI project
- [ ] Write auth tests (must fail)
- [ ] Create User model
- [ ] Implement password hashing
- [ ] Build login endpoint
- [ ] Add JWT generation
```

#### 5. Start Implementation
```
@spec-implementer
Starting with the setup task from specs/001-user-auth/tasks.md
```

#### 8. Update Context
After major milestones:
```
update memory bank
```

## 🐛 Troubleshooting

### Issue: Scripts not executable
**Solution:** Set permissions:
```bash
chmod +x .kilocode/scripts/*.sh
```


## 🔗 Resources

### Kilocode Documentation
- [Task Management](https://kilocode.ai/docs/basic-usage/task-todo-list)
- [Memory Bank](https://kilocode.ai/docs/advanced-usage/memory-bank)
- [Custom Modes](https://kilocode.ai/docs/advanced-usage/custom-modes)
- [Custom Instructions](https://kilocode.ai/docs/advanced-usage/custom-instructions)
- [New Task Tool](https://kilocode.ai/docs/features/tools/new-task)

### Spec-Kit Resources
- [GitHub Repository](https://github.com/github/spec-kit)

