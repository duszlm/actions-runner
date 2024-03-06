#!/bin/bash

# 定义一个函数来请求用户输入，确保输入不为空
prompt_for_input() {
    local prompt=$1 var_name=$2
    local input=""
    while [[ -z "$input" ]]; do
        read -p "$prompt" input
        if [[ -z "$input" ]]; then
            echo "输入不能为空，请重新输入"
        else
            eval $var_name="'$input'"
        fi
    done
}

echo "欢迎使用本脚本配置您的 GitHub Runner。"

# 请求输入实例名称
prompt_for_input "请输入实例名称：" name

# 请求输入 token
prompt_for_input "请输入 token：" token

# 请求输入组织名称
prompt_for_input "请输入组织名称：" org

# 请求输入项目名称（选填）
read -p "请输入项目名称（选填）：" repo

# 请求输入标签，逗号分隔（选填）
read -p "请输入标签，逗号分隔（选填）：" labels

# 请求输入分组，默认为 default
read -p "请输入分组，默认为 default：" group

if [ -z "$group" ]; then
  group="default"
fi

# 使用用户输入的值运行 Docker 容器
docker run \
    --name "ghsr-${name}" \
    -e name=$name \
    -e token=$token \
    -e org=$org \
    -e repo=$repo \
    -e labels=$labels \
    -e group=$group \
    --restart unless-stopped \
    -itd github-runner