# references.yaml Scaffold Skill

生成符合 Bird-Eye 规范的 references.yaml 文件

## 用法

TreeWork Agent 为 mission 或 task 生成上下文引用文件

## 输入参数

- `context_files`: 文件引用列表，每个包含 `path` 和 `desc`

## 输出模板

```yaml
{{#each context_files}}
- path: {{path}}
  desc: {{desc}}
{{/each}}
```

## 生成规则

- 每个 task 目录有独立的 `references.yaml`
- TreeWork 根据任务性质从 mission 上下文中**裁剪生成**
- 只包含该任务**真正需要**的文件引用
- TaskRunner 按此清单读取上下文

## 示例

```javascript
{
  "context_files": [
    {
      "path": "docs/architecture-design.md",
      "desc": "系统整体架构"
    },
    {
      "path": "backend/internal/service/product.go",
      "desc": "商品服务现有实现"
    },
    {
      "path": "docs/prds/csv-import.md",
      "desc": "CSV 导入功能需求文档"
    }
  ]
}
```

输出：
```yaml
- path: docs/architecture-design.md
  desc: 系统整体架构
- path: backend/internal/service/product.go
  desc: 商品服务现有实现
- path: docs/prds/csv-import.md
  desc: CSV 导入功能需求文档
```
