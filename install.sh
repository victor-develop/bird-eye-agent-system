#!/bin/bash

# Bird-Eye Agent System 安装脚本
# 安装 TreeWork 和 TaskRunner agents 及相关 skills

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认配置
GLOBAL=false
OPENCODE_DIR="${OPENCODOPATH:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 显示帮助信息
show_help() {
    cat << EOF
Bird-Eye Agent System 安装脚本

用法:
    $0 [选项]

选项:
    --global              全局安装到 ~/.config/opencode
    -h, --help            显示此帮助信息

环境变量:
    OPENCODOPATH          自定义 OpenCode 配置目录 (默认: ~/.config/opencode)

安装位置:
    本地模式:     当前目录的 .opencode/
    全局模式:     ~/.config/opencode/ 或 \$OPENCODOPATH

示例:
    $0                   # 本地安装到当前项目的 .opencode/
    $0 --global          # 全局安装到 ~/.config/opencode/
    OPENCODOPATH=~/.opencode $0 --global  # 安装到自定义目录
EOF
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --global)
            GLOBAL=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}未知选项: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# 确定目标目录
if [ "$GLOBAL" = true ]; then
    # 全局模式
    if [ -z "$OPENCODOPATH" ]; then
        OPENCODOPATH="$HOME/.config/opencode"
    fi
    BASE_DIR="$OPENCODOPATH"
else
    # 本地模式
    BASE_DIR="$(pwd)/.opencode"
fi

# 创建子目录
AGENTS_DIR="$BASE_DIR/agents"
SKILLS_DIR="$BASE_DIR/skills"

# 显示安装信息
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Bird-Eye Agent System 安装程序${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
if [ "$GLOBAL" = true ]; then
    echo -e "安装模式: ${YELLOW}全局${NC}"
else
    echo -e "安装模式: ${YELLOW}本地${NC}"
fi
echo -e "目标目录: ${GREEN}$BASE_DIR${NC}"
echo ""

# 确认安装
read -p "是否继续安装? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}安装已取消${NC}"
    exit 0
fi

# 创建目录
echo -e "${BLUE}创建目录...${NC}"
mkdir -p "$AGENTS_DIR"
mkdir -p "$SKILLS_DIR"
echo -e "${GREEN}✓ 目录创建完成${NC}"
echo ""

# 函数: 将 YAML agent 转换为 Markdown 格式
convert_yaml_to_md_agent() {
    local yaml_file="$1"
    local output_file="$2"

    # 使用 Python 解析 YAML 并转换为 Markdown 格式
    python3 -c "
import yaml
import sys

with open('$yaml_file', 'r') as f:
    data = yaml.safe_load(f)

# 提取 description（多行字符串）
description = data.get('description', '')
if isinstance(description, list):
    description = ' '.join(description)

# 提取 system_prompt
system_prompt = data.get('system_prompt', '')
if isinstance(system_prompt, list):
    system_prompt = '\n'.join(system_prompt)

# 确定模式（subagent 或 primary）
mode = 'subagent' if data.get('role') else 'primary'

# 生成 Markdown frontmatter
output = f'''---
description: {description}
mode: {mode}
---
{system_prompt}
'''

with open('$output_file', 'w') as f:
    f.write(output)
"
}

# 函数: 创建 SKILL.md
create_skill() {
    local skill_name="$1"
    local skill_file="$2"
    local output_dir="$SKILLS_DIR/$skill_name"
    local output_file="$output_dir/SKILL.md"

    mkdir -p "$output_dir"

    # 将 skill 文件转换为 SKILL.md 格式
    # 提取描述（从 skill 文件中提取）
    local description=$(grep -m 1 "生成符合" "$skill_file" | sed 's/^生成符合 //' | sed 's/的.*//')
    if [ -z "$description" ]; then
        description=$(head -1 "$skill_file" | sed 's/^# //')
    fi

    # 创建 SKILL.md frontmatter
    cat > "$output_file" << EOF
---
name: $skill_name
description: $description
license: MIT
compatibility: opencode
---
EOF

    # 追加 skill 文件内容
    cat "$skill_file" >> "$output_file"

    echo -e "${GREEN}✓ 已创建 skill: $skill_name${NC}"
}

# 安装 Agents
echo -e "${BLUE}安装 Agents...${NC}"

# 转换并安装 TreeWork Agent
echo "  正在安装 TreeWork Agent..."
convert_yaml_to_md_agent "$SCRIPT_DIR/opencode-agents/treework-agent.yaml" "$AGENTS_DIR/treework.md"
echo -e "${GREEN}  ✓ TreeWork Agent${NC}"

# 转换并安装 TaskRunner Agent
echo "  正在安装 TaskRunner Agent..."
convert_yaml_to_md_agent "$SCRIPT_DIR/opencode-agents/taskrunner-agent.yaml" "$AGENTS_DIR/taskrunner.md"
echo -e "${GREEN}  ✓ TaskRunner Agent${NC}"

echo ""

# 安装 Skills
echo -e "${BLUE}安装 Skills...${NC}"

# TreeWork Skills
echo "  正在安装 TreeWork Skills..."
create_skill "treework-scaffold-mission-readme" "$SCRIPT_DIR/opencode-skills/treework/scaffold-mission-readme.md"
create_skill "treework-scaffold-progress-md" "$SCRIPT_DIR/opencode-skills/treework/scaffold-progress-md.md"
create_skill "treework-scaffold-references-yaml" "$SCRIPT_DIR/opencode-skills/treework/scaffold-references-yaml.md"
create_skill "treework-scaffold-task-readme" "$SCRIPT_DIR/opencode-skills/treework/scaffold-task-readme.md"

# TaskRunner Skills
echo "  正在安装 TaskRunner Skills..."
create_skill "taskrunner-scaffold-result-md" "$SCRIPT_DIR/opencode-skills/taskrunner/scaffold-result-md.md"

echo ""

# 完成
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}安装完成！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "已安装到: ${GREEN}$BASE_DIR${NC}"
echo ""
echo -e "已安装的 Agents:"
echo -e "  - ${GREEN}treework${NC}     (任务规划 Agent)"
echo -e "  - ${GREEN}taskrunner${NC}  (任务执行 Agent)"
echo ""
echo -e "已安装的 Skills:"
echo -e "  - ${GREEN}treework-scaffold-mission-readme${NC}"
echo -e "  - ${GREEN}treework-scaffold-progress-md${NC}"
echo -e "  - ${GREEN}treework-scaffold-references-yaml${NC}"
echo -e "  - ${GREEN}treework-scaffold-task-readme${NC}"
echo -e "  - ${GREEN}taskrunner-scaffold-result-md${NC}"
echo ""
echo -e "使用方法:"
echo -e "  在 OpenCode 中使用 ${YELLOW}@treework${NC} 或 ${YELLOW}@taskrunner${NC} 调用这些 agents"
echo -e "  TreeWork 可以使用 ${YELLOW}skill${NC} 工具加载对应的 skills"
echo ""
