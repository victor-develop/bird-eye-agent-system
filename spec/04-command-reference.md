# 命令参考手册

本文档定义 TreeWork Agent 支持的所有命令。

---

## 命令格式

```
@treeWork <command> [args]
```

---

## 初始化命令

### init

创建任务根目录和初始文件。

**语法：**
```
@treeWork init <description>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| description | 是 | 任务描述 |

**行为：**
1. 建议目录路径，等待用户确认
2. 分析描述，规划初始任务树
3. 创建 `readme.md`, `references.yaml`, `progress.md`
4. 展示初始任务树供用户审阅

**示例：**
```
@treeWork init 实现 CSV 导入功能，支持批量导入商品数据
```

---

### from

从指定目录恢复或初始化 TreeWork 会话。

**语法：**
```
@treeWork from <directory>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| directory | 是 | 目录路径 |

**行为：**
1. 检查目录内容，判断目录类型
2. **如果包含 `progress.md`**（已有 TreeWork 任务）：
   - 读取 `readme.md`, `references.yaml`, `progress.md`
   - 恢复任务上下文，继续之前的工作
   - 显示当前进度状态
3. **如果只有 `readme.md` 无 `progress.md`**（TaskRunner 任务目录）：
   - 读取 `readme.md` 提取任务描述
   - 将该目录转换为 mission root
   - 创建 `progress.md`
   - 从 `readme.md` 中提取初始任务结构
4. **如果是普通目录**：
   - 将该目录作为 mission root
   - 执行普通 init 流程

**示例：**
```
# 恢复已有 TreeWork 任务
@treeWork from docs/missions/csv-import

# 从 TaskRunner 任务目录升级为 mission root
@treeWork from docs/tasks/implement-api

# 从普通目录开始新任务
@treeWork from docs/new-feature
```

**说明：**
此命令支持三种场景：恢复已有 TreeWork 会话、将单个 TaskRunner 任务升级为完整任务树、或在指定目录开始新任务。

---

## 任务规划命令

### plan

规划任务树结构（只规划，不创建文件）。

**语法：**
```
@treeWork plan <planning_description>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| planning_description | 是 | 规划描述，可以是自然语言 |

**行为：**
1. 根据描述更新 `progress.md` 中的 ASCII 任务树
2. 新规划的任务标记为 `[  ]`（待定）
3. **不创建目录和文件**，只更新任务树结构
4. 用户确认后可用 `populate` 命令批量生成文件

**示例：**
```
@treeWork plan 后端需要：1. API设计 2. CSV解析 3. 数据校验 4. 批量写入
```

**说明：**
`[  ]` 状态表示"已规划但未准备执行"，与 `[..]` 进行中不同。

---

### populate

为指定任务及其子任务批量创建执行文件。

**语法：**
```
@treeWork populate <task_id>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| task_id | 是 | 任务编号（如 1.2） |

**行为：**
1. 为指定任务及其所有子任务创建目录
2. 生成每个任务的 `readme.md` 和 `references.yaml`
3. 将任务状态从 `[  ]` 更新为 `[..]`

**示例：**
```
@treeWork populate 1.2
```

**说明：**
批量准备后，用户可以并行执行多个 TaskRunner。

---

## 任务管理命令

### subtask

为当前任务创建子任务（规划 + 创建文件）。

**语法：**
```
@treeWork subtask <task_description>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| task_description | 是 | 子任务描述 |

**行为：**
1. 确定子任务编号（基于当前任务）
2. 创建子任务目录 `task-X.X.X/`
3. 生成 `readme.md` 和 `references.yaml`
4. 更新 `progress.md`
5. 标记新任务为 `[..]`

**示例：**
```
@treeWork subtask 设计数据库 Schema
```

---

### next

完成当前任务，开始下一个任务。

**语法：**
```
@treeWork next [next_task_description]
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| next_task_description | 否 | 下一个任务描述（如果需要新建） |

**行为：**
1. 读取任务目录下的 `result.md`（如存在）
2. 将当前任务标记为 `[ok]`
3. 如果有预定的下一个任务，激活它
4. 如果提供了描述，创建新的同级任务
5. 更新 `progress.md`
6. 生成新任务的 `readme.md`

**示例：**
```
# 完成当前任务，继续预定的下一个
@treeWork next

# 完成当前任务，创建新任务
@treeWork next 实现数据校验逻辑
```

---

### done

标记当前任务为完成（不创建新任务）。

