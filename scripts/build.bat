@echo off
chcp 65001 >nul
echo === 提莫合同管理系统打包脚本 ===

REM 检查Node.js环境
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js未安装，请先安装Node.js
    pause
    exit /b 1
)

npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm未安装，请先安装npm
    pause
    exit /b 1
)

echo ✅ Node.js版本:
node --version
echo ✅ npm版本:
npm --version

REM 创建打包目录
set BUILD_DIR=.\build
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set PACKAGE_NAME=contract-management-system_%TIMESTAMP%
set PACKAGE_DIR=%BUILD_DIR%\%PACKAGE_NAME%

echo 📦 创建打包目录: %PACKAGE_DIR%
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%PACKAGE_DIR%" mkdir "%PACKAGE_DIR%"

REM 打包后端
echo 🔧 打包后端...
mkdir "%PACKAGE_DIR%\backend"

REM 复制后端文件（排除node_modules和日志）
xcopy /E /I /Y "backend\*" "%PACKAGE_DIR%\backend\" /EXCLUDE:exclude_list.txt

REM 创建排除列表
echo node_modules\ > exclude_list.txt
echo logs\ >> exclude_list.txt
echo .env >> exclude_list.txt

REM 复制环境变量模板
copy "backend\.env.example" "%PACKAGE_DIR%\backend\.env"

echo ✅ 后端文件复制完成

REM 打包前端
echo 🎨 打包前端...
cd frontend

REM 安装依赖
echo 📥 安装前端依赖...
call npm install

REM 构建生产版本
echo 🏗️ 构建前端生产版本...
call npm run build

REM 复制构建结果
xcopy /E /I /Y "dist\*" "..\%PACKAGE_DIR%\frontend\"

cd ..

echo ✅ 前端打包完成

REM 复制其他必要文件
echo 📋 复制配置文件...
copy "README.md" "%PACKAGE_DIR%\"
xcopy /E /I /Y "database\*" "%PACKAGE_DIR%\database\"
xcopy /E /I /Y "scripts\*" "%PACKAGE_DIR%\scripts\"

REM 创建部署脚本
echo @echo off > "%PACKAGE_DIR%\deploy.bat"
echo chcp 65001 ^>nul >> "%PACKAGE_DIR%\deploy.bat"
echo echo === 提莫合同管理系统部署脚本 === >> "%PACKAGE_DIR%\deploy.bat"
echo. >> "%PACKAGE_DIR%\deploy.bat"
echo REM 检查Node.js >> "%PACKAGE_DIR%\deploy.bat"
echo node --version ^>nul 2^>^&1 >> "%PACKAGE_DIR%\deploy.bat"
echo if %%errorlevel%% neq 0 ^( >> "%PACKAGE_DIR%\deploy.bat"
echo     echo ❌ Node.js未安装，请先安装Node.js >> "%PACKAGE_DIR%\deploy.bat"
echo     pause >> "%PACKAGE_DIR%\deploy.bat"
echo     exit /b 1 >> "%PACKAGE_DIR%\deploy.bat"
echo ^) >> "%PACKAGE_DIR%\deploy.bat"
echo. >> "%PACKAGE_DIR%\deploy.bat"
echo REM 检查Python >> "%PACKAGE_DIR%\deploy.bat"
echo python --version ^>nul 2^>^&1 >> "%PACKAGE_DIR%\deploy.bat"
echo if %%errorlevel%% neq 0 ^( >> "%PACKAGE_DIR%\deploy.bat"
echo     echo ❌ Python未安装，请先安装Python >> "%PACKAGE_DIR%\deploy.bat"
echo     pause >> "%PACKAGE_DIR%\deploy.bat"
echo     exit /b 1 >> "%PACKAGE_DIR%\deploy.bat"
echo ^) >> "%PACKAGE_DIR%\deploy.bat"
echo. >> "%PACKAGE_DIR%\deploy.bat"
echo REM 安装后端依赖 >> "%PACKAGE_DIR%\deploy.bat"
echo echo 📥 安装后端依赖... >> "%PACKAGE_DIR%\deploy.bat"
echo cd backend >> "%PACKAGE_DIR%\deploy.bat"
echo call npm install --production >> "%PACKAGE_DIR%\deploy.bat"
echo. >> "%PACKAGE_DIR%\deploy.bat"
echo REM 安装Python依赖 >> "%PACKAGE_DIR%\deploy.bat"
echo echo 🐍 安装Python依赖... >> "%PACKAGE_DIR%\deploy.bat"
echo pip install -r requirements.txt >> "%PACKAGE_DIR%\deploy.bat"
echo. >> "%PACKAGE_DIR%\deploy.bat"
echo echo ✅ 部署完成！ >> "%PACKAGE_DIR%\deploy.bat"
echo echo 📝 请按照README.md配置数据库和环境变量 >> "%PACKAGE_DIR%\deploy.bat"
echo echo 🚀 启动命令: npm start >> "%PACKAGE_DIR%\deploy.bat"
echo pause >> "%PACKAGE_DIR%\deploy.bat"

REM 清理临时文件
del exclude_list.txt

echo 🎉 打包完成！
echo 📦 打包文件位置: %PACKAGE_DIR%
echo 📝 请手动压缩该目录进行分发

pause