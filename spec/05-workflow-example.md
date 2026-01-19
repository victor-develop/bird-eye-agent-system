# 完整工作流示例

本文档展示一个从需求到完成的端到端工作流。

---

## 场景

用户需求：**为后台管理系统添加 CSV 导入商品功能**

---

## Step 1: 初始化

### 用户输入
```
@treeWork init 为后台管理系统添加 CSV 导入商品功能，需要支持：
1. 上传 CSV 文件
2. 数据校验
3. 批量写入数据库
4. 导入结果反馈
```

### TreeWork 输出

```
建议创建目录：docs/missions/csv-import-feature/
确认此路径？(Y/n)
```

用户确认后：

```
已创建任务目录，初始文件如下：

csv-import-feature/
├── readme.md
├── references.yaml
└── progress.md

初始任务树：

   [..]Task1: CSV 导入功能
        │
        ├───►[..]Task1.1: 需求分析与设计
        │
        ├───►[..]Task1.2: 后端实现
        │
        ├───►[..]Task1.3: 前端实现
        │
        └───►[..]Task1.4: 集成测试

是否需要调整？
```

---

## Step 2: 分解子任务

### 用户输入
```
@treeWork subtask 后端 API 设计
```

### TreeWork 输出

```
已创建子任务 Task1.2.1

当前任务树：

   [..]Task1.2: 后端实现
        │
        └───►[..]Task1.2.1: 后端 API 设计

已创建：
- csv-import-feature/task-1.2/task-1.2.1/readme.md

readme.md 内容预览：
---
# Task: 1.2.1 - 后端 API 设计

## 任务目标
设计 CSV 导入功能的后端 API...
---

需要调整 readme.md 内容吗？
```

---

## Step 3: 用户执行 TaskRunner

用户将 `task-1.2.1/readme.md` 复制到新的 LLM 会话中执行...

TaskRunner 完成后在同目录生成 `result.md`：

```markdown
# Task Result: 1.2.1

## 执行状态
- [x] 成功

## 执行摘要
设计并实现了 CSV 导入的 GraphQL API，包括 Mutation 定义和 Resolver 骨架。

## 变更文件列表
| 文件路径 | 变更类型 | 说明 |
|----------|----------|------|
| internal/graph/schema.graphqls | 修改 | 添加 importProductsFromCSV mutation |
| internal/graph/resolver/import.go | 新增 | 导入功能 resolver |

## 验收检查
- [x] schema.graphqls 已更新
- [x] 生成代码已执行
- [x] Resolver 骨架已创建
```

---

## Step 4: 通知 TreeWork 任务完成

### 用户输入
```
@treeWork done
```

### TreeWork 输出

```
正在读取 task-1.2.1/result.md ...

✓ Task 1.2.1 执行成功

变更文件：
- internal/graph/schema.graphqls (修改)
- internal/graph/resolver/import.go (新增)

进度更新：

   [..]Task1.2: 后端实现
        │
        └───►[ok]Task1.2.1: 后端 API 设计

下一步建议：
1. @treeWork subtask - 创建下一个子任务
2. @treeWork next - 如果 1.2 已有预定子任务
3. @treeWork done - 如果后端实现已完成
```

---

## Step 5: 继续下一个任务

### 用户输入
```
@treeWork subtask 实现 CSV 解析逻辑
```

### TreeWork 输出

```
已创建子任务 Task1.2.2

   [..]Task1.2: 后端实现
        │
        ├───►[ok]Task1.2.1: 后端 API 设计
        │
        └───►[..]Task1.2.2: 实现 CSV 解析逻辑

已创建 task-1.2.2/readme.md
```

---

## 目录最终结构

```
csv-import-feature/
├── readme.md
├── references.yaml
├── progress.md
├── task-1.1/
│   ├── readme.md
│   └── result.md
├── task-1.2/
│   ├── readme.md
│   ├── task-1.2.1/
│   │   ├── readme.md
│   │   └── result.md
│   ├── task-1.2.2/
│   │   ├── readme.md
│   │   └── result.md
│   └── task-1.2.3/
│       └── readme.md
├── task-1.3/
│   └── readme.md
└── task-1.4/
    └── readme.md
```

---

## 关键要点

1. **TreeWork 只规划，不执行** - 具体代码工作交给 TaskRunner
2. **通过文件传递信息** - readme.md 下行，result.md 上行
3. **人工调度** - 用户负责在两个 Agent 间传递信息
4. **进度可视化** - ASCII 树状图始终反映最新状态
5. **灵活应对变化** - 支持阻塞、废弃、新增任务
