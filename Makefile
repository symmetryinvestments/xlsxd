source/libxlsxd/xlsxwrap.d: source/libxlsxd/xlsxwrap.dpp \
		libxlsxwriter/include/xlsxwriter/chart.h \
		libxlsxwriter/include/xlsxwriter/chartsheet.h \
		libxlsxwriter/include/xlsxwriter/common.h \
		libxlsxwriter/include/xlsxwriter/content_types.h \
		libxlsxwriter/include/xlsxwriter/core.h \
		libxlsxwriter/include/xlsxwriter/custom.h \
		libxlsxwriter/include/xlsxwriter/drawing.h \
		libxlsxwriter/include/xlsxwriter/format.h \
		libxlsxwriter/include/xlsxwriter/hash_table.h \
		libxlsxwriter/include/xlsxwriter/packager.h \
		libxlsxwriter/include/xlsxwriter/relationships.h \
		libxlsxwriter/include/xlsxwriter/shared_strings.h \
		libxlsxwriter/include/xlsxwriter/styles.h \
		libxlsxwriter/include/xlsxwriter/theme.h \
		libxlsxwriter/include/xlsxwriter/utility.h \
		libxlsxwriter/include/xlsxwriter/workbook.h \
		libxlsxwriter/include/xlsxwriter/worksheet.h \
		libxlsxwriter/include/xlsxwriter/xmlwriter.h
	/home/burner/.dub/packages/dpp/0.5.5/dpp/bin/d++ --include-path libxlsxwriter/include/ --keep-d-files --preprocess-only source/libxlsxd/xlsxwrap.dpp

libxlsxwriter/libxlsxwriter.a:
	cd libxlsxwriter/ && mkdir -p build && cd build && cmake .. && make -j6