**语法：**
```
@treeWork done [summary]
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| summary | 否 | 完成总结 |

**行为：**
1. 读取任务目录下的 `result.md`（如存在）
2. 将当前任务标记为 `[ok]`
3. 更新 `progress.md`
4. 如有父任务，返回父任务上下文
5. 如果是根任务，报告整体完成

**说明：**
用户执行完 TaskRunner 后，直接用此命令通知 TreeWork。TreeWork 会自动读取 `result.md` 了解执行详情。

**示例：**
```
@treeWork done 数据库设计已完成，共创建 5 个表
```

---

### drop

废弃当前任务。

**语法：**
```
@treeWork drop <reason>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| reason | 是 | 废弃原因 |

**行为：**
1. 将当前任务及其子任务标记为 `[bin]`
2. 在 `progress.md` 添加废弃说明
3. 返回父任务上下文

**示例：**
```
@treeWork drop 需求变更，此功能不再需要
```

---

## 导航命令

### status

显示当前进度概览。

**语法：**
```
@treeWork status
```

**行为：**
1. 展示 `progress.md` 的当前状态
2. 显示统计信息（完成/进行中/阻塞）
3. 标注当前焦点任务

---

## 上下文管理命令

### ref

添加文件路径到 references.yaml。

**语法：**
```
@treeWork ref <path> [description]
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| path | 是 | 文件路径 |
| description | 否 | 为什么需要这个文件 |

**行为：**
1. 将路径添加到当前任务的 `references.yaml`
2. **不读取文件内容**，只记录路径
3. 确认已添加

**示例：**
```
@treeWork ref backend/internal/service/product.go 现有商品服务实现
```

---

### read

读取文件内容（唯一允许 TreeWork 读文件的命令）。

**语法：**
```
@treeWork read <path>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| path | 是 | 要读取的文件路径 |

**行为：**
1. 读取并展示文件内容
2. 自动将路径添加到 `references.yaml`

**说明：**
这是 TreeWork 唯一会读取项目文件的场景。通常用于：
- 用户需要 TreeWork 帮助理解某个文件后再规划任务
- 确认文件存在且内容符合预期

**示例：**
```
@treeWork read docs/architecture-design.md
```

---

### goto

跳转到指定任务。

**语法：**
```
@treeWork goto <task_id>
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| task_id | 是 | 任务编号（如 1.2.3） |

**行为：**
1. 切换当前焦点到指定任务
2. 显示该任务的 readme.md 和状态
3. 如果任务不存在，报错

**示例：**
```
@treeWork goto 1.2.3
```

---

## 结果同步命令

### receive

批量接收 TaskRunner 的执行结果。

**语法：**
```
@treeWork receive [task_ids...]
```

**参数：**
| 参数 | 必填 | 说明 |
|------|------|------|
| task_ids | 否 | 任务编号列表，空格分隔。省略则扫描所有 `[..]` 任务 |

**行为：**
1. 读取指定任务目录下的 `result.md`
2. 解析执行状态
3. 根据状态更新任务标记（成功 → `[ok]`，失败 → `[!!]`）
4. 汇总报告所有结果

**示例：**
```
# 接收单个任务结果
@treeWork receive 1.2.1

# 接收多个任务结果（并行执行后）
@treeWork receive 1.2.1 1.2.2 1.2.3

# 自动扫描所有进行中任务的结果
@treeWork receive
```

**说明：**
支持用户并行执行多个 TaskRunner 后批量同步状态。TreeWork 只负责规划，执行顺序（串行/并行）由用户决定。

---

## 命令速查表

| 命令 | 用途 | 示例 |
|------|------|------|
| init | 初始化任务 | `@treeWork init 实现用户登录` |
| plan | 规划任务树（不创建文件） | `@treeWork plan 需要A、B、C三步` |
| populate | 批量创建任务文件 | `@treeWork populate 1.2` |
| subtask | 创建子任务 | `@treeWork subtask 设计 API` |
| next | 完成并继续 | `@treeWork next` |
| done | 完成当前任务 | `@treeWork done` |
| drop | 废弃任务 | `@treeWork drop 需求取消` |
| status | 查看进度 | `@treeWork status` |
| goto | 跳转任务 | `@treeWork goto 1.2.3` |
| ref | 添加上下文引用 | `@treeWork ref src/xxx.go 说明` |
| read | 读取文件（唯一读文件命令） | `@treeWork read src/xxx.go` |
| receive | 批量接收结果 | `@treeWork receive 1.2.1 1.2.2` |
