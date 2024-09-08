#!/bin/bash

echo "link server..."

# 确保脚本具有执行权限
chmod +x "$0"

# 定义变量
REPO_URL="https://github.com/fishcoderman/fishcoderman.github.io.git"
PROJECT_DIR="/project/vue"
IMAGE_NAME="vue_image"
CONTAINER_NAME="vue_container"
DOCKERFILE_PATH="."  # Dockerfile 所在路径
DOCKER_COMPOSE_PATH="."       # docker-compose.yml 所在路径

# 更新代码
cd /project || exit


# 检查项目目录是否存在
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Cloning repository..."
    mkdir $PROJECT_DIR
    cd $PROJECT_DIR
    git clone $REPO_URL 
else
    echo "Updating repository..."
    cd $PROJECT_DIR || exit
    git pull origin main
fi

# 构建 Docker 镜像
echo "Building Docker image..."
docker build -t $IMAGE_NAME:latest -f $DOCKERFILE_PATH/Dockerfile $DOCKERFILE_PATH

# 停止并移除旧的容器（如果存在）
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "Stopping and removing existing container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# 运行新的容器
echo "Running new container..."
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME:latest

# 可选：使用 docker-compose 进行管理
# cd $DOCKER_COMPOSE_PATH
# docker-compose down
# docker-compose up -d