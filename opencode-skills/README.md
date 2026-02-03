 # Bird-Eye Skills

 本目录包含 Bird-Eye Agent System 的文件生成技能（Skills），这些技能确保 agents 能够按照规范格式创建文件。

 ## 目录结构

 ```
 opencode-skills/
 ├── treework/
 │   ├── scaffold-mission-readme.md   # Mission 根目录 readme.md 模板
 │   ├── scaffold-references-yaml.md  # references.yaml 模板
 │   ├── scaffold-progress-md.md      # progress.md 模板
 │   └── scaffold-task-readme.md      # Task 目录 readme.md 模板
 └── taskrunner/
     └── scaffold-result-md.md        # result.md 模板
 ```

 ## Skill 用途

 ### TreeWork Skills

 | Skill | 用途 | 调用时机 |
 |-------|------|----------|
 | `treework-scaffold-mission-readme` | 生成 mission 根目录的 readme.md | `init`, `from` 命令 |
 | `treework-scaffold-references-yaml` | 生成 references.yaml | 所有需要上下文文件列表的命令 |
 | `treework-scaffold-progress-md` | 生成 progress.md | `init`, `from` 命令，或更新进度时 |
 | `treework-scaffold-task-readme` | 生成 task 目录的 readme.md | `subtask`, `populate`, `next` 命令 |

 ### TaskRunner Skills

 | Skill | 用途 | 调用时机 |
 |-------|------|----------|
 | `taskrunner-scaffold-result-md` | 生成 result.md | 任务执行完成后 |

 ## 如何使用

 ### 安装 Skills

 Skills 通过项目根目录的安装脚本自动安装：

 ```bash
 # 本地安装
 ./install.sh

 # 全局安装
 ./install.sh --global
 ```

 安装脚本会自动将这些 skill 文件转换为 OpenCode 可用的 SKILL.md 格式，并放置到正确的目录中。

 ### Agent 如何引用 Skills

 Agents 的 `system_prompt` 中已经包含了对这些 skills 的引用。例如，TreeWork Agent 的 system_prompt 中包含：

 ```
 ## 文件生成技能（Skills）

 你可以使用内置的 `skill` 工具来加载以下技能，用于生成符合规范的文件：

 ### init / from 命令
 使用 `treework-scaffold-mission-readme` skill 生成 mission 根目录的 readme.md
 ...
 ```

 ### 在 OpenCode 中使用

 安装后，agents 可以通过 OpenCode 的 `skill` 工具加载对应的技能：

 ```bash
 # 在 TreeWork Agent 中
 使用 treework-scaffold-task-readme skill 生成 task 目录的 readme.md

 # 在 TaskRunner Agent 中
 使用 taskrunner-scaffold-result-md skill 生成 result.md
 ```

 ### Skill 文件格式

 安装后的 SKILL.md 文件包含：

 1. **Frontmatter**：技能的元数据（name, description, license, compatibility）
 2. **技能内容**：用途说明、输入参数、输出模板、约束检查、示例

## 文件格式规范

所有 skills 生成的文件都遵循 `spec/03-file-formats.md` 中定义的格式规范：

- **readme.md** (mission 或 task): 不超过 150 行，包含目标、验收标准、上下文、约束等
- **references.yaml**: YAML 格式，列出上下文文件路径和说明
- **progress.md**: ASCII 树状图可视化任务进度
- **result.md**: 记录任务执行结果，包含状态、摘要、变更文件、验收检查等

## 为什么需要 Skills

1. **格式一致性**：确保所有生成的文件遵循相同的格式规范
2. **降低错误**：避免人工编写时的格式错误
3. **提高效率**：agent 可以快速生成符合规范的文件
4. **易于维护**：格式变更只需修改 skill 文件，无需修改 agent 代码

 ## 扩展 Skills

 如果需要添加新的文件生成技能：

 1. 在对应的目录（`treework/` 或 `taskrunner/`）创建新的 skill 文件
 2. 使用与现有 skill 相同的格式（用途、参数、模板、示例）
 3. 在 agent YAML 配置的 `system_prompt` 中添加对新 skill 的引用
 4. 在 `spec/03-file-formats.md` 中定义新的文件格式（如适用）
 5. 更新安装脚本以处理新的 skill

 ## 安装后的文件结构

 安装后，skills 会被转换为以下结构：

 **本地安装**：
 ```
 .opencode/skills/
 ├── treework-scaffold-mission-readme/
 │   └── SKILL.md
 ├── treework-scaffold-progress-md/
 │   └── SKILL.md
 ├── treework-scaffold-references-yaml/
 │   └── SKILL.md
 ├── treework-scaffold-task-readme/
 │   └── SKILL.md
 └── taskrunner-scaffold-result-md/
     └── SKILL.md
 ```

 **全局安装**：
 ```
 ~/.config/opencode/skills/
 ├── treework-scaffold-mission-readme/
 │   └── SKILL.md
 ├── treework-scaffold-progress-md/
 │   └── SKILL.md
 ├── treework-scaffold-references-yaml/
 │   └── SKILL.md
 ├── treework-scaffold-task-readme/
 │   └── SKILL.md
 └── taskrunner-scaffold-result-md/
     └── SKILL.md
 ```

 ## 相关文档

 - [OpenCode Agents 安装指南](../opencode-agents/README.md)
 - [TreeWork Agent 规范](../spec/01-treework-agent.md)
 - [TaskRunner Agent 规范](../spec/02-taskrunner-agent.md)
 - [文件格式定义](../spec/03-file-formats.md)
 - [命令参考手册](../spec/04-command-reference.md)
