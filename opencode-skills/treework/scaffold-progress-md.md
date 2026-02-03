# progress.md Scaffold Skill

生成符合 Bird-Eye 规范的进度追踪文件

## 用法

TreeWork Agent 初始化或更新任务进度时使用

## 输入参数

- `current_focus`: 当前焦点任务
- `task_tree`: 任务树结构（ASCII 格式）
- `notes`: 备注信息（可选）

## 输出模板

```markdown
# Progress

## 当前焦点
{{current_focus}}

## 任务树

{{task_tree}}

## 状态图例
- [  ] 已规划（待准备）
- [..] 进行中（已创建 readme.md）
- [ok] 已完成
- [bin] 已废弃

## 备注
{{#if notes}}
{{notes}}
{{else}}
无
{{/if}}
```

## ASCII 图符号说明

```
符号        含义
──────────────────────────
│           顺序依赖（垂直）
▼           指向下一个任务
├───►       子任务分支（有后续兄弟）
└───►       子任务分支（最后一个）
```

## 示例

输入：
```javascript
{
  "current_focus": "Task 1.2.2.1 - GraphQL Schema",
  "task_tree": "   [ok]Task1.1: 需求分析\n        │\n        ▼\n   [..]Task1.2: 系统设计\n        │\n        ├───►[ok]Task1.2.1: 数据库设计\n        │\n        ├───►[..]Task1.2.2: API 设计\n        │         │\n        │         ├───►[..]Task1.2.2.1: GraphQL Schema\n        │         │\n        │         └───►[..]Task1.2.2.2: HTTP Endpoints\n        │\n        └───►[..]Task1.2.3: 前端设计"
}
```

输出：
```markdown
# Progress

## 当前焦点
Task 1.2.2.1 - GraphQL Schema

## 任务树

   [ok]Task1.1: 需求分析
        │
        ▼
   [..]Task1.2: 系统设计
        │
        ├───►[ok]Task1.2.1: 数据库设计
        │
        ├───►[..]Task1.2.2: API 设计
        │         │
        │         ├───►[..]Task1.2.2.1: GraphQL Schema
        │         │
        │         └───►[..]Task1.2.2.2: HTTP Endpoints
        │
        └───►[..]Task1.2.3: 前端设计

## 状态图例
- [  ] 已规划（待准备）
- [..] 进行中（已创建 readme.md）
- [ok] 已完成
- [bin] 已废弃

## 备注
无
```
