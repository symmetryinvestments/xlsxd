module libxlsxd.datetime;

import std.datetime.date : DateTime, Date, TimeOfDay;

import libxlsxd.xlsxwrap;

@safe:

struct Datetime {
	import std.conv : to;

	lxw_datetime handle;

	version(No_Overloads_Or_Templates) {
		static Datetime fromDateTime(DateTime ddt) @safe {
			Datetime ret;
			ret.handle.year = ddt.year;
			ret.handle.month = ddt.month;
			ret.handle.day = ddt.day;
			ret.handle.hour = ddt.hour;
			ret.handle.min = ddt.minute;
			ret.handle.sec = to!double(ddt.second);
			return ret;
		}

		static Datetime fromDate(Date d) @safe {
			Datetime ret;
			ret.handle.year = d.year;
			ret.handle.month = d.month;
			ret.handle.day = d.day;
			ret.handle.hour = 0;
			ret.handle.min = 0;
			ret.handle.sec = 0;
			return ret;
		}

		static Datetime fromTimeOfday(TimeOfDay tod) @safe {
			Datetime ret;
			ret.handle.year = 0;
			ret.handle.month = 0;
			ret.handle.day = 0;
			ret.handle.hour = tod.hour;
			ret.handle.min = tod.minute;
			ret.handle.sec = to!double(tod.second);
			return ret;
		}

		static Datetime fromLXW_Datetime(lxw_datetime lxw) @safe {
			Datetime ret;
			ret.handle = lxw;
			return ret;
		}
	} else {
		this(lxw_datetime dt) @nogc nothrow pure @safe {
			this.handle = handle;
		}

		this(DateTime ddt) @safe {
			this.handle.year = ddt.year;
			this.handle.month = ddt.month;
			this.handle.day = ddt.day;
			this.handle.hour = ddt.hour;
			this.handle.min = ddt.minute;
			this.handle.sec = to!double(ddt.second);
		}

		this(Date d) @safe {
			this.handle.year = d.year;
			this.handle.month = d.month;
			this.handle.day = d.day;
			this.handle.hour = 0;
			this.handle.min = 0;
			this.handle.sec = 0;
		}

		this(TimeOfDay tod) @safe {
			this.handle.year = 0;
			this.handle.month = 0;
			this.handle.day = 0;
			this.handle.hour = tod.hour;
			this.handle.min = tod.minute;
			this.handle.sec = to!double(tod.second);
		}
	}
}
