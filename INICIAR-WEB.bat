@echo off
chcp 65001 >nul
title Web productora - vista local
cd /d "%~dp0"

echo.
echo  =============================================
echo    Web productora - abriendo en tu computadora
echo  =============================================
echo.

where node >nul 2>nul
if errorlevel 1 goto :sin_node

for /f "tokens=1 delims=." %%v in ('node -v') do set NODEMAJOR=%%v
set NODEMAJOR=%NODEMAJOR:v=%
if %NODEMAJOR% LSS 22 goto :node_viejo

if exist node_modules goto :arrancar
echo  Instalando dependencias, solo la primera vez...
call npm install
if errorlevel 1 goto :error_npm

:arrancar
set ADMIN_USER=admin
set ADMIN_PASSWORD=Prueba12345
set SESSION_SECRET=solo-para-pruebas-locales-1234567890
echo.
echo  Web:   http://localhost:3000
echo  Panel: http://localhost:3000/admin
echo  Usuario: admin    Contrasena: Prueba12345
echo.
echo  Para apagarla, cierra esta ventana.
echo.
start "" cmd /c "timeout /t 3 >nul & start http://localhost:3000"
call npm start
pause
exit /b 0

:sin_node
echo  No tienes Node.js instalado. Intentando instalarlo...
winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
if errorlevel 1 goto :node_manual
echo.
echo  Node.js quedo instalado. Cierra esta ventana y vuelve a abrir INICIAR-WEB.bat
pause
exit /b 0

:node_viejo
echo  Tu version de Node.js es antigua. Se necesita la 22 o superior.
goto :node_manual

:node_manual
echo.
echo  Descarga Node.js LTS desde la pagina que se va a abrir, instalalo
echo  con las opciones por defecto y vuelve a abrir INICIAR-WEB.bat
start "" https://nodejs.org
pause
exit /b 1

:error_npm
echo.
echo  Hubo un error instalando las dependencias. Toma captura de esta ventana.
pause
exit /b 1
