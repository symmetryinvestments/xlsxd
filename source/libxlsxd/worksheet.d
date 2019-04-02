module libxlsxd.worksheet;

import libxlsxd.types;
import libxlsxd.datetime;
import libxlsxd.format;
import libxlsxd.chart;

import libxlsxd.xlsxwrap;

pure string genWriteOverloads() {
	import std.array : empty;
	import std.format : format;
	string[3][] fun = [
			["String", "string", ""],
			["String", "string", "Format"],
			["Int", "long", ""],
			["Int", "long", "Format"],
			["Boolean", "bool", ""],
			["Boolean", "bool", "Format"],
			["Number", "double", ""],
			["Number", "double", "Format"],
			["Datetime", "Datetime", ""],
			["Datetime", "Datetime", "Format"],
			["Formula", "string", ""],
			["Formula", "string", "Format"],
			["Url", "string", ""],
			["Url", "string", "Format"],
			["RichString", "lxw_rich_string_tuple**", ""],
			["RichString", "lxw_rich_string_tuple**", "Format"],
		];
	string ret;
	version(No_Overloads_Or_Templates) {
		immutable overloads = false;
		ret ~= `void writeBlank(RowType row, ColType col) {
		this.writeBlankImpl(row, col, Format(null));
	}

	void writeBlankFormat(RowType row, ColType col, Format f) {
		this.writeBlankImpl(row, col, f);
	}
`;

	} else {
		immutable overloads = true;
		ret ~= `void writeBlank(RowType row, ColType col) {
		this.writeBlankImpl(row, col, Format(null));
	}

	void writeBlank(RowType row, ColType col, Format f) {
		this.writeBlankImpl(row, col, f);
	}
`;
	}

	foreach(string[3] f; fun) {
		bool addi = !f[2].empty;
		ret ~= format("void write%s%s(RowType row, ColType col, %s value%s) {\n",
				f[0],
				!overloads && addi ? "Format" : "",
				f[1], addi ? ", Format f" : ""
			);
		ret ~= format("\tthis.write%sImpl(row, col, value%s);\n}\n\n",
				f[0], addi ? ", f": ", Format(null)"
			);
	}
	return ret;
}

pragma(msg, genWriteOverloads());

struct Worksheet {
	import std.string : toStringz;
	import std.exception : enforce;
	lxw_worksheet* handle;

	this(lxw_worksheet* handle) @nogc nothrow {
		this.handle = handle;
	}

	mixin(genWriteOverloads());

	void write(T)(RowType row, ColType col, T value) {
		this.write(row, col, value, Format(null));
	}

