# TaskRunner result.md Scaffold Skill

生成符合 Bird-Eye 规范的任务执行结果文件

## 用法

TaskRunner Agent 完成任务后调用此 skill 生成 result.md

## 输入参数

- `task_id`: 任务编号
- `status`: 执行状态（"success"/"partial"/"failed"）
- `summary`: 执行摘要（2-3 句话）
- `changed_files`: 变更文件列表，每个包含 `path`, `type`, `desc`
- `decisions`: 关键决策（可选）
- `remaining_issues`: 遗留问题（可选）
- `acceptance_check`: 验收检查结果（列表，每项为 `{criterion, passed, reason}`）

## 输出模板

```markdown
# Task Result: {{task_id}}

## 执行状态
{{#eq status "success"}}- [x] 成功{{/eq}}
{{#eq status "partial"}}- [ ] 部分成功{{/eq}}
{{#eq status "failed"}}- [ ] 失败{{/eq}}

## 执行摘要
{{summary}}

## 变更文件列表
| 文件路径 | 变更类型 | 说明 |
|----------|----------|------|
{{#each changed_files}}
| {{path}} | {{type}} | {{desc}} |
{{/each}}

## 关键决策
{{#if decisions}}
{{#each decisions}}
{{@index}}. {{this}}
{{/each}}
{{else}}
无
{{/each}}

## 遗留问题
{{#if remaining_issues}}
{{#each remaining_issues}}
{{@index}}. {{this}}
{{/each}}
{{else}}
无
{{/if}}

## 验收检查
{{#each acceptance_check}}
{{#if passed}}- [x] {{criterion}}{{else}}- [ ] {{criterion}} (原因: {{reason}}){{/if}}
{{/each}}
```

## 变更类型说明

| 类型 | 说明 |
|------|------|
| 新增 | 创建了新文件 |
| 修改 | 修改了现有文件 |
| 删除 | 删除了文件 |
| 重命名 | 文件重命名或移动 |

## 示例

```javascript
{
  "task_id": "1.2.1",
  "status": "success",
  "summary": "设计并实现了 CSV 导入的 GraphQL API，包括 Mutation 定义和 Resolver 骨架。",
  "changed_files": [
    {
      "path": "internal/graph/schema.graphqls",
      "type": "修改",
      "desc": "添加 importProductsFromCSV mutation"
    },
    {
      "path": "internal/graph/resolver/import.go",
      "type": "新增",
      "desc": "导入功能 resolver"
    }
  ],
  "decisions": [
    "使用 FileUpload GraphQL 类型处理文件上传",
    "校验逻辑在 Resolver 层处理，不在中间层"
  ],
  "remaining_issues": [],
  "acceptance_check": [
    { "criterion": "schema.graphqls 已更新", "passed": true },
    { "criterion": "生成代码已执行", "passed": true },
    { "criterion": "Resolver 骨架已创建", "passed": true }
  ]
}
```

## 约束检查

- **行数限制**: 不超过 150 行
- **必须创建**: 任务完成后必须创建 result.md
- **状态更新**: TreeWork 读取 result.md 后会更新 progress.md 中的任务状态
