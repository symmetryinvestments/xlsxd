module libxlsxd.chart;

import xlsxwrap;

struct Chart {
	import libxlsxd.types;
	import std.exception : enforce;
	import std.string : toStringz;
	import libxlsxd.chartseries;
	import libxlsxd.chartaxis;

	lxw_chart* handle;

	this(lxw_chart* handle) {
		this.handle = handle;
	}

	void free() {
		lxw_chart_free(this.handle);
	}

	void assembleXmlFile() {
		lxw_chart_assemble_xml_file(this.handle);
	}

	Chartseries addChartseries(string categories, string values) {
		return Chartseries(chart_add_series(this.handle, toStringz(categories),
					toStringz(values)
				));
	}

	Chartaxis axisGet(lxw_chart_axis_type axisType) {
		return Chartaxis(chart_axis_get(this.handle, axisType));
	}

	void titleSetName(string title) {
		chart_title_set_name(this.handle, toStringz(title));
	}
	
	void titleSetNameRange(string sheetname, RowType row, ColType col) {
		chart_title_set_name_range(this.handle, toStringz(sheetname), row, col);
	}

	void titleSetNameFont(lxw_chart_font* font) {
		chart_title_set_name_font(this.handle, font);
	}

	void titleOff() {
		chart_title_off(this.handle);
	}

	void legendSetPosition(ubyte pos) {
		chart_legend_set_position(this.handle, pos);
	}

	void legendSetFont(lxw_chart_font* font) {
		chart_legend_set_font(this.handle, font);
	}

	lxw_error legendDeleteSeries(int16_t[] series) {
		return chart_legend_delete_series(this.handle, series.ptr);
	}

	void chartareaSetLine(lxw_chart_line* line) {
		chart_chartarea_set_line(this.handle, line);
	}

	void chartareaSetFill(lxw_chart_fill* fill) {
		chart_chartarea_set_fill(this.handle, fill);
	}

	void chartareaSetPattern(lxw_chart_pattern* pattern) {
		chart_chartarea_set_pattern(this.handle, pattern);
	}

	void plotareaSetLine(lxw_chart_line* line) {
		chart_plotarea_set_line(this.handle, line);
	}

	void plotareaSetFill(lxw_chart_fill* fill) {
		chart_plotarea_set_fill(this.handle, fill);
	}

	void plotareaSetPattern(lxw_chart_pattern* pattern) {
		chart_plotarea_set_pattern(this.handle, pattern);
	}

	void setStyle(ubyte style) {
		chart_set_style(this.handle, style);
	}

	void setTable() {
		chart_set_table(this.handle);
	}

	void setTableGrid(ubyte hori, ubyte vert, ubyte outline, ubyte keys) {
		chart_set_table_grid(this.handle, hori, vert, outline, keys);
	}

	void setTableFont(lxw_chart_font* font) {
		chart_set_table_font(this.handle, font);
	}

	void setUpDownBars() {
		chart_set_up_down_bars(this.handle);
	}

	void setUpDownBarsFormat(lxw_chart_line* upBarLine, 
			lxw_chart_fill* upBarFill, lxw_chart_line* downBarLine, 
			lxw_chart_fill* downBarFill) 
	{
		chart_set_up_down_bars_format(this.handle, upBarLine, upBarFill,
				downBarLine, downBarFill);
	}

	void setDropLines(lxw_chart_line* line) {
		chart_set_drop_lines(this.handle, line);
	}

	void setHighLowLines(lxw_chart_line* line) {
		chart_set_high_low_lines(this.handle, line);
	}

	void setSeriesOverlap(int8_t overlap) {
		chart_set_series_overlap(this.handle, overlap);
	}

	void setSeriesGap(ushort gap) {
		chart_set_series_gap(this.handle, gap);
	}

	void showBlanksAs(ubyte blanks) {
		chart_show_blanks_as(this.handle, blanks);
	}

	void showHiddenData() {
		chart_show_hidden_data(this.handle);
	}

	void setRotation(ushort rotation) {
		chart_set_rotation(this.handle, rotation);
	}

	void setHoleSize(ubyte size) {
		chart_set_hole_size(this.handle, size);
	}
}
