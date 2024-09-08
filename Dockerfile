# 使用Node.js镜像构建Vue项目
FROM node:16 AS build-stage

# 设置工作目录
WORKDIR /app

# 复制package.json和package-lock.json
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制项目文件
COPY . .

# 构建Vue项目
RUN npm run build

# 使用Nginx镜像提供静态文件
FROM nginx:alpine

# 复制构建结果到Nginx的html目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 复制nginx配置文件（可选）
# COPY nginx.conf /etc/nginx/nginx.conf

# 暴露Nginx的80端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]