module libxlsxd.datetime;

import std.datetime.date : DateTime;

import libxlsxd.xlsxwrap;

struct Datetime {
	import std.conv : to;

	lxw_datetime handle;

	version(No_Overloads_Or_Templates) {
		static Datetime fromDateTime(DateTime ddt) {
			Datetime ret;
			ret.handle.year = ddt.year;
			ret.handle.month = ddt.month;
			ret.handle.day = ddt.day;
			ret.handle.hour = ddt.hour;
			ret.handle.min = ddt.minute;
			ret.handle.sec = to!double(ddt.second);
			return ret;
		}

		static Datetime fromLXW_Datetime(lxw_datetime lxw) {
			Datetime ret;
			ret.handle = lxw;
			return ret;
		}
	} else {
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
}
