# 使用 Node.js 作为基础镜像
FROM node:14 AS build

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY package*.json ./
RUN npm install
COPY . .

# 构建前端资源
RUN npm run build

# 使用 Nginx 作为生产环境服务器
FROM nginx:alpine

# 复制构建结果到 Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80