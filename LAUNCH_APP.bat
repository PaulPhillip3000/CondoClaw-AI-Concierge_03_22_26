@echo off
echo Starting CondoClaw AI Concierge...
echo.

:: Start Backend
start "CondoClaw Backend" cmd /k "cd /d %~dp0 && python backend.py"

:: Start Frontend
start "CondoClaw Frontend" cmd /k "cd /d %~dp0\frontend && npm run dev"

echo Waiting for services to start...
timeout /t 5

echo Opening Dashboard...
start http://localhost:5173

echo.
echo Everything is running! Keep the two black windows open while you work.
pause
