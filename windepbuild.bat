@echo off
set    WORK_DIR=%~dp0
set INSTALL_DIR=%~dp0\install_dir

cd %WORK_DIR%

Rem git clone https://github.com/madler/zlib.git

if exist "%INSTALL_DIR%\zlib\lib\zlibstatic.lib" (
	echo "zlib already build"
)  else (
	echo "zlib does not exist"
	cd zlib
	mkdir build
	cd    build
	echo %~dp0
	cmake .. -DCMAKE_INSTALL_PREFIX:STRING="%INSTALL_DIR%\zlib" -DCMAKE_GENERATOR_PLATFORM=x64

	cmake --build . --config Release  --target install

	cd %WORK_DIR%
)

Rem git clone https://github.com/jmcnamara/libxlsxwriter.git

if exist "%INSTALL_DIR%\libxlsxwriter\lib\x64\Release\xlsxwriter.lib" (
	echo "libxlsxwriter already build"
) else (
	echo "libxlsxwriter does not exist"
	cd libxlsxwriter
	mkdir build
	cd    build
	echo %~dp0
	cmake .. -DCMAKE_INSTALL_PREFIX:STRING="%INSTALL_DIR%\libxlsxwriter" -DZLIB_ROOT:STRING="%INSTALL_DIR%\zlib" -DCMAKE_GENERATOR_PLATFORM=x64

	cmake --build . --config Release --target install

	cd %WORK_DIR%
)
