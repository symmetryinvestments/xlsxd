@echo off
setlocal EnableDelayedExpansion

set    WORK_DIR=%~dp0
set INSTALL_DIR=%~dp0\install_dir

cd /d "%WORK_DIR%"
if !errorlevel! neq 0 exit /b !errorlevel!

Rem git clone https://github.com/madler/zlib.git
Rem x86
if exist "%INSTALL_DIR%\zlib\win32\lib\zlibstatic.lib" (
	echo zlib already build
)  else (
	echo zlib does not exist
	cd zlib
	if !errorlevel! neq 0 exit /b !errorlevel!
	mkdir buildx86
	if !errorlevel! neq 0 exit /b !errorlevel!
	cd    buildx86
	if !errorlevel! neq 0 exit /b !errorlevel!
	cmake .. -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%\zlib\win32" -DCMAKE_GENERATOR_PLATFORM=Win32
	if !errorlevel! neq 0 exit /b !errorlevel!

	cmake --build . --config Release  --target install
	if !errorlevel! neq 0 exit /b !errorlevel!

	cd "%WORK_DIR%"
	if !errorlevel! neq 0 exit /b !errorlevel!
)

Rem x64
if exist "%INSTALL_DIR%\zlib\lib\zlibstatic.lib" (
	echo zlib already build
)  else (
	echo zlib does not exist
	cd zlib
	if !errorlevel! neq 0 exit /b !errorlevel!
	mkdir build
	if !errorlevel! neq 0 exit /b !errorlevel!
	cd    build
	if !errorlevel! neq 0 exit /b !errorlevel!
	cmake .. -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%\zlib" -DCMAKE_GENERATOR_PLATFORM=x64
	if !errorlevel! neq 0 exit /b !errorlevel!

	cmake --build . --config Release  --target install
	if !errorlevel! neq 0 exit /b !errorlevel!

	cd "%WORK_DIR%"
	if !errorlevel! neq 0 exit /b !errorlevel!
)

Rem git clone https://github.com/jmcnamara/libxlsxwriter.git
Rem x86
if exist "%INSTALL_DIR%\libxlsxwriter\win32\lib\xlsxwriter.lib" (
	echo libxlsxwriter already build
) else (
	echo libxlsxwriter does not exist
	cd libxlsxwriter
	if !errorlevel! neq 0 exit /b !errorlevel!
	mkdir build86
	if !errorlevel! neq 0 exit /b !errorlevel!
	cd    build86
	if !errorlevel! neq 0 exit /b !errorlevel!
	cmake .. -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%\libxlsxwriter\win32" -DZLIB_ROOT="%INSTALL_DIR%\zlib\win32" -DCMAKE_GENERATOR_PLATFORM=Win32
	if !errorlevel! neq 0 exit /b !errorlevel!

	cmake --build . --config Release --target install
	if !errorlevel! neq 0 exit /b !errorlevel!

	cd "%WORK_DIR%"
	if !errorlevel! neq 0 exit /b !errorlevel!
)

Rem x64
if exist "%INSTALL_DIR%\libxlsxwriter\lib\xlsxwriter.lib" (
	echo libxlsxwriter already build
) else (
	echo libxlsxwriter does not exist
	cd libxlsxwriter
	if !errorlevel! neq 0 exit /b !errorlevel!
	mkdir build
	if !errorlevel! neq 0 exit /b !errorlevel!
	cd    build
	if !errorlevel! neq 0 exit /b !errorlevel!
	cmake .. -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%\libxlsxwriter" -DZLIB_ROOT="%INSTALL_DIR%\zlib" -DCMAKE_GENERATOR_PLATFORM=x64
	if !errorlevel! neq 0 exit /b !errorlevel!

	cmake --build . --config Release --target install
	if !errorlevel! neq 0 exit /b !errorlevel!

	cd "%WORK_DIR%"
	if !errorlevel! neq 0 exit /b !errorlevel!
)
