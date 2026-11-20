@echo off
cd /d "%~dp0"
echo Cargando contenido de ejemplo...
node --disable-warning=ExperimentalWarning ejemplos\sembrar.js
echo.
echo Ahora recarga la pagina en el navegador (Ctrl+F5).
pause
