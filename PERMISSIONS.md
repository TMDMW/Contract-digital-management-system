# 权限管理系统使用指南

## 🎯 权限管理功能概述

本系统实现了基于角色和部门的权限管理，支持以下功能：

### 角色类型
- **管理员 (admin)** - 拥有所有权限，可以管理用户、部门和所有合同
- **经理 (manager)** - 部门管理权限，可以管理本部门相关合同
- **普通用户 (user)** - 基础权限，只能管理自己创建的合同

### 部门权限类型
- **只读 (read)** - 可以查看该部门的合同
- **读写 (write)** - 可以查看和编辑该部门的合同
- **管理 (admin)** - 可以管理该部门的所有合同（包括删除）

## 🗄️ 数据库结构

### 新增表结构

#### 1. departments (部门表)
```sql
CREATE TABLE departments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 2. user_department_permissions (用户部门权限表)
```sql
CREATE TABLE user_department_permissions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  department_id INT NOT NULL,
  permission_type ENUM('read', 'write', 'admin') DEFAULT 'read',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_department (user_id, department_id)
);
```

#### 3. users表新增字段
```sql
ALTER TABLE users ADD COLUMN role ENUM('admin', 'manager', 'user') DEFAULT 'user' AFTER department;
```

## 🚀 安装和配置

### 1. 数据库迁移
运行以下命令来更新数据库结构：

```bash
mysql -h localhost -u ht -p contract_management < database/migrate.sql
```

### 2. 重启服务
```bash
# 重启后端服务
cd backend
npm start

# 重启前端服务
cd frontend
npm run serve
```

## 👥 用户管理

### 管理员功能
1. **用户管理** - 左侧菜单 → 用户管理
   - 查看所有用户
   - 创建新用户并设置角色
   - 编辑用户信息和角色
   - 删除用户（保护admin用户）

2. **权限管理** - 左侧菜单 → 权限管理
   - 用户权限管理：为用户分配部门访问权限
   - 部门管理：创建和管理部门

### 权限分配流程
1. 进入权限管理页面
2. 选择"用户权限管理"标签
3. 点击用户的"编辑权限"按钮
4. 为用户分配不同部门的访问权限
5. 保存权限设置

## 📄 合同访问控制

### 访问规则
1. **管理员** - 可以查看和管理所有合同
2. **合同创建者** - 可以查看和管理自己创建的合同
3. **同部门用户** - 可以查看同部门其他用户创建的合同
4. **有权限的用户** - 可以根据分配的部门权限访问相应合同

### 操作权限
- **查看合同** - 根据访问规则确定
- **下载合同** - 与查看权限相同
- **删除合同** - 仅限管理员和合同创建者

## 🔧 API接口

### 权限管理API

#### 部门管理
- `GET /api/permissions/departments` - 获取所有部门
- `POST /api/permissions/departments` - 创建部门（仅管理员）

#### 用户权限管理
- `GET /api/permissions/user-permissions/:userId` - 获取用户权限（仅管理员）
- `POST /api/permissions/user-permissions` - 设置用户权限（仅管理员）
- `DELETE /api/permissions/user-permissions/:userId/:departmentId` - 删除用户权限（仅管理员）

#### 权限检查
- `GET /api/permissions/my-departments` - 获取当前用户可访问的部门
- `GET /api/permissions/check-permission/:departmentId` - 检查对特定部门的权限

## 🎨 前端界面

### 新增页面
1. **权限管理页面** (`/permissions`)
   - 用户权限管理标签
   - 部门管理标签

### 界面改进
1. **合同列表** - 显示创建者和所属部门信息
2. **用户管理** - 添加角色管理功能
3. **菜单控制** - 根据用户角色显示不同菜单项

## 📝 使用示例

### 场景1：为销售人员分配权限
1. 管理员登录系统
2. 进入权限管理 → 用户权限管理
3. 找到销售人员，点击"编辑权限"
4. 为其分配"销售部"的"读写"权限
5. 保存设置

### 场景2：查看跨部门合同
1. 用户登录系统
2. 进入合同管理页面
3. 可以看到：
   - 自己创建的合同
   - 同部门同事的合同
   - 有权限访问的其他部门合同

## 🔒 安全特性

1. **角色验证** - 所有管理功能都需要管理员权限
2. **权限检查** - 合同访问前进行权限验证
3. **数据隔离** - 用户只能看到有权限的数据
4. **操作日志** - 重要操作都有日志记录

## 🐛 故障排除

### 常见问题

**Q: 权限管理页面显示空白**
A: 确保用户具有管理员权限，普通用户无法访问权限管理

**Q: 用户看不到其他部门的合同**
A: 检查用户是否被分配了相应部门的访问权限

**Q: 数据库迁移失败**
A: 确保数据库连接正常，并且有足够的权限执行DDL语句

### 调试步骤
1. 检查用户角色：`SELECT role FROM users WHERE username = 'your_username'`
2. 检查用户权限：`SELECT * FROM user_department_permissions WHERE user_id = your_user_id`
3. 检查部门数据：`SELECT * FROM departments`

## 🔄 升级说明

如果从旧版本升级，请按以下步骤操作：

1. 备份现有数据库
2. 运行数据库迁移脚本
3. 重启后端服务
4. 清除浏览器缓存
5. 重新登录系统

## 📞 技术支持

如遇到问题，请检查：
1. 数据库连接是否正常
2. 后端服务是否正常启动
3. 前端是否正确连接到后端API
4. 用户权限是否正确配置