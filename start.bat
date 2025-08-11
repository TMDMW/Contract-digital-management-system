@echo off
chcp 65001 >nul
title 提莫合同管理系统

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                提莫合同数字化管理系统                    ║
echo ║                Contract Management System                    ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM 检查Node.js环境
echo 🔍 检查运行环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js未安装，请先安装Node.js
    echo 📥 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python未安装，请先安装Python
    echo 📥 下载地址: https://www.python.org/
    pause
    exit /b 1
)

echo ✅ Node.js版本: 
node --version
echo ✅ Python版本: 
python --version
echo.

REM 检查后端依赖
echo 🔍 检查后端依赖...
if not exist "backend\node_modules" (
    echo 📥 安装后端依赖...
    cd backend
    call npm install
    cd ..
)

REM 检查Python依赖
echo 🔍 检查Python依赖...
cd backend
pip show alibabacloud_ocr_api20210707 >nul 2>&1
if %errorlevel% neq 0 (
    echo 📥 安装Python依赖...
    pip install -r requirements.txt
)
cd ..

REM 检查前端依赖
echo 🔍 检查前端依赖...
if not exist "frontend\node_modules" (
    echo 📥 安装前端依赖...
    cd frontend
    call npm install
    cd ..
)

REM 检查环境变量配置
echo 🔍 检查配置文件...
if not exist "backend\.env" (
    echo ⚠️  未找到环境变量配置文件
    echo 📝 正在创建默认配置...
    copy "backend\.env.example" "backend\.env"
    echo ❗ 请编辑 backend\.env 文件配置数据库和阿里云OCR
    echo 📖 详细配置说明请查看 README.md
    pause
)

echo.
echo 🚀 启动系统服务...
echo.

REM 启动后端服务
echo 🔧 启动后端服务 (端口: 3000)...
start "后端服务" cmd /k "cd backend && npm start"

REM 等待后端启动
echo ⏳ 等待后端服务启动...
timeout /t 5 /nobreak >nul

REM 启动前端服务
echo 🎨 启动前端服务 (端口: 8080)...
start "前端服务" cmd /k "cd frontend && npm run serve"

echo.
echo ✅ 系统启动完成！
echo.
echo 📱 访问地址:
echo    前端界面: http://localhost:8080
echo    后端API:  http://localhost:3000/api
echo.
echo 👤 默认管理员账号:
echo    用户名: admin
echo    密码: admin123
echo.
echo 📝 注意事项:
echo    1. 首次使用请配置数据库连接
echo    2. 配置阿里云OCR AccessKey
echo    3. 确保MySQL服务正在运行
echo.
echo 🔧 如需停止服务，请关闭对应的命令行窗口
echo 📖 详细使用说明请查看 README.md
echo.

pause