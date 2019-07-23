import libxlsxd;

private template Identity(T) {
	alias Identity = T;
}

@safe unittest {
	/* This tests tries to call each method of each struct defined.
	As the arguments are randomly generated these calls might throw.
	This does not matter, we are just trying to make sure that the parameter
	types match, as D does not as little semantic checks as possible, if
	methods or functions are not called.
	*/

	import std.datetime;
	import std.stdio;
	import std.array : empty;
	import std.traits;
	import std.format : format;
	import std.algorithm.searching : canFind;
	import std.datetime.date : DateTime;
	import std.random;
	import std.conv : to;
	import std.string : toStringz;

	auto rnd = Random(1337);

	auto wb = WorkbookOpen("test2.xlsx");
	scope(exit) {
		wb.close();
	}
	auto ws = wb.addWorksheet("__theworksheet");

	string genString() @safe {
		string ret = "";
		foreach(num; 0 .. uniform(2, 10, rnd)) {
			ret ~= to!char(uniform('a', 'z', rnd));
		}
		return ret;
	}

	DocProperties genDocProperties() @safe {
		static lxw_doc_properties dp;
		return DocProperties(&dp);
	}

	Chart genChart() @safe {
		Chart ret = wb.addChart(1);
		return ret;
	}

	lxw_rich_string_tuple** genRichStringTuple() @trusted {
		static lxw_rich_string_tuple tmp;
		static lxw_rich_string_tuple*[2] ret;
		tmp.format = null;
		tmp.string = cast(char*)toStringz("Hello world");

		ret[0] = &tmp;
		ret[1] = null;
		return ret.ptr;
	}

	lxw_row_col_options* genRowColOptions() @safe {
		static lxw_row_col_options ret;
		return &ret;
	}

	lxw_chart_point** genChartPoint() @trusted {
		static lxw_chart_point tmp;
		static lxw_chart_point*[2] ret;
		ret[0] = &tmp;
		ret[1] = null;
		return ret.ptr;
	}

	lxw_image_options* genImageOptions() @safe {
		static lxw_image_options ret;
		return &ret;
	}

	lxw_series_error_bars* genSeriesErrorBars() @safe {
		static lxw_series_error_bars ret;
		return &ret;
	}

	lxw_data_validation* genDataValidation() @safe {
		static lxw_data_validation ret;
		return &ret;
	}

	lxw_protection* genProtection() @safe {
		static lxw_protection ret;
		return &ret;
	}

	lxw_chart_font* genChartFont() @safe {
		static lxw_chart_font ret;
		return &ret;
	}

	lxw_chart_line* genChartLine() @safe {
		static lxw_chart_line ret;
		return &ret;
	}

	lxw_chart_pattern* genChartPattern() @safe {
		static lxw_chart_pattern ret;
		return &ret;
	}

	lxw_chart_fill* genChartFill() @safe {
		static lxw_chart_fill ret;
		return &ret;
	}

	lxw_header_footer_options* genHFOptions() @safe {
		static lxw_header_footer_options ret;
		return &ret;
	}

	void fillValues(T...)(ref T values) @safe {
		foreach(ref val; values) {
			static if(isSomeString!(typeof(val))) {
				val = genString();
			} else static if(isIntegral!(typeof(val))) {
				val = uniform(val.min, val.max, rnd);
			} else static if(isFloatingPoint!(typeof(val))) {
				val = uniform(-10000.0, 10000.0, rnd);
			} else static if(is(typeof(val) == bool)) {
				val = to!bool(uniform(0, 1, rnd));
			} else static if(is(typeof(val) == Datetime)) {
				auto dt = DateTime(1337, 1, 3, 3, 7);
				version(No_Overloads_Or_Templates) {
					val = Datetime.fromDateTime(dt);
				} else {
					val = Datetime(dt);
				}
			} else static if(is(typeof(val) == DocProperties)) {
				val = genDocProperties();
			} else static if(is(typeof(val) == Format)) {
				val = Format(null);
			} else static if(is(typeof(val) == lxw_rich_string_tuple**)) {
				val = genRichStringTuple();
			} else static if(is(typeof(val) == lxw_row_col_options*)) {
				val = genRowColOptions();
			} else static if(is(typeof(val) == lxw_image_options*)) {
				val = genImageOptions();
			} else static if(is(typeof(val) == lxw_data_validation*)) {
				val = genDataValidation();
			} else static if(is(typeof(val) == lxw_header_footer_options*)) {
				val = genHFOptions();
			} else static if(is(typeof(val) == lxw_protection*)) {
				val = genProtection();
			} else static if(is(typeof(val) == lxw_chart_font*)) {
				val = genChartFont();
			} else static if(is(typeof(val) == lxw_chart_line*)) {
				val = genChartLine();
			} else static if(is(typeof(val) == lxw_chart_fill*)) {
				val = genChartFill();
			} else static if(is(typeof(val) == lxw_series_error_bars*)) {
				val = genSeriesErrorBars();
			} else static if(is(typeof(val) == WorkbookImpl)) {
				val = wb;
			} else static if(is(typeof(val) == lxw_worksheet*)) {
				val = ws.handle;
			} else static if(is(typeof(val) == lxw_chart_point**)) {
				val = genChartPoint();
			} else static if(is(typeof(val) == lxw_format*)) {
				static lxw_format tmp;
				val = &tmp;
			} else static if(is(typeof(val) == lxw_chart*)) {
				static lxw_chart tmp;
				val = &tmp;
			} else static if(is(typeof(val) == lxw_chartsheet*)) {
				static lxw_chartsheet tmp;
				val = &tmp;
			} else static if(is(typeof(val) == lxw_chart_series*)) {
				static lxw_chart_series tmp;
				val = &tmp;
			} else static if(is(typeof(val) == lxw_chart_axis*)) {
				static lxw_chart_axis tmp;
				val = &tmp;
			} else static if(is(typeof(val) == const(ubyte)*)) {
				ubyte[2] tmp;
				val = cast(const(ubyte*))tmp.ptr;
			} else static if(is(typeof(val) == lxw_chart_pattern*)) {
				val = genChartPattern();
			} else static if(is(typeof(val) == uint[])) {
				uint[] t;
				t ~= uniform(uint.min, uint.max, rnd);
				t ~= uniform(uint.min, uint.max, rnd);
				val = t;
			} else static if(is(typeof(val) == ushort[])) {
				ushort[] t;
				t ~= uniform(ushort.min, ushort.max, rnd);
				t ~= uniform(ushort.min, ushort.max, rnd);
				val = t;
			} else static if(is(typeof(val) == short[])) {
				short[] t;
				t ~= uniform(short.min, short.max, rnd);
				t ~= uniform(short.min, short.max, rnd);
				val = t;
			} else static if(is(typeof(val) == Chart)) {
				val = genChart();
			} else static if(is(typeof(val) == Date)) {
				val = Date(
						uniform(1901, 2037, rnd),
						uniform(1, 12, rnd),
						uniform(1, 28, rnd));
			} else static if(is(typeof(val) == DateTime)) {
				val = DateTime(
						uniform(1901, 2037, rnd), uniform(1, 12, rnd),
						uniform(1, 28, rnd),
						uniform(1, 23, rnd), uniform(1, 59, rnd),
						uniform(1, 59, rnd));
			} else static if(is(typeof(val) == TimeOfDay)) {
				val = TimeOfDay(uniform(1, 23, rnd), uniform(1, 59, rnd),
						uniform(1, 59, rnd));
			} else {
				static assert(false, "No gen for " ~ typeof(val).stringof);
			}
		}
	}

	void runner(T, alias exclude, S)(ref S obj) @safe {
		static foreach(mem; __traits(allMembers, T)) {{
			static if(!canFind(exclude, mem)
					&& __traits(getProtection, __traits(getMember, T, mem))
						!= "private"
					&& isFunction!(__traits(getMember, T, mem))
				)
			{
				alias Values = staticMap!(Identity,
						Parameters!(__traits(getMember, T, mem))
					);
				Values vals;
				static if(Values.length > 0) {
					fillValues(vals);
				}
				try {
					__traits(getMember, obj, mem)(vals);
				} catch(Exception t) {
				}
			}
		}}
	}

	runner!(WorkbookImpl, ["__dtor", "__xdtor", "opAssign", "open", "close",
			"addChart"])(wb);
	runner!(Worksheet, ["__ctor", "__dtor", "__xdtor", "opAssign",
					"insertImageBuffer", "insertImageBufferOpt"])(ws);

	// testing Format methods
	version(No_Overloads_Or_Templates) {
		auto form = wb.addFormatNamed("__theformat");
	} else {
		auto form = wb.addFormat("__theformat");
	}
	runner!(Format, ["__ctor", "__dtor", "__xdtor", "opAssign"])(form);

	auto chart = wb.addChart(2);
	runner!(Chart, ["__ctor", "__dtor", "__xdtor", "opAssign",
					"free", "assembleXmlFile"])(chart);

	auto chartsheet = wb.addChartsheet("__thechartsheet");
	runner!(Chartsheet, ["__ctor", "__dtor", "__xdtor", "opAssign",
			"assembleXmlFile", "free"])(chartsheet);

	auto chartseries = chart.addChartseries("__thechartseries", "=A1 * 2");
	runner!(Chartseries, ["__ctor", "__dtor", "__xdtor", "opAssign"])
		(chartseries);

	auto chartaxis = chart.axisGet(LXW_CHART_AXIS_TYPE_X);
	runner!(Chartaxis, ["__ctor", "__dtor", "__xdtor", "opAssign"])
		(chartaxis);
}
