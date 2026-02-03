#!/bin/bash

# Bird-Eye Agent System - OpenCode Agents 安装脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo "Bird-Eye Agent System 安装程序"
echo "======================================"
echo ""

# 检查 OpenCode 是否已安装
if ! command -v opencode &> /dev/null; then
    echo "错误: 未找到 opencode 命令"
    echo "请先安装 OpenCode CLI 工具"
    echo "访问: https://opencode.ai"
    exit 1
fi

echo "✓ 检测到 OpenCode CLI"
echo ""

# 安装 TreeWork Agent
echo "正在安装 TreeWork Agent..."
opencode agent install "$SCRIPT_DIR/treework-agent.yaml"
echo "✓ TreeWork Agent 安装完成"
echo ""

# 安装 TaskRunner Agent
echo "正在安装 TaskRunner Agent..."
opencode agent install "$SCRIPT_DIR/taskrunner-agent.yaml"
echo "✓ TaskRunner Agent 安装完成"
echo ""

# 验证安装
echo "验证安装..."
opencode agent list
echo ""

echo "======================================"
echo "安装完成！"
echo "======================================"
echo ""
echo "快速开始："
echo "  1. 初始化新任务:"
echo "     opencode agent run treework init \"你的任务描述\""
echo ""
echo "  2. 执行任务:"
echo "     cd task-1.1"
echo "     opencode agent run taskrunner execute"
echo ""
echo "详细文档: $SCRIPT_DIR/README.md"
echo ""
