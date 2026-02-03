# Bird-Eye Agent System

> **以人为中心的 LLM Agent 任务编排框架——保持完全控制，拥有全面可见性。**

双 Agent 协作系统，让您以前所未有的清晰度管理复杂任务。**TreeWork** 负责规划追踪，**TaskRunner** 执行具体任务。

## Bird-Eye 是什么？

- **清晰的任务分解**：可视化依赖树，随时了解全局状态
- **精确的上下文控制**：每个任务独立配置上下文，避免信息溢出
- **完全可见性**：所有进度和决策都在 Markdown/YAML 文件中
- **Git 友好**：基于文件系统的状态管理，随时可重新恢复进度，支持分支、回滚、协作

## 架构

```
Human User → @treeWork → 拆分任务和全局视图 → Human 微调上下文 → @taskRunner → Human 更新全局计划 → 循环
```

**关键角色**：

- **TreeWork Agent**：任务分解、进度追踪、生成任务规范。不执行任务。
- **Human**：在 TreeWork 和 TaskRunner 之间，**微调上下文文件**（编辑 readme.md 和 references.yaml），确保 TaskRunner 拥有恰好所需的信息。
- **TaskRunner Agent**：执行单个任务、生成执行报告。不管理任务树。

 ## 快速开始

 ### 方式一：项目级使用（推荐用于单个项目）

 下载规范文件到当前工作目录的 `.bird-eye` 文件夹：

 ```bash
 mkdir -p .bird-eye/spec && curl -sL https://github.com/victor-develop/bird-eye-agent-system/archive/refs/heads/master.tar.gz | tar xz -C .bird-eye/spec --strip-components=2
 ```

 所有规范文档都在 `.bird-eye/spec/` 目录中。

 > **如果您是 LLM Agent**：读取 `.bird-eye/spec` 目录下的所有文件，理解 Bird-Eye Agent System 的架构和工作流。确认后回复："我已理解 Bird-Eye Agent System 的架构和工作流。"

 ### 方式二：作为 OpenCode Agents 安装（推荐）

 Bird-Eye Agent System 可以作为 OpenCode 的 Agents 和 Skills 安装，获得完整的任务规划和执行功能。

 **本地安装（仅当前项目可用）**：
 ```bash
 git clone https://github.com/victor-develop/bird-eye-agent-system.git
 cd bird-eye-agent-system
 ./install.sh
 ```

 **全局安装（所有项目可用）**：
 ```bash
 git clone https://github.com/victor-develop/bird-eye-agent-system.git
 cd bird-eye-agent-system
 ./install.sh --global
 ```

 **查看安装选项**：
 ```bash
 ./install.sh --help
 ```

 安装脚本会自动：
 - 将 YAML 格式的 agent 配置转换为 OpenCode 可用的 Markdown 格式
 - 创建所需的技能文件（SKILL.md）
 - 将文件放置到正确的目录中

 **验证安装**：
 ```bash
 # 在 OpenCode TUI 中使用
 @treework status
 @taskrunner execute
 ```

 或者在 CLI 中：
 ```bash
 opencode agent list  # 应该看到 treework 和 taskrunner
 ```

 更多安装和使用详情请参考 [opencode-agents/README.md](./opencode-agents/README.md)。

---

## 基本工作流

**Step 1: 初始化任务**

```
@treeWork init 为后台管理系统添加 CSV 导入商品功能
```

创建：
```
csv-import-feature/
├── readme.md          # 任务背景和目标
├── references.yaml    # 上下文文件列表
└── progress.md        # ASCII 任务树
```

**Step 2: 规划任务**

```
@treeWork subtask 后端 API 设计
```

创建：
```
csv-import-feature/
└── task-1.2.1/
    ├── readme.md         # 任务规范
    └── references.yaml   # 此任务的上下文
```

**Step 3: 微调上下文（可选）**

编辑 `readme.md` 补充验收标准，编辑 `references.yaml` 添加/删除文件。

**Step 4: 执行任务**

启动新的 TaskRunner Agent 会话：
```
按照 task-1.2.1/readme.md 的描述完成任务。
```

