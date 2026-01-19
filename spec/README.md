# Bird-Eye Agent System

> **LLM 提示**：当用户要求你 "work as Bird-Eye" 或 "@birdEye" 时，请先阅读本目录下的所有文件，然后准备好协助用户进行任务规划与管理。

双 Agent 协作系统：TreeWork 管理任务树，TaskRunner 执行具体任务。

## 文件结构

```
bird-eye/
├── README.md                    # 本文件 - 入口与概述
├── 01-treework-agent.md         # TreeWork Agent 规范
├── 02-taskrunner-agent.md       # TaskRunner Agent 规范
├── 03-file-formats.md           # 关键文件格式定义
├── 04-command-reference.md      # 命令参考手册
└── 05-workflow-example.md       # 完整工作流示例
```

## 系统概述

```
┌─────────────────────────────────────────────────────────┐
│                      用户                                │
│                        │                                │
│              ┌─────────▼─────────┐                      │
│              │   @treeWork       │                      │
│              │   任务规划与追踪   │                      │
│              └─────────┬─────────┘                      │
│                        │                                │
│         ┌──────────────┼──────────────┐                 │
│         │              │              │                 │
│         ▼              ▼              ▼                 │
│   ┌──────────┐   ┌──────────┐   ┌──────────┐           │
│   │TaskRunner│   │TaskRunner│   │TaskRunner│           │
│   │ Task A   │   │ Task B   │   │ Task C   │           │
│   └──────────┘   └──────────┘   └──────────┘           │
└─────────────────────────────────────────────────────────┘
```

## 核心概念

### TreeWork Agent
- 负责**任务分解**与**进度追踪**
- 使用 ASCII 树状图可视化任务依赖
- 为每个任务创建目录和 readme.md
- 不执行具体代码/文件操作

### TaskRunner Agent  
- 负责**执行单个具体任务**
- 输入：readme.md
- 输出：result.md + 变更文件列表
- 专注执行，不管理任务树

### 工作模式
当前采用**人工调度模式**：
1. 用户与 TreeWork 交互，规划任务
2. TreeWork 生成 readme.md
3. 用户将 readme.md 喂给独立的 TaskRunner 进程
4. TaskRunner 完成后输出 result.md
5. 用户告知 TreeWork 任务完成
6. TreeWork 更新进度图，继续下一步

## 快速开始

1. 阅读 [01-treework-agent.md](./01-treework-agent.md) 了解 TreeWork
2. 阅读 [02-taskrunner-agent.md](./02-taskrunner-agent.md) 了解 TaskRunner
3. 参考 [05-workflow-example.md](./05-workflow-example.md) 查看完整示例

## 状态标记速查

| 标记 | 含义 |
|------|------|
| `[  ]` | 已规划（待准备） |
| `[..]` | 进行中 |
| `[ok]` | 已完成 |
| `[bin]` | 已废弃 |

## 命令速查表

| 命令 | 用途 | 示例 |
|------|------|------|
| init | 初始化任务 | `@treeWork init 实现用户登录` |
| from | 从目录恢复或初始化 | `@treeWork from docs/missions/csv` |
| plan | 规划任务树（不创建文件） | `@treeWork plan 需要A、B、C三步` |
| populate | 批量创建任务文件 | `@treeWork populate 1.2` |
| subtask | 创建子任务 | `@treeWork subtask 设计 API` |
| next | 完成并继续 | `@treeWork next` |
| done | 完成当前任务 | `@treeWork done` |
| drop | 废弃任务 | `@treeWork drop 需求取消` |
| status | 查看进度 | `@treeWork status` |
| goto | 跳转任务 | `@treeWork goto 1.2.3` |
| ref | 添加上下文引用 | `@treeWork ref src/xxx.go 说明` |
| read | 读取文件 | `@treeWork read src/xxx.go` |
| receive | 批量接收结果 | `@treeWork receive 1.2.1 1.2.2` |
