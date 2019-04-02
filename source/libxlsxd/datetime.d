module libxlsxd.datetime;

import std.datetime.date : DateTime;

import libxlsxd.xlsxwrap;

struct Datetime {
	import std.conv : to;

	lxw_datetime handle;

	this(lxw_datetime dt) @nogc nothrow pure @safe {
		this.handle = handle;
	}

	this(DateTime ddt) {
		this.handle.year = ddt.year;
		this.handle.month = ddt.month;
		this.handle.day = ddt.day;
		this.handle.hour = ddt.hour;
		this.handle.min = ddt.minute;
		this.handle.sec = to!double(ddt.second);
	}
}

version(No_Overloads_Or_Templates) {
	Datetime fromDateTime(DateTime ddt) {
		return Datetime(ddt);
	}

	Datetime fromLXWDateTime(lxw_datetime lxw) {
		return Datetime(lxw);
	}
}
