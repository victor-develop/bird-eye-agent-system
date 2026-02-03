# Mission Root readme.md Scaffold Skill

生成符合 Bird-Eye 规范的任务根目录 readme.md

## 用法

当 TreeWork Agent 执行 `init` 或 `from` 命令时，调用此 skill 生成 `<mission-root>/readme.md`

## 输入参数

- `mission_name`: 任务名称
- `background`: 背景/问题
- `goal`: 目标
- `scope_include`: 包含范围列表
- `scope_exclude`: 不包含范围列表
- `constraints`: 约束列表

## 输出模板

```markdown
# Mission: {{mission_name}}

## 背景
{{background}}

## 目标
{{goal}}

## 范围
### 包含
{{#each scope_include}}
- {{this}}
{{/each}}

### 不包含
{{#each scope_exclude}}
- {{this}}
{{/each}}

## 关键约束
{{#each constraints}}
- {{this}}
{{/each}}

## 当前状态
初始创建

## 变更记录
| 日期 | 变更内容 |
|------|----------|
| {{current_date}} | 初始创建 |
```

## 约束检查

- **行数限制**: 不超过 150 行
- **外部引用**: 上下文涉及的文件应放到 `references.yaml`

## 示例

```javascript
{
  "mission_name": "CSV 导入功能",
  "background": "用户需要批量导入商品数据，当前只能手动添加",
  "goal": "实现 CSV 上传、解析、校验和批量导入功能",
  "scope_include": ["上传 CSV 文件", "数据校验", "批量写入数据库", "导入结果反馈"],
  "scope_exclude": ["数据导出", "批量修改"],
  "constraints": ["支持 CSV UTF-8 编码", "单次最多导入 1000 条", "必须有数据校验"]
}
```
