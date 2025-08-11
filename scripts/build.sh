#!/bin/bash

# 提莫合同管理系统打包脚本

echo "=== 提莫合同管理系统打包脚本 ==="

# 检查Node.js环境
if ! command -v node &> /dev/null; then
    echo "❌ Node.js未安装，请先安装Node.js"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm未安装，请先安装npm"
    exit 1
fi

echo "✅ Node.js版本: $(node --version)"
echo "✅ npm版本: $(npm --version)"

# 创建打包目录
BUILD_DIR="./build"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PACKAGE_NAME="contract-management-system_${TIMESTAMP}"
PACKAGE_DIR="${BUILD_DIR}/${PACKAGE_NAME}"

echo "📦 创建打包目录: ${PACKAGE_DIR}"
mkdir -p "${PACKAGE_DIR}"

# 打包后端
echo "🔧 打包后端..."
mkdir -p "${PACKAGE_DIR}/backend"

# 复制后端文件（排除node_modules和日志）
rsync -av --exclude='node_modules' --exclude='logs' --exclude='.env' ./backend/ "${PACKAGE_DIR}/backend/"

# 复制环境变量模板
cp ./backend/.env.example "${PACKAGE_DIR}/backend/.env"

echo "✅ 后端文件复制完成"

# 打包前端
echo "🎨 打包前端..."
cd frontend

# 安装依赖
echo "📥 安装前端依赖..."
npm install

# 构建生产版本
echo "🏗️ 构建前端生产版本..."
npm run build

# 复制构建结果
cp -r dist "../${PACKAGE_DIR}/frontend"

cd ..

echo "✅ 前端打包完成"

# 复制其他必要文件
echo "📋 复制配置文件..."
cp README.md "${PACKAGE_DIR}/"
cp -r database "${PACKAGE_DIR}/"
cp -r scripts "${PACKAGE_DIR}/"

# 创建部署脚本
cat > "${PACKAGE_DIR}/deploy.sh" << 'EOF'
#!/bin/bash

echo "=== 提莫合同管理系统部署脚本 ==="

# 检查环境
if ! command -v node &> /dev/null; then
    echo "❌ Node.js未安装，请先安装Node.js"
    exit 1
fi

if ! command -v python &> /dev/null; then
    echo "❌ Python未安装，请先安装Python"
    exit 1
fi

# 安装后端依赖
echo "📥 安装后端依赖..."
cd backend
npm install --production

# 安装Python依赖
echo "🐍 安装Python依赖..."
pip install -r requirements.txt

echo "✅ 部署完成！"
echo "📝 请按照README.md配置数据库和环境变量"
echo "🚀 启动命令: npm start"
EOF

chmod +x "${PACKAGE_DIR}/deploy.sh"

# 创建Windows部署脚本
cat > "${PACKAGE_DIR}/deploy.bat" << 'EOF'
@echo off
echo === 提莫合同管理系统部署脚本 ===

REM 检查Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js未安装，请先安装Node.js
    pause
    exit /b 1
)

REM 检查Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python未安装，请先安装Python
    pause
    exit /b 1
)

REM 安装后端依赖
echo 📥 安装后端依赖...
cd backend
npm install --production

REM 安装Python依赖
echo 🐍 安装Python依赖...
pip install -r requirements.txt

echo ✅ 部署完成！
echo 📝 请按照README.md配置数据库和环境变量
echo 🚀 启动命令: npm start
pause
EOF

# 创建压缩包
echo "🗜️ 创建压缩包..."
cd "${BUILD_DIR}"
tar -czf "${PACKAGE_NAME}.tar.gz" "${PACKAGE_NAME}"
zip -r "${PACKAGE_NAME}.zip" "${PACKAGE_NAME}"

cd ..

echo "🎉 打包完成！"
echo "📦 打包文件位置:"
echo "   - ${BUILD_DIR}/${PACKAGE_NAME}.tar.gz"
echo "   - ${BUILD_DIR}/${PACKAGE_NAME}.zip"
echo "📁 解压后的目录: ${PACKAGE_DIR}"