module libxlsxd.test3;

import libxlsxd.xlsxwrap;

import libxlsxd.workbook;
import libxlsxd.worksheet;
import libxlsxd.format;
import libxlsxd.chart;
import libxlsxd.chartsheet;
import libxlsxd.docproperties;
import libxlsxd.chartseries;
import libxlsxd.chartaxis;
import libxlsxd.datetime;
import libxlsxd.types;

@safe unittest {
	import std.traits : isCallable, isFunction, isPointer, isSomeFunction;
	import std.meta : AliasSeq;
	import std.format : format;
	import std.conv : to;
	import std.stdio;
	version(No_Overloads_Or_Templates) {
		// make sure no member function is overloaded
		static foreach(T; AliasSeq!(WorkbookOpen,Worksheet,Format, Chart,
					Chartaxis, Chartseries, Chartsheet, DocProperties, Datetime
			))
		{
			static foreach(mem; __traits(allMembers, T)) {{
				static if (is(typeof(__traits(getMember, T.init, mem)))) {
					enum bool isf =
						isSomeFunction!(__traits(getMember, T.init, mem));
					static if(isf) {{
						enum prot = __traits(getProtection,
								__traits(getMember, T.init, mem));
						static if (prot == "public") {{
							alias over = typeof(__traits(getOverloads, T, mem));
							static assert(over.length == 1, format(
									"%s.%s overload set size %s",
									T.stringof, mem, over.length));
						}}
					}}
				}
			}}
		}
	}
}
