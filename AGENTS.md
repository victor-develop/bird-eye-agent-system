# Bird-Eye Agent System - Agent Guidelines

> This is a **documentation/skill repository** for a dual-agent task orchestration framework. No code, no builds, no tests.

## Repository Purpose

This repository defines the **Bird-Eye Agent System** - a dual-agent framework for managing complex development tasks. When installed as an OpenCode skill, agents can use `@treeWork` and `@taskRunner` commands.

**Key**: This is a specification repository. All actual work happens in user projects that USE this system.

## Build/Lint/Test Commands

**None** - This repository contains only Markdown and YAML documentation files.

## System Architecture

```
Human User (Scheduler) → @treeWork (Planning) → @taskRunner (Execution)
                         ↓                   ↓
                     Creates specs        Executes tasks
```

## Agent Roles

### @treeWork Agent
- **Purpose**: Task decomposition, progress tracking, creates task specs
- **Creates**: task directories, readme.md, references.yaml, progress.md
- **Does NOT**: Execute code or modify project files
- **Key Files**: `spec/01-treework-agent.md`, `spec/04-command-reference.md`

### @taskRunner Agent
- **Purpose**: Execute a single specific task
- **Reads**: `readme.md` (task spec) + `references.yaml` (context files)
- **Creates**: `result.md` (execution report)
- **Does NOT**: Plan tasks or manage dependencies
- **Key Files**: `spec/02-taskrunner-agent.md`, `spec/03-file-formats.md`

## Documentation Structure

```
spec/
├── README.md                    # Entry point and overview
├── 01-treework-agent.md         # TreeWork agent specification
├── 02-taskrunner-agent.md       # TaskRunner agent specification
├── 03-file-formats.md           # File format definitions
├── 04-command-reference.md      # Complete command reference
└── 05-workflow-example.md       # End-to-end example workflow
```

## File Format Conventions

### Markdown Files (readme.md, result.md, progress.md)
- **Language**: Chinese descriptions, English code examples
- **Length**: `readme.md` files ≤ 150 lines
- **Progress Trees**: ASCII art in `progress.md` with status markers:
  - `[  ]` - Planned
  - `[..]` - In progress
  - `[ok]` - Completed
  - `[bin]` - Deprecated

### YAML Files (references.yaml)
- **Structure**: List of file references with descriptions
- **Format**:
  ```yaml
  - path: path/to/file
    desc: Brief description
  ```

## Naming Conventions

- **Task Directories**: `task-<major>.<minor>` (e.g., `task-1.1`, `task-1.2.1`)
- **File Naming**:
  - `readme.md` - Task specification (always required)
  - `references.yaml` - Context file list (always required)
  - `result.md` - Execution output (created by TaskRunner)
  - `progress.md` - ASCII task tree (in mission root)

## Code Style Guidelines

### When Working in User Projects
- **Follow**: Existing project conventions (language, framework, style)
- **Don't**: Apply this repo's Chinese documentation style to code
- **Do**: Follow project's existing import/ordering/formatting patterns

### When Modifying This Repository
- **Language**: Chinese for descriptions, English for code/commands
- **Formatting**: Markdown with 2-space list indentation
- **Code Blocks**: Always specify language (```bash, ```yaml, ```markdown)
- **Line Length**: Aim for 80-100 chars per line

## Error Handling

### @treeWork Agent
- Log decisions in `progress.md` when marking tasks `[bin]`
- Record blocking reasons in `readme.md` or `progress.md`
- Confirm changes with user before destructive operations

### @taskRunner Agent
- On failure: Create `result.md` with `失败` (failed) status
- Explain what was attempted and why it failed
- Provide suggestions for next steps
- Never leave incomplete work without a `result.md`

## Task States

1. `[  ]` Planned - No readme.md yet
2. `[..]` In Progress - Has readme.md, ready for TaskRunner
3. `[ok]` Completed - Task and all subtasks done
4. `[bin]` Deprecated - No longer needed

## Important Constraints

### TreeWork Agent
- **Never** read project files unless via `@treeWork read`
- **Never** execute code or modify files outside task directories
- **Always** limit `readme.md` to 150 lines max
- **Always** create `references.yaml` for every task directory

### TaskRunner Agent
- **Must** read `references.yaml` files first (context setup)
- **Should** focus only on what's in `readme.md` (scope control)
- **Must** create `result.md` after execution
- **Should** list all changed files in result.md

## Quick Reference for New Agents

When asked to "work as Bird-Eye":

1. Read all spec files in `spec/` directory
2. Understand your role: `@treeWork` (planning) or `@taskRunner` (execution)
3. Check file formats: `spec/03-file-formats.md`
4. Reference commands: `spec/04-command-reference.md`
5. See example workflow: `spec/05-workflow-example.md`

## Key Design Principles

1. **Separation of Concerns**: TreeWork plans, TaskRunner executes
2. **Human in the Loop**: User makes scheduling decisions
3. **Git Native**: Everything in plain text files, version-controlled
4. **Observability**: Every operation leaves a trace in Markdown/YAML
5. **Context Control**: `references.yaml` prevents context overflow
