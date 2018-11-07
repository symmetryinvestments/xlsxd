source/libxlsxd/xlsxwrap.d: source/libxlsxd/xlsxwrap.dpp
	d++ --include-path libxlsxwriter/include/ --keep-d-files --preprocess-only source/libxlsxd/xlsxwrap.dpp

buildclib:
	cd libxlsxwriter/ && mkdir -p build && cd build && cmake .. && make -j6

