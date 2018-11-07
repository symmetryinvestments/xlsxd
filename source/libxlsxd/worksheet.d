module libxlsxd.worksheet;

import libxlsxd.types;
import libxlsxd.datetime;
import libxlsxd.format;
import libxlsxd.chart;

import libxlsxd.xlsxwrap;

struct Worksheet {
	import std.string : toStringz;
	import std.exception : enforce;
	lxw_worksheet* handle;

	this(lxw_worksheet* handle) {
		this.handle = handle;
	}

	void write(T)(RowType row, ColType col, T value) {
		this.write(row, col, value, Format(null));
	}

	void write(T)(RowType row, ColType col, T value, Format format) {
		import std.traits : isIntegral, isFloatingPoint, isSomeString;
		static if((isFloatingPoint!T || isIntegral!T) && !is(T == bool)) {
			this.writeNumber(row, col, value, format);
		} else static if(isSomeString!T) {	
			this.writeString(row, col, value, format);
		} else static if(is(T == Datetime)) {	
			this.writeDatetime(row, col, value, format);
		} else static if(is(T == bool)) {	
			this.writeBoolean(row, col, value, format);
		}
	}

    void writeNumber(RowType row, ColType col, double num) {
		this.writeNumber(row, col, num, Format(null));
	}

    void writeNumber(RowType row, ColType col, double num, 
			Format format) 
	{
    	enforce(worksheet_write_number(this.handle, row, col,
					num, format.handle) == LXW_NO_ERROR);
	}

    void writeString(RowType row, ColType col, string str) {
		this.writeString(row, col, str, Format(null));
	}

    void writeString(RowType row, ColType col, string str, Format format) {
    	enforce(worksheet_write_string(this.handle, row, col,
					toStringz(str), format.handle) == LXW_NO_ERROR);
	}

    void writeFormula(RowType row, ColType col, string formula) {
		this.writeFormula(row, col, formula, Format(null));
	}
	
    void writeFormula(RowType row, ColType col, string formula, Format format) {
    	enforce(worksheet_write_formula(this.handle, row, col,
					toStringz(formula), format.handle) == LXW_NO_ERROR);
	}
	
    void writeArrayFormula(RowType firstRow, ColType firstCol, 
			RowType lastRow, ColType lastCol, string formula) 
	{
		this.writeArrayFormula(firstRow, firstCol, lastRow, lastCol, formula, 
				Format(null)
			);
	}

    void writeArrayFormula(RowType firstRow, ColType firstCol, 
			RowType lastRow, ColType lastCol, string formula, Format format) 
	{
    	enforce(worksheet_write_array_formula(this.handle, firstRow,
					firstCol, lastRow, lastCol, toStringz(formula),
					format.handle) == LXW_NO_ERROR);
	}
	
    void writeDatetime(RowType row, ColType col, Datetime datetime) {
		this.writeDatetime(row, col, datetime, Format(null));
	}

    void writeDatetime(RowType row, ColType col, Datetime datetime, Format format) {
    	enforce(worksheet_write_datetime(this.handle, row, col,
					&datetime.handle, format.handle) == LXW_NO_ERROR);
	}

    void writeUrl(RowType row, ColType col, string url) {
		this.writeUrl(row, col, url, Format(null));
	}

    void writeUrl(RowType row, ColType col, string url, Format format) {
    	enforce(worksheet_write_url(this.handle, row, col,
					toStringz(url), format.handle) == LXW_NO_ERROR);
	}

    void writeBoolean(RowType row, ColType col, bool value) {
    	this.writeBoolean(row, col, value, Format(null));
	}

    void writeBoolean(RowType row, ColType col, bool value, Format format) {
    	enforce(worksheet_write_boolean(this.handle, row, col,
					value, format.handle) == LXW_NO_ERROR);
	}

    void writeBlank(RowType row, ColType col) {
    	this.writeBlank(row, col, Format(null));
	}

    void writeBlank(RowType row, ColType col, Format format) {
    	enforce(worksheet_write_blank(this.handle, row, col,
					format.handle) == LXW_NO_ERROR);
	}

    void writeFormulaNum(RowType row, ColType col, string formula, 
			double value) 
	{
    	this.writeFormulaNum(row, col, formula, Format(null), value);
	}

