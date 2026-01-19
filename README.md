# Bird-Eye Agent System

> **A human-centric task orchestration framework for LLM agents - maintain full control with complete visibility.**

A dual-agent collaboration system that empowers you to manage complex development tasks with unprecedented clarity. **TreeWork** handles planning and tracking, while **TaskRunner** executes specific tasks - with you in full control of the orchestration.

## What is Bird-Eye?

Bird-Eye transforms how you work with AI agents by putting you in the driver's seat. Instead of a single, opaque AI process, you get:

- **Clear task decomposition** with visual dependency trees
- **Precise context control** for every task
- **Full visibility** into progress and decision-making
- **Git-friendly state management** for collaboration and experiments

Inspired by the principle that "filesystem is state machine," Bird-Eye keeps everything transparent, trackable, and recoverable.

## Core Advantages

### 🎯 Global Control View

As the task scheduler, you maintain a bird's-eye view through **ASCII tree diagrams** showing:
- Task dependencies and relationships
- Real-time progress status
- Blockers and bottlenecks
- What comes next at any moment

```
[ok]Task1.1: 需求分析
     │
     ▼
[..]Task1.2: 系统设计
     │
     ├───►[ok]Task1.2.1: 数据库设计
     │
     ├───►[..]Task1.2.2: API 设计
     │
     └───►[  ]Task1.2.3: 前端设计
```

You make intelligent scheduling decisions based on this complete picture - not AI.

### 🎛️ Precise Context Tuning

Fine-tune TaskRunner's input to avoid both context overflow and information starvation:

- **`references.yaml`**: Maintain a curated list of files for each task
- **`result.md`**: Capture outputs to build precise context for subsequent tasks
- **Granular control**: Add, remove, or adjust context references at any point

You ensure TaskRunner has exactly what it needs - no more, no less.

### 💾 Breakpoint Recovery

Filesystem-based state management means:
- **Interrupt anytime** and seamlessly resume later
- **Git-friendly**: Branch for experiments, rollback if needed
- **Collaboration-ready**: Share progress via git, no hidden state
- **Zero lock-in**: All data in human-readable Markdown + YAML

Your work is never lost or trapped in an inaccessible AI session.

## Architecture

Bird-Eye uses a dual-agent architecture with clear separation of concerns:

```
┌──────────────────────────────────────────────────────────┐
│                       Human User                         │
│                    (Task Scheduler)                      │
└────────────────────┬─────────────────────────────────────┘
                     │
          ┌──────────▼──────────┐
          │     @treeWork       │  ← Planning & Tracking
          │  Task Decomposer   │     - Creates task trees
          │  Progress Tracker  │     - Manages dependencies
          └──────────┬──────────┘     - Generates task specs
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   ┌─────────┐  ┌─────────┐  ┌─────────┐
   │TaskRun  │  │TaskRun  │  │TaskRun  │  ← Execution
   │ Task A  │  │ Task B  │  │ Task C  │     - Executes tasks
   └─────────┘  └─────────┘  └─────────┘     - Modifies files
```

### TreeWork Agent
- **Role**: Planning and tracking expert
- **Responsibilities**:
  - Decompose user requirements into task trees
  - Visualize progress with ASCII diagrams
  - Generate `readme.md` for each task
  - Maintain `references.yaml` for context control
- **Does NOT**: Execute code or modify files

### TaskRunner Agent
- **Role**: Focused execution specialist
- **Responsibilities**:
  - Read `readme.md` to understand task
  - Execute code, create/modify files
  - Output `result.md` with execution details
  - List all changed files
- **Does NOT**: Plan tasks or manage dependencies

## Quick Start

### Step 1: Initialize a Mission

Start a new project or feature:

```
@treeWork init 为后台管理系统添加 CSV 导入商品功能
```

TreeWork creates:
```
csv-import-feature/
├── readme.md          # Mission background and goals
├── references.yaml    # Context file list
└── progress.md        # ASCII task tree
```

### Step 2: Plan and Create Tasks

Refine the task tree:

```
@treeWork subtask 后端 API 设计
```

TreeWork creates:
```
csv-import-feature/
└── task-1.2.1/
    ├── readme.md         # Task specification
    └── references.yaml   # Context for this task
```

### Step 3: Execute Tasks

Start a new TaskRunner agent session and instruct it to read the task specification:

> **TaskRunner Prompt**: Work as a TaskRunner agent. Read `task-1.2.1/readme.md` to understand the task, then execute it.

TaskRunner reads the `readme.md` file, executes the task, and generates `result.md` in the same directory.

### Step 4: Update Progress

Report completion back to TreeWork:

```
@treeWork done
```

TreeWork reads `result.md`, updates the progress tree, and suggests next steps.

### Step 5: Continue Iteration

Repeat Steps 2-4 until the mission is complete.

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                          WORKFLOW                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   1.  USER  ───────►  @treeWork  ───────►  plan task tree      │
│                                                                 │
│   2.  USER  ◄───────  @treeWork  ◄───────  show progress       │
│                                                                 │
│   3.  USER  ───────►  @treeWork  ───────►  create readme.md    │
│                                                                 │
│   4.  USER  ───────►  TaskRunner  ──────►  execute task       │
│                     (new session)                              │
│                                                                 │
│   5.  USER  ◄───────  TaskRunner  ◄───────  result.md         │
│                                                                 │
│   6.  USER  ───────►  @treeWork  ───────►  mark [ok]          │
│                                                                 │
│   7.  REPEAT  until mission [ok]                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Command Reference

