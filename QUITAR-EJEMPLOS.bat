@echo off
cd /d "%~dp0"
echo Quitando contenido de ejemplo...
node --disable-warning=ExperimentalWarning ejemplos\sembrar.js quitar
echo.
pause