    void writeFormulaNum(RowType row, ColType col, string formula, 
			Format format, double value) 
	{
    	enforce(worksheet_write_formula_num(this.handle, row,
					col, toStringz(formula), format.handle, value
				) 
				== LXW_NO_ERROR
			); 
	}

    void writeRichString(RowType row, ColType col, 
			lxw_rich_string_tuple** rst) 
	{
    	this.writeRichString(row, col, rst, Format(null));
	}

    void writeRichString(RowType row, ColType col, 
			lxw_rich_string_tuple** rst, Format format) 
	{
    	enforce(worksheet_write_rich_string(this.handle, row,
					col, rst, format.handle
				) 
				== LXW_NO_ERROR
			);
	}

    void setRow(RowType row, double height) {
    	this.setRow(row, height, Format(null));
	}

    void setRow(RowType row, double height, Format format) {
    	enforce(worksheet_set_row(this.handle, row, height, format.handle) 
				== LXW_NO_ERROR
			);
	}

    void setRowOpt(RowType row, double height, lxw_row_col_options* options) {
    	this.setRowOpt(row, height, Format(null), options);
	}

    void setRowOpt(RowType row, double height, Format format,
			lxw_row_col_options* options) 
	{
    	enforce(worksheet_set_row_opt(this.handle, row, height,
					format.handle, options) == LXW_NO_ERROR);
	}

    void setColumn(ColType firstCol, ColType lastCol, double width) {
    	this.setColumn(firstCol, lastCol, width, Format(null));
	}

    void setColumn(ColType firstCol, ColType lastCol, double width, Format format) {
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
			ColType lastCol) 
	{
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

    void activate() {
    	worksheet_activate(this.handle);
	}

    void select() {
    	worksheet_select(this.handle);
	}

    void hide() {
    	worksheet_hide(this.handle);
	}

    void setFirstSheet() {
    	worksheet_set_first_sheet(this.handle);
	}

    void freezePanes(RowType row, ColType col) {
    	worksheet_freeze_panes(this.handle, row, col);
	}

    void splitPanes(double vertical, double horizontal) {
    	worksheet_split_panes(this.handle, vertical, horizontal);
	}

    void setSelection(RowType firstRow, ColType firstCol, RowType lastRow,
			ColType lastCol) 
	{
    	worksheet_set_selection(this.handle, firstRow, firstCol, lastRow,
				lastCol
			);
	}

    void setLandscape() {
    	worksheet_set_landscape(this.handle);
	}

    void setPortrait() {
    	worksheet_set_portrait(this.handle);
	}

    void setPageView() {
    	worksheet_set_page_view(this.handle);
	}

    void setPaper(ubyte paperType) {
    	worksheet_set_paper(this.handle, paperType);
	}

    void setMargins(double left, double right, double top, double bottom) {
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

    void printAcross() {
    	worksheet_print_across(this.handle);
	}

    void setZoom(ushort scale) {
    	worksheet_set_zoom(this.handle, scale);
	}

    void gridlines(ubyte option) {
    	worksheet_gridlines(this.handle, option);
	}

    void centerHorizontally() {
    	worksheet_center_horizontally(this.handle);
	}

    void centerVertically() {
    	worksheet_center_vertically(this.handle);

	}
    void printRowColHeaders() {
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

    void fitToPages(ushort width, ushort height) {
    	worksheet_fit_to_pages(this.handle, width, height);
	}

    void setStartPage(ushort startPage) {
    	worksheet_set_start_page(this.handle, startPage);
	}

    void setPrintScale(ushort scale) {
    	worksheet_set_print_scale(this.handle, scale);
	}

    void rightToLeft() {
    	worksheet_right_to_left(this.handle);
	}

    void hideZero() {
    	worksheet_hide_zero(this.handle);
	}

    void setTabColor(lxw_color_t color) {
    	worksheet_set_tab_color(this.handle, color);
	}

    void protect(string password, lxw_protection* options) {
    	worksheet_protect(this.handle, toStringz(password), options);
	}

    void outlineSettings(ubyte visible, ubyte symbolsBelow, 
			ubyte symbolsRight, ubyte autoStyle) 
	{
    	worksheet_outline_settings(this.handle, visible, symbolsBelow, 
			symbolsRight, autoStyle);
	}

    void setDefaultRow(double height, ubyte hideUnusedRows) {
    	worksheet_set_default_row(this.handle, height, hideUnusedRows);
	}
}
