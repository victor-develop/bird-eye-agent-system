 # Bird-Eye Agent System - OpenCode Agents 安装指南

 本目录包含将 Bird-Eye Agent System 转换为 OpenCode Agents 的配置文件。

 ## 概述

 Bird-Eye Agent System 是一个双代理任务编排框架，包含两个专用代理：

 - **TreeWork Agent** (`treework.md`): 任务规划与进度追踪专家
 - **TaskRunner Agent** (`taskrunner.md`): 单任务执行专家
 - **Skills**: 文件生成技能模板，确保 agents 能按照规范格式创建文件

## 系统架构

```
Human User (调度者) → @treeWork (规划) → @taskRunner (执行)
                     ↓                   ↓
                 创建任务规格          执行具体任务
```

 ## 安装步骤

 ### 1. 前置要求

 确保已安装 OpenCode CLI 工具。

 ### 2. 安装 Agents 和 Skills

 使用项目根目录的安装脚本进行安装：

 ```bash
 # 从项目根目录运行（确保你在 bird-eye-agent-system 目录下）
 cd /path/to/bird-eye-agent-system

 # 本地安装（安装到当前项目的 .opencode/ 目录）
 ./install.sh

 # 全局安装（安装到 ~/.config/opencode/ 目录）
 ./install.sh --global

 # 查看帮助信息
 ./install.sh --help
 ```

 安装脚本会自动：
 - 将 YAML 格式的 agent 配置转换为 OpenCode 可用的 Markdown 格式
 - 将 skill 模板文件转换为 OpenCode 可用的 SKILL.md 格式
 - 创建所需的目录结构
 - 将文件放置到正确的目录中

 ### 3. 验证安装

 安装完成后，在 OpenCode 中可以：

 ```bash
 # 使用 @treework 调用 TreeWork Agent
 @treework status

 # 使用 @taskrunner 调用 TaskRunner Agent
 @taskrunner execute
 ```

 或者在 TUI 中使用 `@` 键来调用这些 agents。

 ### 安装位置说明

 | 安装模式 | Agents 目录 | Skills 目录 |
 |----------|-------------|-------------|
 | 本地 | `.opencode/agents/` | `.opencode/skills/` |
 | 全局 | `~/.config/opencode/agents/` | `~/.config/opencode/skills/` |

 ## 使用指南

 ### TreeWork Agent 使用

 TreeWork Agent 负责任务规划和进度追踪。

 在 OpenCode TUI 或 CLI 中使用 `@treework` 调用：

 ```bash
 # 初始化新任务
 @treework init "实现 CSV 导入功能，支持批量导入商品数据"

 # 规划任务树（不创建文件）
 @treework plan "后端需要：1. API设计 2. CSV解析 3. 数据校验 4. 批量写入"

 # 批量创建任务文件
 @treework populate 1.2

 # 创建子任务
 @treework subtask "设计数据库 Schema"

 # 完成当前任务，继续下一个
 @treework next

 # 标记任务完成
 @treework done "数据库设计已完成，共创建 5 个表"

 # 废弃任务
 @treework drop "需求变更，此功能不再需要"

 # 查看当前进度
 @treework status

 # 跳转到指定任务
 @treework goto 1.2.3

 # 添加上下文引用
 @treework ref backend/internal/service/product.go "现有商品服务实现"

 # 读取文件（唯一允许 TreeWork 读文件的命令）
 @treework read docs/architecture-design.md

 # 接收单个任务结果
 @treework receive 1.2.1

 # 批量接收结果
 @treework receive 1.2.1 1.2.2 1.2.3

 # 自动扫描所有进行中任务的结果
 @treework receive
 ```

 ### TaskRunner Agent 使用

 TaskRunner Agent 负责执行具体的单个任务。

 在 OpenCode TUI 或 CLI 中使用 `@taskrunner` 调用：

 ```bash
 # 进入任务目录
 cd task-1.1

 # 执行任务
 @taskrunner execute
 ```

 TaskRunner 会：
 1. 读取 readme.md 理解任务目标
 2. 读取 references.yaml 中的上下文文件
 3. 执行代码编写、文件修改等操作
 4. 创建 result.md 记录执行结果

 ## 工作流示例

 ### 完整工作流程

 ```bash
 # 1. 使用 TreeWork 初始化任务
 @treework init "实现用户认证功能"

 # 2. 规划任务结构
 @treework plan "需要：1. 设计数据库表 2. 实现 API 3. 编写测试"

 # 3. 批量创建任务文件
 @treework populate 1

 # 4. 执行第一个任务（使用 TaskRunner）
 cd task-1.1
 @taskrunner execute

 # 5. 回到根目录，接收结果并继续
 cd ..
 @treework receive 1.1

 # 6. 继续下一个任务
 cd task-1.2
 @taskrunner execute
 ```

 ### 并行执行多个任务

 ```bash
 # 规划并创建多个独立任务
 @treework populate 1.2

 # 在不同的终端并行执行
 cd task-1.2.1 && @taskrunner execute
 cd task-1.2.2 && @taskrunner execute
 cd task-1.2.3 && @taskrunner execute

 # 批量接收结果
 cd ..
 @treework receive
 ```

## 文件格式说明

### 任务目录结构

```
<mission-root>/
├── readme.md         # 任务背景与概述
├── references.yaml   # 关键上下文文件路径
├── progress.md       # ASCII 树状进度图
└── task-1.1/
    ├── readme.md     # 任务规格（不超过 150 行）
    ├── references.yaml
    └── result.md     # TaskRunner 执行完成后生成
```

