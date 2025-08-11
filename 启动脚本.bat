@echo off
chcp 65001 >nul
title 合同数字化管理系统

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                               提莫合同数字化管理系统                                                ║
echo ║                                             Contract Management System                                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 正在启动服务...
call npm run dev

pause