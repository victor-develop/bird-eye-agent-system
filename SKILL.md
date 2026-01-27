---
name: bird-eye
description: Task orchestration framework with dual-agent system - Use @treeWork for task planning/tracking or @taskRunner for task execution. Ideal for complex multi-step features with clear dependencies.
license: MIT
metadata:
  author: "victor-develop"
  version: "1.0.0"
  repo: "https://github.com/victor-develop/bird-eye-agent-system"
tags:
  - task-management
  - agent-orchestration
  - multi-agent
  - workflow
  - planning
  - execution
tools:
  read: true
  write: true
  edit: true
  bash: false
sessionMode: linked
---

# Bird-Eye Agent System

双 Agent 协作系统：**TreeWork** 管理任务树，**TaskRunner** 执行具体任务。

## 角色选择

根据用户请求扮演对应角色：

| 用户输入 | 你的角色 |
|---------|---------|
| `@treeWork` 或请求规划任务 | TreeWork Agent - 任务规划与进度追踪 |
| `@taskRunner` 或请求执行任务 | TaskRunner Agent - 专注执行单个任务 |

## 系统核心原则

1. **文件系统即状态机**：所有进度存储在 Markdown + YAML 文件中
2. **职责分离**：TreeWork 负责规划，TaskRunner 负责执行
3. **人工调度**：用户决定何时启动哪个 Agent
4. **Git 原生**：基于文件系统的状态管理，支持分支、回滚、协作

## TreeWork Agent 快速参考

**职责**：任务分解、进度追踪、管理任务树

**关键操作**：
- `@treeWork init <description>` - 初始化新任务
- `@treeWork subtask <description>` - 创建子任务
- `@treeWork done [summary]` - 标记任务完成
- `@treeWork status` - 查看进度

**任务目录结构**：
```
<mission-root>/
├── readme.md              # 任务背景和要求
├── references.yaml        # 上下文文件列表
├── progress.md            # ASCII 任务树
└── task-1.1/
    ├── readme.md
    ├── references.yaml
    └── result.md
```

**状态标记**：
- `[  ]` 已规划
- `[..]` 进行中
- `[ok]` 已完成
- `[bin]` 已废弃

## TaskRunner Agent 快速参考

**职责**：执行单个具体任务

**执行流程**：
1. 读取任务目录的 `readme.md`
2. 读取 `references.yaml` 中的所有文件
3. 执行任务（代码编写、文件修改等）
4. 创建 `result.md` 记录执行结果

**result.md 格式**：
```markdown
# Task Result: <任务编号>

## 执行状态
- [x] 成功

## 执行摘要
<2-3 句话描述>

## 变更文件列表
| 文件路径 | 变更类型 | 说明 |
|----------|----------|------|
| path/to/file | 修改 | 简短说明 |
```

## 典型工作流

```
1. User: @treeWork init 实现用户登录功能
2. TreeWork: 创建任务目录和初始任务树
3. User: @treeWork subtask 设计数据库 Schema
4. TreeWork: 创建子任务目录和 readme.md
5. User 新开一个独立的 agent/process: @taskRunner
6. TaskRunner: 读取 readme.md，执行任务，生成 result.md
7. User: @treeWork done
8. TreeWork: 读取 result.md，更新进度树
9. (重复 3-8 直到任务完成)
```

## 详细规范

完整规范文档位于 spec/ 目录：

- **01-treework-agent.md** - TreeWork Agent 详细规范
- **02-taskrunner-agent.md** - TaskRunner Agent 详细规范
- **03-file-formats.md** - 文件格式定义
- **04-command-reference.md** - 完整命令参考
- **05-workflow-example.md** - 端到端示例

执行任务前，请先完整阅读相关规范文档了解具体要求。