### readme.md 格式（任务规格）

```markdown
# Task: 1.1

## 目标
<简要描述任务目标>

## 验收标准
- [ ] 标准 1
- [ ] 标准 2

## 上下文
见 references.yaml

## 约束条件
<任何约束>

## 输出要求
完成后在当前目录创建 result.md（不超过 150 行）
```

### references.yaml 格式

```yaml
- path: path/to/file1
  desc: 文件说明
- path: path/to/file2
  desc: 文件说明
```

### result.md 格式

```markdown
# Task Result: 1.1

## 执行状态
- [ ] 成功
- [ ] 部分成功
- [ ] 失败

## 执行摘要
<2-3 句话描述做了什么>

## 变更文件列表
| 文件路径 | 变更类型 | 说明 |
|----------|----------|------|
| src/xxx.go | 新增 | 实现了 xxx 功能 |

## 关键决策
<重要决策记录>

## 遗留问题
<未解决的问题>

## 验收检查
- [x] 验收标准 1
- [x] 验收标准 2
```

### progress.md 格式（ASCII 进度树）

```text
Mission: CSV 导入功能

[ok]Task1.0: 总体设计
  ├─►[ok]Task1.1: 数据库 Schema
  │  └─►[ok]Task1.1.1: 商品表设计
  ├─►[ok]Task1.2: API 接口设计
  └─►[..]Task1.3: CSV 解析实现
     ├─►[..]Task1.3.1: 解析器实现
     └─►[  ]Task1.3.2: 数据校验
```

状态标记说明：
- `[  ]` - 已规划，尚未生成 readme.md
- `[..]` - 进行中，已创建 readme.md，可执行 TaskRunner
- `[ok]` - 已完成，任务及其所有子任务都已完成
- `[bin]` - 已废弃，需求变更导致任务不再需要

 ## 配置文件说明

 ### 安装后的 Agents

 安装脚本会创建以下 agent 文件：

 - **treework.md** - TreeWork Agent 配置
 - **taskrunner.md** - TaskRunner Agent 配置

 这些 Markdown 格式的文件包含：
 - Frontmatter（元数据）：description, mode
 - System Prompt：代理的系统提示词、能力、约束等

 ### 安装后的 Skills

 安装脚本会创建以下技能文件：

 - **treework-scaffold-mission-readme/SKILL.md** - Mission 根目录 readme.md 生成技能
 - **treework-scaffold-progress-md/SKILL.md** - progress.md 生成技能
 - **treework-scaffold-references-yaml/SKILL.md** - references.yaml 生成技能
 - **treework-scaffold-task-readme/SKILL.md** - Task 目录 readme.md 生成技能
 - **taskrunner-scaffold-result-md/SKILL.md** - result.md 生成技能

 这些 skills 确保 agents 按照规范格式创建文件，避免格式不一致的问题。Agent 在执行相关命令时会通过 `skill` 工具加载对应的 skill。

 ### 源文件

 - **treework-agent.yaml** - TreeWork Agent 的 YAML 格式配置（源文件）
 - **taskrunner-agent.yaml** - TaskRunner Agent 的 YAML 格式配置（源文件）
 - **../opencode-skills/** - 技能模板源文件目录

 ## 常见问题

 ### Q: 如何更新代理或技能？

 A: 修改对应的 YAML 或 skill 文件后，重新运行安装脚本：

 ```bash
 # 重新安装
 ./install.sh

 # 或全局重新安装
 ./install.sh --global
 ```

 ### Q: 本地安装和全局安装有什么区别？

 A:
 - **本地安装**: 安装到当前项目的 `.opencode/` 目录，只在该项目中可用
 - **全局安装**: 安装到 `~/.config/opencode/` 目录，在所有项目中可用

 ### Q: 如何查看已安装的 agents 和 skills？

 A: 在 OpenCode 中：

 ```bash
 # 列出所有可用的 agents（通过 Tab 键切换）
 # 或使用 opencode agent list 命令

 # 在 TUI 中，agents 会显示在 agent 切换菜单中
 # Skills 可以通过 @ 提及或 skill 工具使用
 ```

### Q: TreeWork 和 TaskRunner 如何协作？

A: TreeWork 负责规划和创建任务规格文件（readme.md），TaskRunner 读取这些文件并执行具体工作，完成后生成 result.md。TreeWork 再读取 result.md 更新进度。

### Q: 可以并行执行多个 TaskRunner 吗？

A: 可以。当任务树中有多个独立任务（无依赖关系）时，可以在不同终端并行执行多个 TaskRunner，然后使用 `@treeWork receive` 批量同步结果。

### Q: 如何处理任务失败？

A: TaskRunner 会在 result.md 中记录失败原因和建议。TreeWork 收到后会更新任务状态，等待用户决策是废弃、拆分任务还是补充上下文。

## 相关文档

- [TreeWork Agent 规范](../spec/01-treework-agent.md)
- [TaskRunner Agent 规范](../spec/02-taskrunner-agent.md)
- [文件格式定义](../spec/03-file-formats.md)
- [命令参考手册](../spec/04-command-reference.md)
- [工作流示例](../spec/05-workflow-example.md)

## 技术支持

如有问题或建议，请在 GitHub Issues 中反馈。
