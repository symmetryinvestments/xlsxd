module libxlsxd.worksheet;

import libxlsxd.types;
import libxlsxd.datetime;
import libxlsxd.format;
import libxlsxd.chart;

import libxlsxd.xlsxwrap;

private pure string genWriteOverloads() {
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
			["DateTime", "DateTime", ""],
			["DateTime", "DateTime", "Format"],
			["Date", "Date", ""],
			["Date", "Date", "Format"],
			["TimeOfDay", "TimeOfDay", ""],
			["TimeOfDay", "TimeOfDay", "Format"],
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
		ret ~= `
	void writeBlank(RowType row, ColType col) @safe {
		this.writeBlankImpl(row, col, Format(null));
	}

	void writeBlankFormat(RowType row, ColType col, Format f) @safe {
		this.writeBlankImpl(row, col, f);
	}

	void writeFormulaNum(RowType row, ColType col, string formula, double num)
			@safe
	{
		this.writeFormulaNumImpl(row, col, formula, num, Format(null));
	}

	void writeFormulaNumFormat(RowType row, ColType col, string formula,
			double num, Format f) @safe
	{
		this.writeFormulaNumImpl(row, col, formula, num, f);
	}
`;

	} else {
		immutable overloads = true;
		ret ~= `
	void writeBlank(RowType row, ColType col) @safe {
		this.writeBlankImpl(row, col, Format(null));
	}

	void writeBlank(RowType row, ColType col, Format f) @safe {
		this.writeBlankImpl(row, col, f);
	}

	void writeFormulaNum(RowType row, ColType col, string formula, double num)
			@safe
	{
		this.writeFormulaNumImpl(row, col, formula, num, Format(null));
	}

	void writeFormulaNum(RowType row, ColType col, string formula,
			double num, Format f) @safe
	{
		this.writeFormulaNumImpl(row, col, formula, num, f);
	}
`;
	}

	foreach(string[3] f; fun) {
		bool addi = !f[2].empty;
		ret ~= format(
				"void write%s%s(RowType row, ColType col, %s value%s) @safe {\n",
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

struct Column {
	WorksheetFluent* wsf;

	this(WorksheetFluent* wsf) @safe {
		this.wsf = wsf;
	}

	Column writeInt(long value) @safe {
		return this.writeIntFormatted(value, Format(null));
	}

	Column writeIntFormatted(long value, Format format) @safe {
		this.wsf.ws.write(this.wsf.pos.row++, this.wsf.pos.col, value,
				format);
		return this;
	}

	Column writeNumber(double value) @safe {
		return this.writeNumberFormatted(value, Format(null));
	}

	Column writeNumberFormatted(double value, Format format) @safe {
		this.wsf.ws.write(this.wsf.pos.row++, this.wsf.pos.col, value,
				format);
		return this;
	}

	Column writeString(string value) @safe {
		return this.writeStringFormatted(value, Format(null));
	}

	Column writeStringFormatted(string value, Format format) @safe {
		this.wsf.ws.write(this.wsf.pos.row++, this.wsf.pos.col, value,
				format);
		return this;
	}

	WorksheetFluent terminate() @safe {
		this.wsf.pos.row = 0;
		this.wsf.pos.col++;
		return *this.wsf;
	}
}

struct Row {
	WorksheetFluent* wsf;

	this(WorksheetFluent* wsf) @safe {
		this.wsf = wsf;
	}

	Row writeInt(long value) @safe {
		return this.writeIntFormatted(value, Format(null));
	}

	Row writeIntFormatted(long value, Format format) @safe {
		this.wsf.ws.write(this.wsf.pos.row, this.wsf.pos.col++, value,
				format);
		return this;
	}

	Row writeNumber(double value) @safe {
		return this.writeNumberFormatted(value, Format(null));
	}

	Row writeNumberFormatted(double value, Format format) @safe {
		this.wsf.ws.write(this.wsf.pos.row, this.wsf.pos.col++, value,
				format);
		return this;
	}

	Row writeString(string value) @safe {
		return this.writeStringFormatted(value, Format(null));
	}

	Row writeStringFormatted(string value, Format format) @safe {
		this.wsf.ws.write(this.wsf.pos.row, this.wsf.pos.col++, value,
				format);
		return this;
	}

	WorksheetFluent terminate() @safe {
		this.wsf.pos.row++;
		this.wsf.pos.col = 0;
		return *this.wsf;
	}
}

struct Position {
	RowType row;
	ColType col;
}

struct WorksheetFluent {
	import libxlsxd.workbook : WorkbookOpen;
	WorkbookOpen* wb;
	Worksheet ws;

	Position pos;

	this(WorkbookOpen* wb, Worksheet ws) @safe {
		this.wb = wb;
		this.ws = ws;
	}

	Row startRow() @safe {
		return Row(&this);
	}

	Column startColumn() @safe {
		return Column(&this);
	}

	WorkbookOpen terminate() @safe {
		return *this.wb;
	}
}

struct Worksheet {
	import core.stdc.config : c_ulong;
	import std.datetime;
	import std.string : toStringz;
	import std.exception : enforce;
	lxw_worksheet* handle;

	private Format* dtf;
	private Format* df;
	private Format* tf;

	this(lxw_worksheet* handle, Format* dtf, Format* df, Format* tf)
			@nogc nothrow @safe
	{
		this.handle = handle;
		this.dtf = dtf;
		this.df = df;
		this.tf = tf;
	}

	mixin(genWriteOverloads());

	void write(T)(RowType row, ColType col, T value) @safe {
		this.write(row, col, value, Format(null));
	}

	void write(T)(RowType row, ColType col, T value, Format format) @trusted {
		import std.traits : isIntegral, isFloatingPoint, isSomeString;
		static if((isFloatingPoint!T || isIntegral!T) && !is(T == bool)) {
			this.writeNumberImpl(row, col, value, format);
		} else static if(isSomeString!T) {
			this.writeStringImpl(row, col, value, format);
		} else static if(is(T == TimeOfDay)) {
			format = format.handle == null ? *this.tf : format;
			Datetime theTime;
			version(No_Overloads_Or_Templates) {
				theTime = Datetime.fromTimeOfDay(value);
			} else {
				theTime = Datetime(value);
			}
			this.writeDatetimeImpl(row, col, theTime, format);
		} else static if(is(T == Date)) {
			format = format.handle == null ? *this.df : format;
			Datetime theTime;
			version(No_Overloads_Or_Templates) {
				theTime = Datetime.fromDate(value);
			} else {
				theTime = Datetime(value);
			}
			this.writeDatetimeImpl(row, col, theTime, format);
		} else static if(is(T == DateTime)) {
			format = format.handle == null ? *this.dtf : format;
			Datetime theTime;
			version(No_Overloads_Or_Templates) {
				theTime = Datetime.fromDateTime(value);
			} else {
				theTime = Datetime(value);
			}
			this.writeDatetimeImpl(row, col, theTime, format);
		} else static if(is(T == Datetime)) {
			this.writeDatetimeImpl(row, col, value, format);
		} else static if(is(T == bool)) {
			this.writeBooleanImpl(row, col, value, format);
		} else {
			static assert(false, "The function 'write' does not support type
					'" ~ T.stringof ~ "'");
		}
	}

	size_t writeAndGetWidth(T)(RowType row, ColType col, T value) @safe {
		return writeAndGetWidth(row, col, value, Format(null));
	}

	size_t writeAndGetWidth(T)(RowType row, ColType col, T value,
			Format format) @safe
	{
		import std.traits : isIntegral, isFloatingPoint, isSomeString;
		import std.conv : to;
		static if((isFloatingPoint!T || isIntegral!T) && !is(T == bool)) {
			this.writeNumberImpl(row, col, value, format);
			return to!string(value).length;
		} else static if(is(T == TimeOfDay)) {
			format = format.handle == null ? *this.tf : format;
			Datetime theTime;
			version(No_Overloads_Or_Templates) {
				theTime = Datetime.fromTimeOfday(value);
			} else {
				theTime = Datetime(value);
			}
			this.writeDatetimeImpl(row, col, theTime, format);
			return to!size_t(8);
		} else static if(is(T == Date)) {
			format = format.handle == null ? *this.df : format;
			Datetime theTime;
			version(No_Overloads_Or_Templates) {
				theTime = Datetime.fromTimeOfday(value);
			} else {
				theTime = Datetime(value);
			}
			return to!size_t(10);
			this.writeDatetimeImpl(row, col, theTime, format);
		} else static if(is(T == DateTime)) {
			format = format.handle == null ? *this.dtf : format;
			Datetime theTime;
			version(No_Overloads_Or_Templates) {
				theTime = Datetime.fromDateTime(value);
			} else {
				theTime = Datetime(value);
			}
			this.writeDatetimeImpl(row, col, theTime, format);
			return to!size_t(19);
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
			Format format) @trusted
	{
		enforce(worksheet_write_number(this.handle, row, col,
					num, format.handle) == LXW_NO_ERROR);
	}

	void writeNumberImpl(RowType row, ColType col, double num,
			Format format) @trusted
	{
		enforce(worksheet_write_number(this.handle, row, col,
					num, format.handle) == LXW_NO_ERROR);
	}

	void writeStringImpl(RowType row, ColType col, string str, Format format)
			@trusted
	{
		enforce(worksheet_write_string(this.handle, row, col,
					toStringz(str), format.handle) == LXW_NO_ERROR);
	}

	private void writeFormulaImpl(RowType row, ColType col, string formula,
			Format format) @trusted
	{
		enforce(worksheet_write_formula(this.handle, row, col,
					toStringz(formula), format.handle) == LXW_NO_ERROR);
	}

	void writeArrayFormula(RowType firstRow, ColType firstCol,
			RowType lastRow, ColType lastCol, string formula) @trusted
	{
		this.writeArrayFormulaImpl(firstRow, firstCol, lastRow, lastCol,
				formula, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void writeArrayFormulaFormat(RowType firstRow, ColType firstCol,
				RowType lastRow, ColType lastCol, string formula, Format format)
				@trusted
		{
			this.writeArrayFormulaImpl(firstRow, firstCol, lastRow, lastCol,
					formula, format);
		}
	} else {
		void writeArrayFormula(RowType firstRow, ColType firstCol,
				RowType lastRow, ColType lastCol, string formula, Format format)
				@trusted
		{
			this.writeArrayFormulaImpl(firstRow, firstCol, lastRow, lastCol,
					formula, format);
		}
	}

	private void writeArrayFormulaImpl(RowType firstRow, ColType firstCol,
			RowType lastRow, ColType lastCol, string formula, Format format)
			@trusted
	{
		enforce(worksheet_write_array_formula(this.handle, firstRow,
					firstCol, lastRow, lastCol, toStringz(formula),
					format.handle) == LXW_NO_ERROR);
	}

	void writeTimeOfDayImpl(RowType row, ColType col, TimeOfDay tod,
			Format format) @trusted
	{
		Datetime theTime;
		version(No_Overloads_Or_Templates) {
			theTime = Datetime.fromTimeOfDay(tod);
		} else {
			theTime = Datetime(tod);
		}
		enforce(worksheet_write_datetime(this.handle, row, col,
					&theTime.handle, format.handle) == LXW_NO_ERROR);
	}

	void writeDateImpl(RowType row, ColType col, Date date,
			Format format) @trusted
	{
		Datetime theTime;
		version(No_Overloads_Or_Templates) {
			theTime = Datetime.fromDate(date);
		} else {
			theTime = Datetime(date);
		}
		enforce(worksheet_write_datetime(this.handle, row, col,
					&theTime.handle, format.handle) == LXW_NO_ERROR);
	}

	void writeDateTimeImpl(RowType row, ColType col, DateTime dt,
			Format format) @trusted
	{
		Datetime theTime;
		version(No_Overloads_Or_Templates) {
			theTime = Datetime.fromDateTime(dt);
		} else {
			theTime = Datetime(dt);
		}
		enforce(worksheet_write_datetime(this.handle, row, col,
					&theTime.handle, format.handle) == LXW_NO_ERROR);
	}

	void writeDatetimeImpl(RowType row, ColType col, Datetime datetime,
			Format format) @trusted
	{
		enforce(worksheet_write_datetime(this.handle, row, col,
					&datetime.handle, format.handle) == LXW_NO_ERROR);
	}

	void writeUrlImpl(RowType row, ColType col, string url, Format format)
			@trusted
	{
		enforce(worksheet_write_url(this.handle, row, col,
					toStringz(url), format.handle) == LXW_NO_ERROR);
	}

	void writeBooleanImpl(RowType row, ColType col, bool value, Format format)
			@trusted
	{
		enforce(worksheet_write_boolean(this.handle, row, col,
					value, format.handle) == LXW_NO_ERROR);
	}

	void writeBlankImpl(RowType row, ColType col, Format format) @trusted {
		enforce(worksheet_write_blank(this.handle, row, col,
					format.handle) == LXW_NO_ERROR);
	}

	void writeFormulaNumImpl(RowType row, ColType col, string formula,
			double value, Format format) @trusted
	{
		enforce(worksheet_write_formula_num(this.handle, row,
					col, toStringz(formula), format.handle, value
				)
				== LXW_NO_ERROR
			);
	}

	void writeRichStringImpl(RowType row, ColType col,
			lxw_rich_string_tuple** rst, Format format) @trusted
	{
		enforce(worksheet_write_rich_string(this.handle, row,
					col, rst, format.handle
				)
				== LXW_NO_ERROR
			);
	}

	void setRow(RowType row, double height) @safe {
		this.setRowImpl(row, height, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void setRowFormat(RowType row, double height, Format f) @safe {
			this.setRowImpl(row, height, f);
		}
	} else {
		void setRow(RowType row, double height, Format f) @safe {
			this.setRowImpl(row, height, f);
		}
	}

	private void setRowImpl(RowType row, double height, Format format)
			@trusted
	{
		enforce(worksheet_set_row(this.handle, row, height, format.handle)
				== LXW_NO_ERROR
			);
	}

	void setRowOpt(RowType row, double height, lxw_row_col_options* options)
			@trusted
	{
		this.setRowOptImpl(row, height, options, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void setRowOptFormat(RowType row, double height,
				lxw_row_col_options* options, Format f) @trusted
		{
			this.setRowOptImpl(row, height, options, f);
		}
	} else {
		void setRowOpt(RowType row, double height,
				lxw_row_col_options* options, Format f) @trusted
		{
			this.setRowOptImpl(row, height, options, f);
		}
	}

	private void setRowOptImpl(RowType row, double height,
			lxw_row_col_options* options, Format format) @trusted
	{
		enforce(worksheet_set_row_opt(this.handle, row, height,
					format.handle, options) == LXW_NO_ERROR);
	}

	void setColumn(ColType firstCol, ColType lastCol, double width) @trusted {
		this.setColumnImpl(firstCol, lastCol, width, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void setColumnFormat(ColType firstCol, ColType lastCol, double width,
				Format f) @trusted
		{
			this.setColumnImpl(firstCol, lastCol, width, f);
		}
	} else {
		void setColumn(ColType firstCol, ColType lastCol, double width,
				Format f) @trusted
		{
			this.setColumnImpl(firstCol, lastCol, width, f);
		}
	}

	private void setColumnImpl(ColType firstCol, ColType lastCol, double width,
			Format format) @trusted
	{
		enforce(worksheet_set_column(this.handle, firstCol, lastCol,
					width, format.handle
				)
				== LXW_NO_ERROR
			);
	}

	void setColumnOpt(ColType firstCol, ColType lastCol, double width,
			lxw_row_col_options* options) @trusted
	{
		this.setColumnOptImpl(firstCol, lastCol, width, options, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void setColumnOptFormat(ColType firstCol, ColType lastCol, double width,
				lxw_row_col_options* options, Format f) @trusted
		{
			this.setColumnOptImpl(firstCol, lastCol, width, options, f);
		}
	} else {
		void setColumnOpt(ColType firstCol, ColType lastCol, double width,
				lxw_row_col_options* options, Format f) @trusted
		{
			this.setColumnOptImpl(firstCol, lastCol, width, options, f);
		}
	}

	private void setColumnOptImpl(ColType firstCol, ColType lastCol,
			double width, lxw_row_col_options* options, Format format) @trusted
	{
		enforce(worksheet_set_column_opt(this.handle, firstCol, lastCol,
					width, format.handle, options)
				== LXW_NO_ERROR
			);
	}

	void insertImage(RowType row, ColType col, string filename) @trusted {
		enforce(worksheet_insert_image(this.handle, row, col,
					toStringz(filename)
				)
				== LXW_NO_ERROR
			);
	}

	void insertImageOpt(RowType row, ColType col, string filename,
			lxw_image_options* options) @trusted
	{
		enforce(worksheet_insert_image_opt(this.handle, row, col,
					toStringz(filename), options
				)
				== LXW_NO_ERROR
			);
	}

	void insertImageBuffer(RowType row, ColType col, const(ubyte)* buf,
			size_t bufSize) @trusted
	{
		enforce(worksheet_insert_image_buffer(this.handle, row,
					col, buf, cast(c_ulong)bufSize
				)
				== LXW_NO_ERROR
			);
	}

	void insertImageBufferOpt(RowType row, ColType col, const(ubyte)* buf,
			size_t bufSize, lxw_image_options* options) @trusted
	{
		enforce(worksheet_insert_image_buffer_opt(this.handle, row,
					col, buf, cast(c_ulong)bufSize, options
				)
				== LXW_NO_ERROR
			);
	}

	void insertChart(RowType row, ColType col, Chart chart) @trusted {
		enforce(worksheet_insert_chart(this.handle, row, col,
					chart.handle) == LXW_NO_ERROR);
	}

	void insertChartOpt(RowType row, ColType col, Chart chart,
			lxw_image_options* options) @trusted
	{
		enforce(worksheet_insert_chart_opt(this.handle, row,
					col, chart.handle, options
				)
				== LXW_NO_ERROR
			);
	}

	void mergeRange(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol, string str) @trusted
	{
		this.mergeRangeImpl(firstRow, firstCol, lastRow,
			lastCol, str, Format(null));
	}

	version(No_Overloads_Or_Templates) {
		void mergeRangeFormat(RowType firstRow, ColType firstCol,
				RowType lastRow, ColType lastCol, string str, Format f) @trusted
		{
			this.mergeRangeImpl(firstRow, firstCol, lastRow,
				lastCol, str, f);
		}
	} else {
		void mergeRange(RowType firstRow, ColType firstCol, RowType lastRow,
				ColType lastCol, string str, Format f) @trusted
		{
			this.mergeRangeImpl(firstRow, firstCol, lastRow,
				lastCol, str, f);
		}
	}

	private void mergeRangeImpl(RowType firstRow, ColType firstCol,
			RowType lastRow, ColType lastCol, string str, Format format)
			@trusted
	{
		enforce(worksheet_merge_range(this.handle, firstRow, firstCol,
					lastRow, lastCol, toStringz(str), format.handle
				)
				== LXW_NO_ERROR
			);
	}

	void autofilter(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol) @trusted
	{
		enforce(worksheet_autofilter(this.handle, firstRow, firstCol,
					lastRow, lastCol) == LXW_NO_ERROR);
	}

	void dataValidationCell(RowType row, ColType col,
			lxw_data_validation* validator) @trusted
	{
		enforce(worksheet_data_validation_cell(this.handle, row,
					col, validator
				)
				== LXW_NO_ERROR
			);
	}

	void dataValidationRange(RowType firstRow, ColType firstCol,
			RowType lastRow, ColType lastCol, lxw_data_validation* validator)
			@trusted
	{
		enforce(worksheet_data_validation_range(this.handle, firstRow,
					firstCol, lastRow, lastCol, validator
				)
				== LXW_NO_ERROR
			);
	}

	void activate() @nogc nothrow @trusted {
		worksheet_activate(this.handle);
	}

	void select() @nogc nothrow @trusted {
		worksheet_select(this.handle);
	}

	void hide() @nogc nothrow @trusted {
		worksheet_hide(this.handle);
	}

	void setFirstSheet() @nogc nothrow @trusted {
		worksheet_set_first_sheet(this.handle);
	}

	void freezePanes(RowType row, ColType col) @nogc nothrow @trusted {
		worksheet_freeze_panes(this.handle, row, col);
	}

	void splitPanes(double vertical, double horizontal) @nogc nothrow @trusted {
		worksheet_split_panes(this.handle, vertical, horizontal);
	}

	void setSelection(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol) @nogc nothrow @trusted
	{
		worksheet_set_selection(this.handle, firstRow, firstCol, lastRow,
				lastCol
			);
	}

	void setLandscape() @nogc nothrow @trusted {
		worksheet_set_landscape(this.handle);
	}

	void setPortrait() @nogc nothrow @trusted {
		worksheet_set_portrait(this.handle);
	}

	void setPageView() @nogc nothrow @trusted {
		worksheet_set_page_view(this.handle);
	}

	void setPaper(ubyte paperType) @nogc nothrow @trusted {
		worksheet_set_paper(this.handle, paperType);
	}

	void setMargins(double left, double right, double top, double bottom)
			@nogc nothrow @trusted
	{
		worksheet_set_margins(this.handle, left, right, top, bottom);
	}

	void setHeader(string header) @trusted {
		enforce(worksheet_set_header(this.handle, toStringz(header))
				== LXW_NO_ERROR
			);
	}

	void setFooter(string footer) @trusted {
		enforce(worksheet_set_footer(this.handle, toStringz(footer))
				== LXW_NO_ERROR
			);
	}

	void setHeaderOpt(string header, lxw_header_footer_options* options)
			@trusted
	{
		enforce(worksheet_set_header_opt(this.handle, toStringz(header),
					options
				)
				== LXW_NO_ERROR
			);
	}

	void setFooterOpt(string footer, lxw_header_footer_options* options)
			@trusted
	{
		enforce(worksheet_set_footer_opt(this.handle, toStringz(footer),
					options
				)
				== LXW_NO_ERROR
			);
	}

	void setHPagebreaks(RowType[] row) @trusted {
		enforce(worksheet_set_h_pagebreaks(this.handle, row.ptr)
				== LXW_NO_ERROR
			);
	}

	void setVPagebreaks(ColType[] col) @trusted {
		enforce(worksheet_set_v_pagebreaks(this.handle, col.ptr)
				== LXW_NO_ERROR
			);
	}

	void printAcross() @nogc nothrow @trusted {
		worksheet_print_across(this.handle);
	}

	void setZoom(ushort scale) @nogc nothrow @trusted {
		worksheet_set_zoom(this.handle, scale);
	}

	void gridlines(ubyte option) @nogc nothrow @trusted {
		worksheet_gridlines(this.handle, option);
	}

	void centerHorizontally() @nogc nothrow @trusted {
		worksheet_center_horizontally(this.handle);
	}

	void centerVertically() @nogc nothrow @trusted {
		worksheet_center_vertically(this.handle);

	}
	void printRowColHeaders() @nogc nothrow @trusted {
		worksheet_print_row_col_headers(this.handle);
	}

	void repeatRows(RowType firstRow, RowType lastRow) @trusted {
		enforce(worksheet_repeat_rows(this.handle, firstRow, lastRow) ==
				LXW_NO_ERROR);
	}

	void repeatColumns(ColType firstCol, ColType lastCol) @trusted {
		enforce(worksheet_repeat_columns(this.handle, firstCol, lastCol)
				== LXW_NO_ERROR
			);
	}

	void printArea(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol) @trusted
	{
		enforce(worksheet_print_area(this.handle, firstRow, firstCol, lastRow,
					lastCol
				)
				== LXW_NO_ERROR
			);
	}

	void fitToPages(ushort width, ushort height) @nogc nothrow @trusted {
		worksheet_fit_to_pages(this.handle, width, height);
	}

	void setStartPage(ushort startPage) @nogc nothrow @trusted {
		worksheet_set_start_page(this.handle, startPage);
	}

	void setPrintScale(ushort scale) @nogc nothrow @trusted {
		worksheet_set_print_scale(this.handle, scale);
	}

	void rightToLeft() @nogc nothrow @trusted {
		worksheet_right_to_left(this.handle);
	}

	void hideZero() @nogc nothrow @trusted {
		worksheet_hide_zero(this.handle);
	}

	void setTabColor(lxw_color_t color) @nogc nothrow @trusted {
		worksheet_set_tab_color(this.handle, color);
	}

	void protect(string password, lxw_protection* options) @trusted {
		worksheet_protect(this.handle, toStringz(password), options);
	}

	void outlineSettings(ubyte visible, ubyte symbolsBelow,
			ubyte symbolsRight, ubyte autoStyle) @nogc nothrow @trusted
	{
		worksheet_outline_settings(this.handle, visible, symbolsBelow,
			symbolsRight, autoStyle);
	}

	void setDefaultRow(double height, ubyte hideUnusedRows) @nogc nothrow
			@trusted
	{
		worksheet_set_default_row(this.handle, height, hideUnusedRows);
	}
}
