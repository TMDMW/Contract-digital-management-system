// 系统配置示例文件
// 复制此文件为 config.js 并根据实际情况修改配置

module.exports = {
  // 数据库配置
  database: {
    host: 'localhost',
    user: 'ht',
    password: 'your_password',
    database: 'contract_management',
    charset: 'utf8mb4'
  },

  // 服务器配置
  server: {
    port: 3000,
    host: 'localhost'
  },

  // JWT配置
  jwt: {
    secret: 'your_jwt_secret_key_here_please_change_this',
    expiresIn: '24h'
  },

  // 文件上传配置
  upload: {
    maxSize: 10 * 1024 * 1024, // 10MB
    allowedTypes: ['application/pdf'],
    uploadDir: './uploads'
  },

  // OCR配置
  ocr: {
    language: 'chi_sim+eng', // 中文简体 + 英文
    options: {
      logger: m => console.log(m)
    }
  },

  // 前端配置
  frontend: {
    port: 8080,
    apiBaseUrl: 'http://localhost:3000/api'
  },

  // 安全配置
  security: {
    bcryptRounds: 10,
    corsOrigin: ['http://localhost:8080'],
    rateLimitWindowMs: 15 * 60 * 1000, // 15分钟
    rateLimitMax: 100 // 每个IP最多100次请求
  },

  // 日志配置
  logging: {
    level: 'info',
    file: './logs/app.log',
    maxSize: '10m',
    maxFiles: 5
  }
}