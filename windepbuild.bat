set    WORK_DIR=%cd%
set INSTALL_DIR=%cd%\install_dir

cd %WORK_DIR%

Rem git clone https://github.com/madler/zlib.git
cd zlib
mkdir build
cd    build

cmake .. -G "Visual Studio 14 Win64" -DCMAKE_INSTALL_PREFIX:PATH="%INSTALL_DIR%/zlib"

cmake --build . --config Release --target install

cd %WORK_DIR%

Rem git clone https://github.com/jmcnamara/libxlsxwriter.git
cd libxlsxwriter
mkdir build
cd    build

cmake .. -G "Visual Studio 14 Win64" -DCMAKE_INSTALL_PREFIX:PATH="%INSTALL_DIR%/libxlsxwriter" -DZLIB_ROOT:STRING="%INSTALL_DIR%/zlib"

cmake --build . --config Release --target install
