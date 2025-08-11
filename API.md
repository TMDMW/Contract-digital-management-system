# API 接口文档

## 基础信息

- **Base URL**: `http://localhost:3000/api`
- **认证方式**: JWT Bearer Token
- **数据格式**: JSON
- **字符编码**: UTF-8

## 认证说明

除了登录和注册接口外，所有API都需要在请求头中包含JWT token：

```
Authorization: Bearer <your_jwt_token>
```

## 接口列表

### 1. 用户认证

#### 1.1 用户登录
```
POST /auth/login
```

**请求参数**:
```json
{
  "username": "admin",
  "password": "password"
}
```

**响应示例**:
```json
{
  "message": "登录成功",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "admin"
  }
}
```

#### 1.2 用户注册
```
POST /auth/register
```

**请求参数**:
```json
{
  "username": "newuser",
  "password": "password123",
  "email": "user@example.com"
}
```

**响应示例**:
```json
{
  "message": "用户注册成功",
  "userId": 2
}
```

### 2. 合同管理

#### 2.1 获取合同列表
```
GET /contracts
```

**响应示例**:
```json
[
  {
    "id": 1,
    "title": "服务合同",
    "merchant_id": 1,
    "merchant_name": "北京科技有限公司",
    "pdf_path": "1640995200000-123456789.pdf",
    "ocr_content": "合同内容...",
    "contract_date": "2024-01-15",
    "amount": "50000.00",
    "status": "active",
    "created_at": "2024-01-01T10:00:00.000Z",
    "updated_at": "2024-01-01T10:00:00.000Z"
  }
]
```

#### 2.2 获取合同详情
```
GET /contracts/:id
```

**路径参数**:
- `id`: 合同ID

**响应示例**:
```json
{
  "id": 1,
  "title": "服务合同",
  "merchant_id": 1,
  "merchant_name": "北京科技有限公司",
  "contact_person": "张经理",
  "phone": "13800138001",
  "email": "zhang@bjtech.com",
  "pdf_path": "1640995200000-123456789.pdf",
  "ocr_content": "合同内容...",
  "contract_date": "2024-01-15",
  "amount": "50000.00",
  "status": "active",
  "created_at": "2024-01-01T10:00:00.000Z"
}
```

#### 2.3 上传合同
```
POST /contracts/upload
```

**请求类型**: `multipart/form-data`

**请求参数**:
- `contract`: PDF文件 (必需)
- `title`: 合同标题 (必需)
- `merchant_id`: 商家ID (可选)
- `contract_date`: 合同日期 (可选)
- `amount`: 合同金额 (可选)

**响应示例**:
```json
{
  "message": "合同上传成功",
  "contractId": 1,
  "filename": "1640995200000-123456789.pdf"
}
```

#### 2.4 删除合同
```
DELETE /contracts/:id
```

**路径参数**:
- `id`: 合同ID

**响应示例**:
```json
{
  "message": "合同删除成功"
}
```

### 3. 商家管理

#### 3.1 获取商家列表
```
GET /merchants
```

**响应示例**:
```json
[
  {
    "id": 1,
    "name": "北京科技有限公司",
    "contact_person": "张经理",
    "phone": "13800138001",
    "email": "zhang@bjtech.com",
    "address": "北京市朝阳区科技园",
    "created_at": "2024-01-01T10:00:00.000Z",
    "updated_at": "2024-01-01T10:00:00.000Z"
  }
]
```

#### 3.2 创建商家
```
POST /merchants
```

**请求参数**:
```json
{
  "name": "新商家名称",
  "contact_person": "联系人",
  "phone": "13800138000",
  "email": "contact@company.com",
  "address": "公司地址"
}
```

**响应示例**:
```json
{
  "message": "商家创建成功",
  "merchantId": 2
}
```

#### 3.3 获取商家合同
```
GET /merchants/:id/contracts
```

**路径参数**:
- `id`: 商家ID

**响应示例**:
```json
[
  {
    "id": 1,
    "title": "服务合同",
    "merchant_name": "北京科技有限公司",
    "contract_date": "2024-01-15",
    "amount": "50000.00",
    "status": "active",
    "created_at": "2024-01-01T10:00:00.000Z"
  }
]
```

