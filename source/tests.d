import libxlsxd;
import std.datetime;

unittest {
	import std.conv : to;
    /* Create a new workbook and add a worksheet. */
    auto workbook  = newWorkbook("empty.xlsx");
}

@safe unittest {
	import std.conv : to;
    /* Create a new workbook and add a worksheet. */
    auto workbook  = WorkbookOpen("demo.xlsx");
	scope(exit) {
		workbook.close();
	}

	foreach(i; 0 .. 2) {
    auto worksheet = workbook.addWorksheet(to!string(i));

    /* Add a format. */
    auto format = workbook.addFormat();

    /* Set the bold property for the format */
    format.setBold();

    /* Change the column width for clarity. */
    worksheet.setColumn(0, 0, 20);

    /* Write some simple text. */
    worksheet.writeString(0, 0, "Hello " ~ to!string(i));

	import std.datetime : DateTime, Month;
	DateTime dt;
	dt.year = 1337;
	dt.month = Month.jul;
	dt.day = 2;
	dt.hour = 13;
	dt.minute = 37;

	version(No_Overloads_Or_Templates) {
		worksheet.write(7, 3, Datetime.fromDateTime(dt));

		worksheet.write(7, 3, Datetime.fromDate(Date(2038, 2, 13)));
		worksheet.write(8, 3, Datetime.fromDateTime(
				DateTime(2038, 2, 13, 15, 14, 13))
			);
		worksheet.write(9, 3, Datetime.fromTimeOfDay(
				TimeOfDay(16, 14, 13))
			);
	} else {
		worksheet.write(7, 3, Datetime(dt));

		worksheet.write(7, 3, Date(2038, 2, 13));
		worksheet.write(8, 3, DateTime(2038, 2, 13, 15, 14, 13));
		worksheet.write(9, 3, TimeOfDay(16, 14, 13));
	}

    /* Text with formatting. */
	version(No_Overloads_Or_Templates) {
		worksheet.writeStringFormat(to!RowType(1), to!ColType(0), "World",
				format
			);
	} else {
		worksheet.writeString(to!RowType(1), to!ColType(0), "World", format);
	}

    /* Write some numbers. */
    worksheet.writeNumber(2, 0, 123);
    worksheet.writeNumber(3, 0, 123.456);

	// for the lazy
    worksheet.write(4, 0, 13.37);
	// for the lazy
    worksheet.write(4, 1, true);

    worksheet.write(4, 2, "Hello 1337");
	worksheet.setColumn(4, 2, 20.0);

	size_t len = worksheet.writeAndGetWidth(5, 5, "Hello");
	assert(len == 5);

	len = worksheet.writeAndGetWidth(5, 6, true);
	assert(len == 4);

	len = worksheet.writeAndGetWidth(5, 6, false);
	assert(len == 5);

	len = worksheet.writeAndGetWidth(5, 7, 133);
	assert(len == 3);

	len = worksheet.writeAndGetWidth(5, 8, 133.7);
	assert(len == 5);
	}
}

@safe unittest {
	import std.conv : to;
    /* Create a new workbook and add a worksheet.
	   WorkbookOpen needs to be closed manually
	*/
    auto workbook  = WorkbookOpen("demo2.xlsx");
	foreach(i; 0 .. 2) {
    auto worksheet = workbook.addWorksheet(to!string(i));

    /* Add a format. */
    auto format = workbook.addFormat();

    /* Set the bold property for the format */
    format.setBold();

    /* Change the column width for clarity. */
    worksheet.setColumn(0, 0, 20);

    /* Write some simple text. */
    worksheet.writeString(0, 0, "Hello " ~ to!string(i));

    /* Text with formatting. */
	version(No_Overloads_Or_Templates) {
		worksheet.writeStringFormat(1, 0, "World", format);
	} else {
		worksheet.writeString(1, 0, "World", format);
	}

    /* Write some numbers. */
    worksheet.writeNumber(2, 0, 123);
    worksheet.writeNumber(3, 0, 123.456);

	// for the lazy
    worksheet.write(4, 0, 13.37);
	// for the lazy
    worksheet.write(4, 1, true);

    worksheet.write(4, 2, "Hello 1337");
	worksheet.setColumn(4, 2, 20.0);

	size_t len = worksheet.writeAndGetWidth(5, 5, "Hello");
	assert(len == 5);

	len = worksheet.writeAndGetWidth(5, 6, true);
	assert(len == 4);

	len = worksheet.writeAndGetWidth(5, 6, false);
	assert(len == 5);

	len = worksheet.writeAndGetWidth(5, 7, 133);
	assert(len == 3);

	len = worksheet.writeAndGetWidth(5, 8, 133.7);
	assert(len == 5);
	}
	workbook.close();
}

// #Issue 49
unittest {
	import std.conv : to;
    /* Create a new workbook and add a worksheet. */
    auto workbook  = newWorkbook("formula.xlsx");
    auto worksheet = workbook.addWorksheet("one");
	worksheet.write(0,0, 1);
	worksheet.write(1,0, 2);
	worksheet.write(2,0, 3);
	worksheet.writeFormula(0,1, "=SUM(A1,A2,A3)");
	worksheet.writeFormulaNum(1,1, "=SUM(A1,A2,A3)", 6.0);
}
