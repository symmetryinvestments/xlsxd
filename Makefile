source/libxlsxd/xlsxwrap.d: source/libxlsxd/xlsxwrap.dpp
	/home/burner/.dub/packages/dpp-0.3.1/dpp/bin/d++ --include-path libxlsxwriter/include/ --keep-d-files --preprocess-only source/libxlsxd/xlsxwrap.dpp

libxlsxwriter/build/libxlsxwriter.a:
	cd libxlsxwriter/ && mkdir -p build && cd build && cmake .. && make -j6

