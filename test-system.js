#!/usr/bin/env node

/**
 * 系统测试脚本
 * 用于验证合同管理系统是否正常工作
 */

const axios = require('axios').default;
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

// 配置
const config = {
  apiBaseUrl: 'http://localhost:3000/api',
  database: {
    host: 'localhost',
    user: 'ht',
    password: 'Tjksyy123',
    database: 'contract_management'
  }
};

// 测试结果
let testResults = {
  passed: 0,
  failed: 0,
  errors: []
};

// 测试函数
async function runTest(testName, testFn) {
  try {
    console.log(`🧪 测试: ${testName}`);
    await testFn();
    console.log(`✅ ${testName} - 通过`);
    testResults.passed++;
  } catch (error) {
    console.log(`❌ ${testName} - 失败: ${error.message}`);
    testResults.failed++;
    testResults.errors.push({ test: testName, error: error.message });
  }
}

// 数据库连接测试
async function testDatabaseConnection() {
  const connection = await mysql.createConnection(config.database);
  const [rows] = await connection.execute('SELECT 1 as test');
  await connection.end();
  
  if (rows[0].test !== 1) {
    throw new Error('数据库查询结果异常');
  }
}

// 数据库表结构测试
async function testDatabaseTables() {
  const connection = await mysql.createConnection(config.database);
  
  const requiredTables = ['users', 'merchants', 'contracts', 'contract_keywords'];
  
  for (const table of requiredTables) {
    const [rows] = await connection.execute(`SHOW TABLES LIKE '${table}'`);
    if (rows.length === 0) {
      throw new Error(`缺少数据表: ${table}`);
    }
  }
  
  await connection.end();
}

// API服务测试
async function testApiServer() {
  try {
    const response = await axios.get(`${config.apiBaseUrl}/merchants`);
    // 未登录应该返回401
    throw new Error('API应该要求认证');
  } catch (error) {
    if (error.response && error.response.status === 401) {
      // 这是期望的结果
      return;
    }
    throw error;
  }
}

// 用户登录测试
async function testUserLogin() {
  const response = await axios.post(`${config.apiBaseUrl}/auth/login`, {
    username: 'admin',
    password: 'password'
  });
  
  if (!response.data.token) {
    throw new Error('登录未返回token');
  }
  
  if (!response.data.user) {
    throw new Error('登录未返回用户信息');
  }
  
  // 保存token供后续测试使用
  config.authToken = response.data.token;
}

// 商家API测试
async function testMerchantsApi() {
  const response = await axios.get(`${config.apiBaseUrl}/merchants`, {
    headers: {
      'Authorization': `Bearer ${config.authToken}`
    }
  });
  
  if (!Array.isArray(response.data)) {
    throw new Error('商家列表应该返回数组');
  }
}

// 文件上传目录测试
async function testUploadDirectory() {
  const uploadDir = path.join(__dirname, 'uploads');
  
  if (!fs.existsSync(uploadDir)) {
    throw new Error('uploads目录不存在');
  }
  
  // 测试写入权限
  const testFile = path.join(uploadDir, 'test.txt');
  fs.writeFileSync(testFile, 'test');
  
  if (!fs.existsSync(testFile)) {
    throw new Error('无法写入uploads目录');
  }
  
  // 清理测试文件
  fs.unlinkSync(testFile);
}

// 前端文件测试
async function testFrontendFiles() {
  const requiredFiles = [
    'frontend/src/main.js',
    'frontend/src/App.vue',
    'frontend/src/router/index.js',
    'frontend/public/index.html'
  ];
  
  for (const file of requiredFiles) {
    if (!fs.existsSync(file)) {
      throw new Error(`缺少前端文件: ${file}`);
    }
  }
}

// 后端文件测试
async function testBackendFiles() {
  const requiredFiles = [
    'backend/server.js',
    'backend/.env',
    'backend/config/database.js',
    'backend/routes/auth.js',
    'backend/routes/contracts.js'
  ];
  
  for (const file of requiredFiles) {
    if (!fs.existsSync(file)) {
      throw new Error(`缺少后端文件: ${file}`);
    }
  }
}

// 环境变量测试
async function testEnvironmentConfig() {
  const envFile = path.join(__dirname, 'backend/.env');
  const envContent = fs.readFileSync(envFile, 'utf8');
  
  const requiredVars = ['DB_HOST', 'DB_USER', 'DB_PASSWORD', 'JWT_SECRET'];
  
  for (const varName of requiredVars) {
    if (!envContent.includes(varName)) {
      throw new Error(`环境变量文件缺少: ${varName}`);
    }
  }
}

// 主测试函数
async function runAllTests() {
  console.log('🚀 开始系统测试...\n');
  
  // 基础文件测试
  await runTest('后端文件完整性', testBackendFiles);
  await runTest('前端文件完整性', testFrontendFiles);
  await runTest('环境配置文件', testEnvironmentConfig);
  await runTest('上传目录权限', testUploadDirectory);
  
  // 数据库测试
  await runTest('数据库连接', testDatabaseConnection);
  await runTest('数据库表结构', testDatabaseTables);
  
  // API测试（需要服务器运行）
  try {
    await runTest('API服务响应', testApiServer);
    await runTest('用户登录功能', testUserLogin);
    await runTest('商家API接口', testMerchantsApi);
  } catch (error) {
    console.log('⚠️  API测试跳过 - 请确保服务器正在运行 (npm run server)');
  }
  
  // 输出测试结果
  console.log('\n📊 测试结果:');
  console.log(`✅ 通过: ${testResults.passed}`);
  console.log(`❌ 失败: ${testResults.failed}`);
  
  if (testResults.failed > 0) {
    console.log('\n❌ 失败详情:');
    testResults.errors.forEach(({ test, error }) => {
      console.log(`  - ${test}: ${error}`);
    });
    process.exit(1);
  } else {
    console.log('\n🎉 所有测试通过！系统准备就绪。');
  }
}

// 运行测试
if (require.main === module) {
  runAllTests().catch(error => {
    console.error('测试运行失败:', error);
    process.exit(1);
  });
}

module.exports = { runAllTests };