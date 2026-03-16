@echo off
echo ========================================
echo   茶马古道·春茶之旅 2026 - 本地预览
echo ========================================
echo.
echo 正在启动服务器...
echo 访问地址: http://localhost:8080
echo 按 Ctrl+C 停止服务器
echo.
powershell -ExecutionPolicy Bypass -File "start-server.ps1"
pause