	void write(T)(RowType row, ColType col, T value, Format format) {
		import std.traits : isIntegral, isFloatingPoint, isSomeString;
		static if((isFloatingPoint!T || isIntegral!T) && !is(T == bool)) {
			this.writeNumberImpl(row, col, value, format);
		} else static if(isSomeString!T) {
			this.writeStringImpl(row, col, value, format);
		} else static if(is(T == Datetime)) {
			this.writeDatetimeImpl(row, col, value, format);
		} else static if(is(T == bool)) {
			this.writeBooleanImpl(row, col, value, format);
		} else {
			static assert(false, "The function 'write' does not support type
					'" ~ T.stringof ~ "'");
		}
	}

	size_t writeAndGetWidth(T)(RowType row, ColType col, T value) {
		return writeAndGetWidth(row, col, value, Format(null));
	}

	size_t writeAndGetWidth(T)(RowType row, ColType col, T value,
			Format format)
	{
		import std.traits : isIntegral, isFloatingPoint, isSomeString;
		import std.conv : to;
		static if((isFloatingPoint!T || isIntegral!T) && !is(T == bool)) {
			this.writeNumberImpl(row, col, value, format);
			return to!string(value).length;
		} else static if(isSomeString!T) {
			this.writeStringImpl(row, col, value, format);
			return value.length;
		} else static if(is(T == bool)) {
			this.writeBooleanImpl(row, col, value, format);
			return value ? 4 : 5;
		} else {
			static assert(false, "The function 'writeAndGetWidth' does not "
					~ " support type '" ~ T.stringof ~ "'");
		}
	}

	void writeIntImpl(RowType row, ColType col, double num,
			Format format)
	{
		enforce(worksheet_write_number(this.handle, row, col,
					num, format.handle) == LXW_NO_ERROR);
	}

	void writeNumberImpl(RowType row, ColType col, double num,
			Format format)
	{
		enforce(worksheet_write_number(this.handle, row, col,
					num, format.handle) == LXW_NO_ERROR);
	}

	void writeStringImpl(RowType row, ColType col, string str, Format format) {
		enforce(worksheet_write_string(this.handle, row, col,
					toStringz(str), format.handle) == LXW_NO_ERROR);
	}

	private void writeFormulaImpl(RowType row, ColType col, string formula,
			Format format)
	{
		enforce(worksheet_write_formula(this.handle, row, col,
					toStringz(formula), format.handle) == LXW_NO_ERROR);
	}

	void writeArrayFormula(RowType firstRow, ColType firstCol,
			RowType lastRow, ColType lastCol, string formula)
	{
		this.writeArrayFormulaImpl(firstRow, firstCol, lastRow, lastCol,
				formula, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void writeArrayFormulaFormat(RowType firstRow, ColType firstCol,
				RowType lastRow, ColType lastCol, string formula, Format format)
		{
			this.writeArrayFormulaImpl(firstRow, firstCol, lastRow, lastCol,
					formula, format);
		}
	} else {
		void writeArrayFormula(RowType firstRow, ColType firstCol,
				RowType lastRow, ColType lastCol, string formula, Format format)
		{
			this.writeArrayFormulaImpl(firstRow, firstCol, lastRow, lastCol,
					formula, format);
		}
	}

	private void writeArrayFormulaImpl(RowType firstRow, ColType firstCol,
			RowType lastRow, ColType lastCol, string formula, Format format)
	{
		enforce(worksheet_write_array_formula(this.handle, firstRow,
					firstCol, lastRow, lastCol, toStringz(formula),
					format.handle) == LXW_NO_ERROR);
	}

	void writeDatetimeImpl(RowType row, ColType col, Datetime datetime,
			Format format)
	{
		enforce(worksheet_write_datetime(this.handle, row, col,
					&datetime.handle, format.handle) == LXW_NO_ERROR);
	}

	void writeUrlImpl(RowType row, ColType col, string url, Format format) {
		enforce(worksheet_write_url(this.handle, row, col,
					toStringz(url), format.handle) == LXW_NO_ERROR);
	}

	void writeBooleanImpl(RowType row, ColType col, bool value, Format format) {
		enforce(worksheet_write_boolean(this.handle, row, col,
					value, format.handle) == LXW_NO_ERROR);
	}

	void writeBlankImpl(RowType row, ColType col, Format format) {
		enforce(worksheet_write_blank(this.handle, row, col,
					format.handle) == LXW_NO_ERROR);
	}

	void writeFormulaNumImpl(RowType row, ColType col, string formula,
			double value, Format format)
	{
		enforce(worksheet_write_formula_num(this.handle, row,
					col, toStringz(formula), format.handle, value
				)
				== LXW_NO_ERROR
			);
	}

	void writeRichStringImpl(RowType row, ColType col,
			lxw_rich_string_tuple** rst, Format format)
	{
		enforce(worksheet_write_rich_string(this.handle, row,
					col, rst, format.handle
				)
				== LXW_NO_ERROR
			);
	}

	void setRow(RowType row, double height) {
		this.setRowImpl(row, height, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void setRowFormat(RowType row, double height, Format f) {
			this.setRowImpl(row, height, f);
		}
	} else {
		void setRow(RowType row, double height, Format f) {
			this.setRowImpl(row, height, f);
		}
	}

	private void setRowImpl(RowType row, double height, Format format) {
		enforce(worksheet_set_row(this.handle, row, height, format.handle)
				== LXW_NO_ERROR
			);
	}

	void setRowOpt(RowType row, double height, lxw_row_col_options* options) {
		this.setRowOptImpl(row, height, options, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void setRowOptFormat(RowType row, double height,
				lxw_row_col_options* options, Format f)
		{
			this.setRowOptImpl(row, height, options, f);
		}
	} else {
		void setRowOpt(RowType row, double height,
				lxw_row_col_options* options, Format f)
		{
			this.setRowOptImpl(row, height, options, f);
		}
	}

	private void setRowOptImpl(RowType row, double height,
			lxw_row_col_options* options, Format format)
	{
		enforce(worksheet_set_row_opt(this.handle, row, height,
					format.handle, options) == LXW_NO_ERROR);
	}

	void setColumn(ColType firstCol, ColType lastCol, double width) {
		this.setColumnImpl(firstCol, lastCol, width, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void setColumnFormat(ColType firstCol, ColType lastCol, double width,
				Format f)
		{
			this.setColumnImpl(firstCol, lastCol, width, f);
		}
	} else {
		void setColumn(ColType firstCol, ColType lastCol, double width,
				Format f)
		{
			this.setColumnImpl(firstCol, lastCol, width, f);
		}
	}

	private void setColumnImpl(ColType firstCol, ColType lastCol, double width,
			Format format)
	{
		enforce(worksheet_set_column(this.handle, firstCol, lastCol,
					width, format.handle
				)
				== LXW_NO_ERROR
			);
	}

	void setColumnOpt(ColType firstCol, ColType lastCol, double width,
			lxw_row_col_options* options)
	{
		this.setColumnOpt(firstCol, lastCol, width, Format(null), options);
	}

	void setColumnOpt(ColType firstCol, ColType lastCol, double width,
			Format format, lxw_row_col_options* options)
	{
		enforce(worksheet_set_column_opt(this.handle, firstCol, lastCol,
					width, format.handle, options)
				== LXW_NO_ERROR
			);
	}

	void insertImage(RowType row, ColType col, string filename) {
		enforce(worksheet_insert_image(this.handle, row, col,
					toStringz(filename)
				)
				== LXW_NO_ERROR
			);
	}

	void insertImageOpt(RowType row, ColType col, string filename,
			lxw_image_options* options)
	{
		enforce(worksheet_insert_image_opt(this.handle, row, col,
					toStringz(filename), options
				)
				== LXW_NO_ERROR
			);
	}

	void insertImageBuffer(RowType row, ColType col, const(ubyte)* buf,
			size_t bufSize)
	{
		enforce(worksheet_insert_image_buffer(this.handle, row,
					col, buf, bufSize
				)
				== LXW_NO_ERROR
			);
	}

	void insertImageBufferOpt(RowType row, ColType col, const(ubyte)* buf,
			size_t bufSize, lxw_image_options* options)
	{
		enforce(worksheet_insert_image_buffer_opt(this.handle, row,
					col, buf, bufSize, options
				)
				== LXW_NO_ERROR
			);
	}

	void insertChart(RowType row, ColType col, Chart chart) {
		enforce(worksheet_insert_chart(this.handle, row, col,
					chart.handle) == LXW_NO_ERROR);
	}

	void insertChartOpt(RowType row, ColType col, Chart chart,
			lxw_image_options* options)
	{
		enforce(worksheet_insert_chart_opt(this.handle, row,
					col, chart.handle, options
				)
				== LXW_NO_ERROR
			);
	}

	void mergeRange(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol, string str)
	{
		this.mergeRange(firstRow, firstCol, lastRow,
			lastCol, str, Format(null));
	}

	void mergeRange(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol, string str, Format format)
	{
		enforce(worksheet_merge_range(this.handle, firstRow, firstCol,
					lastRow, lastCol, toStringz(str), format.handle
				)
				== LXW_NO_ERROR
			);
	}

	void autofilter(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol) {
		enforce(worksheet_autofilter(this.handle, firstRow, firstCol,
					lastRow, lastCol) == LXW_NO_ERROR);
	}

	void dataValidationCell(RowType row, ColType col,
			lxw_data_validation* validator)
	{
		enforce(worksheet_data_validation_cell(this.handle, row,
					col, validator
				)
				== LXW_NO_ERROR
			);
	}

	void dataValidationRange(RowType firstRow, ColType firstCol,
			RowType lastRow, ColType lastCol, lxw_data_validation* validator)
	{
		enforce(worksheet_data_validation_range(this.handle, firstRow,
					firstCol, lastRow, lastCol, validator
				)
				== LXW_NO_ERROR
			);
	}

	void activate() @nogc nothrow {
		worksheet_activate(this.handle);
	}

	void select() @nogc nothrow {
		worksheet_select(this.handle);
	}

	void hide() @nogc nothrow {
		worksheet_hide(this.handle);
	}

	void setFirstSheet() @nogc nothrow {
		worksheet_set_first_sheet(this.handle);
	}

	void freezePanes(RowType row, ColType col) @nogc nothrow {
		worksheet_freeze_panes(this.handle, row, col);
	}

	void splitPanes(double vertical, double horizontal) @nogc nothrow {
		worksheet_split_panes(this.handle, vertical, horizontal);
	}

	void setSelection(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol) @nogc nothrow
	{
		worksheet_set_selection(this.handle, firstRow, firstCol, lastRow,
				lastCol
			);
	}

	void setLandscape() @nogc nothrow {
		worksheet_set_landscape(this.handle);
	}

	void setPortrait() @nogc nothrow {
		worksheet_set_portrait(this.handle);
	}

	void setPageView() @nogc nothrow {
		worksheet_set_page_view(this.handle);
	}

	void setPaper(ubyte paperType) @nogc nothrow {
		worksheet_set_paper(this.handle, paperType);
	}

	void setMargins(double left, double right, double top, double bottom)
			@nogc nothrow
	{
		worksheet_set_margins(this.handle, left, right, top, bottom);
	}

	void setHeader(string header) {
		enforce(worksheet_set_header(this.handle, toStringz(header))
				== LXW_NO_ERROR
			);
	}

	void setFooter(string footer) {
		enforce(worksheet_set_footer(this.handle, toStringz(footer))
				== LXW_NO_ERROR
			);
	}

	void setHeaderOpt(string header, lxw_header_footer_options* options) {
		enforce(worksheet_set_header_opt(this.handle, toStringz(header),
					options
				)
				== LXW_NO_ERROR
			);
	}

	void setFooterOpt(string footer, lxw_header_footer_options* options) {
		enforce(worksheet_set_footer_opt(this.handle, toStringz(footer),
					options
				)
				== LXW_NO_ERROR
			);
	}

	void setHPagebreaks(RowType[] row) {
		enforce(worksheet_set_h_pagebreaks(this.handle, row.ptr)
				== LXW_NO_ERROR
			);
	}

	void setVPagebreaks(ColType[] col) {
		enforce(worksheet_set_v_pagebreaks(this.handle, col.ptr)
				== LXW_NO_ERROR
			);
	}

	void printAcross() @nogc nothrow {
		worksheet_print_across(this.handle);
	}

	void setZoom(ushort scale) @nogc nothrow {
		worksheet_set_zoom(this.handle, scale);
	}

	void gridlines(ubyte option) @nogc nothrow {
		worksheet_gridlines(this.handle, option);
	}

	void centerHorizontally() @nogc nothrow {
		worksheet_center_horizontally(this.handle);
	}

	void centerVertically() @nogc nothrow {
		worksheet_center_vertically(this.handle);

	}
	void printRowColHeaders() @nogc nothrow {
		worksheet_print_row_col_headers(this.handle);
	}

	void repeatRows(RowType firstRow, RowType lastRow) {
		enforce(worksheet_repeat_rows(this.handle, firstRow, lastRow) ==
				LXW_NO_ERROR);
	}

	void repeatColumns(ColType firstCol, ColType lastCol) {
		enforce(worksheet_repeat_columns(this.handle, firstCol, lastCol)
				== LXW_NO_ERROR
			);
	}

	void printArea(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol)
	{
		enforce(worksheet_print_area(this.handle, firstRow, firstCol, lastRow,
					lastCol
				)
				== LXW_NO_ERROR
			);
	}

	void fitToPages(ushort width, ushort height) @nogc nothrow {
		worksheet_fit_to_pages(this.handle, width, height);
	}

	void setStartPage(ushort startPage) @nogc nothrow {
		worksheet_set_start_page(this.handle, startPage);
	}

	void setPrintScale(ushort scale) @nogc nothrow {
		worksheet_set_print_scale(this.handle, scale);
	}

	void rightToLeft() @nogc nothrow {
		worksheet_right_to_left(this.handle);
	}

	void hideZero() @nogc nothrow {
		worksheet_hide_zero(this.handle);
	}

	void setTabColor(lxw_color_t color) @nogc nothrow {
		worksheet_set_tab_color(this.handle, color);
	}

	void protect(string password, lxw_protection* options) {
		worksheet_protect(this.handle, toStringz(password), options);
	}

	void outlineSettings(ubyte visible, ubyte symbolsBelow,
			ubyte symbolsRight, ubyte autoStyle) @nogc nothrow
	{
		worksheet_outline_settings(this.handle, visible, symbolsBelow,
			symbolsRight, autoStyle);
	}

	void setDefaultRow(double height, ubyte hideUnusedRows) @nogc nothrow {
		worksheet_set_default_row(this.handle, height, hideUnusedRows);
	}
}
