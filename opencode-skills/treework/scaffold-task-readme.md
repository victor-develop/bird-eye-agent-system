# Task readme.md Scaffold Skill

生成符合 Bird-Eye 规范的任务目录 readme.md

## 用法

TreeWork Agent 执行 `subtask`、`next` 或 `populate` 命令时调用

## 输入参数

- `task_id`: 任务编号（如 1.2.1）
- `task_name`: 任务名称
- `task_goal`: 任务目标
- `acceptance_criteria`: 验收标准列表
- `context`: 上下文信息
- `implementation_guide`: 实现指引（可选）
- `constraints`: 约束列表
- `previous_tasks`: 前置任务列表
- `next_tasks`: 后续任务列表

## 输出模板

```markdown
# Task: {{task_id}} - {{task_name}}

> 输出位置：任务完成后在填写本目录下的 `result.md`, 不要超过 150 行

## 任务目标
{{task_goal}}

## 验收标准
{{#each acceptance_criteria}}
- [ ] {{this}}
{{/each}}

## 上下文
{{context}}

参考文件见 `references.yaml`

## 实现指引
{{#if implementation_guide}}
{{implementation_guide}}
{{else}}
无
{{/if}}

## 约束
{{#each constraints}}
- {{this}}
{{/each}}

## 相关任务
{{#if previous_tasks}}
- 前置任务：{{join previous_tasks ", "}}
{{else}}
- 前置任务：无
{{/if}}

{{#if next_tasks}}
- 后续任务：{{join next_tasks ", "}}
{{else}}
- 后续任务：待规划
{{/if}}
```

## 关键原则

1. **目标明确**：读完应该知道"做什么"
2. **标准可验**：验收标准应该是可检查的
3. **上下文充分**：不需要额外搜索就能开始
4. **边界清晰**：知道什么不该做

## 示例

```javascript
{
  "task_id": "1.2.1",
  "task_name": "后端 API 设计",
  "task_goal": "设计 CSV 导入功能的 GraphQL API，包括 Mutation 定义和 Resolver 骨架",
  "acceptance_criteria": [
    "schema.graphqls 已添加 importProductsFromCSV mutation",
    "生成代码已执行",
    "Resolver 骨架已创建"
  ],
  "context": "现有产品服务位于 backend/internal/service/product.go，需要扩展导入功能",
  "implementation_guide": "1. 参考 existing mutations 定义\n2. 使用 go generate 生成 resolver 骨架",
  "constraints": [
    "使用 GraphQL",
    "遵循现有代码风格",
    "不要修改现有 schema"
  ],
  "previous_tasks": ["1.1"],
  "next_tasks": ["1.2.2"]
}
```

## 约束检查

- **行数限制**: 不超过 150 行
- **状态要求**: 任务完成后 TaskRunner 必须创建 result.md
