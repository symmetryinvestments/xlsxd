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

Workbook newWorkbook(string filename) {
	Workbook wb;
	wb.filename = filename;
	wb.open();
	return wb;
}

struct WorkbookImpl {
	WorkbookOpen workBook;

	alias workBook this;

	~this() {
		this.workBook.close();
	}
}

struct WorkbookOpen {
	import std.exception : enforce;
	import std.datetime : DateTime;
	lxw_workbook* handle;
	string filename;

	Format[string] formats;

	static WorkbookOpen opCall(string filename) {
		WorkbookOpen ret;
		ret.filename = filename;
		ret.open();
		return ret;
	}

	void open() {
		this.handle = workbook_new(this.filename.toStringz());
	}

	void close() {
		workbook_close(this.handle);
	}

	Worksheet addWorksheet(string name) nothrow {
		return Worksheet(workbook_add_worksheet(this.handle,
					name.toStringz())
				);
	}

	Chartsheet addChartsheet(string name) {
		return Chartsheet(workbook_add_chartsheet(this.handle,
					name.toStringz())
				);
	}

	Format addFormat() nothrow @nogc {
		return Format(workbook_add_format(this.handle));
	}

	version(No_Overloads_Or_Templates) {
		Format addFormatNamed(string name) nothrow {
			return this.addFormatNamedImpl(name);
		}
	} else {
		Format addFormat(string name) nothrow {
			return this.addFormatNamedImpl(name);
		}
	}

	private Format addFormatNamedImpl(string name) nothrow {
		auto t = Format(workbook_add_format(this.handle));
		this.formats[name] = t;
		return t;
	}

	Format getFormat(string name) nothrow {
		return this.formats[name];
	}

	Chart addChart(ubyte chartType) @nogc nothrow {
		return Chart(workbook_add_chart(this.handle, chartType));
	}

	void setProperties(DocProperties property) {
		enforce(workbook_set_properties(this.handle, property.handle)
				== LXW_NO_ERROR
			);
	}

	version(No_Overloads_Or_Templates) {
		void setCustomPropertiesBool(string name, bool b) {
			return this.setCustomPropertiesImpl(name, b);
		}
		void setCustomPropertiesInt(string name, long l) {
			return this.setCustomPropertiesImpl(name, l);
		}
		void setCustomPropertiesNumber(string name, double d) {
			return this.setCustomPropertiesImpl(name, d);
		}
		void setCustomPropertiesDateTime(string name, DateTime d) {
			return this.setCustomPropertiesImpl(name, Datetime.fromDateTime(d));
		}
	} else {
		alias setCustomProperties = setCustomPropertiesImpl;
	}

	private void setCustomPropertiesImpl(T)(string name, T t) {
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

	void defineName(string name, string formula) {
		enforce(workbook_define_name(this.handle, name.toStringz(),
						formula.toStringz()
					)
				== LXW_NO_ERROR
			);
	}

	Worksheet getWorksheetByName(string name) {
		return Worksheet(workbook_get_worksheet_by_name(this.handle,
						name.toStringz()
					)
				);
	}

	Chartsheet getChartByName(string name) {
		return Chartsheet(workbook_get_chartsheet_by_name(this.handle,
						name.toStringz()
					)
				);
	}

	bool validateSheetName(string name) {
		return workbook_validate_sheet_name(this.handle, name.toStringz())
				== LXW_NO_ERROR;
	}
}
