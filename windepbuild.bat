@echo off
setlocal EnableDelayedExpansion

set    WORK_DIR=%~dp0
set INSTALL_DIR=%~dp0\install_dir

cd /d "%WORK_DIR%"
if !errorlevel! neq 0 exit /b !errorlevel!

Rem git clone https://github.com/jmcnamara/libxlsxwriter.git
Rem x86
if exist "%INSTALL_DIR%\libxlsxwriter\lib\Win32\Release\xlsxwriter.lib" (
	echo 32-bit libxlsxwriter already built
) else (
	echo 32-bit libxlsxwriter does not exist
	cd libxlsxwriter
	if !errorlevel! neq 0 exit /b !errorlevel!
	mkdir build86
	if !errorlevel! neq 0 exit /b !errorlevel!
	cd    build86
	if !errorlevel! neq 0 exit /b !errorlevel!
	cmake .. -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%\libxlsxwriter" -DCMAKE_GENERATOR_PLATFORM=Win32
	if !errorlevel! neq 0 exit /b !errorlevel!

	cmake --build . --config Release --target install
	if !errorlevel! neq 0 exit /b !errorlevel!

	cd "%WORK_DIR%"
	if !errorlevel! neq 0 exit /b !errorlevel!
)

Rem x64
if exist "%INSTALL_DIR%\libxlsxwriter\lib\x64\Release\xlsxwriter.lib" (
	echo 64-bit libxlsxwriter already built
) else (
	echo 64-bit libxlsxwriter does not exist
	cd libxlsxwriter
	if !errorlevel! neq 0 exit /b !errorlevel!
	mkdir build
	if !errorlevel! neq 0 exit /b !errorlevel!
	cd    build
	if !errorlevel! neq 0 exit /b !errorlevel!
	cmake .. -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%\libxlsxwriter" -DCMAKE_GENERATOR_PLATFORM=x64
	if !errorlevel! neq 0 exit /b !errorlevel!

	cmake --build . --config Release --target install
	if !errorlevel! neq 0 exit /b !errorlevel!

	cd "%WORK_DIR%"
	if !errorlevel! neq 0 exit /b !errorlevel!
)
