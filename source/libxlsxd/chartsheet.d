module libxlsxd.chartsheet;

import libxlsxd.xlsxwrap;

struct Chartsheet {
	import libxlsxd.chart;
	import std.exception : enforce;
	import std.string : toStringz;

	lxw_chartsheet* handle;

	this(lxw_chartsheet* handle) @nogc nothrow pure @safe {
		this.handle = handle;
	}

	void setChart(Chart c) @trusted {
		enforce(chartsheet_set_chart(this.handle, c.handle)
				== LXW_NO_ERROR
			);
	}

	void setChartOpt(Chart chart, lxw_chart_options* opt) @trusted {
		enforce(chartsheet_set_chart_opt(this.handle, chart.handle, opt)
				== LXW_NO_ERROR
			);
	}

	void activate() nothrow @nogc @trusted {
		chartsheet_activate(this.handle);
	}

	void select() nothrow @nogc @trusted {
		chartsheet_select(this.handle);
	}

	void hide() nothrow @nogc @trusted {
		chartsheet_hide(this.handle);
	}

	void setFirstSheet() nothrow @nogc @trusted {
		chartsheet_set_first_sheet(this.handle);
	}

	void setTabColor(lxw_color_t color) nothrow @nogc @trusted {
		chartsheet_set_tab_color(this.handle, color);
	}

	void protect(string password, lxw_protection* option) @trusted {
		chartsheet_protect(this.handle, toStringz(password), option);
	}

	void setZoom(ushort zoom) nothrow @nogc @trusted {
		chartsheet_set_zoom(this.handle, zoom);
	}

	void setLandscape() nothrow @nogc @trusted {
		chartsheet_set_landscape(this.handle);
	}

	void setPortrait() nothrow @nogc @trusted {
		chartsheet_set_portrait(this.handle);
	}

	void setPaper(ubyte paper) nothrow @nogc @trusted {
		chartsheet_set_paper(this.handle, paper);
	}

	void setMargins(double left, double right, double top, double bottom)
			nothrow @nogc @trusted
	{
		chartsheet_set_margins(this.handle, left, right, top, bottom);
	}

	void setHeader(string header) @trusted {
		enforce(chartsheet_set_header(this.handle, toStringz(header))
				== LXW_NO_ERROR
			);
	}

	void setFooter(string footer) @trusted {
		enforce(chartsheet_set_footer(this.handle, toStringz(footer))
				== LXW_NO_ERROR
			);
	}

	void setHeaderOpt(string header, lxw_header_footer_options* opt) @trusted {
		enforce(chartsheet_set_header_opt(this.handle, toStringz(header), opt)
				== LXW_NO_ERROR
			);
	}

	void setFooterOpt(string footer, lxw_header_footer_options* opt) @trusted {
		enforce(chartsheet_set_footer_opt(this.handle, toStringz(footer), opt)
				== LXW_NO_ERROR
			);
	}

	void free() nothrow @nogc @trusted {
		lxw_chartsheet_free(this.handle);
	}

	void assembleXmlFile() nothrow @nogc @trusted {
		lxw_chartsheet_assemble_xml_file(this.handle);
	}
}
