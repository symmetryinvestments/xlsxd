module libxlsxd.chartaxis;

import xlsxwrap;

struct Chartaxis {
	lxw_chart_axis* handle;
	import libxlsxd.chart;
	import std.exception : enforce;
	import std.string : toStringz;
	import std.conv : to;

	this(lxw_chart_axis* handle) {
		this.handle = handle;
	}

    void setName(string name) {
    	chart_axis_set_name(this.handle, toStringz(name));
	}

    void setNameRange(string sheetname, lxw_row_t row, lxw_col_t col) {
    	chart_axis_set_name_range(this.handle, toStringz(sheetname), row,
				col
			);
	}

    void setNameFont(lxw_chart_font* font) {
    	chart_axis_set_name_font(this.handle, font);
	}

    void setNumFont(lxw_chart_font* font) {
    	chart_axis_set_num_font(this.handle, font);
	}

    void setNumFormat(string numFormat) {
    	chart_axis_set_num_format(this.handle, toStringz(numFormat));
	}

    void setLine(lxw_chart_line* line) {
    	chart_axis_set_line(this.handle, line);
	}

    void setFill(lxw_chart_fill* fill) {
    	chart_axis_set_fill(this.handle, fill);
	}

    void setPattern(lxw_chart_pattern* pattern) {
    	chart_axis_set_pattern(this.handle, pattern);
	}

    void setReverse() {
    	chart_axis_set_reverse(this.handle);
	}

    void setCrossing(double value) {
    	chart_axis_set_crossing(this.handle, value);
	}

    void setCrossing_max() {
    	chart_axis_set_crossing_max(this.handle);
	}

    void off() {
    	chart_axis_off(this.handle);
	}

    void setPosition(uint8_t position) {
    	chart_axis_set_position(this.handle, position);
	}

    void setLabelPosition(uint8_t position) {
    	chart_axis_set_label_position(this.handle, position);
	}

    void setLabelAlign(uint8_t align_) {
    	chart_axis_set_label_align(this.handle, align_);
	}

    void setMin(double min) {
    	chart_axis_set_min(this.handle, min);
	}

    void setMax(double max) {
    	chart_axis_set_max(this.handle, max);
	}

    void setLogBase(uint16_t base) {
    	chart_axis_set_log_base(this.handle, base);
	}

    void setMajorTickMark(uint8_t mark) {
    	chart_axis_set_major_tick_mark(this.handle, mark);
	}

    void setMinorTickMark(uint8_t mark) {
    	chart_axis_set_minor_tick_mark(this.handle, mark);
	}

    void setIntervalUnit(uint16_t unit) {
    	chart_axis_set_interval_unit(this.handle, unit);
	}

    void setIntervalTick(uint16_t tick) {
    	chart_axis_set_interval_tick(this.handle, tick);
	}

    void setMajorUnit(double unit) {
    	chart_axis_set_major_unit(this.handle, unit);
	}

    void setMinorUnit(double unit) {
    	chart_axis_set_minor_unit(this.handle, unit);
	}

    void setDisplayUnits(uint8_t unit) {
    	chart_axis_set_display_units(this.handle, unit);
	}

    void setDisplayUnitsVisible(bool isVisiable ) {
    	chart_axis_set_display_units_visible(this.handle, to!ubyte(isVisiable));
	}

    void majorGridlinesSetVisible(bool isVisiable) {
    	chart_axis_major_gridlines_set_visible(this.handle, to!ubyte(isVisiable));
	}

    void minorGridlinesSetVisible(bool isVisiable) {
    	chart_axis_minor_gridlines_set_visible(this.handle, to!ubyte(isVisiable));
	}

    void majorGridlinesSetLine(lxw_chart_line* line) {
    	chart_axis_major_gridlines_set_line(this.handle, line);
	}

    void minorGridlinesSetLine(lxw_chart_line* line) {
    	chart_axis_minor_gridlines_set_line(this.handle, line);
	}
}