### 4. 搜索功能

#### 4.1 关键词搜索
```
GET /search/keywords?q=关键词
```

**查询参数**:
- `q`: 搜索关键词 (必需)

**响应示例**:
```json
[
  {
    "id": 1,
    "title": "服务合同",
    "merchant_name": "北京科技有限公司",
    "contract_date": "2024-01-15",
    "amount": "50000.00",
    "status": "active",
    "created_at": "2024-01-01T10:00:00.000Z"
  }
]
```

#### 4.2 商家搜索
```
GET /search/merchant?merchant_name=商家名称
```

**查询参数**:
- `merchant_name`: 商家名称 (必需)

#### 4.3 高级搜索
```
POST /search/advanced
```

**请求参数**:
```json
{
  "keyword": "服务",
  "merchant_id": 1,
  "date_from": "2024-01-01",
  "date_to": "2024-12-31",
  "amount_min": 1000,
  "amount_max": 100000
}
```

**响应示例**:
```json
[
  {
    "id": 1,
    "title": "服务合同",
    "merchant_name": "北京科技有限公司",
    "contract_date": "2024-01-15",
    "amount": "50000.00",
    "status": "active",
    "created_at": "2024-01-01T10:00:00.000Z"
  }
]
```

## 错误响应

所有API在出错时都会返回统一格式的错误响应：

```json
{
  "message": "错误描述信息"
}
```

### 常见HTTP状态码

- `200`: 请求成功
- `201`: 创建成功
- `400`: 请求参数错误
- `401`: 未授权（需要登录）
- `403`: 禁止访问
- `404`: 资源不存在
- `500`: 服务器内部错误

## 使用示例

### JavaScript (Axios)

```javascript
// 设置基础URL和认证头
const api = axios.create({
  baseURL: 'http://localhost:3000/api',
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('token')}`
  }
});

// 登录
const login = async (username, password) => {
  const response = await api.post('/auth/login', { username, password });
  localStorage.setItem('token', response.data.token);
  return response.data;
};

// 获取合同列表
const getContracts = async () => {
  const response = await api.get('/contracts');
  return response.data;
};

// 上传合同
const uploadContract = async (formData) => {
  const response = await api.post('/contracts/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  });
  return response.data;
};
```

### cURL

```bash
# 登录获取token
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password"}'

# 使用token获取合同列表
curl -X GET http://localhost:3000/api/contracts \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 上传合同
curl -X POST http://localhost:3000/api/contracts/upload \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "contract=@contract.pdf" \
  -F "title=测试合同" \
  -F "merchant_id=1"
```

## 数据模型

### User (用户)
```json
{
  "id": "number",
  "username": "string",
  "email": "string",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Merchant (商家)
```json
{
  "id": "number",
  "name": "string",
  "contact_person": "string",
  "phone": "string",
  "email": "string",
  "address": "text",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Contract (合同)
```json
{
  "id": "number",
  "title": "string",
  "merchant_id": "number",
  "pdf_path": "string",
  "ocr_content": "text",
  "contract_date": "date",
  "amount": "decimal",
  "status": "enum(active,expired,terminated)",
  "user_id": "number",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

## 注意事项

1. **文件上传限制**: PDF文件最大10MB
2. **认证有效期**: JWT token有效期为24小时
3. **请求频率**: 建议控制API请求频率，避免过于频繁的调用
4. **文件访问**: 上传的PDF文件可通过 `/uploads/文件名` 直接访问
5. **OCR处理**: 文件上传后OCR识别可能需要一些时间，大文件处理时间更长

## 开发调试

### 启用调试模式
在 `backend/.env` 文件中设置：
```
NODE_ENV=development
DEBUG=true
```

### 查看日志
后端服务会在控制台输出详细的请求日志，包括：
- 请求方法和路径
- 请求参数
- 响应状态
- 错误信息

### 测试工具推荐
- **Postman**: 图形化API测试工具
- **Insomnia**: 轻量级REST客户端
- **curl**: 命令行HTTP客户端
- **HTTPie**: 用户友好的命令行HTTP客户端