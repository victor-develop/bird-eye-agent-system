 # Bird-Eye Agent System - OpenCode Agents 安装指南

 本目录包含将 Bird-Eye Agent System 转换为 OpenCode Agents 的配置文件。

 ## 概述

 Bird-Eye Agent System 是一个双代理任务编排框架，包含两个专用代理：

 - **TreeWork Agent** (`treework-agent.yaml`): 任务规划与进度追踪专家
 - **TaskRunner Agent** (`taskrunner-agent.yaml`): 单任务执行专家
 - **Skills** (`../opencode-skills/`): 文件生成技能模板，确保 agents 能按照规范格式创建文件

## 系统架构

```
Human User (调度者) → @treeWork (规划) → @taskRunner (执行)
                     ↓                   ↓
                 创建任务规格          执行具体任务
```

## 安装步骤

### 1. 前置要求

确保已安装 OpenCode CLI 工具。

### 2. 安装代理

使用以下命令安装代理：

```bash
# 安装 TreeWork Agent
opencode agent install treework-agent.yaml

# 安装 TaskRunner Agent
opencode agent install taskrunner-agent.yaml
```

### 3. 验证安装

```bash
# 检查已安装的代理
opencode agent list

# 应该看到：
# - treework
# - taskrunner
```

## 使用指南

### TreeWork Agent 使用

TreeWork Agent 负责任务规划和进度追踪。

#### 初始化新任务

```bash
# 初始化新任务
opencode agent run treework init "实现 CSV 导入功能，支持批量导入商品数据"
```

#### 规划任务树

```bash
# 规划任务树（不创建文件）
opencode agent run treework plan "后端需要：1. API设计 2. CSV解析 3. 数据校验 4. 批量写入"

# 批量创建任务文件
opencode agent run treework populate 1.2
```

#### 任务管理

```bash
# 创建子任务
opencode agent run treework subtask "设计数据库 Schema"

# 完成当前任务，继续下一个
opencode agent run treework next

# 标记任务完成
opencode agent run treework done "数据库设计已完成，共创建 5 个表"

# 废弃任务
opencode agent run treework drop "需求变更，此功能不再需要"
```

#### 导航与状态

```bash
# 查看当前进度
opencode agent run treework status

# 跳转到指定任务
opencode agent run treework goto 1.2.3
```

#### 上下文管理

```bash
# 添加上下文引用
opencode agent run treework ref backend/internal/service/product.go "现有商品服务实现"

# 读取文件（唯一允许 TreeWork 读文件的命令）
opencode agent run treework read docs/architecture-design.md
```

#### 结果同步

```bash
# 接收单个任务结果
opencode agent run treework receive 1.2.1

# 批量接收结果
opencode agent run treework receive 1.2.1 1.2.2 1.2.3

# 自动扫描所有进行中任务的结果
opencode agent run treework receive
```

### TaskRunner Agent 使用

TaskRunner Agent 负责执行具体的单个任务。

#### 执行任务

```bash
# 进入任务目录
cd task-1.1

# 执行任务
opencode agent run taskrunner execute
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
opencode agent run treework init "实现用户认证功能"

# 2. 规划任务结构
opencode agent run treework plan "需要：1. 设计数据库表 2. 实现 API 3. 编写测试"

# 3. 批量创建任务文件
opencode agent run treework populate 1

# 4. 执行第一个任务（使用 TaskRunner）
cd task-1.1
opencode agent run taskrunner execute

# 5. 回到根目录，接收结果并继续
cd ..
opencode agent run treework receive 1.1

# 6. 继续下一个任务
cd task-1.2
opencode agent run taskrunner execute
```

### 并行执行多个任务

```bash
# 规划并创建多个独立任务
opencode agent run treework populate 1.2

# 在不同的终端并行执行
cd task-1.2.1 && opencode agent run taskrunner execute
cd task-1.2.2 && opencode agent run taskrunner execute
cd task-1.2.3 && opencode agent run taskrunner execute

# 批量接收结果
cd ..
opencode agent run treework receive
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

### treework-agent.yaml

配置了 TreeWork Agent 的：
- 代理名称、版本、描述
- 角色定义和系统提示词
- 能力和约束
- 支持的命令
- 使用示例

 ### taskrunner-agent.yaml

 配置了 TaskRunner Agent 的：
 - 代理名称、版本、描述
 - 角色定义和系统提示词
 - 能力和约束
 - 支持的命令
 - 使用示例

 ### opencode-skills/ 目录

 包含 agents 使用的文件生成技能模板：

 - `treework/scaffold-mission-readme.md` - Mission 根目录 readme.md 生成技能
 - `treework/scaffold-references-yaml.md` - references.yaml 生成技能
 - `treework/scaffold-progress-md.md` - progress.md 生成技能
 - `treework/scaffold-task-readme.md` - Task 目录 readme.md 生成技能
 - `taskrunner/scaffold-result-md.md` - result.md 生成技能

 这些 skills 确保 agents 按照规范格式创建文件，避免格式不一致的问题。Agent 在执行相关命令时会自动参考对应的 skill 文件。

## 常见问题

### Q: 如何更新代理配置？

A: 修改对应的 YAML 文件后，重新安装：

```bash
opencode agent uninstall treework
opencode agent install treework-agent.yaml
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