TaskRunner 读取规范、执行任务、生成 `result.md`。

**Step 5: 更新进度**

```
@treeWork done
```

TreeWork 读取 `result.md`，更新进度树，建议下一步。

**Step 6: 继续迭代**

重复步骤 2-5，直到任务完成。

## 命令速查表

### 初始化
| 命令 | 用途 | 示例 |
|------|------|------|
| `init <desc>` | 创建新任务 | `@treeWork init 实现用户登录` |
| `from <dir>` | 从目录恢复 | `@treeWork from docs/missions/csv` |

### 规划
| 命令 | 用途 | 示例 |
|------|------|------|
| `plan <desc>` | 规划任务树（不创建文件） | `@treeWork plan 需要A、B、C三步` |
| `populate <id>` | 批量创建任务文件 | `@treeWork populate 1.2` |
| `subtask <desc>` | 创建子任务 | `@treeWork subtask 设计 API` |

### 执行控制
| 命令 | 用途 | 示例 |
|------|------|------|
| `next [desc]` | 完成并继续 | `@treeWork next 实现数据校验` |
| `done [summary]` | 标记任务完成 | `@treeWork done 数据库设计已完成` |
| `drop <reason>` | 废弃任务 | `@treeWork drop 需求变更` |

### 导航和信息
| 命令 | 用途 | 示例 |
|------|------|------|
| `status` | 查看进度 | `@treeWork status` |
| `goto <id>` | 跳转任务 | `@treeWork goto 1.2.3` |

### 上下文管理
| 命令 | 用途 | 示例 |
|------|------|------|
| `ref <path> [desc]` | 添加上下文引用 | `@treeWork ref src/xxx.go 说明` |
| `read <path>` | 读取文件内容 | `@treeWork read docs/architecture.md` |

### 结果同步
| 命令 | 用途 | 示例 |
|------|------|------|
| `receive [ids...]` | 批量接收结果 | `@treeWork receive 1.2.1 1.2.2` |

## 状态标记

| 标记 | 含义 | 使用场景 |
|------|------|----------|
| `[  ]` | 已规划 | plan 命令创建，尚未生成 readme.md |
| `[..]` | 进行中 | 已创建 readme.md，可执行 TaskRunner |
| `[ok]` | 已完成 | 任务及其所有子任务都已完成 |
| `[bin]` | 已废弃 | 需求变更导致任务不再需要 |

## 文件结构

```
<mission-root>/
├── readme.md              # Mission background & goals
├── references.yaml        # Global context references
├── progress.md            # ASCII task tree with status
│
├── task-1.1/
│   ├── readme.md          # Task specification
│   ├── references.yaml    # Task context
│   └── result.md          # Execution output
│
└── task-1.2/
    └── task-1.2.1/
        ├── readme.md
        ├── references.yaml
        └── result.md
```

## 使用建议

### 模型选择
- **TreeWork Agent**：用便宜、快的模型（Grok Fast, Gemini Flash, GLM-4.6V-Flash）
- **TaskRunner Agent**：用强模型（Claude Sonnet 4.5, Gemini Pro, Claude Opus 4.5）

### 任务并行执行
**适合并行**：调研类、整理文档、问题排查
**建议线性**：代码 review、有依赖的任务、需整合结果的任务

## 深入文档

- [TreeWork Agent 规范](./spec/01-treework-agent.md)
- [TaskRunner Agent 规范](./spec/02-taskrunner-agent.md)
- [文件格式参考](./spec/03-file-formats.md)
- [完整命令参考](./spec/04-command-reference.md)
- [工作流示例](./spec/05-workflow-example.md)

## 贡献

欢迎贡献！改进领域：
- **工具**: TreeWork/TaskRunner 的 CLI 封装
- **自动化**: 用于结果验证的 Git 钩子
- **可视化**: 从 progress.md 生成 SVG 图表
- **集成**: 与现有项目管理工具连接

## 许可证

MIT License

---

**为希望在 AI 辅助开发中获得控制、清晰和协作的开发者而构建。**