### Initialization
| Command | Purpose | Example |
|---------|---------|---------|
| `init <desc>` | Create new mission | `@treeWork init 实现用户登录` |
| `from <dir>` | Resume from directory | `@treeWork from docs/missions/csv` |

### Planning
| Command | Purpose | Example |
|---------|---------|---------|
| `plan <desc>` | Plan task tree (no files) | `@treeWork plan 需要A、B、C三步` |
| `populate <id>` | Batch create task files | `@treeWork populate 1.2` |
| `subtask <desc>` | Create subtask | `@treeWork subtask 设计 API` |

### Execution Control
| Command | Purpose | Example |
|---------|---------|---------|
| `next [desc]` | Complete & continue | `@treeWork next 实现数据校验` |
| `done [summary]` | Mark task complete | `@treeWork done 数据库设计已完成` |
| `drop <reason>` | Abandon task | `@treeWork drop 需求变更` |

### Navigation & Info
| Command | Purpose | Example |
|---------|---------|---------|
| `status` | Show progress | `@treeWork status` |
| `goto <id>` | Jump to task | `@treeWork goto 1.2.3` |

### Context Management
| Command | Purpose | Example |
|---------|---------|---------|
| `ref <path> [desc]` | Add context reference | `@treeWork ref src/xxx.go 说明` |
| `read <path>` | Read file content | `@treeWork read docs/architecture.md` |

### Result Sync
| Command | Purpose | Example |
|---------|---------|---------|
| `receive [ids...]` | Batch receive results | `@treeWork receive 1.2.1 1.2.2` |

## Status Markers

| Marker | Meaning | Usage |
|--------|---------|-------|
| `[  ]` | Planned (pending) | Tasks created by `plan`, not yet ready |
| `[..]` | In progress | Task has `readme.md`, ready for TaskRunner |
| `[ok]` | Completed | Task and all subtasks done |
| `[bin]` | Deprecated | No longer needed (requirements changed) |

## Use Cases

### ✅ Perfect For

- **Complex multi-step features** with clear dependencies
- **Exploratory development** where requirements evolve
- **Team collaboration** with Git-based workflow
- **Long-running projects** requiring checkpoints
- **Code refactoring** with systematic approach
- **Documentation-driven development**

### ❌ Not Ideal For

- **Single quick tasks** (use direct LLM conversation)
- **Well-defined, repetitive tasks** (use scripts/tools)
- **Simple one-off changes** (manual editing is faster)

## Comparison

| Aspect | Bird-Eye | Single Agent | Project Management Tools |
|--------|----------|--------------|--------------------------|
| **Visibility** | 🟢 Complete ASCII tree | 🔴 Opaque | 🟢 Gantt charts |
| **Context Control** | 🟢 Precise YAML tuning | 🟡 Limited prompts | 🔴 N/A |
| **Recovery** | 🟢 Git-friendly state | 🔴 Session lost | 🟡 Manual sync |
| **AI Execution** | 🟢 Specialized agents | 🟡 General-purpose | 🔴 Manual |
| **Flexibility** | 🟢 Adapt to changes | 🟡 Rigid | 🟢 Structured |
| **Learning Curve** | 🟡 Moderate | 🟢 Low | 🟡 Moderate |

## File Structure

```
<mission-root>/
├── readme.md              # Mission background & goals
├── references.yaml        # Global context references
├── progress.md            # ASCII task tree with status
│
├── task-1.1/
│   ├── readme.md          # Task 1.1 specification
│   ├── references.yaml    # Task 1.1 context
│   └── result.md          # Task 1.1 output (after execution)
│
├── task-1.2/
│   ├── readme.md
│   ├── references.yaml
│   ├── result.md
│   │
│   ├── task-1.2.1/
│   │   ├── readme.md
│   │   ├── references.yaml
│   │   └── result.md
│   │
│   └── task-1.2.2/
│       └── readme.md
│
└── ...
```

## Key Design Principles

1. **Separation of Concerns**: Planning vs. execution, handled by specialized agents
2. **Filesystem as State**: All progress stored in human-readable files
3. **Git-Native**: Version control, branching, collaboration out-of-the-box
4. **Human-in-the-Loop**: You remain the orchestrator and decision-maker
5. **Observability First**: Every action leaves a trace in Markdown/YAML

## Example Mission Workflow

See [spec/05-workflow-example.md](./spec/05-workflow-example.md) for a complete end-to-end example of implementing a CSV import feature.

## Deep Dive Documentation

- [TreeWork Agent Specification](./spec/01-treework-agent.md)
- [TaskRunner Agent Specification](./spec/02-taskrunner-agent.md)
- [File Format Reference](./spec/03-file-formats.md)
- [Complete Command Reference](./spec/04-command-reference.md)
- [Workflow Example](./spec/05-workflow-example.md)

## Why "Bird-Eye"?

The name embodies the system's philosophy:

- **Elevated perspective**: See the entire task landscape at once
- **Clear vision**: No blind spots, dependencies are visible
- **Strategic control**: You decide where to focus and when to pivot
- **Agile adaptation**: Quickly adjust when requirements change

You're the bird, AI agents are your eyes and hands.

## Contributing

Contributions are welcome! Areas for improvement:

- **Tooling**: CLI wrappers for TreeWork/TaskRunner
- **Automation**: Git hooks for result validation
- **Visualization**: Generate SVG diagrams from progress.md
- **Integrations**: Connect with existing project management tools

## License

MIT License - see LICENSE file for details

---

**Built for developers who want control, clarity, and collaboration in AI-assisted development.**
