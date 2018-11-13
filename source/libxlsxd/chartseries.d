module libxlsxd.chartseries;

import libxlsxd.xlsxwrap;

struct Chartseries {
	lxw_chart_series* handle;
	import libxlsxd.chart;
	import std.exception : enforce;
	import std.string : toStringz;
	import std.conv : to;

	this(lxw_chart_series* handle) @nogc nothrow pure @safe {
		this.handle = handle;
	}

	void setCategories(string sheetName, lxw_row_t firstRow, lxw_col_t
			firstCol, lxw_row_t lastRow, lxw_col_t lastCol)
	{
		chart_series_set_categories(this.handle, toStringz(sheetName),
				firstRow, firstCol, lastRow, lastCol
			);
	}

	void setValues(string sheetname, lxw_row_t firstRow, lxw_col_t
			firstCol, lxw_row_t lastRow, lxw_col_t lastCol)
	{
		chart_series_set_values(this.handle, toStringz(sheetname), firstRow,
				firstCol, lastRow, lastCol
			);
	}

	void setName(string name) {
		chart_series_set_name(this.handle, toStringz(name));
	}

	void setNameRange(string sheetname, lxw_row_t row, lxw_col_t col) {
		chart_series_set_name_range(this.handle, toStringz(sheetname), row,
				col
			);
	}

	void setLine(lxw_chart_line* line) nothrow @nogc {
		chart_series_set_line(this.handle, line);
	}

	void setFill(lxw_chart_fill* fill) nothrow @nogc {
		chart_series_set_fill(this.handle, fill);
	}

	void setInvertIfNegative() nothrow @nogc {
		chart_series_set_invert_if_negative(this.handle);
	}

	void setPattern(lxw_chart_pattern* pattern) nothrow @nogc {
		chart_series_set_pattern(this.handle, pattern);
	}

	void setMarkerType(ubyte mark) nothrow @nogc {
		chart_series_set_marker_type(this.handle, mark);
	}

	void setMarkerSize(ubyte size) nothrow @nogc {
		chart_series_set_marker_size(this.handle, size);
	}

	void setMarkerLine(lxw_chart_line* line) nothrow @nogc {
		chart_series_set_marker_line(this.handle, line);
	}

	void setMarkerFill(lxw_chart_fill* fill) nothrow @nogc {
		chart_series_set_marker_fill(this.handle, fill);
	}

	void setMarkerPattern(lxw_chart_pattern* pattern) nothrow @nogc {
		chart_series_set_marker_pattern(this.handle, pattern);
	}

	void setPoints(lxw_chart_point** point) {
		enforce(chart_series_set_points(this.handle, point)
				== LXW_NO_ERROR
			);
	}

	void setSmooth(ubyte smooth) nothrow @nogc {
		chart_series_set_smooth(this.handle, smooth);
	}

	void setLabels() nothrow @nogc {
		chart_series_set_labels(this.handle);
	}

	void setLabelsOptions(bool showName, bool showCategory ,
			bool showValue)
	{
		chart_series_set_labels_options(this.handle, to!ubyte(showName),
				to!ubyte(showCategory), to!ubyte(showValue)
			);
	}

	void setLabelsSeparator(ubyte seperator) nothrow @nogc {
		chart_series_set_labels_separator(this.handle, seperator);
	}

	void setLabelsPosition(ubyte position) nothrow @nogc {
		chart_series_set_labels_position(this.handle, position);
	}

	void setLabelsLeaderLine() nothrow @nogc {
		chart_series_set_labels_leader_line(this.handle);
	}

	void setLabelsLegend() nothrow @nogc {
		chart_series_set_labels_legend(this.handle);
	}

	void setLabelsPercentage() nothrow @nogc {
		chart_series_set_labels_percentage(this.handle);
	}

	void setLabelsNumFormat(string format) {
		chart_series_set_labels_num_format(this.handle, toStringz(format));
	}

	void setLabelsFont(lxw_chart_font* font) nothrow @nogc {
		chart_series_set_labels_font(this.handle, font);
	}

	void setTrendline(ubyte type, ubyte value) nothrow @nogc {
		chart_series_set_trendline(this.handle, type, value);
	}

	void setTrendlineForecast(double forward, double backward) nothrow @nogc {
		chart_series_set_trendline_forecast(this.handle, forward, backward);
	}

	void setTrendlineEquation() nothrow @nogc {
		chart_series_set_trendline_equation(this.handle);
	}

	void setTrendlineRsquared() nothrow @nogc {
		chart_series_set_trendline_r_squared(this.handle);
	}

	void setTrendlineIntercept(double intercept) nothrow @nogc {
		chart_series_set_trendline_intercept(this.handle, intercept);
	}

	void setTrendlineName(string name) {
		chart_series_set_trendline_name(this.handle, toStringz(name));
	}

	void setTrendlineLine(lxw_chart_line* line) nothrow @nogc {
		chart_series_set_trendline_line(this.handle, line);
	}

	lxw_series_error_bars* getErrorBars( lxw_chart_error_bar_axis axis) nothrow 
			@nogc 
	{
		return chart_series_get_error_bars(this.handle, axis);
	}

	void setErrorBars(lxw_series_error_bars* bars, ubyte type, double value)
			nothrow @nogc 
	{
		chart_series_set_error_bars(bars, type, value);
	}

	void setErrorBarsDirection(lxw_series_error_bars* bars,
			ubyte direction) nothrow @nogc 
	{
		chart_series_set_error_bars_direction(bars, direction);
	}

	void setErrorBarsEndcap(lxw_series_error_bars* bars,
			ubyte endcap) nothrow @nogc 
	{
		chart_series_set_error_bars_endcap(bars, endcap);
	}

	void setErrorBarsLine(lxw_series_error_bars* bars,
			lxw_chart_line* line) nothrow @nogc 
	{
		chart_series_set_error_bars_line(bars, line);
	}
}
