# 使用最新的 Ubuntu 镜像作为基础
FROM ubuntu:latest

# 避免在安装过程中出现交互式对话框
ENV DEBIAN_FRONTEND noninteractive

# 替换为阿里云的 Ubuntu 镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装必要的依赖
RUN apt-get update
RUN apt-get install curl sudo openssh-client -y

# 创建一个新用户
RUN useradd -m blossom -s /bin/bash && \
    passwd -d blossom && \
    usermod -aG sudo blossom

# 切换用户
USER blossom
WORKDIR /home/blossom

# 下载文件
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-linux-x64-2.314.1.tar.gz
RUN tar xzf ./actions-runner.tar.gz
RUN rm ./actions-runner.tar.gz

# 安装 GitHub Actions Runner 依赖
RUN sudo ./bin/installdependencies.sh

COPY ./entrypoint.sh ./entrypoint.sh

ENTRYPOINT ./entrypoint.sh