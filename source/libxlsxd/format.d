module libxlsxd.format;

import libxlsxd.xlsxwrap;

Format newFormat() {
	return Format(lxw_format_new());
}

void freeFormat(Format format) {
    lxw_format_free(format.handle);
}

struct Format {
	import std.string : toStringz;
	lxw_format* handle;

	this(lxw_format* handle) {
		this.handle = handle;
	}

    int32_t getXfIndex() {
    	return lxw_format_get_xf_index(this.handle);
	}

    lxw_font* getFontKey() {
    	return lxw_format_get_font_key(this.handle);
	}

    lxw_border* getBorderKey() {
    	return lxw_format_get_border_key(this.handle);
	}

    lxw_fill* getFillKey() {
    	return lxw_format_get_fill_key(this.handle);
	}

    static lxw_color_t checkColor(lxw_color_t color) {
    	return lxw_format_check_color(color);
	}

    void setFontName(string fontname) {
    	format_set_font_name(this.handle, toStringz(fontname));
	}

    void setFontSize(double size) {
    	format_set_font_size(this.handle, size);
	}

    void setFontColor(lxw_color_t color) {
    	format_set_font_color(this.handle, color);
	}

    void setBold() {
    	format_set_bold(this.handle);
	}

    void setItalic() {
    	format_set_italic(this.handle);
	}

    void setUnderline(uint8_t style) {
    	format_set_underline(this.handle, style);
	}

    void setFontStrikeout() {
    	format_set_font_strikeout(this.handle);
	}

    void setFontScript(uint8_t style) {
    	format_set_font_script(this.handle, style);
	}

    void setNumFormat(string numFormat) {
    	format_set_num_format(this.handle, toStringz(numFormat));
	}

    void setNumFormatIndex(uint8_t index) {
    	format_set_num_format_index(this.handle, index);
	}

    void setUnlocked() {
    	format_set_unlocked(this.handle);
	}

    void setHidden() {
    	format_set_hidden(this.handle);
	}

    void setAlign(uint8_t align_) {
    	format_set_align(this.handle, align_);
	}

    void setTextWrap() {
    	format_set_text_wrap(this.handle);
	}

    void setRotation(int16_t angle) {
    	format_set_rotation(this.handle, angle);
	}

    void setIndent(uint8_t level) {
    	format_set_indent(this.handle, level);
	}

    void setShrink() {
    	format_set_shrink(this.handle);
	}

    void setPattern(uint8_t pattern) {
    	format_set_pattern(this.handle, pattern);
	}

    void setBgColor(lxw_color_t color) {
    	format_set_bg_color(this.handle, color);
	}

    void setFgColor(lxw_color_t color) {
    	format_set_fg_color(this.handle, color);
	}

    void setBorder(uint8_t border) {
    	format_set_border(this.handle, border);
	}

    void setBottom(uint8_t bottom) {
    	format_set_bottom(this.handle, bottom);
	}

    void setTop(uint8_t top) {
    	format_set_top(this.handle, top);
	}

    void setLeft(uint8_t left) {
    	format_set_left(this.handle, left);
	}

    void setRight(uint8_t right) {
    	format_set_right(this.handle, right);
	}

    void setBorder_color(lxw_color_t color) {
    	format_set_border_color(this.handle, color);
	}

    void setBottomColor(lxw_color_t color) {
    	format_set_bottom_color(this.handle, color);
	}

    void setTopColor(lxw_color_t color) {
    	format_set_top_color(this.handle, color);
	}

    void setLeftColor(lxw_color_t color) {
    	format_set_left_color(this.handle, color);
	}

    void setRightColor(lxw_color_t color) {
    	format_set_right_color(this.handle, color);
	}

    void setDiagType(uint8_t type) {
    	format_set_diag_type(this.handle, type);
	}

    void setDiagColor(lxw_color_t color) {
    	format_set_diag_color(this.handle, color);
	}

    void setDiagBorder(uint8_t border) {
    	format_set_diag_border(this.handle, border);
	}

    void setFontOutline() {
    	format_set_font_outline(this.handle);
	}

    void setFontShadow() {
    	format_set_font_shadow(this.handle);
	}

    void setFontFamily(uint8_t family) {
    	format_set_font_family(this.handle, family);
	}

    void setFontCharset(uint8_t charset) {
    	format_set_font_charset(this.handle, charset);
	}

    void setFontScheme(string schema) {
    	format_set_font_scheme(this.handle, toStringz(schema));
	}

    void setFontCondense() {
    	format_set_font_condense(this.handle);
	}

    void setFontExtend() {
    	format_set_font_extend(this.handle);
	}

    void setReadingOrder(uint8_t order) {
    	format_set_reading_order(this.handle, order);
	}

    void setTheme(uint8_t theme) {
    	format_set_theme(this.handle, theme);
	}
}
