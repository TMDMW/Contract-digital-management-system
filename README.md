# 提莫合同数字化管理系统

基于Vue.js和Node.js的现代化合同管理系统，支持OCR文字识别、全文搜索、权限管理等功能。

## 📋 目录

- [系统概述](#系统概述)
- [功能特性](#功能特性)
- [技术栈](#技术栈)
- [系统架构](#系统架构)
- [安装部署](#安装部署)
- [配置说明](#配置说明)
- [使用指南](#使用指南)
- [开发记录](#开发记录)
- [常见问题](#常见问题)

## 🎯 系统概述

提莫合同数字化管理系统是一个现代化的企业级合同管理解决方案，旨在帮助企业实现合同的数字化管理、智能识别和高效检索。

### 主要解决的问题

1. **合同管理效率低**：传统纸质合同管理效率低下，查找困难
2. **文字识别需求**：扫描件PDF需要转换为可搜索的文本内容
3. **权限控制复杂**：不同部门和用户需要不同的访问权限
4. **审计追踪缺失**：缺乏完整的操作日志和审计功能

## ✨ 功能特性

### 🔐 用户认证与权限管理
- **多角色支持**：管理员、普通用户等不同角色
- **部门权限控制**：基于部门的细粒度权限管理
- **操作审计**：完整的用户操作日志记录
- **企业微信登录**：支持企业微信单点登录，移动端友好

### 📄 合同管理
- **合同上传**：支持PDF格式合同文件上传
- **合同编辑**：支持合同信息的在线编辑
- **合同查看**：支持合同详情查看和PDF预览
- **合同删除**：支持合同的安全删除

### 🔍 智能OCR识别
- **文本型PDF处理**：自动提取PDF中的文本内容
- **扫描件识别**：使用阿里云OCR识别扫描件PDF中的文字
- **异步处理**：OCR处理采用异步模式，不阻塞用户操作
- **进度跟踪**：实时显示OCR处理进度

### 🔎 全文搜索
- **关键词搜索**：支持合同标题、内容、商家名称搜索
- **高级筛选**：支持按日期范围、金额范围、商家等条件筛选
- **搜索结果高亮**：搜索结果中关键词高亮显示

### 🏢 商家管理
- **商家信息管理**：支持商家信息的增删改查
- **合同关联**：合同与商家信息关联管理

### 📊 系统监控
- **操作日志**：详细的系统操作日志
- **统计分析**：用户活跃度、操作统计等
- **错误追踪**：系统错误日志和追踪

### 📱 移动端支持
- **响应式设计**：完美适配手机、平板等移动设备
- **触摸优化**：针对触摸操作优化的界面交互
- **移动端菜单**：专为移动端设计的侧边栏菜单
- **企业微信集成**：支持在企业微信客户端中使用

## 🛠 技术栈

### 前端技术
- **Vue.js 2.x**：渐进式JavaScript框架
- **Element UI**：基于Vue的桌面端组件库
- **Vue Router**：Vue.js官方路由管理器
- **Vuex**：Vue.js状态管理模式
- **Axios**：基于Promise的HTTP库

### 后端技术
- **Node.js**：JavaScript运行时环境
- **Express.js**：快速、开放、极简的Web开发框架
- **MySQL**：关系型数据库管理系统
- **JWT**：JSON Web Token身份验证
- **Multer**：Node.js中间件，用于处理文件上传

### OCR技术
- **阿里云OCR**：专业的云端文字识别服务
- **pdf-parse**：PDF文本提取库
- **PyMuPDF**：PDF处理Python库

### 开发工具
- **Nodemon**：Node.js开发工具，自动重启服务
- **Vue CLI**：Vue.js开发工具链
- **ESLint**：JavaScript代码检查工具

## 🏗 系统架构

```
提莫合同管理系统
├── 前端 (Vue.js)
│   ├── 用户界面层
│   ├── 路由管理
│   ├── 状态管理
│   └── HTTP请求层
├── 后端 (Node.js + Express)
│   ├── API接口层
│   ├── 业务逻辑层
│   ├── 数据访问层
│   └── 中间件层
├── 数据库 (MySQL)
│   ├── 用户表
│   ├── 合同表
│   ├── 商家表
│   ├── 权限表
│   └── 日志表
├── OCR服务 (阿里云OCR + Python)
│   ├── PDF文本提取
│   ├── 图像识别
│   └── 结果处理
└── 文件存储
    └── 上传文件目录
```

## 🚀 安装部署

### 环境要求

- **Node.js**: >= 14.0.0
- **Python**: >= 3.7.0
- **MySQL**: >= 5.7.0
- **操作系统**: Windows 10/11, Linux, macOS

### 1. 克隆项目

```bash
git clone <repository-url>
cd contract-management-system
```

### 2. 数据库初始化

```sql
-- 创建数据库
CREATE DATABASE ht CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 导入数据库结构
mysql -u root -p ht < database/init.sql
```

### 3. 后端部署

#### 3.1 安装Node.js依赖

```bash
cd backend
npm install
```

#### 3.2 安装Python依赖

```bash
pip install -r requirements.txt
```

#### 3.3 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑环境变量文件
nano .env
```

配置内容：
```env
# 数据库配置
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=ht

# JWT密钥
JWT_SECRET=your_complex_jwt_secret_here

# 阿里云OCR配置
ALIBABA_CLOUD_ACCESS_KEY_ID=your_access_key_id
ALIBABA_CLOUD_ACCESS_KEY_SECRET=your_access_key_secret

# 企业微信配置
WECHAT_WORK_CORP_ID=your_corp_id_here
WECHAT_WORK_AGENT_ID=your_agent_id_here
WECHAT_WORK_SECRET=your_secret_here
WECHAT_WORK_REDIRECT_URI=http://your-domain.com/auth/wechat/callback

# 服务器端口
PORT=3000
```

#### 3.4 启动后端服务

```bash
# 开发环境
npm run dev

# 生产环境
npm start
```

### 4. 前端部署

#### 4.1 安装依赖

```bash
cd frontend
npm install
```

#### 4.2 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑环境变量文件
nano .env
```

配置内容：
```env
# 生产环境API地址
VUE_APP_API_BASE_URL=http://your-domain.com/api
VUE_APP_UPLOAD_BASE_URL=http://your-domain.com/uploads
```

#### 4.3 开发环境启动

```bash
npm run serve
```

#### 4.4 生产环境打包

```bash
npm run build
```

## 🐋 宝塔面板部署

### 1. 环境准备

在宝塔面板中安装以下软件：
- **Nginx**: >= 1.18
- **Node.js**: >= 14.0
- **Python**: >= 3.7
- **MySQL**: >= 5.7
- **PM2管理器**

### 2. 后端部署

#### 2.1 上传代码

```bash
# 将backend文件夹上传到服务器
/www/wwwroot/your-domain.com/backend/
```

#### 2.2 安装依赖

```bash
cd /www/wwwroot/your-domain.com/backend
npm install --production
pip install -r requirements.txt
```

#### 2.3 配置环境变量

```bash
# 编辑.env文件
nano .env
```

#### 2.4 使用PM2启动

在宝塔面板的PM2管理器中：
- **项目名称**: contract-backend
- **启动文件**: server.js
- **项目目录**: /www/wwwroot/your-domain.com/backend
- **运行模式**: cluster
- **实例数量**: 2

### 3. 前端部署

#### 3.1 本地打包

```bash
cd frontend
npm run build
```

#### 3.2 上传文件

将`dist`文件夹中的所有文件上传到：
```
/www/wwwroot/your-domain.com/
```

#### 3.3 配置Nginx

在宝塔面板中配置网站的Nginx：

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /www/wwwroot/your-domain.com;
    index index.html;

    # 前端路由支持
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API代理
    location /api/ {
        proxy_pass http://127.0.0.1:3000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 文件上传访问
    location /uploads/ {
        proxy_pass http://127.0.0.1:3000/uploads/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # 静态文件缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## 🖥 Windows系统部署

### 1. 环境安装

#### 1.1 安装Node.js
- 下载并安装Node.js LTS版本
- 验证安装：`node --version`

#### 1.2 安装Python
- 下载并安装Python 3.7+
- 添加到系统PATH
- 验证安装：`python --version`

#### 1.3 安装MySQL
- 下载并安装MySQL Community Server
- 创建数据库和用户

### 2. 项目部署

#### 2.1 克隆项目

```cmd
git clone <repository-url>
cd contract-management-system
```

#### 2.2 后端部署

```cmd
cd backend
npm install
pip install -r requirements.txt

# 配置环境变量
copy .env.example .env
# 编辑.env文件

# 启动服务
npm start
```

#### 2.3 前端部署

```cmd
cd frontend
npm install

# 开发环境
npm run serve

# 生产环境打包
npm run build
```

### 3. 使用PM2管理进程

```cmd
# 安装PM2
npm install -g pm2

# 启动后端服务
cd backend
pm2 start server.js --name contract-backend

# 查看进程状态
pm2 status

# 设置开机自启
pm2 startup
pm2 save
```

### 4. 使用IIS部署前端

1. 启用IIS和相关功能
2. 将打包后的文件复制到IIS网站目录
3. 配置URL重写规则支持Vue Router
4. 配置反向代理到后端API

## ⚙️ 配置说明

### 后端配置文件

配置文件位置：`backend/config/app.config.js`

```javascript
module.exports = {
  // 服务器配置
  server: {
    port: 3000,
    host: '0.0.0.0',
    cors: {
      origin: ['http://localhost:8080'],
      credentials: true
    }
  },

  // 数据库配置
  database: {
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'ht'
  },

  // 阿里云OCR配置
  aliyun: {
    ocr: {
      accessKeyId: 'your_key_id',
      accessKeySecret: 'your_key_secret'
    }
  }
}
```

### 前端配置文件

配置文件位置：`frontend/src/config/app.config.js`

```javascript
export default {
  // API配置
  api: {
    baseURL: 'http://localhost:3000/api',
    timeout: 30000
  },

  // 文件上传配置
  upload: {
    baseURL: 'http://localhost:3000/uploads',
    maxFileSize: 10 * 1024 * 1024
  }
}
```

## 📖 使用指南

### 1. 系统登录

- 访问系统首页
- 使用管理员账号登录：admin/password
- 首次登录建议修改密码

### 2. 合同管理

#### 上传合同
1. 点击"合同管理" → "上传合同"
2. 填写合同基本信息
3. 选择PDF文件上传
4. 系统自动进行OCR识别

#### 查看合同
1. 在合同列表中点击合同标题
2. 查看合同详细信息
3. 可以下载原始PDF文件

### 3. 搜索功能

#### 关键词搜索
1. 访问"合同搜索"页面
2. 输入关键词进行搜索
3. 支持搜索标题、内容、商家名称

#### 高级搜索
1. 设置日期范围筛选
2. 设置金额范围筛选
3. 选择特定商家筛选

### 4. 权限管理

#### 用户管理
1. 访问"权限管理"页面
2. 查看用户列表
3. 编辑用户权限

#### 部门管理
1. 添加新部门
2. 设置部门描述
3. 管理部门权限

### 5. 系统日志

1. 访问"系统日志"页面
2. 查看操作日志统计
3. 筛选和搜索日志记录

## 📝 开发记录

### 主要功能开发历程

#### 1. 基础架构搭建
- ✅ 前后端项目初始化
- ✅ 数据库设计和创建
- ✅ 用户认证系统
- ✅ 基础路由和页面

#### 2. 合同管理功能
- ✅ 合同上传功能
- ✅ 合同列表展示
- ✅ 合同详情查看
- ✅ 合同编辑和删除

#### 3. OCR识别系统
- ✅ PDF文本提取（pdf-parse）
- ✅ 本地OCR识别（Tesseract.js）→ 已弃用
- ✅ 阿里云OCR集成
- ✅ 异步处理和进度跟踪

#### 4. 搜索功能
- ✅ 基础关键词搜索
- ✅ 高级筛选功能
- ✅ 搜索结果高亮
- ✅ 全文搜索支持

#### 5. 权限管理系统
- ✅ 用户角色管理
- ✅ 部门权限控制
- ✅ 细粒度权限设置

#### 6. 系统监控
- ✅ 操作日志记录
- ✅ 日志查看和筛选
- ✅ 统计分析功能

#### 7. UI/UX优化
- ✅ 响应式设计
- ✅ 现代化界面风格
- ✅ 用户体验优化
- ✅ 布局问题修复

### 技术难点解决

#### 1. OCR识别优化
**问题**：本地Tesseract.js识别准确率低，Windows兼容性差
**解决方案**：
- 集成阿里云OCR API
- 使用PyMuPDF进行PDF转图片
- 实现异步处理机制

#### 2. 编码问题解决
**问题**：Python脚本输出乱码，JSON解析失败
**解决方案**：
- 设置Python输出编码为UTF-8
- 清理文本中的控制字符
- 改进Node.js的JSON解析逻辑

#### 3. 权限控制复杂性
**问题**：多层级权限控制实现复杂
**解决方案**：
- 设计灵活的权限表结构
- 实现中间件权限检查
- 前端路由权限控制

#### 4. 文件上传和存储
**问题**：大文件上传和存储管理
**解决方案**：
- 使用Multer处理文件上传
- 实现文件大小限制
- 静态文件服务配置

### 性能优化记录

1. **数据库优化**
   - 添加必要的索引
   - 优化查询语句
   - 实现分页查询

2. **前端优化**
   - 组件懒加载
   - 图片压缩和缓存
   - API请求优化

3. **后端优化**
   - 异步处理OCR任务
   - 缓存机制实现
   - 错误处理优化

## ❓ 常见问题

### 1. 安装问题

**Q: npm install失败怎么办？**
A: 
```bash
# 清除缓存
npm cache clean --force

# 使用淘宝镜像
npm config set registry https://registry.npm.taobao.org

# 重新安装
npm install
```

**Q: Python依赖安装失败？**
A:
```bash
# 升级pip
python -m pip install --upgrade pip

# 使用清华镜像
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### 2. 运行问题

**Q: 后端启动失败？**
A: 检查以下项目：
- 数据库连接配置是否正确
- 端口是否被占用
- 环境变量是否设置正确

**Q: OCR识别失败？**
A: 检查以下项目：
- 阿里云AccessKey是否正确
- Python环境是否正常
- 网络连接是否正常

**Q: 前端页面空白？**
A: 检查以下项目：
- API地址配置是否正确
- 浏览器控制台是否有错误
- 后端服务是否正常运行

### 3. 部署问题

**Q: 宝塔面板部署后无法访问？**
A: 检查以下项目：
- Nginx配置是否正确
- 防火墙端口是否开放
- PM2进程是否正常运行

**Q: 文件上传失败？**
A: 检查以下项目：
- uploads目录权限是否正确
- 文件大小是否超过限制
- 磁盘空间是否充足

### 4. 功能问题

**Q: 搜索功能不工作？**
A: 检查以下项目：
- OCR识别是否完成
- 数据库中是否有内容数据
- 搜索关键词是否正确

**Q: 权限设置不生效？**
A: 检查以下项目：
- 用户是否重新登录
- 权限配置是否正确
- 缓存是否清除

## 📞 技术支持

如果在使用过程中遇到问题，可以通过以下方式获取帮助：

1. **查看日志**：检查系统日志和错误信息
2. **检查配置**：确认所有配置文件设置正确
3. **重启服务**：尝试重启前后端服务
4. **清除缓存**：清除浏览器缓存和npm缓存

## 📄 许可证

本项目采用MIT许可证，详情请查看LICENSE文件。

## 🤝 贡献指南

欢迎提交Issue和Pull Request来帮助改进项目。

---

**提莫合同数字化管理系统** - 让合同管理更智能、更高效！