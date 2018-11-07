module libxlsxd.chartsheet;

import xlsxwrap;

struct Chartsheet {
	import libxlsxd.chart;
	import std.exception : enforce;
	import std.string : toStringz;

	lxw_chartsheet* handle;

	this(lxw_chartsheet* handle) {
		this.handle = handle;
	}

    void setChart(Chart c) {
    	enforce(chartsheet_set_chart(this.handle, c.handle) 
				== LXW_NO_ERROR
			);
	}

    void setChart_opt(Chart chart, lxw_image_options* opt) {
    	enforce(chartsheet_set_chart_opt(this.handle, chart.handle, opt) 
				== LXW_NO_ERROR
			);
	}

    void activate() {
    	chartsheet_activate(this.handle);
	}

    void select() {
    	chartsheet_select(this.handle);
	}

    void hide() {
    	chartsheet_hide(this.handle);
	}

    void setFirstSheet() {
    	chartsheet_set_first_sheet(this.handle);
	}

    void setTabColor(lxw_color_t color) {
    	chartsheet_set_tab_color(this.handle, color);
	}

    void protect(string password, lxw_protection* option) {
    	chartsheet_protect(this.handle, toStringz(password), option);
	}

    void setZoom(uint16_t zoom) {
    	chartsheet_set_zoom(this.handle, zoom);
	}

    void setLandscape() {
    	chartsheet_set_landscape(this.handle);
	}

    void setPortrait() {
    	chartsheet_set_portrait(this.handle);
	}

    void setPaper(uint8_t paper) {
    	chartsheet_set_paper(this.handle, paper);
	}

    void setMargins(double left, double right, double top, double bottom) {
    	chartsheet_set_margins(this.handle, left, right, top, bottom);
	}

    void setHeader(string header) {
    	enforce(chartsheet_set_header(this.handle, toStringz(header)) 
				== LXW_NO_ERROR
			);
	}

    void setFooter(string footer) {
    	enforce(chartsheet_set_footer(this.handle, toStringz(footer)) 
				== LXW_NO_ERROR
			);
	}

    void setHeader_opt(string header, lxw_header_footer_options* opt) {
    	enforce(chartsheet_set_header_opt(this.handle, toStringz(header), opt) 
				== LXW_NO_ERROR
			);
	}

    void setFooterOpt(string footer, lxw_header_footer_options* opt) {
    	enforce(chartsheet_set_footer_opt(this.handle, toStringz(footer), opt) 
				== LXW_NO_ERROR
			);
	}

    void chartsheetFree() {
    	lxw_chartsheet_free(this.handle);
	}

    void chartsheetAssembleXmlFile() {
    	lxw_chartsheet_assemble_xml_file(this.handle);
	}
}
