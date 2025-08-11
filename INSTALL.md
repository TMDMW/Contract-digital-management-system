# 安装部署指南

## 系统要求

### 软件环境
- **Node.js**: 14.0 或更高版本
- **MySQL**: 5.7 或更高版本  
- **npm**: 6.0 或更高版本

### 硬件要求
- **内存**: 最少 2GB RAM
- **存储**: 最少 5GB 可用空间
- **网络**: 能够访问MySQL数据库服务器

## 详细安装步骤

### 1. 环境准备

#### 安装Node.js
```bash
# Windows: 下载并安装 https://nodejs.org/
# Ubuntu/Debian:
sudo apt update
sudo apt install nodejs npm

# CentOS/RHEL:
sudo yum install nodejs npm
```

#### 验证安装
```bash
node --version  # 应显示 v14.0.0 或更高
npm --version   # 应显示 6.0.0 或更高
```

### 2. 数据库配置

#### 连接数据库
```bash
mysql -h localhost -u ht -p
```

#### 创建数据库
```sql
CREATE DATABASE IF NOT EXISTS contract_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 导入初始化脚本
```bash
mysql -h localhost -u ht -p contract_management < database/init.sql
```

#### 验证数据库
```sql
USE contract_management;
SHOW TABLES;
-- 应该显示: users, merchants, contracts, contract_keywords
```

### 3. 项目安装

#### 下载项目
```bash
# 如果有Git仓库
git clone <repository-url>
cd contract-management

# 或者解压项目文件
unzip contract-management.zip
cd contract-management
```

#### 安装依赖
```bash
# 安装所有依赖（推荐）
npm run install-all

# 或者分别安装
npm install                    # 根目录依赖
cd backend && npm install      # 后端依赖
cd ../frontend && npm install  # 前端依赖
```

### 4. 配置文件

#### 后端配置 (backend/.env)
```env
# 数据库配置
DB_HOST=localhost
DB_USER=ht
DB_PASSWORD=Tjksyy123
DB_NAME=contract_management

# JWT密钥（请修改为随机字符串）
JWT_SECRET=your_super_secret_jwt_key_here_change_this

# 服务器端口
PORT=3000
```

#### 前端配置 (frontend/vue.config.js)
```javascript
module.exports = {
  devServer: {
    port: 8080,
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true
      }
    }
  }
}
```

### 5. 启动应用

#### 开发模式
```bash
# 同时启动前后端
npm run dev

# 或者分别启动
npm run server  # 后端服务 (端口3000)
npm run client  # ���端服务 (端口8080)
```

#### 生产模式
```bash
# 构建前端
cd frontend
npm run build

# 启动后端
cd ../backend
npm start
```

### 6. 验证安装

#### 检查服务状态
```bash
# 检查后端API
curl http://localhost:3000/api/merchants

# 检查前端页面
# 浏览器访问: http://localhost:8080
```

#### 登录测试
- 用户名: `admin`
- 密码: `password`

## 生产环境部署

### 使用PM2部署
```bash
# 安装PM2
npm install -g pm2

# 启动后端服务
cd backend
pm2 start server.js --name contract-backend

# 构建并部署前端
cd ../frontend
npm run build
# 将dist目录部署到Web服务器
```

### 使用Docker部署
```dockerfile
# Dockerfile示例
FROM node:14-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
EXPOSE 3000

CMD ["npm", "start"]
```

### Nginx配置
```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端静态文件
    location / {
        root /path/to/frontend/dist;
        try_files $uri $uri/ /index.html;
    }

    # 后端API代理
    location /api {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # 文件上传目录
    location /uploads {
        alias /path/to/uploads;
    }
}
```

## 常见问题解决

### 端口占用
```bash
# 查看端口占用
netstat -ano | findstr :3000
netstat -ano | findstr :8080

# 杀死进程
taskkill /PID <进程ID> /F
```

### 权限问题
```bash
# Linux/Mac 设置上传目录权限
chmod 755 uploads/
chown -R www-data:www-data uploads/
```

### 数据库连接问题
1. 检查MySQL服务是否启动
2. 验证网络连接: `telnet localhost 3306`
3. 检查用户权限: `SHOW GRANTS FOR 'ht'@'%';`
4. 检查防火墙设置

### 依赖安装失败
```bash
# 清理缓存
npm cache clean --force

# 使用淘宝镜像
npm config set registry https://registry.npm.taobao.org

# 重新安装
rm -rf node_modules package-lock.json
npm install
```

## 性能优化

### 数据库优化
```sql
-- 添加索引
CREATE INDEX idx_contracts_title ON contracts(title);
CREATE INDEX idx_contracts_merchant ON contracts(merchant_id);
CREATE INDEX idx_contracts_date ON contracts(contract_date);
CREATE FULLTEXT INDEX idx_contracts_content ON contracts(title, ocr_content);
```

### 文件存储优化
- 考虑使用对象存储服务（如阿里云OSS）
- 实现文件压缩和缩略图生成
- 配置CDN加速文件访问

### 应用优化
- 启用Gzip压缩
- 配置缓存策略
- 使用连接池优化数据库连接

## 备份策略

### 数据库备份
```bash
# 每日备份脚本
mysqldump -h localhost -u ht -p contract_management > backup_$(date +%Y%m%d).sql
```

### 文件备份
```bash
# 备份上传文件
tar -czf uploads_backup_$(date +%Y%m%d).tar.gz uploads/
```

## 监控和日志

### 应用监控
- 使用PM2监控进程状态
- 配置日志轮转
- 设置错误报警

### 性能监控
- 监控数据库连接数
- 跟踪API响应时间
- 监控磁盘空间使用

## 安全建议

1. **修改默认密码**: 更改admin用户密码
2. **JWT密钥**: 使用强随机字符串作为JWT_SECRET
3. **HTTPS**: 生产环境启用SSL证书
4. **防火墙**: 限制数据库访问IP
5. **文件验证**: 严格验证上传文件类型
6. **定期更新**: 保持依赖包最新版本