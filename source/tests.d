import libxlsxd;

unittest {
	import std.conv : to;
    /* Create a new workbook and add a worksheet. */
    auto workbook  = newWorkbook("demo.xlsx");
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

	worksheet.write(7, 3, Datetime(dt));

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

unittest {
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
