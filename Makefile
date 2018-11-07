source/xlsxwrap.d: source/xlsxwrap.dpp
	d++ --include-path libxlsxwriter/include/ --keep-d-files --preprocess-only source/xlsxwrap.dpp

buildclib:
	cd libxlsxwriter/ && mkdir -p build && cd build && cmake .. && make -j6

