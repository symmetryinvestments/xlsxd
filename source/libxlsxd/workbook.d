module libxlsxd.workbook;

import libxlsxd.xlsxwrap;
import std.string : toStringz;
import std.typecons : refCounted, RefCounted;

import libxlsxd.worksheet;
import libxlsxd.format;
import libxlsxd.chart;
import libxlsxd.chartsheet;
import libxlsxd.datetime;
import libxlsxd.docproperties;

alias Workbook = RefCounted!WorkbookImpl;

Workbook newWorkbook(string filename) @trusted {
	Workbook wb;
	wb.filename = filename;
	wb.open();
	return wb;
}

struct WorkbookImpl {
	WorkbookOpen workBook;

	alias workBook this;

	~this() @safe {
		this.workBook.close();
	}
}

struct WorkbookOpen {
	import std.exception : enforce;
	import std.datetime : DateTime;
	import std.array : empty;
	lxw_workbook* handle;
	string filename;

	Format[string] formats;
	Format dateFormat;
	Format timeFormat;
	Format dateTimeFormat;

	static WorkbookOpen opCall(string filename) @safe {
		WorkbookOpen ret;
		ret.filename = filename;
		ret.open();
		ret.buildDefaultFormats();
		return ret;
	}

	void open() @trusted {
		this.handle = workbook_new(this.filename.toStringz());
		this.buildDefaultFormats();
	}

	void buildDefaultFormats() @safe {
		this.dateFormat = this.addFormat();
		this.dateFormat.setNumFormat("yyyy-mm-dd");

		this.dateTimeFormat = this.addFormat();
		this.dateTimeFormat.setNumFormat("yyyy-mm-ddThh:MM:ss");

		this.timeFormat = this.addFormat();
		this.timeFormat.setNumFormat("hh:MM:ss");
	}

	void close() @trusted {
		workbook_close(this.handle);
	}

	WorksheetFluent addFluentWorksheet(string name) @trusted {
		return WorksheetFluent(&this, this.addWorksheet(name));
	}

	Worksheet addWorksheet(string name) nothrow @trusted {
		return Worksheet(workbook_add_worksheet(this.handle,
					name.empty ? null : name.toStringz()),
					&this.dateTimeFormat, &this.dateFormat, &this.timeFormat
				);
	}

	Chartsheet addChartsheet(string name) @trusted {
		return Chartsheet(workbook_add_chartsheet(this.handle,
					name.empty ? null : name.toStringz())
				);
	}

	Format addFormat() nothrow @nogc @trusted {
		return Format(workbook_add_format(this.handle));
	}

	version(No_Overloads_Or_Templates) {
		Format addFormatNamed(string name) nothrow @safe {
			return this.addFormatNamedImpl(name);
		}
	} else {
		Format addFormat(string name) nothrow @safe {
			return this.addFormatNamedImpl(name);
		}
	}

	private Format addFormatNamedImpl(string name) nothrow @trusted {
		auto t = Format(workbook_add_format(this.handle));
		this.formats[name] = t;
		return t;
	}

	Format getFormat(string name) nothrow @safe {
		return this.formats[name];
	}

	Chart addChart(ubyte chartType) @nogc nothrow @trusted {
		return Chart(workbook_add_chart(this.handle, chartType));
	}

	void setProperties(DocProperties property) @trusted {
		enforce(workbook_set_properties(this.handle, property.handle)
				== LXW_NO_ERROR
			);
	}

	version(No_Overloads_Or_Templates) {
		void setCustomPropertiesBool(string name, bool b) @safe {
			return this.setCustomPropertiesImpl(name, b);
		}
		void setCustomPropertiesInt(string name, long l) @safe {
			return this.setCustomPropertiesImpl(name, l);
		}
		void setCustomPropertiesNumber(string name, double d) @safe {
			return this.setCustomPropertiesImpl(name, d);
		}
		void setCustomPropertiesDateTime(string name, DateTime d) @safe {
			return this.setCustomPropertiesImpl(name, Datetime.fromDateTime(d));
		}
	} else {
		alias setCustomProperties = setCustomPropertiesImpl;
	}

	private void setCustomPropertiesImpl(T)(string name, T t) @trusted {
		import std.traits : isIntegral, isFloatingPoint, isSomeString;
		import std.conv : to;

		static if(is(T == bool)) {
			enforce(workbook_set_custom_property_boolean(this.handle,
						name.toStringz(), t
					)
					== LXW_NO_ERROR
				);
		} else static if(isIntegral!T) {
			enforce(workbook_set_custom_property_integer(this.handle,
						name.toStringz(), to!int(t)
					)
					== LXW_NO_ERROR
				);
		} else static if(isFloatingPoint!T) {
			enforce(workbook_set_custom_property_number(this.handle,
						name.toStringz(), to!double(t)
					)
					== LXW_NO_ERROR
				);
		} else static if(is(T == Datetime)) {
			enforce(workbook_set_custom_property_datetime(this.handle,
						toStringz(name), &t.handle)
					== LXW_NO_ERROR
				);
		} else {
			static assert(false, "setCustomProperties does not work with '" ~
					T.stringof ~ "'");
		}
	}

	void defineName(string name, string formula) @trusted {
		enforce(workbook_define_name(this.handle, name.toStringz(),
						formula.toStringz()
					)
				== LXW_NO_ERROR
			);
	}

	Worksheet getWorksheetByName(string name) @trusted {
		return Worksheet(workbook_get_worksheet_by_name(this.handle,
						name.toStringz()
					),
					&this.dateTimeFormat, &this.dateFormat, &this.timeFormat
				);
	}

	Chartsheet getChartByName(string name) @trusted {
		return Chartsheet(workbook_get_chartsheet_by_name(this.handle,
						name.toStringz()
					)
				);
	}

	bool validateSheetName(string name) @trusted {
		return workbook_validate_sheet_name(this.handle, name.toStringz())
				== LXW_NO_ERROR;
	}
}
