module libxlsxd.format;

import libxlsxd.xlsxwrap;

Format newFormat() @trusted {
	return Format(lxw_format_new());
}

void freeFormat(Format format) @trusted {
	lxw_format_free(format.handle);
}

struct Format {
	import std.string : toStringz;
	lxw_format* handle;

	this(lxw_format* handle) pure @nogc nothrow @safe {
		this.handle = handle;
	}

	int getXfIndex() @nogc nothrow @trusted {
		return lxw_format_get_xf_index(this.handle);
	}

	lxw_font* getFontKey() @nogc nothrow @trusted {
		return lxw_format_get_font_key(this.handle);
	}

	lxw_border* getBorderKey() @nogc nothrow @trusted {
		return lxw_format_get_border_key(this.handle);
	}

	lxw_fill* getFillKey() @nogc nothrow @trusted {
		return lxw_format_get_fill_key(this.handle);
	}

	void setFontName(string fontname) nothrow @trusted {
		format_set_font_name(this.handle, toStringz(fontname));
	}

	void setFontSize(double size) @nogc nothrow @trusted {
		format_set_font_size(this.handle, size);
	}

	void setFontColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_font_color(this.handle, color);
	}

	void setBold() @nogc nothrow @trusted {
		format_set_bold(this.handle);
	}

	void setItalic() @nogc nothrow @trusted {
		format_set_italic(this.handle);
	}

	void setUnderline(ubyte style) @nogc nothrow @trusted {
		format_set_underline(this.handle, style);
	}

	void setFontStrikeout() @nogc nothrow @trusted {
		format_set_font_strikeout(this.handle);
	}

	void setFontScript(ubyte style) @nogc nothrow @trusted {
		format_set_font_script(this.handle, style);
	}

	void setNumFormat(string numFormat) nothrow @trusted {
		format_set_num_format(this.handle, toStringz(numFormat));
	}

	void setNumFormatIndex(ubyte index) @nogc nothrow @trusted {
		format_set_num_format_index(this.handle, index);
	}

	void setUnlocked() @nogc nothrow @trusted {
		format_set_unlocked(this.handle);
	}

	void setHidden() @nogc nothrow @trusted {
		format_set_hidden(this.handle);
	}

	void setAlign(ubyte align_) @nogc nothrow @trusted {
		format_set_align(this.handle, align_);
	}

	void setTextWrap() @nogc nothrow @trusted {
		format_set_text_wrap(this.handle);
	}

	void setRotation(short angle) @nogc nothrow @trusted {
		format_set_rotation(this.handle, angle);
	}

	void setIndent(ubyte level) @nogc nothrow @trusted {
		format_set_indent(this.handle, level);
	}

	void setShrink() @nogc nothrow @trusted {
		format_set_shrink(this.handle);
	}

	void setPattern(ubyte pattern) @nogc nothrow @trusted {
		format_set_pattern(this.handle, pattern);
	}

	void setBgColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_bg_color(this.handle, color);
	}

	void setFgColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_fg_color(this.handle, color);
	}

	void setBorder(ubyte border) @nogc nothrow @trusted {
		format_set_border(this.handle, border);
	}

	void setBottom(ubyte bottom) @nogc nothrow @trusted {
		format_set_bottom(this.handle, bottom);
	}

	void setTop(ubyte top) @nogc nothrow @trusted {
		format_set_top(this.handle, top);
	}

	void setLeft(ubyte left) @nogc nothrow @trusted {
		format_set_left(this.handle, left);
	}

	void setRight(ubyte right) @nogc nothrow @trusted {
		format_set_right(this.handle, right);
	}

	void setBorderColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_border_color(this.handle, color);
	}

	void setBottomColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_bottom_color(this.handle, color);
	}

	void setTopColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_top_color(this.handle, color);
	}

	void setLeftColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_left_color(this.handle, color);
	}

	void setRightColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_right_color(this.handle, color);
	}

	void setDiagType(ubyte type) @nogc nothrow @trusted {
		format_set_diag_type(this.handle, type);
	}

	void setDiagColor(lxw_color_t color) @nogc nothrow @trusted {
		format_set_diag_color(this.handle, color);
	}

	void setDiagBorder(ubyte border) @nogc nothrow @trusted {
		format_set_diag_border(this.handle, border);
	}

	void setFontOutline() @nogc nothrow @trusted {
		format_set_font_outline(this.handle);
	}

	void setFontShadow() @nogc nothrow @trusted {
		format_set_font_shadow(this.handle);
	}

	void setFontFamily(ubyte family) @nogc nothrow @trusted {
		format_set_font_family(this.handle, family);
	}

	void setFontCharset(ubyte charset) @nogc nothrow @trusted {
		format_set_font_charset(this.handle, charset);
	}

	void setFontScheme(string schema) nothrow @trusted {
		format_set_font_scheme(this.handle, toStringz(schema));
	}

	void setFontCondense() @nogc nothrow @trusted {
		format_set_font_condense(this.handle);
	}

	void setFontExtend() @nogc nothrow @trusted {
		format_set_font_extend(this.handle);
	}

	void setReadingOrder(ubyte order) @nogc nothrow @trusted {
		format_set_reading_order(this.handle, order);
	}

	void setTheme(ubyte theme) @nogc nothrow @trusted {
		format_set_theme(this.handle, theme);
	}
}
