module libxlsxd.xlsxwrap;


        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; } // FIXME



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }
    // Replacement for the gcc/clang intrinsic
    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }
    // dmd bug causes a crash if T is passed by value.
    // Works fine with ldc.
    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{

    char* lxw_escape_data(const(char)*) @nogc nothrow;

    char* lxw_escape_url_characters(const(char)*, ubyte) @nogc nothrow;

    char* lxw_escape_control_characters(const(char)*) @nogc nothrow;

    ubyte lxw_has_control_characters(const(char)*) @nogc nothrow;

    void lxw_xml_rich_si_element(_IO_FILE*, const(char)*) @nogc nothrow;
    /**
 * Write an XML element containing data and optional attributes.
 *
 * @param xmlfile    A FILE pointer to the output XML file.
 * @param tag        The XML tag to write.
 * @param data       The data section of the XML element.
 * @param attributes An optional list of attributes to add to the tag.
 */
    void lxw_xml_data_element(_IO_FILE*, const(char)*, const(char)*, xml_attribute_list*) @nogc nothrow;
    /**
 * Write an XML empty tag with optional un-encoded attributes.
 * This is a minor optimization for attributes that don't need encoding.
 *
 * @param xmlfile    A FILE pointer to the output XML file.
 * @param tag        The XML tag to write.
 * @param attributes An optional list of attributes to add to the tag.
 */
    void lxw_xml_empty_tag_unencoded(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    /**
 * Write an XML empty tag with optional attributes.
 *
 * @param xmlfile    A FILE pointer to the output XML file.
 * @param tag        The XML tag to write.
 * @param attributes An optional list of attributes to add to the tag.
 */
    void lxw_xml_empty_tag(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    /**
 * Write an XML end tag.
 *
 * @param xmlfile    A FILE pointer to the output XML file.
 * @param tag        The XML tag to write.
 */
    void lxw_xml_end_tag(_IO_FILE*, const(char)*) @nogc nothrow;
    /**
 * Write an XML start tag with optional un-encoded attributes.
 * This is a minor optimization for attributes that don't need encoding.
 *
 * @param xmlfile    A FILE pointer to the output XML file.
 * @param tag        The XML tag to write.
 * @param attributes An optional list of attributes to add to the tag.
 */
    void lxw_xml_start_tag_unencoded(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    /**
 * Write an XML start tag with optional attributes.
 *
 * @param xmlfile    A FILE pointer to the output XML file.
 * @param tag        The XML tag to write.
 * @param attributes An optional list of attributes to add to the tag.
 */
    void lxw_xml_start_tag(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    /**
 * Create the XML declaration in an XML file.
 *
 * @param xmlfile A FILE pointer to the output XML file.
 */
    void lxw_xml_declaration(_IO_FILE*) @nogc nothrow;

    xml_attribute* lxw_new_attribute_dbl(const(char)*, double) @nogc nothrow;

    xml_attribute* lxw_new_attribute_int(const(char)*, uint) @nogc nothrow;

    xml_attribute* lxw_new_attribute_str(const(char)*, const(char)*) @nogc nothrow;

    struct xml_attribute_list
    {

        xml_attribute* stqh_first;

        xml_attribute** stqh_last;
    }

    struct xml_attribute
    {

        char[2080] key;

        char[2080] value;

        static struct _Anonymous_0
        {

            xml_attribute* stqe_next;
        }

        _Anonymous_0 list_entries;
    }

    void lxw_worksheet_write_header_footer(lxw_worksheet*) @nogc nothrow;

    void lxw_worksheet_write_page_setup(lxw_worksheet*) @nogc nothrow;

    void lxw_worksheet_write_sheet_pr(lxw_worksheet*) @nogc nothrow;

    void lxw_worksheet_write_sheet_protection(lxw_worksheet*, lxw_protection_obj*) @nogc nothrow;

    void lxw_worksheet_write_drawings(lxw_worksheet*) @nogc nothrow;

    void lxw_worksheet_write_page_margins(lxw_worksheet*) @nogc nothrow;

    void lxw_worksheet_write_sheet_views(lxw_worksheet*) @nogc nothrow;

    lxw_cell* lxw_worksheet_find_cell_in_row(lxw_row*, ushort) @nogc nothrow;

    lxw_row* lxw_worksheet_find_row(lxw_worksheet*, uint) @nogc nothrow;

    void lxw_worksheet_prepare_tables(lxw_worksheet*, uint) @nogc nothrow;

    void lxw_worksheet_prepare_header_vml_objects(lxw_worksheet*, uint, uint) @nogc nothrow;

    uint lxw_worksheet_prepare_vml_objects(lxw_worksheet*, uint, uint, uint, uint) @nogc nothrow;

    void lxw_worksheet_prepare_chart(lxw_worksheet*, uint, uint, lxw_object_properties*, ubyte) @nogc nothrow;

    void lxw_worksheet_prepare_background(lxw_worksheet*, uint, lxw_object_properties*) @nogc nothrow;

    void lxw_worksheet_prepare_header_image(lxw_worksheet*, uint, lxw_object_properties*) @nogc nothrow;

    void lxw_worksheet_prepare_image(lxw_worksheet*, uint, uint, lxw_object_properties*) @nogc nothrow;

    void lxw_worksheet_write_single_row(lxw_worksheet*) @nogc nothrow;

    void lxw_worksheet_assemble_xml_file(lxw_worksheet*) @nogc nothrow;

    void lxw_worksheet_free(lxw_worksheet*) @nogc nothrow;

    lxw_worksheet* lxw_worksheet_new(lxw_worksheet_init_data*) @nogc nothrow;
    /**
 * @brief Ignore various Excel errors/warnings in a worksheet for user
 *        defined ranges.
 *
 * @param worksheet Pointer to a lxw_worksheet instance.
 * @param type      The type of error/warning to ignore. See #lxw_ignore_errors.
 * @param range     The range(s) for which the error/warning should be ignored.
 *
 * @return A #lxw_error.
 *
 *
 * The `%worksheet_ignore_errors()` function can be used to ignore various
 * worksheet cell errors/warnings. For example the following code writes a string
 * that looks like a number:
 *
 * @code
 *     worksheet_write_string(worksheet, CELL("D2"), "123", NULL);
 * @endcode
 *
 * This causes Excel to display a small green triangle in the top left hand
 * corner of the cell to indicate an error/warning:
 *
 * @image html ignore_errors1.png
 *
 * Sometimes these warnings are useful indicators that there is an issue in
 * the spreadsheet but sometimes it is preferable to turn them off. Warnings
 * can be turned off at the Excel level for all workbooks and worksheets by
 * using the using "Excel options -> Formulas -> Error checking
 * rules". Alternatively you can turn them off for individual cells in a
 * worksheet, or ranges of cells, using the `%worksheet_ignore_errors()`
 * function with different #lxw_ignore_errors options and ranges like this:
 *
 * @code
 *     worksheet_ignore_errors(worksheet, LXW_IGNORE_NUMBER_STORED_AS_TEXT, "C3");
 *     worksheet_ignore_errors(worksheet, LXW_IGNORE_EVAL_ERROR,            "C6");
 * @endcode
 *
 * The range can be a single cell, a range of cells, or multiple cells and ranges
 * separated by spaces:
 *
 * @code
 *     // Single cell.
 *     worksheet_ignore_errors(worksheet, LXW_IGNORE_NUMBER_STORED_AS_TEXT, "C6");
 *
 *     // Or a single range:
 *     worksheet_ignore_errors(worksheet, LXW_IGNORE_NUMBER_STORED_AS_TEXT, "C6:G8");
 *
 *     // Or multiple cells and ranges:
 *     worksheet_ignore_errors(worksheet, LXW_IGNORE_NUMBER_STORED_AS_TEXT, "C6 E6 G1:G20 J2:J6");
 * @endcode
 *
 * @note Calling `%worksheet_ignore_errors()` more than once for the same
 * #lxw_ignore_errors type will overwrite the previous range.
 *
 * You can turn off warnings for an entire column by specifying the range from
 * the first cell in the column to the last cell in the column:
 *
 * @code
 *     worksheet_ignore_errors(worksheet, LXW_IGNORE_NUMBER_STORED_AS_TEXT, "A1:A1048576");
 * @endcode
 *
 * Or for the entire worksheet by specifying the range from the first cell in
 * the worksheet to the last cell in the worksheet:
 *
 * @code
 *     worksheet_ignore_errors(worksheet, LXW_IGNORE_NUMBER_STORED_AS_TEXT, "A1:XFD1048576");
 * @endcode
 *
 * The worksheet errors/warnings that can be ignored are:
 *
 * - #LXW_IGNORE_NUMBER_STORED_AS_TEXT: Turn off errors/warnings for numbers
 *    stores as text.
 *
 * - #LXW_IGNORE_EVAL_ERROR: Turn off errors/warnings for formula errors (such
 *    as divide by zero).
 *
 * - #LXW_IGNORE_FORMULA_DIFFERS: Turn off errors/warnings for formulas that
 *    differ from surrounding formulas.
 *
 * - #LXW_IGNORE_FORMULA_RANGE: Turn off errors/warnings for formulas that
 *    omit cells in a range.
 *
 * - #LXW_IGNORE_FORMULA_UNLOCKED: Turn off errors/warnings for unlocked cells
 *    that contain formulas.
 *
 * - #LXW_IGNORE_EMPTY_CELL_REFERENCE: Turn off errors/warnings for formulas
 *    that refer to empty cells.
 *
 * - #LXW_IGNORE_LIST_DATA_VALIDATION: Turn off errors/warnings for cells in a
 *    table that do not comply with applicable data validation rules.
 *
 * - #LXW_IGNORE_CALCULATED_COLUMN: Turn off errors/warnings for cell formulas
 *    that differ from the column formula.
 *
 * - #LXW_IGNORE_TWO_DIGIT_TEXT_YEAR: Turn off errors/warnings for formulas
 *    that contain a two digit text representation of a year.
 *
 */
    lxw_error worksheet_ignore_errors(lxw_worksheet*, ubyte, const(char)*) @nogc nothrow;
    /**
 * @brief Set the default author of the cell comments.
 *
 * @param worksheet Pointer to a lxw_worksheet instance.
 * @param author    The name of the comment author.
 *
 * This `%worksheet_set_comments_author()` function is used to set the
 * default author of all cell comments:
 *
 * @code
 *     worksheet_set_comments_author(worksheet, "Jane Gloriana Villanueva")
 * @endcode
 *
 * Individual authors can be set using the `author` option of the
 * #lxw_comment_options struct and the `worksheet_write_comment_opt()`
 * function (see above and @ref ww_comments_author).
 */
    void worksheet_set_comments_author(lxw_worksheet*, const(char)*) @nogc nothrow;
    /**
 * @brief Make all comments in the worksheet visible.
 *
 * @param worksheet Pointer to a lxw_worksheet instance.
 *
 * This `%worksheet_show_comments()` function is used to make all cell
 * comments visible when a worksheet is opened:
 *
 * @code
 *     worksheet_show_comments(worksheet);
 * @endcode
 *
 * Individual comments can be made visible or hidden using the `visible`
 * option of the #lxw_comment_options struct and the `worksheet_write_comment_opt()`
 * function (see above and @ref ww_comments_visible).
 */
    void worksheet_show_comments(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the VBA name for the worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance.
 * @param name      Name of the worksheet used by VBA.
 *
 * @return A #lxw_error.
 *
 * The `worksheet_set_vba_name()` function can be used to set the VBA name for
 * the worksheet. This is sometimes required when a vbaProject macro included
 * via `workbook_add_vba_project()` refers to the worksheet by a name other
 * than the worksheet name:
 *
 * @code
 *     workbook_set_vba_name (workbook,  "MyWorkbook");
 *     worksheet_set_vba_name(worksheet, "MySheet1");
 * @endcode
 *
 * In general Excel uses the worksheet name such as "Sheet1" as the VBA name.
 * However, this can be changed in the VBA environment or if the the macro was
 * extracted from a foreign language version of Excel.
 *
 * See also @ref working_with_macros
 */
    lxw_error worksheet_set_vba_name(lxw_worksheet*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the default row properties.
 *
 * @param worksheet        Pointer to a lxw_worksheet instance to be updated.
 * @param height           Default row height.
 * @param hide_unused_rows Hide unused cells.
 *
 * The `%worksheet_set_default_row()` function is used to set Excel default
 * row properties such as the default height and the option to hide unused
 * rows. These parameters are an optimization used by Excel to set row
 * properties without generating a very large file with an entry for each row.
 *
 * To set the default row height:
 *
 * @code
 *     worksheet_set_default_row(worksheet, 24, LXW_FALSE);
 *
 * @endcode
 *
 * To hide unused rows:
 *
 * @code
 *     worksheet_set_default_row(worksheet, 15, LXW_TRUE);
 * @endcode
 *
 * Note, in the previous case we use the default height #LXW_DEF_ROW_HEIGHT =
 * 15 so the the height remains unchanged.
 */
    void worksheet_set_default_row(lxw_worksheet*, double, ubyte) @nogc nothrow;
    /**
 * @brief Set the Outline and Grouping display properties.
 *
 * @param worksheet      Pointer to a lxw_worksheet instance to be updated.
 * @param visible        Outlines are visible. Optional, defaults to True.
 * @param symbols_below  Show row outline symbols below the outline bar.
 * @param symbols_right  Show column outline symbols to the right of outline.
 * @param auto_style     Use Automatic outline style.
 *
 * The `%worksheet_outline_settings()` method is used to control the
 * appearance of outlines in Excel. Outlines are described the section on
 * @ref working_with_outlines.
 *
 * The `visible` parameter is used to control whether or not outlines are
 * visible. Setting this parameter to False will cause all outlines on the
 * worksheet to be hidden. They can be un-hidden in Excel by means of the
 * "Show Outline Symbols" command button. The default Excel setting is True
 * for visible outlines.
 *
 * The `symbols_below` parameter is used to control whether the row outline
 * symbol will appear above or below the outline level bar. The default Excel
 * setting is True for symbols to appear below the outline level bar.
 *
 * The `symbols_right` parameter is used to control whether the column outline
 * symbol will appear to the left or the right of the outline level bar. The
 * default Excel setting is True for symbols to appear to the right of the
 * outline level bar.
 *
 * The `auto_style` parameter is used to control whether the automatic outline
 * generator in Excel uses automatic styles when creating an outline. This has
 * no effect on a file generated by XlsxWriter but it does have an effect on
 * how the worksheet behaves after it is created. The default Excel setting is
 * False for "Automatic Styles" to be turned off.
 *
 * The default settings for all of these parameters in libxlsxwriter
 * correspond to Excel's default parameters and are shown below:
 *
 * @code
 *     worksheet_outline_settings(worksheet1, LXW_TRUE, LXW_TRUE, LXW_TRUE, LXW_FALSE);
 * @endcode
 *
 * The worksheet parameters controlled by `worksheet_outline_settings()` are
 * rarely used.
 */
    void worksheet_outline_settings(lxw_worksheet*, ubyte, ubyte, ubyte, ubyte) @nogc nothrow;
    /**
 * @brief Protect elements of a worksheet from modification.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param password  A worksheet password.
 * @param options   Worksheet elements to protect.
 *
 * The `%worksheet_protect()` function protects worksheet elements from modification:
 *
 * @code
 *     worksheet_protect(worksheet, "Some Password", options);
 * @endcode
 *
 * The `password` and lxw_protection pointer are both optional:
 *
 * @code
 *     worksheet_protect(worksheet1, NULL,       NULL);
 *     worksheet_protect(worksheet2, NULL,       my_options);
 *     worksheet_protect(worksheet3, "password", NULL);
 *     worksheet_protect(worksheet4, "password", my_options);
 * @endcode
 *
 * Passing a `NULL` password is the same as turning on protection without a
 * password. Passing a `NULL` password and `NULL` options, or any other
 * combination has the effect of enabling a cell's `locked` and `hidden`
 * properties if they have been set.
 *
 * A *locked* cell cannot be edited and this property is on by default for all
 * cells. A *hidden* cell will display the results of a formula but not the
 * formula itself. These properties can be set using the format_set_unlocked()
 * and format_set_hidden() format functions.
 *
 * You can specify which worksheet elements you wish to protect by passing a
 * lxw_protection pointer in the `options` argument with any or all of the
 * following members set:
 *
 *     no_select_locked_cells
 *     no_select_unlocked_cells
 *     format_cells
 *     format_columns
 *     format_rows
 *     insert_columns
 *     insert_rows
 *     insert_hyperlinks
 *     delete_columns
 *     delete_rows
 *     sort
 *     autofilter
 *     pivot_tables
 *     scenarios
 *     objects
 *
 * All parameters are off by default. Individual elements can be protected as
 * follows:
 *
 * @code
 *     lxw_protection options = {
 *         .format_cells             = 1,
 *         .insert_hyperlinks        = 1,
 *         .insert_rows              = 1,
 *         .delete_rows              = 1,
 *         .insert_columns           = 1,
 *         .delete_columns           = 1,
 *     };
 *
 *     worksheet_protect(worksheet, NULL, &options);
 *
 * @endcode
 *
 * See also the format_set_unlocked() and format_set_hidden() format functions.
 *
 * **Note:** Sheet level passwords in Excel offer **very** weak
 * protection. They don't encrypt your data and are very easy to
 * deactivate. Full workbook encryption is not supported by `libxlsxwriter`
 * since it requires a completely different file format.
 */
    void worksheet_protect(lxw_worksheet*, const(char)*, lxw_protection*) @nogc nothrow;
    /**
 * @brief Set the color of the worksheet tab.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param color     The tab color.
 *
 * The `%worksheet_set_tab_color()` function is used to change the color of
 * the worksheet tab:
 *
 * @code
 *      worksheet_set_tab_color(worksheet1, LXW_COLOR_RED);
 *      worksheet_set_tab_color(worksheet2, LXW_COLOR_GREEN);
 *      worksheet_set_tab_color(worksheet3, 0xFF9900); // Orange.
 * @endcode
 *
 * The color should be an RGB integer value, see @ref working_with_colors.
 */
    void worksheet_set_tab_color(lxw_worksheet*, uint) @nogc nothrow;
    /**
 * @brief Hide zero values in worksheet cells.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * The `%worksheet_hide_zero()` function is used to hide any zero values that
 * appear in cells:
 *
 * @code
 *     worksheet_hide_zero(worksheet1);
 * @endcode
 */
    void worksheet_hide_zero(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Display the worksheet cells from right to left for some versions of
 *        Excel.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
  * The `%worksheet_right_to_left()` function is used to change the default
 * direction of the worksheet from left-to-right, with the `A1` cell in the
 * top left, to right-to-left, with the `A1` cell in the top right.
 *
 * @code
 *     worksheet_right_to_left(worksheet1);
 * @endcode
 *
 * This is useful when creating Arabic, Hebrew or other near or far eastern
 * worksheets that use right-to-left as the default direction.
 */
    void worksheet_right_to_left(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the worksheet to print in black and white
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * Set the option to print the worksheet in black and white:
 * @code
 *     worksheet_print_black_and_white(worksheet);
 * @endcode
 */
    void worksheet_print_black_and_white(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the scale factor for the printed page.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param scale     Print scale of worksheet to be printed.
 *
 * This function sets the scale factor of the printed page. The Scale factor
 * must be in the range `10 <= scale <= 400`:
 *
 * @code
 *     worksheet_set_print_scale(worksheet1, 75);
 *     worksheet_set_print_scale(worksheet2, 400);
 * @endcode
 *
 * The default scale factor is 100. Note, `%worksheet_set_print_scale()` does
 * not affect the scale of the visible page in Excel. For that you should use
 * `worksheet_set_zoom()`.
 *
 * Note that although it is valid to use both `worksheet_fit_to_pages()` and
 * `%worksheet_set_print_scale()` on the same worksheet Excel only allows one
 * of these options to be active at a time. The last function call made will
 * set the active option.
 *
 */
    void worksheet_set_print_scale(lxw_worksheet*, ushort) @nogc nothrow;
    /**
 * @brief Set the start/first page number when printing.
 *
 * @param worksheet  Pointer to a lxw_worksheet instance to be updated.
 * @param start_page Page number of the starting page when printing.
 *
 * The `%worksheet_set_start_page()` function is used to set the number number
 * of the first page when the worksheet is printed out. It is the same as the
 * "First Page Number" option in Excel:
 *
 * @code
 *     // Start print from page 2.
 *     worksheet_set_start_page(worksheet, 2);
 * @endcode
 */
    void worksheet_set_start_page(lxw_worksheet*, ushort) @nogc nothrow;
    /**
 * @brief Fit the printed area to a specific number of pages both vertically
 *        and horizontally.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param width     Number of pages horizontally.
 * @param height    Number of pages vertically.
 *
 * The `%worksheet_fit_to_pages()` function is used to fit the printed area to
 * a specific number of pages both vertically and horizontally. If the printed
 * area exceeds the specified number of pages it will be scaled down to
 * fit. This ensures that the printed area will always appear on the specified
 * number of pages even if the page size or margins change:
 *
 * @code
 *     worksheet_fit_to_pages(worksheet1, 1, 1); // Fit to 1x1 pages.
 *     worksheet_fit_to_pages(worksheet2, 2, 1); // Fit to 2x1 pages.
 *     worksheet_fit_to_pages(worksheet3, 1, 2); // Fit to 1x2 pages.
 * @endcode
 *
 * The print area can be defined using the `worksheet_print_area()` function
 * as described above.
 *
 * A common requirement is to fit the printed output to `n` pages wide but
 * have the height be as long as necessary. To achieve this set the `height`
 * to zero:
 *
 * @code
 *     // 1 page wide and as long as necessary.
 *     worksheet_fit_to_pages(worksheet, 1, 0);
 * @endcode
 *
 * **Note**:
 *
 * - Although it is valid to use both `%worksheet_fit_to_pages()` and
 *   `worksheet_set_print_scale()` on the same worksheet Excel only allows one
 *   of these options to be active at a time. The last function call made will
 *   set the active option.
 *
 * - The `%worksheet_fit_to_pages()` function will override any manual page
 *   breaks that are defined in the worksheet.
 *
 * - When using `%worksheet_fit_to_pages()` it may also be required to set the
 *   printer paper size using `worksheet_set_paper()` or else Excel will
 *   default to "US Letter".
 *
 */
    void worksheet_fit_to_pages(lxw_worksheet*, ushort, ushort) @nogc nothrow;
    /**
 * @brief Set the print area for a worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_row The first row of the range. (All zero indexed.)
 * @param first_col The first column of the range.
 * @param last_row  The last row of the range.
 * @param last_col  The last col of the range.
 *
 * @return A #lxw_error code.
 *
 * This function is used to specify the area of the worksheet that will be
 * printed. The RANGE() macro is often convenient for this.
 *
 * @code
 *     worksheet_print_area(worksheet, 0, 0, 41, 10); // A1:K42.
 *
 *     // Same as:
 *     worksheet_print_area(worksheet, RANGE("A1:K42"));
 * @endcode
 *
 * In order to set a row or column range you must specify the entire range:
 *
 * @code
 *     worksheet_print_area(worksheet, RANGE("A1:H1048576")); // Same as A:H.
 * @endcode
 */
    lxw_error worksheet_print_area(lxw_worksheet*, uint, ushort, uint, ushort) @nogc nothrow;
    /**
 * @brief Set the number of columns to repeat at the top of each printed page.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_col First column of repeat range.
 * @param last_col  Last column of repeat range.
 *
 * @return A #lxw_error code.
 *
 * For large Excel documents it is often desirable to have the first column or
 * columns of the worksheet print out at the left of each page.
 *
 * This can be achieved by using this function. The parameters `first_col`
 * and `last_col` are zero based:
 *
 * @code
 *     worksheet_repeat_columns(worksheet, 0, 0); // Repeat the first col.
 *     worksheet_repeat_columns(worksheet, 0, 1); // Repeat the first two cols.
 * @endcode
 */
    lxw_error worksheet_repeat_columns(lxw_worksheet*, ushort, ushort) @nogc nothrow;
    /**
 * @brief Set the number of rows to repeat at the top of each printed page.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_row First row of repeat range.
 * @param last_row  Last row of repeat range.
 *
 * @return A #lxw_error code.
 *
 * For large Excel documents it is often desirable to have the first row or
 * rows of the worksheet print out at the top of each page.
 *
 * This can be achieved by using this function. The parameters `first_row`
 * and `last_row` are zero based:
 *
 * @code
 *     worksheet_repeat_rows(worksheet, 0, 0); // Repeat the first row.
 *     worksheet_repeat_rows(worksheet, 0, 1); // Repeat the first two rows.
 * @endcode
 */
    lxw_error worksheet_repeat_rows(lxw_worksheet*, uint, uint) @nogc nothrow;
    /**
 * @brief Set the option to print the row and column headers on the printed
 *        page.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * When printing a worksheet from Excel the row and column headers (the row
 * numbers on the left and the column letters at the top) aren't printed by
 * default.
 *
 * This function sets the printer option to print these headers:
 *
 * @code
 *    worksheet_print_row_col_headers(worksheet);
 * @endcode
 *
 */
    void worksheet_print_row_col_headers(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Center the printed page vertically.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * Center the worksheet data vertically between the margins on the printed
 * page:
 *
 * @code
 *     worksheet_center_vertically(worksheet);
 * @endcode
 *
 */
    void worksheet_center_vertically(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Center the printed page horizontally.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * Center the worksheet data horizontally between the margins on the printed
 * page:
 *
 * @code
 *     worksheet_center_horizontally(worksheet);
 * @endcode
 *
 */
    void worksheet_center_horizontally(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the option to display or hide gridlines on the screen and
 *        the printed page.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param option    Gridline option.
 *
 * Display or hide screen and print gridlines using one of the values of
 * @ref lxw_gridlines.
 *
 * @code
 *    worksheet_gridlines(worksheet1, LXW_HIDE_ALL_GRIDLINES);
 *
 *    worksheet_gridlines(worksheet2, LXW_SHOW_PRINT_GRIDLINES);
 * @endcode
 *
 * The Excel default is that the screen gridlines are on  and the printed
 * worksheet is off.
 *
 */
    void worksheet_gridlines(lxw_worksheet*, ubyte) @nogc nothrow;
    /**
 * @brief Set the worksheet zoom factor.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param scale     Worksheet zoom factor.
 *
 * Set the worksheet zoom factor in the range `10 <= zoom <= 400`:
 *
 * @code
 *     worksheet_set_zoom(worksheet1, 50);
 *     worksheet_set_zoom(worksheet2, 75);
 *     worksheet_set_zoom(worksheet3, 300);
 *     worksheet_set_zoom(worksheet4, 400);
 * @endcode
 *
 * The default zoom factor is 100. It isn't possible to set the zoom to
 * "Selection" because it is calculated by Excel at run-time.
 *
 * Note, `%worksheet_zoom()` does not affect the scale of the printed
 * page. For that you should use `worksheet_set_print_scale()`.
 */
    void worksheet_set_zoom(lxw_worksheet*, ushort) @nogc nothrow;
    /**
 * @brief Set the order in which pages are printed.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * The `%worksheet_print_across()` function is used to change the default
 * print direction. This is referred to by Excel as the sheet "page order":
 *
 * @code
 *     worksheet_print_across(worksheet);
 * @endcode
 *
 * The default page order is shown below for a worksheet that extends over 4
 * pages. The order is called "down then across":
 *
 *     [1] [3]
 *     [2] [4]
 *
 * However, by using the `print_across` function the print order will be
 * changed to "across then down":
 *
 *     [1] [2]
 *     [3] [4]
 *
 */
    void worksheet_print_across(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the vertical page breaks on a worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param breaks    Array of page breaks.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_v_pagebreaks()` function adds vertical page breaks to a
 * worksheet. A page break causes all the data that follows it to be printed
 * on the next page. Vertical page breaks act between columns.
 *
 * The function takes an array of one or more page breaks. The type of the
 * array data is @ref lxw_col_t and the last element of the array must be 0:
 *
 * @code
 *    lxw_col_t breaks1[] = {20, 0}; // 1 page break. Zero indicates the end.
 *    lxw_col_t breaks2[] = {20, 40, 60, 80, 0};
 *
 *    worksheet_set_v_pagebreaks(worksheet1, breaks1);
 *    worksheet_set_v_pagebreaks(worksheet2, breaks2);
 * @endcode
 *
 * To create a page break between columns 20 and 21 you must specify the break
 * at column 21. However in zero index notation this is actually column 20:
 *
 * @code
 *    // Break between column 20 and 21.
 *    lxw_col_t breaks[] = {20, 0};
 *
 *    worksheet_set_v_pagebreaks(worksheet, breaks);
 * @endcode
 *
 * There is an Excel limitation of 1023 vertical page breaks per worksheet.
 *
 * Note: If you specify the "fit to page" option via the
 * `worksheet_fit_to_pages()` function it will override all manual page
 * breaks.
 *
 */
    lxw_error worksheet_set_v_pagebreaks(lxw_worksheet*, ushort*) @nogc nothrow;
    /**
 * @brief Set the horizontal page breaks on a worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param breaks    Array of page breaks.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_h_pagebreaks()` function adds horizontal page breaks to
 * a worksheet. A page break causes all the data that follows it to be printed
 * on the next page. Horizontal page breaks act between rows.
 *
 * The function takes an array of one or more page breaks. The type of the
 * array data is @ref lxw_row_t and the last element of the array must be 0:
 *
 * @code
 *    lxw_row_t breaks1[] = {20, 0}; // 1 page break. Zero indicates the end.
 *    lxw_row_t breaks2[] = {20, 40, 60, 80, 0};
 *
 *    worksheet_set_h_pagebreaks(worksheet1, breaks1);
 *    worksheet_set_h_pagebreaks(worksheet2, breaks2);
 * @endcode
 *
 * To create a page break between rows 20 and 21 you must specify the break at
 * row 21. However in zero index notation this is actually row 20:
 *
 * @code
 *    // Break between row 20 and 21.
 *    lxw_row_t breaks[] = {20, 0};
 *
 *    worksheet_set_h_pagebreaks(worksheet, breaks);
 * @endcode
 *
 * There is an Excel limitation of 1023 horizontal page breaks per worksheet.
 *
 * Note: If you specify the "fit to page" option via the
 * `worksheet_fit_to_pages()` function it will override all manual page
 * breaks.
 *
 */
    lxw_error worksheet_set_h_pagebreaks(lxw_worksheet*, uint*) @nogc nothrow;
    /**
 * @brief Set the printed page footer caption with additional options.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param string    The footer string.
 * @param options   Footer options.
 *
 * @return A #lxw_error code.
 *
 * The syntax of this function is the same as `worksheet_set_header_opt()`.
 *
 */
    lxw_error worksheet_set_footer_opt(lxw_worksheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    /**
 * @brief Set the printed page header caption with additional options.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param string    The header string.
 * @param options   Header options.
 *
 * @return A #lxw_error code.
 *
 * The syntax of this function is the same as `worksheet_set_header()` with an
 * additional parameter to specify options for the header.
 *
 * The #lxw_header_footer_options options are:
 *
 * - `margin`: Header or footer margin in inches. The value must by larger
 *   than 0.0. The Excel default is 0.3.
 *
 * - `image_left`: The left header image filename, with path if required. This
 *   should have a corresponding `&G/&[Picture]` placeholder in the `&L`
 *   section of the header/footer string.
 *
 * - `image_center`: The center header image filename, with path if
 *   required. This should have a corresponding `&G/&[Picture]` placeholder in
 *   the `&C` section of the header/footer string.
 *
 * - `image_right`: The right header image filename, with path if
 *   required. This should have a corresponding `&G/&[Picture]` placeholder in
 *   the `&R` section of the header/footer string.
 *
 * @code
 *     lxw_header_footer_options header_options = { .margin = 0.2 };
 *
 *     worksheet_set_header_opt(worksheet, "Some text", &header_options);
 * @endcode
 *
 * Images can be inserted in the header by specifying the `&[Picture]`
 * placeholder and a filename/path to the image:
 *
 * @code
 *     lxw_header_footer_options header_options = {.image_left = "logo.png"};
 *
 *    worksheet_set_header_opt(worksheet, "&L&[Picture]", &header_options);
 * @endcode
 *
 * @image html headers_footers.png
 *
 */
    lxw_error worksheet_set_header_opt(lxw_worksheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    /**
 * @brief Set the printed page footer caption.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param string    The footer string.
 *
 * @return A #lxw_error code.
 *
 * The syntax of this function is the same as worksheet_set_header().
 *
 */
    lxw_error worksheet_set_footer(lxw_worksheet*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the printed page header caption.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param string    The header string.
 *
 * @return A #lxw_error code.
 *
 * Headers and footers are generated using a string which is a combination of
 * plain text and control characters.
 *
 * The available control character are:
 *
 *
 *   | Control         | Category      | Description           |
 *   | --------------- | ------------- | --------------------- |
 *   | `&L`            | Justification | Left                  |
 *   | `&C`            |               | Center                |
 *   | `&R`            |               | Right                 |
 *   | `&P`            | Information   | Page number           |
 *   | `&N`            |               | Total number of pages |
 *   | `&D`            |               | Date                  |
 *   | `&T`            |               | Time                  |
 *   | `&F`            |               | File name             |
 *   | `&A`            |               | Worksheet name        |
 *   | `&Z`            |               | Workbook path         |
 *   | `&fontsize`     | Font          | Font size             |
 *   | `&"font,style"` |               | Font name and style   |
 *   | `&U`            |               | Single underline      |
 *   | `&E`            |               | Double underline      |
 *   | `&S`            |               | Strikethrough         |
 *   | `&X`            |               | Superscript           |
 *   | `&Y`            |               | Subscript             |
 *   | `&[Picture]`    | Images        | Image placeholder     |
 *   | `&G`            |               | Same as `&[Picture]`  |
 *   | `&&`            | Miscellaneous | Literal ampersand &   |
 *
 * Note: inserting images requires the `worksheet_set_header_opt()` function.
 *
 * Text in headers and footers can be justified (aligned) to the left, center
 * and right by prefixing the text with the control characters `&L`, `&C` and
 * `&R`.
 *
 * For example (with ASCII art representation of the results):
 *
 * @code
 *     worksheet_set_header(worksheet, "&LHello");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    | Hello                                                         |
 *     //    |                                                               |
 *
 *
 *     worksheet_set_header(worksheet, "&CHello");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    |                          Hello                                |
 *     //    |                                                               |
 *
 *
 *     worksheet_set_header(worksheet, "&RHello");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    |                                                         Hello |
 *     //    |                                                               |
 *
 *
 * @endcode
 *
 * For simple text, if you do not specify any justification the text will be
 * centered. However, you must prefix the text with `&C` if you specify a font
 * name or any other formatting:
 *
 * @code
 *     worksheet_set_header(worksheet, "Hello");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    |                          Hello                                |
 *     //    |                                                               |
 *
 * @endcode
 *
 * You can have text in each of the justification regions:
 *
 * @code
 *     worksheet_set_header(worksheet, "&LCiao&CBello&RCielo");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    | Ciao                     Bello                          Cielo |
 *     //    |                                                               |
 *
 * @endcode
 *
 * The information control characters act as variables that Excel will update
 * as the workbook or worksheet changes. Times and dates are in the users
 * default format:
 *
 * @code
 *     worksheet_set_header(worksheet, "&CPage &P of &N");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    |                        Page 1 of 6                            |
 *     //    |                                                               |
 *
 *     worksheet_set_header(worksheet, "&CUpdated at &T");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    |                    Updated at 12:30 PM                        |
 *     //    |                                                               |
 *
 * @endcode
 *
 * You can specify the font size of a section of the text by prefixing it with
 * the control character `&n` where `n` is the font size:
 *
 * @code
 *     worksheet_set_header(worksheet1, "&C&30Hello Big");
 *     worksheet_set_header(worksheet2, "&C&10Hello Small");
 *
 * @endcode
 *
 * You can specify the font of a section of the text by prefixing it with the
 * control sequence `&"font,style"` where `fontname` is a font name such as
 * Windows font descriptions: "Regular", "Italic", "Bold" or "Bold Italic":
 * "Courier New" or "Times New Roman" and `style` is one of the standard
 *
 * @code
 *     worksheet_set_header(worksheet1, "&C&\"Courier New,Italic\"Hello");
 *     worksheet_set_header(worksheet2, "&C&\"Courier New,Bold Italic\"Hello");
 *     worksheet_set_header(worksheet3, "&C&\"Times New Roman,Regular\"Hello");
 *
 * @endcode
 *
 * It is possible to combine all of these features together to create
 * sophisticated headers and footers. As an aid to setting up complicated
 * headers and footers you can record a page set-up as a macro in Excel and
 * look at the format strings that VBA produces. Remember however that VBA
 * uses two double quotes `""` to indicate a single double quote. For the last
 * example above the equivalent VBA code looks like this:
 *
 * @code
 *     .LeftHeader = ""
 *     .CenterHeader = "&""Times New Roman,Regular""Hello"
 *     .RightHeader = ""
 *
 * @endcode
 *
 * Alternatively you can inspect the header and footer strings in an Excel
 * file by unzipping it and grepping the XML sub-files. The following shows
 * how to do that using libxml's xmllint to format the XML for clarity:
 *
 * @code
 *
 *    $ unzip myfile.xlsm -d myfile
 *    $ xmllint --format `find myfile -name "*.xml" | xargs` | egrep "Header|Footer" | sed 's/&amp;/\&/g'
 *
 *      <headerFooter scaleWithDoc="0">
 *        <oddHeader>&L&P</oddHeader>
 *      </headerFooter>
 *
 * @endcode
 *
 * To include a single literal ampersand `&` in a header or footer you should
 * use a double ampersand `&&`:
 *
 * @code
 *     worksheet_set_header(worksheet, "&CCuriouser && Curiouser - Attorneys at Law");
 * @endcode
 *
 * @note
 * Excel requires that the header or footer string cannot be longer than 255
 * characters, including the control characters. Strings longer than this will
 * not be written.
 *
 */
    lxw_error worksheet_set_header(lxw_worksheet*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the worksheet margins for the printed page.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param left    Left margin in inches.   Excel default is 0.7.
 * @param right   Right margin in inches.  Excel default is 0.7.
 * @param top     Top margin in inches.    Excel default is 0.75.
 * @param bottom  Bottom margin in inches. Excel default is 0.75.
 *
 * The `%worksheet_set_margins()` function is used to set the margins of the
 * worksheet when it is printed. The units are in inches. Specifying `-1` for
 * any parameter will give the default Excel value as shown above.
 *
 * @code
 *    worksheet_set_margins(worksheet, 1.3, 1.2, -1, -1);
 * @endcode
 *
 */
    void worksheet_set_margins(lxw_worksheet*, double, double, double, double) @nogc nothrow;
    /**
 * @brief Set the paper type for printing.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param paper_type The Excel paper format type.
 *
 * This function is used to set the paper format for the printed output of a
 * worksheet. The following paper styles are available:
 *
 *
 *   Index    | Paper format            | Paper size
 *   :------- | :---------------------- | :-------------------
 *   0        | Printer default         | Printer default
 *   1        | Letter                  | 8 1/2 x 11 in
 *   2        | Letter Small            | 8 1/2 x 11 in
 *   3        | Tabloid                 | 11 x 17 in
 *   4        | Ledger                  | 17 x 11 in
 *   5        | Legal                   | 8 1/2 x 14 in
 *   6        | Statement               | 5 1/2 x 8 1/2 in
 *   7        | Executive               | 7 1/4 x 10 1/2 in
 *   8        | A3                      | 297 x 420 mm
 *   9        | A4                      | 210 x 297 mm
 *   10       | A4 Small                | 210 x 297 mm
 *   11       | A5                      | 148 x 210 mm
 *   12       | B4                      | 250 x 354 mm
 *   13       | B5                      | 182 x 257 mm
 *   14       | Folio                   | 8 1/2 x 13 in
 *   15       | Quarto                  | 215 x 275 mm
 *   16       | ---                     | 10x14 in
 *   17       | ---                     | 11x17 in
 *   18       | Note                    | 8 1/2 x 11 in
 *   19       | Envelope 9              | 3 7/8 x 8 7/8
 *   20       | Envelope 10             | 4 1/8 x 9 1/2
 *   21       | Envelope 11             | 4 1/2 x 10 3/8
 *   22       | Envelope 12             | 4 3/4 x 11
 *   23       | Envelope 14             | 5 x 11 1/2
 *   24       | C size sheet            | ---
 *   25       | D size sheet            | ---
 *   26       | E size sheet            | ---
 *   27       | Envelope DL             | 110 x 220 mm
 *   28       | Envelope C3             | 324 x 458 mm
 *   29       | Envelope C4             | 229 x 324 mm
 *   30       | Envelope C5             | 162 x 229 mm
 *   31       | Envelope C6             | 114 x 162 mm
 *   32       | Envelope C65            | 114 x 229 mm
 *   33       | Envelope B4             | 250 x 353 mm
 *   34       | Envelope B5             | 176 x 250 mm
 *   35       | Envelope B6             | 176 x 125 mm
 *   36       | Envelope                | 110 x 230 mm
 *   37       | Monarch                 | 3.875 x 7.5 in
 *   38       | Envelope                | 3 5/8 x 6 1/2 in
 *   39       | Fanfold                 | 14 7/8 x 11 in
 *   40       | German Std Fanfold      | 8 1/2 x 12 in
 *   41       | German Legal Fanfold    | 8 1/2 x 13 in
 *
 * Note, it is likely that not all of these paper types will be available to
 * the end user since it will depend on the paper formats that the user's
 * printer supports. Therefore, it is best to stick to standard paper types:
 *
 * @code
 *     worksheet_set_paper(worksheet1, 1);  // US Letter
 *     worksheet_set_paper(worksheet2, 9);  // A4
 * @endcode
 *
 * If you do not specify a paper type the worksheet will print using the
 * printer's default paper style.
 */
    void worksheet_set_paper(lxw_worksheet*, ubyte) @nogc nothrow;
    /**
 * @brief Set the page layout to page view mode.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * This function is used to display the worksheet in "Page View/Layout" mode:
 *
 * @code
 *     worksheet_set_page_view(worksheet);
 * @endcode
 */
    void worksheet_set_page_view(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the page orientation as portrait.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * This function is used to set the orientation of a worksheet's printed page
 * to portrait. The default worksheet orientation is portrait, so this
 * function isn't generally required:
 *
 * @code
 *     worksheet_set_portrait(worksheet);
 * @endcode
 */
    void worksheet_set_portrait(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the page orientation as landscape.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * This function is used to set the orientation of a worksheet's printed page
 * to landscape:
 *
 * @code
 *     worksheet_set_landscape(worksheet);
 * @endcode
 */
    void worksheet_set_landscape(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Set the first visible cell at the top left of a worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The cell row (zero indexed).
 * @param col       The cell column (zero indexed).
 *
 * The `%worksheet_set_top_left_cell()` function can be used to set the
 * top leftmost visible cell in the worksheet:
 *
 * @code
 *     worksheet_set_top_left_cell(worksheet, 31, 26);
 *     worksheet_set_top_left_cell(worksheet, CELL("AA32")); // Same as above.
 * @endcode
 *
 * @image html top_left_cell.png
 *
 */
    void worksheet_set_top_left_cell(lxw_worksheet*, uint, ushort) @nogc nothrow;
    /**
 * @brief Set the selected cell or cells in a worksheet:
 *
 * @param worksheet   A pointer to a lxw_worksheet instance to be updated.
 * @param first_row   The first row of the range. (All zero indexed.)
 * @param first_col   The first column of the range.
 * @param last_row    The last row of the range.
 * @param last_col    The last col of the range.
 *
 *
 * The `%worksheet_set_selection()` function can be used to specify which cell
 * or range of cells is selected in a worksheet: The most common requirement
 * is to select a single cell, in which case the `first_` and `last_`
 * parameters should be the same.
 *
 * The active cell within a selected range is determined by the order in which
 * `first_` and `last_` are specified.
 *
 * Examples:
 *
 * @code
 *     worksheet_set_selection(worksheet1, 3, 3, 3, 3);     // Cell D4.
 *     worksheet_set_selection(worksheet2, 3, 3, 6, 6);     // Cells D4 to G7.
 *     worksheet_set_selection(worksheet3, 6, 6, 3, 3);     // Cells G7 to D4.
 *     worksheet_set_selection(worksheet5, RANGE("D4:G7")); // Using the RANGE macro.
 *
 * @endcode
 *
 */
    void worksheet_set_selection(lxw_worksheet*, uint, ushort, uint, ushort) @nogc nothrow;

    void worksheet_split_panes_opt(lxw_worksheet*, double, double, uint, ushort) @nogc nothrow;

    void worksheet_freeze_panes_opt(lxw_worksheet*, uint, ushort, uint, ushort, ubyte) @nogc nothrow;
    /**
 * @brief Split a worksheet into panes.
 *
 * @param worksheet  Pointer to a lxw_worksheet instance to be updated.
 * @param vertical   The position for the vertical split.
 * @param horizontal The position for the horizontal split.
 *
 * The `%worksheet_split_panes()` function can be used to divide a worksheet
 * into horizontal or vertical regions known as panes. This function is
 * different from the `worksheet_freeze_panes()` function in that the splits
 * between the panes will be visible to the user and each pane will have its
 * own scroll bars.
 *
 * The parameters `vertical` and `horizontal` are used to specify the vertical
 * and horizontal position of the split. The units for `vertical` and
 * `horizontal` are the same as those used by Excel to specify row height and
 * column width. However, the vertical and horizontal units are different from
 * each other. Therefore you must specify the `vertical` and `horizontal`
 * parameters in terms of the row heights and column widths that you have set
 * or the default values which are 15 for a row and 8.43 for a column.
 *
 * Examples:
 *
 * @code
 *     worksheet_split_panes(worksheet1, 15, 0);    // First row.
 *     worksheet_split_panes(worksheet2, 0,  8.43); // First column.
 *     worksheet_split_panes(worksheet3, 15, 8.43); // First row and column.
 *
 * @endcode
 *
 */
    void worksheet_split_panes(lxw_worksheet*, double, double) @nogc nothrow;
    /**
 * @brief Split and freeze a worksheet into panes.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The cell row (zero indexed).
 * @param col       The cell column (zero indexed).
 *
 * The `%worksheet_freeze_panes()` function can be used to divide a worksheet
 * into horizontal or vertical regions known as panes and to "freeze" these
 * panes so that the splitter bars are not visible.
 *
 * The parameters `row` and `col` are used to specify the location of the
 * split. It should be noted that the split is specified at the top or left of
 * a cell and that the function uses zero based indexing. Therefore to freeze
 * the first row of a worksheet it is necessary to specify the split at row 2
 * (which is 1 as the zero-based index).
 *
 * You can set one of the `row` and `col` parameters as zero if you do not
 * want either a vertical or horizontal split.
 *
 * Examples:
 *
 * @code
 *     worksheet_freeze_panes(worksheet1, 1, 0); // Freeze the first row.
 *     worksheet_freeze_panes(worksheet2, 0, 1); // Freeze the first column.
 *     worksheet_freeze_panes(worksheet3, 1, 1); // Freeze first row/column.
 *
 * @endcode
 *
 */
    void worksheet_freeze_panes(lxw_worksheet*, uint, ushort) @nogc nothrow;
    /**
 * @brief Set current worksheet as the first visible sheet tab.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * The `worksheet_activate()` function determines which worksheet is initially
 * selected.  However, if there are a large number of worksheets the selected
 * worksheet may not appear on the screen. To avoid this you can select the
 * leftmost visible worksheet tab using `%worksheet_set_first_sheet()`:
 *
 * @code
 *     worksheet_set_first_sheet(worksheet19); // First visible worksheet tab.
 *     worksheet_activate(worksheet20);        // First visible worksheet.
 * @endcode
 *
 * This function is not required very often. The default value is the first
 * worksheet.
 */
    void worksheet_set_first_sheet(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Hide the current worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 *
 * The `%worksheet_hide()` function is used to hide a worksheet:
 *
 * @code
 *     worksheet_hide(worksheet2);
 * @endcode
 *
 * You may wish to hide a worksheet in order to avoid confusing a user with
 * intermediate data or calculations.
 *
 * @image html hide_sheet.png
 *
 * A hidden worksheet can not be activated or selected so this function is
 * mutually exclusive with the `worksheet_activate()` and `worksheet_select()`
 * functions. In addition, since the first worksheet will default to being the
 * active worksheet, you cannot hide the first worksheet without activating
 * another sheet:
 *
 * @code
 *     worksheet_activate(worksheet2);
 *     worksheet_hide(worksheet1);
 * @endcode
 */
    void worksheet_hide(lxw_worksheet*) @nogc nothrow;
    /**
  * @brief Set a worksheet tab as selected.
  *
  * @param worksheet Pointer to a lxw_worksheet instance to be updated.
  *
  * The `%worksheet_select()` function is used to indicate that a worksheet is
  * selected in a multi-sheet workbook:
  *
  * @code
  *     worksheet_activate(worksheet1);
  *     worksheet_select(worksheet2);
  *     worksheet_select(worksheet3);
  *
  * @endcode
  *
  * A selected worksheet has its tab highlighted. Selecting worksheets is a
  * way of grouping them together so that, for example, several worksheets
  * could be printed in one go. A worksheet that has been activated via the
  * `worksheet_activate()` function will also appear as selected.
  *
  */
    void worksheet_select(lxw_worksheet*) @nogc nothrow;
    /**
  * @brief Make a worksheet the active, i.e., visible worksheet.
  *
  * @param worksheet Pointer to a lxw_worksheet instance to be updated.
  *
  * The `%worksheet_activate()` function is used to specify which worksheet is
  * initially visible in a multi-sheet workbook:
  *
  * @code
  *     lxw_worksheet *worksheet1 = workbook_add_worksheet(workbook, NULL);
  *     lxw_worksheet *worksheet2 = workbook_add_worksheet(workbook, NULL);
  *     lxw_worksheet *worksheet3 = workbook_add_worksheet(workbook, NULL);
  *
  *     worksheet_activate(worksheet3);
  * @endcode
  *
  * @image html worksheet_activate.png
  *
  * More than one worksheet can be selected via the `worksheet_select()`
  * function, see below, however only one worksheet can be active.
  *
  * The default active worksheet is the first worksheet.
  *
  */
    void worksheet_activate(lxw_worksheet*) @nogc nothrow;
    /**
 * @brief Add an Excel table to a worksheet.
 *
 * @param worksheet  Pointer to a lxw_worksheet instance to be updated.
 * @param first_row  The first row of the range. (All zero indexed.)
 * @param first_col  The first column of the range.
 * @param last_row   The last row of the range.
 * @param last_col   The last col of the range.
 * @param options    A #lxw_table_options struct to define the table options.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_add_table()` function is used to add a table to a
 * worksheet. Tables in Excel are a way of grouping a range of cells into a
 * single entity that has common formatting or that can be referenced from
 * formulas. Tables can have column headers, autofilters, total rows, column
 * formulas and default formatting.
 *
 * @code
 *     worksheet_add_table(worksheet, 2, 1, 6, 5, NULL);
 * @endcode
 *
 * Output:
 *
 * @image html tables1.png
 *
 * See @ref working_with_tables for more detailed usage information and also
 * @ref tables.c.
 *
 */
    lxw_error worksheet_add_table(lxw_worksheet*, uint, ushort, uint, ushort, lxw_table_options*) @nogc nothrow;
    /**
 * @brief Insert a button object into a worksheet.
 *
 * @param worksheet  Pointer to a lxw_worksheet instance to be updated.
 * @param row        The zero indexed row number.
 * @param col        The zero indexed column number.
 * @param options    A #lxw_button_options object to set the button properties.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_insert_button()` function can be used to insert an Excel
 * form button into a worksheet. This function is generally only useful when
 * used in conjunction with the `workbook_add_vba_project()` function to tie
 * the button to a macro from an embedded VBA project:
 *
 * @code
 *     lxw_button_options options = {.caption = "Press Me",
 *                                   .macro   = "say_hello"};
 *
 *     worksheet_insert_button(worksheet, 2, 1, &options);
 * @endcode
 *
 * @image html macros.png
 *
 * The button properties are set using the lxw_button_options struct.
 *
 * See also @ref working_with_macros
 */
    lxw_error worksheet_insert_button(lxw_worksheet*, uint, ushort, lxw_button_options*) @nogc nothrow;
    /**
 * @brief Add a conditional format to a worksheet range.
 *
 * @param worksheet  Pointer to a lxw_worksheet instance to be updated.
 * @param first_row  The first row of the range. (All zero indexed.)
 * @param first_col  The first column of the range.
 * @param last_row   The last row of the range.
 * @param last_col   The last col of the range.
 * @param conditional_format  A #lxw_conditional_format object to control the
 *                            conditional format.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_conditional_format_cell()` function is used to set a
 * conditional format for a range of cells in a worksheet:
 *
 * @code
 *     conditional_format->type     = LXW_CONDITIONAL_TYPE_CELL;
 *     conditional_format->criteria = LXW_CONDITIONAL_CRITERIA_GREATER_THAN_OR_EQUAL_TO;
 *     conditional_format->value    = 50;
 *     conditional_format->format   = format1;
 *     worksheet_conditional_format_range(worksheet1, RANGE("B3:K12"), conditional_format);
 *
 *     conditional_format->type     = LXW_CONDITIONAL_TYPE_CELL;
 *     conditional_format->criteria = LXW_CONDITIONAL_CRITERIA_LESS_THAN;
 *     conditional_format->value    = 50;
 *     conditional_format->format   = format2;
 *     worksheet_conditional_format_range(worksheet1, RANGE("B3:K12"), conditional_format);
 * @endcode
 *
 * Output:
 *
 * @image html conditional_format1.png
 *
 *
 * The conditional format parameters is specified in #lxw_conditional_format.
 *
 * See @ref working_with_conditional_formatting for full details.
 */
    lxw_error worksheet_conditional_format_range(lxw_worksheet*, uint, ushort, uint, ushort, lxw_conditional_format*) @nogc nothrow;
    /**
 * @brief Add a conditional format to a worksheet cell.
 *
 * @param worksheet           Pointer to a lxw_worksheet instance to be updated.
 * @param row                 The zero indexed row number.
 * @param col                 The zero indexed column number.
 * @param conditional_format  A #lxw_conditional_format object to control the
 *                            conditional format.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_conditional_format_cell()` function is used to set a
 * conditional format for a cell in a worksheet:
 *
 * @code
 *     conditional_format->type     = LXW_CONDITIONAL_TYPE_CELL;
 *     conditional_format->criteria = LXW_CONDITIONAL_CRITERIA_GREATER_THAN_OR_EQUAL_TO;
 *     conditional_format->value    = 50;
 *     conditional_format->format   = format1;
 *     worksheet_conditional_format_cell(worksheet, CELL("A1"), conditional_format);
 * @endcode
 *
 * The conditional format parameters is specified in #lxw_conditional_format.
 *
 * See @ref working_with_conditional_formatting for full details.
 */
    lxw_error worksheet_conditional_format_cell(lxw_worksheet*, uint, ushort, lxw_conditional_format*) @nogc nothrow;
    /**
 * @brief Add a data validation to a range.
 *
 * @param worksheet  Pointer to a lxw_worksheet instance to be updated.
 * @param first_row  The first row of the range. (All zero indexed.)
 * @param first_col  The first column of the range.
 * @param last_row   The last row of the range.
 * @param last_col   The last col of the range.
 * @param validation A #lxw_data_validation object to control the validation.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_data_validation_range()` function is the same as the
 * `%worksheet_data_validation_cell()`, see above,  except the data validation
 * is applied to a range of cells:
 *
 * @code
 *
 *    lxw_data_validation *data_validation = calloc(1, sizeof(lxw_data_validation));
 *
 *    data_validation->validate       = LXW_VALIDATION_TYPE_INTEGER;
 *    data_validation->criteria       = LXW_VALIDATION_CRITERIA_BETWEEN;
 *    data_validation->minimum_number = 1;
 *    data_validation->maximum_number = 10;
 *
 *    worksheet_data_validation_range(worksheet, 2, 1, 4, 1, data_validation);
 *
 *    // Same as above with the RANGE() macro.
 *    worksheet_data_validation_range(worksheet, RANGE("B3:B5"), data_validation);
 *
 * @endcode
 *
 * Data validation and the various options of #lxw_data_validation are
 * described in more detail in @ref working_with_data_validation.
 */
    lxw_error worksheet_data_validation_range(lxw_worksheet*, uint, ushort, uint, ushort, lxw_data_validation*) @nogc nothrow;
    /**
 * @brief Add a data validation to a cell.
 *
 * @param worksheet  Pointer to a lxw_worksheet instance to be updated.
 * @param row        The zero indexed row number.
 * @param col        The zero indexed column number.
 * @param validation A #lxw_data_validation object to control the validation.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_data_validation_cell()` function is used to construct an
 * Excel data validation or to limit the user input to a dropdown list of
 * values:
 *
 * @code
 *
 *    lxw_data_validation *data_validation = calloc(1, sizeof(lxw_data_validation));
 *
 *    data_validation->validate       = LXW_VALIDATION_TYPE_INTEGER;
 *    data_validation->criteria       = LXW_VALIDATION_CRITERIA_BETWEEN;
 *    data_validation->minimum_number = 1;
 *    data_validation->maximum_number = 10;
 *
 *    worksheet_data_validation_cell(worksheet, 2, 1, data_validation);
 *
 *    // Same as above with the CELL() macro.
 *    worksheet_data_validation_cell(worksheet, CELL("B3"), data_validation);
 *
 * @endcode
 *
 * @image html data_validate4.png
 *
 * Data validation and the various options of #lxw_data_validation are
 * described in more detail in @ref working_with_data_validation.
 */
    lxw_error worksheet_data_validation_cell(lxw_worksheet*, uint, ushort, lxw_data_validation*) @nogc nothrow;
    /**
 * @brief Write multiple string filters to an autofilter column.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param col       The column in the autofilter that the rules applies to.
 * @param list      A NULL terminated array of strings to filter on.
 *
 * @return A #lxw_error code.
 *
 * The `worksheet_filter_column_list()` function can be used specify multiple
 * string matching criteria. This is a newer type of filter introduced in
 * Excel 2007. Prior to that it was only possible to have either 1 or 2 filter
 * conditions, such as the ones used by `worksheet_filter_column()` and
 * `worksheet_filter_column2()`.
 *
 * As an example, consider a column that contains data for the months of the
 * year. The `%worksheet_filter_list()` function can be used to filter out
 * data rows for different months:
 *
 * @code
 *     char* list[] = {"March", "April", "May", NULL};
 *
 *     worksheet_filter_list(worksheet, 0, list);
 * @endcode
 *
 * @image html autofilter2.png
 *
 *
 * Note, the array must be NULL terminated to indicate the end of the array of
 * strings. To filter blanks as part of the list use `Blanks` as a list item:
 *
 * @code
 *     char* list[] = {"March", "April", "May", "Blanks", NULL};
 *
 *     worksheet_filter_list(worksheet, 0, list);
 * @endcode
 *
 * It isn't sufficient to just specify the filter condition. You must also
 * hide any rows that don't match the filter condition. See @ref
 * ww_autofilters_data for more details.
 */
    lxw_error worksheet_filter_list(lxw_worksheet*, ushort, char**) @nogc nothrow;
    /**
 * @brief Write two filter rules to an autofilter column.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param col       The column in the autofilter that the rules applies to.
 * @param rule1     First lxw_filter_rule autofilter rule.
 * @param rule2     Second lxw_filter_rule autofilter rule.
 * @param and_or    A #lxw_filter_operator and/or operator.
 *
 * @return A #lxw_error code.
 *
 * The `worksheet_filter_column2` function can be used to filter columns in a autofilter
 * range based on two rule conditions:
 *
 * @code
 *     lxw_filter_rule filter_rule1 = {.criteria     = LXW_FILTER_CRITERIA_EQUAL_TO,
 *                                     .value_string = "East"};
 *
 *     lxw_filter_rule filter_rule2 = {.criteria     = LXW_FILTER_CRITERIA_EQUAL_TO,
 *                                     .value_string = "South"};
 *
 *     worksheet_filter_column2(worksheet, 0, &filter_rule1, &filter_rule2, LXW_FILTER_OR);
 * @endcode
 *
 * @image html autofilter5.png
 *
 * The rules and criteria are explained in more detail in @ref
 * ww_autofilters_criteria in @ref working_with_autofilters.
 *
 * The `col` parameter is a zero indexed column number and must refer to a
 * column in an existing autofilter created with `worksheet_autofilter()`.
 *
 * The `and_or` parameter is either "and (LXW_FILTER_AND)" or "or  (LXW_FILTER_OR)".
 *
 * It isn't sufficient to just specify the filter condition. You must also
 * hide any rows that don't match the filter condition. See @ref
 * ww_autofilters_data for more details.
 */
    lxw_error worksheet_filter_column2(lxw_worksheet*, ushort, lxw_filter_rule*, lxw_filter_rule*, ubyte) @nogc nothrow;
    /**
 * @brief Write a filter rule to an autofilter column.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param col       The column in the autofilter that the rule applies to.
 * @param rule      The lxw_filter_rule autofilter rule.
 *
 * @return A #lxw_error code.
 *
 * The `worksheet_filter_column` function can be used to filter columns in a
 * autofilter range based on single rule conditions:
 *
 * @code
 *     lxw_filter_rule filter_rule = {.criteria     = LXW_FILTER_CRITERIA_EQUAL_TO,
 *                                    .value_string = "East"};
 *
 *    worksheet_filter_column(worksheet, 0, &filter_rule);
 *@endcode
 *
 * @image html autofilter4.png
 *
 * The rules and criteria are explained in more detail in @ref
 * ww_autofilters_criteria in @ref working_with_autofilters.
 *
 * The `col` parameter is a zero indexed column number and must refer to a
 * column in an existing autofilter created with `worksheet_autofilter()`.
 *
 * It isn't sufficient to just specify the filter condition. You must also
 * hide any rows that don't match the filter condition. See @ref
 * ww_autofilters_data for more details.
 */
    lxw_error worksheet_filter_column(lxw_worksheet*, ushort, lxw_filter_rule*) @nogc nothrow;
    /**
 * @brief Set the autofilter area in the worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_row The first row of the range. (All zero indexed.)
 * @param first_col The first column of the range.
 * @param last_row  The last row of the range.
 * @param last_col  The last col of the range.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_autofilter()` function allows an autofilter to be added to
 * a worksheet.
 *
 * An autofilter is a way of adding drop down lists to the headers of a 2D
 * range of worksheet data. This allows users to filter the data based on
 * simple criteria so that some data is shown and some is hidden.
 *
 * @image html autofilter3.png
 *
 * To add an autofilter to a worksheet:
 *
 * @code
 *     worksheet_autofilter(worksheet, 0, 0, 50, 3);
 *
 *     // Same as above using the RANGE() macro.
 *     worksheet_autofilter(worksheet, RANGE("A1:D51"));
 * @endcode
 *
 * In order to apply a filter condition it is necessary to add filter rules to
 * the columns using either the `%worksheet_filter_column()`,
 * `%worksheet_filter_column2()` or `%worksheet_filter_list()` functions:
 *
 * - `worksheet_filter_column()`: filter on a single criterion such as "Column ==
 *   East". More complex conditions such as "<=" or ">=" can also be use.
 *
 * - `worksheet_filter_column2()`: filter on two criteria such as "Column == East
 *   or Column == West". Complex conditions can also be used.
 *
 * - `worksheet_filter_list()`: filter on a list of values such as "Column in (East, West,
 *   North)".
 *
 * These functions are explained below. It isn't sufficient to just specify
 * the filter condition. You must also hide any rows that don't match the
 * filter condition. See @ref ww_autofilters_data for more details.
 *
 */
    lxw_error worksheet_autofilter(lxw_worksheet*, uint, ushort, uint, ushort) @nogc nothrow;
    /**
 * @brief Merge a range of cells.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_row The first row of the range. (All zero indexed.)
 * @param first_col The first column of the range.
 * @param last_row  The last row of the range.
 * @param last_col  The last col of the range.
 * @param string    String to write to the merged range.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_merge_range()` function allows cells to be merged together
 * so that they act as a single area.
 *
 * Excel generally merges and centers cells at same time. To get similar
 * behavior with libxlsxwriter you need to apply a @ref format.h "Format"
 * object with the appropriate alignment:
 *
 * @code
 *     lxw_format *merge_format = workbook_add_format(workbook);
 *     format_set_align(merge_format, LXW_ALIGN_CENTER);
 *
 *     worksheet_merge_range(worksheet, 1, 1, 1, 3, "Merged Range", merge_format);
 *
 * @endcode
 *
 * It is possible to apply other formatting to the merged cells as well:
 *
 * @code
 *    format_set_align   (merge_format, LXW_ALIGN_CENTER);
 *    format_set_align   (merge_format, LXW_ALIGN_VERTICAL_CENTER);
 *    format_set_border  (merge_format, LXW_BORDER_DOUBLE);
 *    format_set_bold    (merge_format);
 *    format_set_bg_color(merge_format, 0xD7E4BC);
 *
 *    worksheet_merge_range(worksheet, 2, 1, 3, 3, "Merged Range", merge_format);
 *
 * @endcode
 *
 * @image html merge.png
 *
 * The `%worksheet_merge_range()` function writes a `char*` string using
 * `worksheet_write_string()`. In order to write other data types, such as a
 * number or a formula, you can overwrite the first cell with a call to one of
 * the other write functions. The same Format should be used as was used in
 * the merged range.
 *
 * @code
 *    // First write a range with a blank string.
 *    worksheet_merge_range (worksheet, 1, 1, 1, 3, "", format);
 *
 *    // Then overwrite the first cell with a number.
 *    worksheet_write_number(worksheet, 1, 1, 123, format);
 * @endcode
 *
 * @note Merged ranges generally don't work in libxlsxwriter when the Workbook
 * #lxw_workbook_options `constant_memory` mode is enabled.
 */
    lxw_error worksheet_merge_range(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    /**
 * @brief Insert a chart object into a worksheet, with options.
 *
 * @param worksheet    Pointer to a lxw_worksheet instance to be updated.
 * @param row          The zero indexed row number.
 * @param col          The zero indexed column number.
 * @param chart        A #lxw_chart object created via workbook_add_chart().
 * @param user_options Optional chart parameters.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_insert_chart_opt()` function is like
 * `worksheet_insert_chart()` function except that it takes an optional
 * #lxw_chart_options struct to scale and position the chart:
 *
 * @code
 *    lxw_chart_options options = {.x_offset = 30,  .y_offset = 10,
 *                                 .x_scale  = 0.5, .y_scale  = 0.75};
 *
 *    worksheet_insert_chart_opt(worksheet, 0, 2, chart, &options);
 *
 * @endcode
 *
 * @image html chart_line_opt.png
 *
 */
    lxw_error worksheet_insert_chart_opt(lxw_worksheet*, uint, ushort, lxw_chart*, lxw_chart_options*) @nogc nothrow;
    /**
 * @brief Insert a chart object into a worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param chart     A #lxw_chart object created via workbook_add_chart().
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_insert_chart()` function can be used to insert a chart into
 * a worksheet. The chart object must be created first using the
 * `workbook_add_chart()` function and configured using the @ref chart.h
 * functions.
 *
 * @code
 *     // Create a chart object.
 *     lxw_chart *chart = workbook_add_chart(workbook, LXW_CHART_LINE);
 *
 *     // Add a data series to the chart.
 *     chart_add_series(chart, NULL, "=Sheet1!$A$1:$A$6");
 *
 *     // Insert the chart into the worksheet.
 *     worksheet_insert_chart(worksheet, 0, 2, chart);
 * @endcode
 *
 * @image html chart_working.png
 *
 * **Note:**
 *
 * A chart may only be inserted into a worksheet once. If several similar
 * charts are required then each one must be created separately with
 * `%worksheet_insert_chart()`.
 *
 */
    lxw_error worksheet_insert_chart(lxw_worksheet*, uint, ushort, lxw_chart*) @nogc nothrow;
    /**
 * @brief Set the background image for a worksheet, from a buffer.
 *
 * @param worksheet    Pointer to a lxw_worksheet instance to be updated.
 * @param image_buffer Pointer to an array of bytes that holds the image data.
 * @param image_size   The size of the array of bytes.
 *
 * @return A #lxw_error code.
 *
 * This function can be used to insert a background image into a worksheet
 * from a memory buffer:
 *
 * @code
 *     worksheet_set_background_buffer(worksheet, image_buffer, image_size);
 * @endcode
 *
 * The buffer should be a pointer to an array of unsigned char data with a
 * specified size.
 *
 * See `worksheet_set_background()` for more details.
 *
 */
    lxw_error worksheet_set_background_buffer(lxw_worksheet*, const(ubyte)*, c_ulong) @nogc nothrow;
    /**
 * @brief Set the background image for a worksheet.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param filename  The image filename, with path if required.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_background()` function can be used to set the
 * background image for a worksheet:
 *
 * @code
 *      worksheet_set_background(worksheet, "logo.png");
 * @endcode
 *
 * @image html background.png
 *
 * The ``set_background()`` method supports all the image formats supported by
 * `worksheet_insert_image()`.
 *
 * Some people use this method to add a watermark background to their
 * document. However, Microsoft recommends using a header image [to set a
 * watermark][watermark]. The choice of method depends on whether you want the
 * watermark to be visible in normal viewing mode or just when the file is
 * printed. In libxlsxwriter you can get the header watermark effect using
 * `worksheet_set_header()`:
 *
 * @code
 *     lxw_header_footer_options header_options = {.image_center = "watermark.png"};
 *     worksheet_set_header_opt(worksheet, "&C&G", &header_options);
 * @endcode
 *
 * [watermark]:https://support.microsoft.com/en-us/office/add-a-watermark-in-excel-a372182a-d733-484e-825c-18ddf3edf009
 *
 */
    lxw_error worksheet_set_background(lxw_worksheet*, const(char)*) @nogc nothrow;
    /**
 * @brief Insert an image in a worksheet cell, from a memory buffer.
 *
 * @param worksheet    Pointer to a lxw_worksheet instance to be updated.
 * @param row          The zero indexed row number.
 * @param col          The zero indexed column number.
 * @param image_buffer Pointer to an array of bytes that holds the image data.
 * @param image_size   The size of the array of bytes.
 * @param options      Optional image parameters.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_insert_image_buffer_opt()` function is like
 * `worksheet_insert_image_buffer()` function except that it takes an optional
 * #lxw_image_options struct  * #lxw_image_options struct with the following members/options:
 *
 * - `x_offset`: Offset from the left of the cell in pixels.
 * - `y_offset`: Offset from the top of the cell in pixels.
 * - `x_scale`: X scale of the image as a decimal.
 * - `y_scale`: Y scale of the image as a decimal.
 * - `object_position`: See @ref working_with_object_positioning.
 * - `description`: Optional description or "Alt text" for the image.
 * - `decorative`: Optional parameter to mark image as decorative.
 * - `url`: Add an optional hyperlink to the image.
 * - `tip`: Add an optional mouseover tip for a hyperlink to the image.
 *
 * For example, to scale and position the image:
 *
 * @code
 *     lxw_image_options options = {.x_offset = 32, .y_offset = 4,
 *                                  .x_scale  = 2,  .y_scale  = 1};
 *
 *     worksheet_insert_image_buffer_opt(worksheet, CELL("B3"), image_buffer, image_size, &options);
 * @endcode
 *
 * @image html image_buffer_opt.png
 *
 * The buffer should be a pointer to an array of unsigned char data with a
 * specified size.
 *
 * See `worksheet_insert_image_buffer_opt()` for details about the supported
 * image formats, and other image options.
 */
    lxw_error worksheet_insert_image_buffer_opt(lxw_worksheet*, uint, ushort, const(ubyte)*, c_ulong, lxw_image_options*) @nogc nothrow;
    /**
 * @brief Insert an image in a worksheet cell, from a memory buffer.
 *
 * @param worksheet    Pointer to a lxw_worksheet instance to be updated.
 * @param row          The zero indexed row number.
 * @param col          The zero indexed column number.
 * @param image_buffer Pointer to an array of bytes that holds the image data.
 * @param image_size   The size of the array of bytes.
 *
 * @return A #lxw_error code.
 *
 * This function can be used to insert a image into a worksheet from a memory
 * buffer:
 *
 * @code
 *     worksheet_insert_image_buffer(worksheet, CELL("B3"), image_buffer, image_size);
 * @endcode
 *
 * @image html image_buffer.png
 *
 * The buffer should be a pointer to an array of unsigned char data with a
 * specified size.
 *
 * See `worksheet_insert_image()` for details about the supported image
 * formats, and other image features.
 */
    lxw_error worksheet_insert_image_buffer(lxw_worksheet*, uint, ushort, const(ubyte)*, c_ulong) @nogc nothrow;
    /**
 * @brief Insert an image in a worksheet cell, with options.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param filename  The image filename, with path if required.
 * @param options   Optional image parameters.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_insert_image_opt()` function is like
 * `worksheet_insert_image()` function except that it takes an optional
 * #lxw_image_options struct with the following members/options:
 *
 * - `x_offset`: Offset from the left of the cell in pixels.
 * - `y_offset`: Offset from the top of the cell in pixels.
 * - `x_scale`: X scale of the image as a decimal.
 * - `y_scale`: Y scale of the image as a decimal.
 * - `object_position`: See @ref working_with_object_positioning.
 * - `description`: Optional description or "Alt text" for the image.
 * - `decorative`: Optional parameter to mark image as decorative.
 * - `url`: Add an optional hyperlink to the image.
 * - `tip`: Add an optional mouseover tip for a hyperlink to the image.
 *
 * For example, to scale and position the image:
 *
 * @code
 *     lxw_image_options options = {.x_offset = 30,  .y_offset = 10,
 *                                 .x_scale  = 0.5, .y_scale  = 0.5};
 *
 *     worksheet_insert_image_opt(worksheet, 2, 1, "logo.png", &options);
 *
 * @endcode
 *
 * @image html insert_image_opt.png
 *
 * The `url` field of lxw_image_options can be use to used to add a hyperlink
 * to an image:
 *
 * @code
 *     lxw_image_options options = {.url = "https://github.com/jmcnamara"};
 *
 *     worksheet_insert_image_opt(worksheet, 3, 1, "logo.png", &options);
 * @endcode
 *
 * The supported URL formats are the same as those supported by the
 * `worksheet_write_url()` method and the same rules/limits apply.
 *
 * The `tip` field of lxw_image_options can be use to used to add a mouseover
 * tip to the hyperlink:
 *
 * @code
 *      lxw_image_options options = {.url = "https://github.com/jmcnamara",
                                     .tip = "GitHub"};
 *
 *     worksheet_insert_image_opt(worksheet, 4, 1, "logo.png", &options);
 * @endcode
 *
 * @note See the notes about row scaling and BMP images in
 * `worksheet_insert_image()` above.
 */
    lxw_error worksheet_insert_image_opt(lxw_worksheet*, uint, ushort, const(char)*, lxw_image_options*) @nogc nothrow;
    /**
 * @brief Insert an image in a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param filename  The image filename, with path if required.
 *
 * @return A #lxw_error code.
 *
 * This function can be used to insert a image into a worksheet. The image can
 * be in PNG, JPEG, GIF or BMP format:
 *
 * @code
 *     worksheet_insert_image(worksheet, 2, 1, "logo.png");
 * @endcode
 *
 * @image html insert_image.png
 *
 * The `worksheet_insert_image_opt()` function takes additional optional
 * parameters to position and scale the image, see below.
 *
 * **Note**:
 * The scaling of a image may be affected if is crosses a row that has its
 * default height changed due to a font that is larger than the default font
 * size or that has text wrapping turned on. To avoid this you should
 * explicitly set the height of the row using `worksheet_set_row()` if it
 * crosses an inserted image. See @ref working_with_object_positioning.
 *
 * BMP images are only supported for backward compatibility. In general it is
 * best to avoid BMP images since they aren't compressed. If used, BMP images
 * must be 24 bit, true color, bitmaps.
 */
    lxw_error worksheet_insert_image(lxw_worksheet*, uint, ushort, const(char)*) @nogc nothrow;
    /**
 * @brief Set the properties for one or more columns of cells with options,
 *        with the width in pixels.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_col The zero indexed first column.
 * @param last_col  The zero indexed last column.
 * @param pixels    The width of the column(s) in pixels.
 * @param format    A pointer to a Format instance or NULL.
 * @param options   Optional row parameters: hidden, level, collapsed.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_column_pixels_opt()` function is the same as the
 * `worksheet_set_column_opt()` function except that the width can be set in
 * pixels.
 *
 */
    lxw_error worksheet_set_column_pixels_opt(lxw_worksheet*, ushort, ushort, uint, lxw_format*, lxw_row_col_options*) @nogc nothrow;
    /**
 * @brief Set the properties for one or more columns of cells, with the width
 *        in pixels.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_col The zero indexed first column.
 * @param last_col  The zero indexed last column.
 * @param pixels    The width of the column(s) in pixels.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_column_pixels()` function is the same as
 * `worksheet_set_column()` function except that the width can be set in
 * pixels:
 *
 * @code
 *     // Column width set to 75 pixels, the same as 10 character units.
 *     worksheet_set_column(worksheet, 5, 5, 75, NULL);
 * @endcode
 *
 * @image html set_column_pixels.png
 *
 * If you wish to set the format of a column without changing the width you can
 * pass the default column width in pixels: #LXW_DEF_COL_WIDTH_PIXELS.
 */
    lxw_error worksheet_set_column_pixels(lxw_worksheet*, ushort, ushort, uint, lxw_format*) @nogc nothrow;
    /**
 * @brief Set the properties for one or more columns of cells with options.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_col The zero indexed first column.
 * @param last_col  The zero indexed last column.
 * @param width     The width of the column(s).
 * @param format    A pointer to a Format instance or NULL.
 * @param options   Optional row parameters: hidden, level, collapsed.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_column_opt()` function  is the same as
 * `worksheet_set_column()` with an additional `options` parameter.
 *
 * The `options` parameter is a #lxw_row_col_options struct. It has the
 * following members:
 *
 * - `hidden`
 * - `level`
 * - `collapsed`
 *
 * The `"hidden"` option is used to hide a column. This can be used, for
 * example, to hide intermediary steps in a complicated calculation:
 *
 * @code
 *     lxw_row_col_options options1 = {.hidden = 1, .level = 0, .collapsed = 0};
 *
 *     worksheet_set_column_opt(worksheet, COLS("D:E"),  LXW_DEF_COL_WIDTH, NULL, &options1);
 * @endcode
 *
 * @image html hide_row_col3.png
 *
 * The `"hidden"`, `"level"`,  and `"collapsed"`, options can also be used to
 * create Outlines and Grouping. See @ref working_with_outlines.
 *
 * @code
 *     lxw_row_col_options options1 = {.hidden = 0, .level = 1, .collapsed = 0};
 *
 *     worksheet_set_column_opt(worksheet, COLS("B:G"),  5, NULL, &options1);
 * @endcode
 *
 * @image html outline8.png
 */
    lxw_error worksheet_set_column_opt(lxw_worksheet*, ushort, ushort, double, lxw_format*, lxw_row_col_options*) @nogc nothrow;
    /**
 * @brief Set the properties for one or more columns of cells.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_col The zero indexed first column.
 * @param last_col  The zero indexed last column.
 * @param width     The width of the column(s).
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_column()` function can be used to change the default
 * properties of a single column or a range of columns:
 *
 * @code
 *     // Width of columns B:D set to 30.
 *     worksheet_set_column(worksheet, 1, 3, 30, NULL);
 *
 * @endcode
 *
 * If `%worksheet_set_column()` is applied to a single column the value of
 * `first_col` and `last_col` should be the same:
 *
 * @code
 *     // Width of column B set to 30.
 *     worksheet_set_column(worksheet, 1, 1, 30, NULL);
 *
 * @endcode
 *
 * It is also possible, and generally clearer, to specify a column range using
 * the form of `COLS()` macro:
 *
 * @code
 *     worksheet_set_column(worksheet, 4, 4, 20, NULL);
 *     worksheet_set_column(worksheet, 5, 8, 30, NULL);
 *
 *     // Same as the examples above but clearer.
 *     worksheet_set_column(worksheet, COLS("E:E"), 20, NULL);
 *     worksheet_set_column(worksheet, COLS("F:H"), 30, NULL);
 *
 * @endcode
 *
 * The `width` parameter sets the column width in the same units used by Excel
 * which is: the number of characters in the default font. The default width
 * is 8.43 in the default font of Calibri 11. The actual relationship between
 * a string width and a column width in Excel is complex. See the
 * [following explanation of column widths](https://support.microsoft.com/en-us/kb/214123)
 * from the Microsoft support documentation for more details. To set the width
 * in pixels use the `worksheet_set_column_pixels()` function.
 *
 * There is no way to specify "AutoFit" for a column in the Excel file
 * format. This feature is only available at runtime from within Excel. It is
 * possible to simulate "AutoFit" in your application by tracking the maximum
 * width of the data in the column as your write it and then adjusting the
 * column width at the end.
 *
 * As usual the @ref format.h `format` parameter is optional. If you wish to
 * set the format without changing the width you can pass a default column
 * width of #LXW_DEF_COL_WIDTH = 8.43:
 *
 * @code
 *     lxw_format *bold = workbook_add_format(workbook);
 *     format_set_bold(bold);
 *
 *     // Set the first column to bold.
 *     worksheet_set_column(worksheet, 0, 0, LXW_DEF_COL_WIDTH, bold);
 * @endcode
 *
 * The `format` parameter will be applied to any cells in the column that
 * don't have a format. For example:
 *
 * @code
 *     // Column 1 has format1.
 *     worksheet_set_column(worksheet, COLS("A:A"), 8.43, format1);
 *
 *     // Cell A1 in column 1 defaults to format1.
 *     worksheet_write_string(worksheet, 0, 0, "Hello", NULL);
 *
 *     // Cell A2 in column 1 keeps format2.
 *     worksheet_write_string(worksheet, 1, 0, "Hello", format2);
 * @endcode
 *
 * As in Excel a row format takes precedence over a default column format:
 *
 * @code
 *     // Row 1 has format1.
 *     worksheet_set_row(worksheet, 0, 15, format1);
 *
 *     // Col 1 has format2.
 *     worksheet_set_column(worksheet, COLS("A:A"), 8.43, format2);
 *
 *     // Cell A1 defaults to format1, the row format.
 *     worksheet_write_string(worksheet, 0, 0, "Hello", NULL);
 *
 *    // Cell A2 keeps format2, the column format.
 *     worksheet_write_string(worksheet, 1, 0, "Hello", NULL);
 * @endcode
 */
    lxw_error worksheet_set_column(lxw_worksheet*, ushort, ushort, double, lxw_format*) @nogc nothrow;
    /**
 * @brief Set the properties for a row of cells, with the height in pixels.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param pixels    The row height in pixels.
 * @param format    A pointer to a Format instance or NULL.
 * @param options   Optional row parameters: hidden, level, collapsed.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_row_pixels_opt()` function is the same as the
 * `worksheet_set_row_opt()` function except that the height can be set in
 * pixels.
 *
 */
    lxw_error worksheet_set_row_pixels_opt(lxw_worksheet*, uint, uint, lxw_format*, lxw_row_col_options*) @nogc nothrow;
    /**
 * @brief Set the properties for a row of cells, with the height in pixels.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param pixels    The row height in pixels.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_row_pixels()` function is the same as the
 * `worksheet_set_row()` function except that the height can be set in pixels
 *
 * @code
 *     // Set the height of Row 1 to 20 pixels.
 *     worksheet_set_row_pixels(worksheet, 0, 20, NULL);
 * @endcode
 *
 * If you wish to set the format of a row without changing the height you can
 * pass the default row height in pixels: #LXW_DEF_ROW_HEIGHT_PIXELS.
 */
    lxw_error worksheet_set_row_pixels(lxw_worksheet*, uint, uint, lxw_format*) @nogc nothrow;
    /**
 * @brief Set the properties for a row of cells.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param height    The row height.
 * @param format    A pointer to a Format instance or NULL.
 * @param options   Optional row parameters: hidden, level, collapsed.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_row_opt()` function  is the same as
 *  `worksheet_set_row()` with an additional `options` parameter.
 *
 * The `options` parameter is a #lxw_row_col_options struct. It has the
 * following members:
 *
 * - `hidden`
 * - `level`
 * - `collapsed`
 *
 * The `"hidden"` option is used to hide a row. This can be used, for
 * example, to hide intermediary steps in a complicated calculation:
 *
 * @code
 *     lxw_row_col_options options1 = {.hidden = 1, .level = 0, .collapsed = 0};
 *
 *     // Hide the fourth and fifth (zero indexed) rows.
 *     worksheet_set_row_opt(worksheet, 3,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 4,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *
 * @endcode
 *
 * @image html hide_row_col2.png
 *
 * The `"hidden"`, `"level"`,  and `"collapsed"`, options can also be used to
 * create Outlines and Grouping. See @ref working_with_outlines.
 *
 * @code
 *     // The option structs with the outline level set.
 *     lxw_row_col_options options1 = {.hidden = 0, .level = 2, .collapsed = 0};
 *     lxw_row_col_options options2 = {.hidden = 0, .level = 1, .collapsed = 0};
 *
 *
 *     // Set the row options with the outline level.
 *     worksheet_set_row_opt(worksheet, 1,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 2,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 3,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 4,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 5,  LXW_DEF_ROW_HEIGHT, NULL, &options2);
 *
 *     worksheet_set_row_opt(worksheet, 6,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 7,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 8,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 9,  LXW_DEF_ROW_HEIGHT, NULL, &options1);
 *     worksheet_set_row_opt(worksheet, 10, LXW_DEF_ROW_HEIGHT, NULL, &options2);
 * @endcode
 *
 * @image html outline1.png
 *
 */
    lxw_error worksheet_set_row_opt(lxw_worksheet*, uint, double, lxw_format*, lxw_row_col_options*) @nogc nothrow;
    /**
 * @brief Set the properties for a row of cells.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param height    The row height, in character units.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_set_row()` function is used to change the default
 * properties of a row. The most common use for this function is to change the
 * height of a row:
 *
 * @code
 *     // Set the height of Row 1 to 20.
 *     worksheet_set_row(worksheet, 0, 20, NULL);
 * @endcode
 *
 * The height is specified in character units. To specify the height in pixels
 * use the `worksheet_set_row_pixels()` function.
 *
 * The other common use for `%worksheet_set_row()` is to set the a @ref
 * format.h "Format" for all cells in the row:
 *
 * @code
 *     lxw_format *bold = workbook_add_format(workbook);
 *     format_set_bold(bold);
 *
 *     // Set the header row to bold.
 *     worksheet_set_row(worksheet, 0, 15, bold);
 * @endcode
 *
 * If you wish to set the format of a row without changing the height you can
 * pass the default row height of #LXW_DEF_ROW_HEIGHT = 15:
 *
 * @code
 *     worksheet_set_row(worksheet, 0, LXW_DEF_ROW_HEIGHT, format);
 *     worksheet_set_row(worksheet, 0, 15, format); // Same as above.
 * @endcode
 *
 * The `format` parameter will be applied to any cells in the row that don't
 * have a format. As with Excel the row format is overridden by an explicit
 * cell format. For example:
 *
 * @code
 *     // Row 1 has format1.
 *     worksheet_set_row(worksheet, 0, 15, format1);
 *
 *     // Cell A1 in Row 1 defaults to format1.
 *     worksheet_write_string(worksheet, 0, 0, "Hello", NULL);
 *
 *     // Cell B1 in Row 1 keeps format2.
 *     worksheet_write_string(worksheet, 0, 1, "Hello", format2);
 * @endcode
 *
 */
    lxw_error worksheet_set_row(lxw_worksheet*, uint, double, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a comment to a worksheet cell with options.
 *
 * @param worksheet   Pointer to a lxw_worksheet instance to be updated.
 * @param row         The zero indexed row number.
 * @param col         The zero indexed column number.
 * @param string      The comment string to be written.
 * @param options     #lxw_comment_options to control position and format
 *                    of the comment.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_comment_opt()` function is used to add a comment to a
 * cell with option that control the position, format and metadata of the
 * comment. A comment is indicated in Excel by a small red triangle in the
 * upper right-hand corner of the cell. Moving the cursor over the red
 * triangle will reveal the comment.
 *
 * The following example shows how to add a comment to a cell with options:
 *
 * @code
 *     lxw_comment_options options = {.visible = LXW_COMMENT_DISPLAY_VISIBLE};
 *
 *     worksheet_write_comment_opt(worksheet, CELL("C6"), "Hello.", &options);
 * @endcode
 *
 * The following options are available in #lxw_comment_options:
 *
 * - `author`
 * - `visible`
 * - `width`
 * - `height`
 * - `x_scale`
 * - `y_scale`
 * - `color`
 * - `font_name`
 * - `font_size`
 * - `start_row`
 * - `start_col`
 * - `x_offset`
 * - `y_offset`
 *
 * @image html comments2.png
 *
 * Comment options are explained in detail in the @ref ww_comments_properties
 * section of the docs.
 */
    lxw_error worksheet_write_comment_opt(lxw_worksheet*, uint, ushort, const(char)*, lxw_comment_options*) @nogc nothrow;
    /**
 * @brief Write a comment to a worksheet cell.
 *
 * @param worksheet   Pointer to a lxw_worksheet instance to be updated.
 * @param row         The zero indexed row number.
 * @param col         The zero indexed column number.
 * @param string      The comment string to be written.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_comment()` function is used to add a comment to a
 * cell. A comment is indicated in Excel by a small red triangle in the upper
 * right-hand corner of the cell. Moving the cursor over the red triangle will
 * reveal the comment.
 *
 * The following example shows how to add a comment to a cell:
 *
 * @code
 *     worksheet_write_comment(worksheet, 0, 0, "This is a comment");
 * @endcode
 *
 * @image html comments1.png
 *
 * See also @ref working_with_comments
 *
 */
    lxw_error worksheet_write_comment(lxw_worksheet*, uint, ushort, const(char)*) @nogc nothrow;
    /**
 * @brief Write a "Rich" multi-format string to a worksheet cell.
 *
 * @param worksheet   Pointer to a lxw_worksheet instance to be updated.
 * @param row         The zero indexed row number.
 * @param col         The zero indexed column number.
 * @param rich_string An array of format/string lxw_rich_string_tuple fragments.
 * @param format      A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_rich_string()` function is used to write strings with
 * multiple formats. For example to write the string 'This is **bold**
 * and this is *italic*' you would use the following:
 *
 * @code
 *     lxw_format *bold = workbook_add_format(workbook);
 *     format_set_bold(bold);
 *
 *     lxw_format *italic = workbook_add_format(workbook);
 *     format_set_italic(italic);
 *
 *     lxw_rich_string_tuple fragment11 = {.format = NULL,   .string = "This is "     };
 *     lxw_rich_string_tuple fragment12 = {.format = bold,   .string = "bold"         };
 *     lxw_rich_string_tuple fragment13 = {.format = NULL,   .string = " and this is "};
 *     lxw_rich_string_tuple fragment14 = {.format = italic, .string = "italic"       };
 *
 *     lxw_rich_string_tuple *rich_string1[] = {&fragment11, &fragment12,
 *                                              &fragment13, &fragment14, NULL};
 *
 *     worksheet_write_rich_string(worksheet, CELL("A1"), rich_string1, NULL);
 *
 * @endcode
 *
 * @image html rich_strings_small.png
 *
 * The basic rule is to break the string into fragments and put a lxw_format
 * object before the fragment that you want to format. So if we look at the
 * above example again:
 *
 * This is **bold** and this is *italic*
 *
 * The would be broken down into 4 fragments:
 *
 *      default: |This is |
 *      bold:    |bold|
 *      default: | and this is |
 *      italic:  |italic|
 *
 * This in then converted to the lxw_rich_string_tuple fragments shown in the
 * example above. For the default format we use `NULL`.
 *
 * The fragments are passed to `%worksheet_write_rich_string()` as a `NULL`
 * terminated array:
 *
 * @code
 *     lxw_rich_string_tuple *rich_string1[] = {&fragment11, &fragment12,
 *                                              &fragment13, &fragment14, NULL};
 *
 *     worksheet_write_rich_string(worksheet, CELL("A1"), rich_string1, NULL);
 *
 * @endcode
 *
 * **Note**:
 * Excel doesn't allow the use of two consecutive formats in a rich string or
 * an empty string fragment. For either of these conditions a warning is
 * raised and the input to `%worksheet_write_rich_string()` is ignored.
 *
 */
    lxw_error worksheet_write_rich_string(lxw_worksheet*, uint, ushort, lxw_rich_string_tuple**, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a formula to a worksheet cell with a user defined string
 *        result.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param formula   Formula string to write to cell.
 * @param format    A pointer to a Format instance or NULL.
 * @param result    A user defined string result for the formula.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_formula_str()` function writes a formula or Excel
 * function to the cell specified by `row` and `column` with a user defined
 * string result:
 *
 * @code
 *     // The example formula is A & B -> AB.
 *     worksheet_write_formula_str(worksheet, 0, 0, "=\"A\" & \"B\"", NULL, "AB");
 * @endcode
 *
 * The `%worksheet_write_formula_str()` function is similar to the
 * `%worksheet_write_formula_num()` function except it writes a string result
 * instead or a numeric result. See `worksheet_write_formula_num()`  for more
 * details on why/when these functions are required.
 *
 * One place where the `%worksheet_write_formula_str()` function may be required
 * is to specify an empty result which will force a recalculation of the formula
 * when loaded in LibreOffice.
 *
 * @code
 *     worksheet_write_formula_str(worksheet, 0, 0, "=Sheet1!$A$1", NULL, "");
 * @endcode
 *
 * See the FAQ @ref faq_formula_zero.
 *
 * See also @ref working_with_formulas.
 */
    lxw_error worksheet_write_formula_str(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*, const(char)*) @nogc nothrow;
    /**
 * @brief Write a formula to a worksheet cell with a user defined numeric
 *        result.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param formula   Formula string to write to cell.
 * @param format    A pointer to a Format instance or NULL.
 * @param result    A user defined numeric result for the formula.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_formula_num()` function writes a formula or Excel
 * function to the cell specified by `row` and `column` with a user defined
 * numeric result:
 *
 * @code
 *     // Required as a workaround only.
 *     worksheet_write_formula_num(worksheet, 0, 0, "=1 + 2", NULL, 3);
 * @endcode
 *
 * Libxlsxwriter doesn't calculate the value of a formula and instead stores
 * the value `0` as the formula result. It then sets a global flag in the XLSX
 * file to say that all formulas and functions should be recalculated when the
 * file is opened.
 *
 * This is the method recommended in the Excel documentation and in general it
 * works fine with spreadsheet applications.
 *
 * However, applications that don't have a facility to calculate formulas,
 * such as Excel Viewer, or some mobile applications will only display the `0`
 * results.
 *
 * If required, the `%worksheet_write_formula_num()` function can be used to
 * specify a formula and its result.
 *
 * This function is rarely required and is only provided for compatibility
 * with some third party applications. For most applications the
 * worksheet_write_formula() function is the recommended way of writing
 * formulas.
 *
 * See also @ref working_with_formulas.
 */
    lxw_error worksheet_write_formula_num(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*, double) @nogc nothrow;
    /**
 * @brief Write a formatted blank worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * Write a blank cell specified by `row` and `column`:
 *
 * @code
 *     worksheet_write_blank(worksheet, 1, 1, border_format);
 * @endcode
 *
 * This function is used to add formatting to a cell which doesn't contain a
 * string or number value.
 *
 * Excel differentiates between an "Empty" cell and a "Blank" cell. An Empty
 * cell is a cell which doesn't contain data or formatting whilst a Blank cell
 * doesn't contain data but does contain formatting. Excel stores Blank cells
 * but ignores Empty cells.
 *
 * As such, if you write an empty cell without formatting it is ignored.
 *
 */
    lxw_error worksheet_write_blank(lxw_worksheet*, uint, ushort, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a formatted boolean worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param value     The boolean value to write to the cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * Write an Excel boolean to the cell specified by `row` and `column`:
 *
 * @code
 *     worksheet_write_boolean(worksheet, 2, 2, 0, my_format);
 * @endcode
 *
 */
    lxw_error worksheet_write_boolean(lxw_worksheet*, uint, ushort, int, lxw_format*) @nogc nothrow;

    lxw_error worksheet_write_url_opt(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*, const(char)*, const(char)*) @nogc nothrow;
    /**
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param url       The url to write to the cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 *
 * The `%worksheet_write_url()` function is used to write a URL/hyperlink to a
 * worksheet cell specified by `row` and `column`.
 *
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "http://libxlsxwriter.github.io", NULL);
 * @endcode
 *
 * @image html hyperlinks_short.png
 *
 * The `format` parameter is used to apply formatting to the cell. This
 * parameter can be `NULL`, in which case the default Excel blue underlined
 * hyperlink style will be used. If required a user defined @ref format.h
 * "Format" object can be used:
 * underline:
 *
 * @code
 *    lxw_format *url_format   = workbook_add_format(workbook);
 *
 *    format_set_underline (url_format, LXW_UNDERLINE_SINGLE);
 *    format_set_font_color(url_format, LXW_COLOR_RED);
 *
 * @endcode
 *
 * The usual web style URI's are supported: `%http://`, `%https://`, `%ftp://`
 * and `mailto:` :
 *
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "ftp://www.python.org/",     NULL);
 *     worksheet_write_url(worksheet, 1, 0, "http://www.python.org/",    NULL);
 *     worksheet_write_url(worksheet, 2, 0, "https://www.python.org/",   NULL);
 *     worksheet_write_url(worksheet, 3, 0, "mailto:jmcnamara@cpan.org", NULL);
 *
 * @endcode
 *
 * An Excel hyperlink is comprised of two elements: the displayed string and
 * the non-displayed link. By default the displayed string is the same as the
 * link. However, it is possible to overwrite it with any other
 * `libxlsxwriter` type using the appropriate `worksheet_write_*()`
 * function. The most common case is to overwrite the displayed link text with
 * another string. To do this we must also match the default URL format using
 * `workbook_get_default_url_format()`:
 *
 * @code
 *     // Write a hyperlink with the default blue underline format.
 *     worksheet_write_url(worksheet, 2, 0, "http://libxlsxwriter.github.io", NULL);
 *
 *     // Get the default url format.
 *     lxw_format *url_format = workbook_get_default_url_format(workbook);
 *
 *     // Overwrite the hyperlink with a user defined string and default format.
 *     worksheet_write_string(worksheet, 2, 0, "Read the documentation.", url_format);
 * @endcode
 *
 * @image html hyperlinks_short2.png
 *
 * Two local URIs are supported: `internal:` and `external:`. These are used
 * for hyperlinks to internal worksheet references or external workbook and
 * worksheet references:
 *
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "internal:Sheet2!A1",                NULL);
 *     worksheet_write_url(worksheet, 1, 0, "internal:Sheet2!B2",                NULL);
 *     worksheet_write_url(worksheet, 2, 0, "internal:Sheet2!A1:B2",             NULL);
 *     worksheet_write_url(worksheet, 3, 0, "internal:'Sales Data'!A1",          NULL);
 *     worksheet_write_url(worksheet, 4, 0, "external:c:\\temp\\foo.xlsx",       NULL);
 *     worksheet_write_url(worksheet, 5, 0, "external:c:\\foo.xlsx#Sheet2!A1",   NULL);
 *     worksheet_write_url(worksheet, 6, 0, "external:..\\foo.xlsx",             NULL);
 *     worksheet_write_url(worksheet, 7, 0, "external:..\\foo.xlsx#Sheet2!A1",   NULL);
 *     worksheet_write_url(worksheet, 8, 0, "external:\\\\NET\\share\\foo.xlsx", NULL);
 *
 * @endcode
 *
 * Worksheet references are typically of the form `Sheet1!A1`. You can also
 * link to a worksheet range using the standard Excel notation:
 * `Sheet1!A1:B2`.
 *
 * In external links the workbook and worksheet name must be separated by the
 * `#` character:
 *
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "external:c:\\foo.xlsx#Sheet2!A1",   NULL);
 * @endcode
 *
 * You can also link to a named range in the target worksheet: For example say
 * you have a named range called `my_name` in the workbook `c:\temp\foo.xlsx`
 * you could link to it as follows:
 *
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "external:c:\\temp\\foo.xlsx#my_name", NULL);
 *
 * @endcode
 *
 * Excel requires that worksheet names containing spaces or non alphanumeric
 * characters are single quoted as follows:
 *
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "internal:'Sales Data'!A1", NULL);
 * @endcode
 *
 * Links to network files are also supported. Network files normally begin
 * with two back slashes as follows `\\NETWORK\etc`. In order to represent
 * this in a C string literal the backslashes should be escaped:
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "external:\\\\NET\\share\\foo.xlsx", NULL);
 * @endcode
 *
 *
 * Alternatively, you can use Unix style forward slashes. These are
 * translated internally to backslashes:
 *
 * @code
 *     worksheet_write_url(worksheet, 0, 0, "external:c:/temp/foo.xlsx",     NULL);
 *     worksheet_write_url(worksheet, 1, 0, "external://NET/share/foo.xlsx", NULL);
 *
 * @endcode
 *
 *
 * **Note:**
 *
 *    libxlsxwriter will escape the following characters in URLs as required
 *    by Excel: `\s " < > \ [ ]  ^ { }`. Existing URL `%%xx` style escapes in
 *    the string are ignored to allow for user-escaped strings.
 *
 * **Note:**
 *
 *    The maximum allowable URL length in recent versions of Excel is 2079
 *    characters. In older versions of Excel (and libxlsxwriter <= 0.8.8) the
 *    limit was 255 characters.
 */
    lxw_error worksheet_write_url(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a Unix datetime to a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param unixtime  The Unix datetime to write to the cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_unixtime()` function can be used to write dates and
 * times in Unix date format to the cell specified by `row` and
 * `column`. [Unix Time](https://en.wikipedia.org/wiki/Unix_time) which is a
 * common integer time format. It is defined as the number of seconds since
 * the Unix epoch (1970-01-01 00:00 UTC). Negative values can also be used for
 * dates prior to 1970:
 *
 * @dontinclude dates_and_times03.c
 * @skip 1970
 * @until 2208988800
 *
 * The `format` parameter should be used to apply formatting to the cell using
 * a @ref format.h "Format" object as shown above. Without a date format the
 * datetime will appear as a number only.
 *
 * The output from this code sample is:
 *
 * @image html date_example03.png
 *
 * Unixtime is generally represented with a 32 bit `time_t` type which has a
 * range of approximately 1900-12-14 to 2038-01-19. To access the full Excel
 * date range of 1900-01-01 to 9999-12-31 this function uses a 64 bit
 * parameter.
 *
 * See @ref working_with_dates for more information about handling dates and
 * times in libxlsxwriter.
 */
    lxw_error worksheet_write_unixtime(lxw_worksheet*, uint, ushort, c_long, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a date or time to a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param datetime  The datetime to write to the cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_datetime()` function can be used to write a date or
 * time to the cell specified by `row` and `column`:
 *
 * @dontinclude dates_and_times02.c
 * @skip include
 * @until num_format
 * @skip Feb
 * @until }
 *
 * The `format` parameter should be used to apply formatting to the cell using
 * a @ref format.h "Format" object as shown above. Without a date format the
 * datetime will appear as a number only.
 *
 * See @ref working_with_dates for more information about handling dates and
 * times in libxlsxwriter.
 */
    lxw_error worksheet_write_datetime(lxw_worksheet*, uint, ushort, lxw_datetime*, lxw_format*) @nogc nothrow;

    lxw_error worksheet_write_dynamic_formula_num(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*, double) @nogc nothrow;

    lxw_error worksheet_write_dynamic_array_formula_num(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*, double) @nogc nothrow;

    lxw_error worksheet_write_array_formula_num(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*, double) @nogc nothrow;
    /**
 * @brief Write an Excel 365 dynamic array formula to a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param formula   Formula string to write to cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_dynamic_formula()` function is similar to the
 * `worksheet_write_dynamic_array_formula()` function, shown above, except
 * that it writes a dynamic array formula to a single cell, rather than a
 * range. This is a syntactic shortcut since the array range isn't generally
 * known for a dynamic range and specifying the initial cell is sufficient for
 * Excel, as shown in the example below:
 *
 * @code
 *     worksheet_write_dynamic_formula(worksheet, 7, 1,
 *                                     "=_xlfn._xlws.SORT(_xlfn.UNIQUE(B2:B17))",
 *                                     NULL);
 * @endcode
 *
 * This formula gives the following result:
 *
 * @image html dynamic_arrays01.png
 *
 * The need for the `_xlfn.` and `_xlfn._xlws.` prefixes in the formula is
 * explained in @ref ww_formulas_future.
 */
    lxw_error worksheet_write_dynamic_formula(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    /**
 * @brief Write an Excel 365 dynamic array formula to a worksheet range.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_row The first row of the range. (All zero indexed.)
 * @param first_col The first column of the range.
 * @param last_row  The last row of the range.
 * @param last_col  The last col of the range.
 * @param formula   Dynamic Array formula to write to cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 *
 * The `%worksheet_write_dynamic_array_formula()` function writes an Excel 365
 * dynamic array formula to a cell range. Some examples of functions that
 * return dynamic arrays are:
 *
 * - `FILTER`
 * - `RANDARRAY`
 * - `SEQUENCE`
 * - `SORTBY`
 * - `SORT`
 * - `UNIQUE`
 * - `XLOOKUP`
 * - `XMATCH`
 *
 * Dynamic array formulas and their usage in libxlsxwriter is explained in
 * detail @ref ww_formulas_dynamic_arrays. The following is a example usage:
 *
 * @code
 *     worksheet_write_dynamic_array_formula(worksheet, 1, 5, 1, 5,
 *                                           "=_xlfn._xlws.FILTER(A1:D17,C1:C17=K2)",
 *                                           NULL);
 * @endcode
 *
 * This formula gives the results shown in the image below.
 *
 * @image html dynamic_arrays02.png
 *
 * The need for the `_xlfn._xlws.` prefix in the formula is explained in @ref
 * ww_formulas_future.
 */
    lxw_error worksheet_write_dynamic_array_formula(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    /**
 * @brief Write an array formula to a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param first_row The first row of the range. (All zero indexed.)
 * @param first_col The first column of the range.
 * @param last_row  The last row of the range.
 * @param last_col  The last col of the range.
 * @param formula   Array formula to write to cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_array_formula()` function writes an array formula to
 * a cell range. In Excel an array formula is a formula that performs a
 * calculation on a set of values.
 *
 * In Excel an array formula is indicated by a pair of braces around the
 * formula: `{=SUM(A1:B1*A2:B2)}`.
 *
 * Array formulas can return a single value or a range or values. For array
 * formulas that return a range of values you must specify the range that the
 * return values will be written to. This is why this function has `first_`
 * and `last_` row/column parameters. The RANGE() macro can also be used to
 * specify the range:
 *
 * @code
 *     worksheet_write_array_formula(worksheet, 4, 0, 6, 0,     "{=TREND(C5:C7,B5:B7)}", NULL);
 *
 *     // Same as above using the RANGE() macro.
 *     worksheet_write_array_formula(worksheet, RANGE("A5:A7"), "{=TREND(C5:C7,B5:B7)}", NULL);
 * @endcode
 *
 * If the array formula returns a single value then the `first_` and `last_`
 * parameters should be the same:
 *
 * @code
 *     worksheet_write_array_formula(worksheet, 1, 0, 1, 0,     "{=SUM(B1:C1*B2:C2)}", NULL);
 *     worksheet_write_array_formula(worksheet, RANGE("A2:A2"), "{=SUM(B1:C1*B2:C2)}", NULL);
 * @endcode
 *
 */
    lxw_error worksheet_write_array_formula(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a formula to a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param formula   Formula string to write to cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_formula()` function writes a formula or function to
 * the cell specified by `row` and `column`:
 *
 * @code
 *  worksheet_write_formula(worksheet, 0, 0, "=B3 + 6",                    NULL);
 *  worksheet_write_formula(worksheet, 1, 0, "=SIN(PI()/4)",               NULL);
 *  worksheet_write_formula(worksheet, 2, 0, "=SUM(A1:A2)",                NULL);
 *  worksheet_write_formula(worksheet, 3, 0, "=IF(A3>1,\"Yes\", \"No\")",  NULL);
 *  worksheet_write_formula(worksheet, 4, 0, "=AVERAGE(1, 2, 3, 4)",       NULL);
 *  worksheet_write_formula(worksheet, 5, 0, "=DATEVALUE(\"1-Jan-2013\")", NULL);
 * @endcode
 *
 * @image html write_formula01.png
 *
 * The `format` parameter is used to apply formatting to the cell. This
 * parameter can be `NULL` to indicate no formatting or it can be a
 * @ref format.h "Format" object.
 *
 * Libxlsxwriter doesn't calculate the value of a formula and instead stores a
 * default value of `0`. The correct formula result is displayed in Excel, as
 * shown in the example above, since it recalculates the formulas when it loads
 * the file. For cases where this is an issue see the
 * `worksheet_write_formula_num()` function and the discussion in that section.
 *
 * Formulas must be written with the US style separator/range operator which
 * is a comma (not semi-colon). Therefore a formula with multiple values
 * should be written as follows:
 *
 * @code
 *     // OK.
 *     worksheet_write_formula(worksheet, 0, 0, "=SUM(1, 2, 3)", NULL);
 *
 *     // NO. Error on load.
 *     worksheet_write_formula(worksheet, 1, 0, "=SUM(1; 2; 3)", NULL);
 * @endcode
 *
 * See also @ref working_with_formulas.
 */
    lxw_error worksheet_write_formula(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a string to a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param string    String to write to cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `%worksheet_write_string()` function writes a string to the cell
 * specified by `row` and `column`:
 *
 * @code
 *     worksheet_write_string(worksheet, 0, 0, "This phrase is English!", NULL);
 * @endcode
 *
 * @image html write_string01.png
 *
 * The `format` parameter is used to apply formatting to the cell. This
 * parameter can be `NULL` to indicate no formatting or it can be a
 * @ref format.h "Format" object:
 *
 * @code
 *     lxw_format *format = workbook_add_format(workbook);
 *     format_set_bold(format);
 *
 *     worksheet_write_string(worksheet, 0, 0, "This phrase is Bold!", format);
 * @endcode
 *
 * @image html write_string02.png
 *
 * Unicode strings are supported in UTF-8 encoding. This generally requires
 * that your source file is UTF-8 encoded or that the data has been read from
 * a UTF-8 source:
 *
 * @code
 *    worksheet_write_string(worksheet, 0, 0, "Это фраза на русском!", NULL);
 * @endcode
 *
 * @image html write_string03.png
 *
 */
    lxw_error worksheet_write_string(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    /**
 * @brief Write a number to a worksheet cell.
 *
 * @param worksheet Pointer to a lxw_worksheet instance to be updated.
 * @param row       The zero indexed row number.
 * @param col       The zero indexed column number.
 * @param number    The number to write to the cell.
 * @param format    A pointer to a Format instance or NULL.
 *
 * @return A #lxw_error code.
 *
 * The `worksheet_write_number()` function writes numeric types to the cell
 * specified by `row` and `column`:
 *
 * @code
 *     worksheet_write_number(worksheet, 0, 0, 123456, NULL);
 *     worksheet_write_number(worksheet, 1, 0, 2.3451, NULL);
 * @endcode
 *
 * @image html write_number01.png
 *
 * The native data type for all numbers in Excel is a IEEE-754 64-bit
 * double-precision floating point, which is also the default type used by
 * `%worksheet_write_number`.
 *
 * The `format` parameter is used to apply formatting to the cell. This
 * parameter can be `NULL` to indicate no formatting or it can be a
 * @ref format.h "Format" object.
 *
 * @code
 *     lxw_format *format = workbook_add_format(workbook);
 *     format_set_num_format(format, "$#,##0.00");
 *
 *     worksheet_write_number(worksheet, 0, 0, 1234.567, format);
 * @endcode
 *
 * @image html write_number02.png
 *
 * @note Excel doesn't support `NaN`, `Inf` or `-Inf` as a number value. If
 * you are writing data that contains these values then your application
 * should convert them to a string or handle them in some other way.
 *
 */
    lxw_error worksheet_write_number(lxw_worksheet*, uint, ushort, double, lxw_format*) @nogc nothrow;

    struct lxw_worksheet_init_data
    {

        ushort index;

        ubyte hidden;

        ubyte optimize;

        ushort* active_sheet;

        ushort* first_sheet;

        lxw_sst* sst;

        char* name;

        char* quoted_name;

        char* tmpdir;

        lxw_format* default_url_format;

        ushort max_url_length;
    }
    /**
 * @brief Struct to represent an Excel worksheet.
 *
 * The members of the lxw_worksheet struct aren't modified directly. Instead
 * the worksheet properties are set by calling the functions shown in
 * worksheet.h.
 */
    struct lxw_worksheet
    {

        _IO_FILE* file;

        _IO_FILE* optimize_tmpfile;

        char* optimize_buffer;

        c_ulong optimize_buffer_size;

        lxw_table_rows* table;

        lxw_table_rows* hyperlinks;

        lxw_table_rows* comments;

        lxw_cell** array;

        lxw_merged_ranges* merged_ranges;

        lxw_selections* selections;

        lxw_data_validations* data_validations;

        lxw_cond_format_hash* conditional_formats;

        lxw_image_props* image_props;

        lxw_chart_props* chart_data;

        lxw_drawing_rel_ids* drawing_rel_ids;

        lxw_vml_drawing_rel_ids* vml_drawing_rel_ids;

        lxw_comment_objs* comment_objs;

        lxw_comment_objs* header_image_objs;

        lxw_comment_objs* button_objs;

        lxw_table_objs* table_objs;

        ushort table_count;

        uint dim_rowmin;

        uint dim_rowmax;

        ushort dim_colmin;

        ushort dim_colmax;

        lxw_sst* sst;

        char* name;

        char* quoted_name;

        char* tmpdir;

        ushort index;

        ubyte active;

        ubyte selected;

        ubyte hidden;

        ushort* active_sheet;

        ushort* first_sheet;

        ubyte is_chartsheet;

        lxw_col_options** col_options;

        ushort col_options_max;

        double* col_sizes;

        ushort col_sizes_max;

        lxw_format** col_formats;

        ushort col_formats_max;

        ubyte col_size_changed;

        ubyte row_size_changed;

        ubyte optimize;

        lxw_row* optimize_row;

        ushort fit_height;

        ushort fit_width;

        ushort horizontal_dpi;

        ushort hlink_count;

        ushort page_start;

        ushort print_scale;

        ushort rel_count;

        ushort vertical_dpi;

        ushort zoom;

        ubyte filter_on;

        ubyte fit_page;

        ubyte hcenter;

        ubyte orientation;

        ubyte outline_changed;

        ubyte outline_on;

        ubyte outline_style;

        ubyte outline_below;

        ubyte outline_right;

        ubyte page_order;

        ubyte page_setup_changed;

        ubyte page_view;

        ubyte paper_size;

        ubyte print_gridlines;

        ubyte print_headers;

        ubyte print_options_changed;

        ubyte right_to_left;

        ubyte screen_gridlines;

        ubyte show_zeros;

        ubyte vcenter;

        ubyte zoom_scale_normal;

        ubyte black_white;

        ubyte num_validations;

        ubyte has_dynamic_arrays;

        char* vba_codename;

        ushort num_buttons;

        uint tab_color;

        double margin_left;

        double margin_right;

        double margin_top;

        double margin_bottom;

        double margin_header;

        double margin_footer;

        double default_row_height;

        uint default_row_pixels;

        uint default_col_pixels;

        ubyte default_row_zeroed;

        ubyte default_row_set;

        ubyte outline_row_level;

        ubyte outline_col_level;

        ubyte header_footer_changed;

        char* header;

        char* footer;

        lxw_repeat_rows repeat_rows;

        lxw_repeat_cols repeat_cols;

        lxw_print_area print_area;

        lxw_autofilter autofilter;

        ushort merged_range_count;

        ushort max_url_length;

        uint* hbreaks;

        ushort* vbreaks;

        ushort hbreaks_count;

        ushort vbreaks_count;

        uint drawing_rel_id;

        uint vml_drawing_rel_id;

        lxw_rel_tuples* external_hyperlinks;

        lxw_rel_tuples* external_drawing_links;

        lxw_rel_tuples* drawing_links;

        lxw_rel_tuples* vml_drawing_links;

        lxw_rel_tuples* external_table_links;

        lxw_panes panes;

        char[14] top_left_cell;

        lxw_protection_obj protection;

        lxw_drawing* drawing;

        lxw_format* default_url_format;

        ubyte has_vml;

        ubyte has_comments;

        ubyte has_header_vml;

        ubyte has_background_image;

        ubyte has_buttons;

        lxw_rel_tuple* external_vml_comment_link;

        lxw_rel_tuple* external_comment_link;

        lxw_rel_tuple* external_vml_header_link;

        lxw_rel_tuple* external_background_link;

        char* comment_author;

        char* vml_data_id_str;

        char* vml_header_id_str;

        uint vml_shape_id;

        uint vml_header_id;

        uint dxf_priority;

        ubyte comment_display_default;

        uint data_bar_2010_index;

        ubyte has_ignore_errors;

        char* ignore_number_stored_as_text;

        char* ignore_eval_error;

        char* ignore_formula_differs;

        char* ignore_formula_range;

        char* ignore_formula_unlocked;

        char* ignore_empty_cell_reference;

        char* ignore_list_data_validation;

        char* ignore_calculated_column;

        char* ignore_two_digit_text_year;

        ushort excel_version;

        lxw_object_properties**[6] header_footer_objs;

        lxw_object_properties* header_left_object_props;

        lxw_object_properties* header_center_object_props;

        lxw_object_properties* header_right_object_props;

        lxw_object_properties* footer_left_object_props;

        lxw_object_properties* footer_center_object_props;

        lxw_object_properties* footer_right_object_props;

        lxw_object_properties* background_image;

        lxw_filter_rule_obj** filter_rules;

        ushort num_filter_rules;

        static struct _Anonymous_1
        {

            lxw_worksheet* stqe_next;
        }

        _Anonymous_1 list_pointers;
    }
    /**
 * @brief Struct to represent a rich string format/string pair.
 *
 * Arrays of this struct are used to define "rich" multi-format strings that
 * are passed to `worksheet_write_rich_string()`. Each struct represents a
 * fragment of the rich multi-format string with a lxw_format to define the
 * format for the string part. If the string fragment is unformatted then
 * `NULL` can be used for the format.
 */
    struct lxw_rich_string_tuple
    {
        /** The format for a string fragment in a rich string. NULL if the string
     *  isn't formatted. */
        lxw_format* format;
        /** The string fragment. */
        char* string_;
    }

    struct lxw_protection_obj
    {

        ubyte no_select_locked_cells;

        ubyte no_select_unlocked_cells;

        ubyte format_cells;

        ubyte format_columns;

        ubyte format_rows;

        ubyte insert_columns;

        ubyte insert_rows;

        ubyte insert_hyperlinks;

        ubyte delete_columns;

        ubyte delete_rows;

        ubyte sort;

        ubyte autofilter;

        ubyte pivot_tables;

        ubyte scenarios;

        ubyte objects;

        ubyte no_content;

        ubyte no_objects;

        ubyte no_sheet;

        ubyte is_configured;

        char[5] hash;
    }
    /**
 * @brief Worksheet protection options.
 */
    struct lxw_protection
    {
        /** Turn off selection of locked cells. This in on in Excel by default.*/
        ubyte no_select_locked_cells;
        /** Turn off selection of unlocked cells. This in on in Excel by default.*/
        ubyte no_select_unlocked_cells;
        /** Prevent formatting of cells. */
        ubyte format_cells;
        /** Prevent formatting of columns. */
        ubyte format_columns;
        /** Prevent formatting of rows. */
        ubyte format_rows;
        /** Prevent insertion of columns. */
        ubyte insert_columns;
        /** Prevent insertion of rows. */
        ubyte insert_rows;
        /** Prevent insertion of hyperlinks. */
        ubyte insert_hyperlinks;
        /** Prevent deletion of columns. */
        ubyte delete_columns;
        /** Prevent deletion of rows. */
        ubyte delete_rows;
        /** Prevent sorting data. */
        ubyte sort;
        /** Prevent filtering data. */
        ubyte autofilter;
        /** Prevent insertion of pivot tables. */
        ubyte pivot_tables;
        /** Protect scenarios. */
        ubyte scenarios;
        /** Protect drawing objects. Worksheets only. */
        ubyte objects;
        /** Turn off chartsheet content protection. */
        ubyte no_content;
        /** Turn off chartsheet objects. */
        ubyte no_objects;
    }
    /**
 * @brief Header and footer options.
 *
 * Optional parameters used in the `worksheet_set_header_opt()` and
 * worksheet_set_footer_opt() functions.
 *
 */
    struct lxw_header_footer_options
    {
        /** Header or footer margin in inches. Excel default is 0.3. Must by
     *  larger than 0.0.  See `worksheet_set_header_opt()`. */
        double margin;
        /** The left header image filename, with path if required. This should
     * have a corresponding `&G/&[Picture]` placeholder in the `&L` section of
     * the header/footer string. See `worksheet_set_header_opt()`. */
        char* image_left;
        /** The center header image filename, with path if required. This should
     * have a corresponding `&G/&[Picture]` placeholder in the `&C` section of
     * the header/footer string. See `worksheet_set_header_opt()`. */
        char* image_center;
        /** The right header image filename, with path if required. This should
     * have a corresponding `&G/&[Picture]` placeholder in the `&R` section of
     * the header/footer string. See `worksheet_set_header_opt()`. */
        char* image_right;
    }
    /**
 * @brief Options for inserted buttons.
 *
 * Options for modifying buttons inserted via `worksheet_insert_button()`.
 *
 */
    struct lxw_button_options
    {
        /** Sets the caption on the button. The default is "Button n" where n is
     *  the current number of buttons in the worksheet, including this
     *  button. */
        char* caption;
        /** Name of the macro to run when the button is pressed. The macro must be
     *  included with workbook_add_vba_project(). */
        char* macro_;
        /** Optional description or "Alt text" for the button. This field can be
     *  used to provide a text description of the button to help
     *  accessibility. Set to NULL to ignore the description field. */
        char* description;
        /** This option is used to set the width of the cell button box
     *  explicitly in pixels. The default width is 64 pixels. */
        ushort width;
        /** This option is used to set the height of the cell button box
     *  explicitly in pixels. The default height is 20 pixels. */
        ushort height;
        /** X scale of the button as a decimal. */
        double x_scale;
        /** Y scale of the button as a decimal. */
        double y_scale;
        /** Offset from the left of the cell in pixels.  */
        int x_offset;
        /** Offset from the top of the cell in pixels. */
        int y_offset;
    }
    /**
 * @brief Options for inserted comments.
 *
 * Options for modifying comments inserted via `worksheet_write_comment_opt()`.
 *
 */
    struct lxw_comment_options
    {
        /** This option is used to make a cell comment visible when the worksheet
     *  is opened. The default behavior in Excel is that comments are
     *  initially hidden. However, it is also possible in Excel to make
     *  individual comments or all comments visible.  You can make all
     *  comments in the worksheet visible using the
     *  `worksheet_show_comments()` function. Defaults to
     *  LXW_COMMENT_DISPLAY_DEFAULT. See also @ref ww_comments_visible. */
        ubyte visible;
        /** This option is used to indicate the author of the cell comment. Excel
     *  displays the author in the status bar at the bottom of the
     *  worksheet. The default author for all cell comments in a worksheet can
     *  be set using the `worksheet_set_comments_author()` function. Set to
     *  NULL if not required.  See also @ref ww_comments_author. */
        char* author;
        /** This option is used to set the width of the cell comment box
     *  explicitly in pixels. The default width is 128 pixels. See also @ref
     *  ww_comments_width. */
        ushort width;
        /** This option is used to set the height of the cell comment box
     *  explicitly in pixels. The default height is 74 pixels.  See also @ref
     *  ww_comments_height. */
        ushort height;
        /** X scale of the comment as a decimal. See also
     * @ref ww_comments_x_scale. */
        double x_scale;
        /** Y scale of the comment as a decimal. See also
     * @ref ww_comments_y_scale. */
        double y_scale;
        /** This option is used to set the background color of cell comment
     *  box. The color should be an RGB integer value, see @ref
     *  working_with_colors. See also @ref ww_comments_color. */
        uint color;
        /** This option is used to set the font for the comment. The default font
     *  is 'Tahoma'.  See also @ref ww_comments_font_name. */
        char* font_name;
        /** This option is used to set the font size for the comment. The default
      * is 8. See also @ref ww_comments_font_size. */
        double font_size;
        /** This option is used to set the font family number for the comment.
     *  Not required very often. Set to 0. */
        ubyte font_family;
        /** This option is used to set the row in which the comment will
     *  appear. By default Excel displays comments one cell to the right and
     *  one cell above the cell to which the comment relates. The `start_row`
     *  and `start_col` options should both be set to 0 if not used.  See also
     *  @ref ww_comments_start_row. */
        uint start_row;
        /** This option is used to set the column in which the comment will
     *   appear. See the `start_row` option for more information and see also
     *   @ref ww_comments_start_col. */
        ushort start_col;
        /** Offset from the left of the cell in pixels. See also
     * @ref ww_comments_x_offset. */
        int x_offset;
        /** Offset from the top of the cell in pixels. See also
     * @ref ww_comments_y_offset. */
        int y_offset;
    }
    /**
 * @brief Options for inserted charts.
 *
 * Options for modifying charts inserted via `worksheet_insert_chart_opt()`.
 *
 */
    struct lxw_chart_options
    {
        /** Offset from the left of the cell in pixels. */
        int x_offset;
        /** Offset from the top of the cell in pixels. */
        int y_offset;
        /** X scale of the chart as a decimal. */
        double x_scale;
        /** Y scale of the chart as a decimal. */
        double y_scale;
        /** Object position - use one of the values of #lxw_object_position.
     *  See @ref working_with_object_positioning.*/
        ubyte object_position;
        /** Optional description or "Alt text" for the chart. This field can be
     *  used to provide a text description of the chart to help
     *  accessibility. Defaults to the image filename as in Excel. Set to NULL
     *  to ignore the description field. */
        char* description;
        /** Optional parameter to help accessibility. It is used to mark the chart
     *  as decorative, and thus uninformative, for automated screen
     *  readers. As in Excel, if this parameter is in use the `description`
     *  field isn't written. */
        ubyte decorative;
    }
    /**
 * @brief Options for inserted images.
 *
 * Options for modifying images inserted via `worksheet_insert_image_opt()`.
 *
 */
    struct lxw_image_options
    {
        /** Offset from the left of the cell in pixels. */
        int x_offset;
        /** Offset from the top of the cell in pixels. */
        int y_offset;
        /** X scale of the image as a decimal. */
        double x_scale;
        /** Y scale of the image as a decimal. */
        double y_scale;
        /** Object position - use one of the values of #lxw_object_position.
     *  See @ref working_with_object_positioning.*/
        ubyte object_position;
        /** Optional description or "Alt text" for the image. This field can be
     *  used to provide a text description of the image to help
     *  accessibility. Defaults to the image filename as in Excel. Set to ""
     *  to ignore the description field. */
        char* description;
        /** Optional parameter to help accessibility. It is used to mark the image
     *  as decorative, and thus uninformative, for automated screen
     *  readers. As in Excel, if this parameter is in use the `description`
     *  field isn't written. */
        ubyte decorative;
        /** Add an optional hyperlink to the image. Follows the same URL rules
     *  and types as `worksheet_write_url()`. */
        char* url;
        /** Add an optional mouseover tip for a hyperlink to the image. */
        char* tip;
    }

    struct lxw_filter_rule_obj
    {

        ubyte type;

        ubyte is_custom;

        ubyte has_blanks;

        ushort col_num;

        ubyte criteria1;

        ubyte criteria2;

        double value1;

        double value2;

        char* value1_string;

        char* value2_string;

        ushort num_list_filters;

        char** list;
    }
    /**
 * @brief Options for autofilter rules.
 *
 * Options to define an autofilter rule.
 *
 */
    struct lxw_filter_rule
    {
        /** The #lxw_filter_criteria to define the rule. */
        ubyte criteria;
        /** String value to which the criteria applies. */
        char* value_string;
        /** Numeric value to which the criteria applies (if value_string isn't used). */
        double value;
    }
    /**
 * @brief Worksheet table options.
 *
 * Options used to define worksheet tables. See @ref working_with_tables for
 * more information.
 *
 */
    struct lxw_table_options
    {
        /**
     * The `name` parameter is used to set the name of the table. This
     * parameter is optional and by default tables are named `Table1`,
     * `Table2`, etc. in the worksheet order that they are added.
     *
     * @code
     *     lxw_table_options options = {.name = "Sales"};
     *
     *     worksheet_add_table(worksheet, RANGE("B3:G8"), &options);
     * @endcode
     *
     * If you override the table name you must ensure that it doesn't clash
     * with an existing table name and that it follows Excel's requirements
     * for table names, see the Microsoft Office documentation on
     * [Naming an Excel Table]
     * (https://support.microsoft.com/en-us/office/rename-an-excel-table-fbf49a4f-82a3-43eb-8ba2-44d21233b114).
     */
        char* name;
        /**
     * The `no_header_row` parameter can be used to turn off the header row in
     * the table. It is on by default:
     *
     * @code
     *     lxw_table_options options = {.no_header_row = LXW_TRUE};
     *
     *     worksheet_add_table(worksheet, RANGE("B4:F7"), &options);
     * @endcode
     *
     * @image html tables4.png
     *
     * Without this option the header row will contain default captions such
     * as `Column 1`, ``Column 2``, etc. These captions can be overridden
     * using the `columns` parameter shown below.
     *
     */
        ubyte no_header_row;
        /**
     * The `no_autofilter` parameter can be used to turn off the autofilter in
     * the header row. It is on by default:
     *
     * @code
     *     lxw_table_options options = {.no_autofilter = LXW_TRUE};
     *
     *     worksheet_add_table(worksheet, RANGE("B3:F7"), &options);
     * @endcode
     *
     * @image html tables3.png
     *
     * The autofilter is only shown if the `no_header_row` parameter is off
     * (the default). Filter conditions within the table are not supported.
     *
     */
        ubyte no_autofilter;
        /**
     * The `no_banded_rows` parameter can be used to turn off the rows of alternating
     * color in the table. It is on by default:
     *
     * @code
     *     lxw_table_options options = {.no_banded_rows = LXW_TRUE};
     *
     *     worksheet_add_table(worksheet, RANGE("B3:F7"), &options);
     * @endcode
     *
     * @image html tables6.png
     *
     */
        ubyte no_banded_rows;
        /**
     * The `banded_columns` parameter can be used to used to create columns of
     * alternating color in the table. It is off by default:
     *
     * @code
     *     lxw_table_options options = {.banded_columns = LXW_TRUE};
     *
     *     worksheet_add_table(worksheet, RANGE("B3:F7"), &options);
     * @endcode
     *
     * The banded columns formatting is shown in the image in the previous
     * section above.
     */
        ubyte banded_columns;
        /**
     * The `first_column` parameter can be used to highlight the first column
     * of the table. The type of highlighting will depend on the `style_type`
     * of the table. It may be bold text or a different color. It is off by
     * default:
     *
     * @code
     *     lxw_table_options options = {.first_column = LXW_TRUE, .last_column = LXW_TRUE};
     *
     *     worksheet_add_table(worksheet, RANGE("B3:F7"), &options);
     * @endcode
     *
     * @image html tables5.png
     */
        ubyte first_column;
        /**
     * The `last_column` parameter can be used to highlight the last column of
     * the table. The type of highlighting will depend on the `style` of the
     * table. It may be bold text or a different color. It is off by default:
     *
     * @code
     *     lxw_table_options options = {.first_column = LXW_TRUE, .last_column = LXW_TRUE};
     *
     *     worksheet_add_table(worksheet, RANGE("B3:F7"), &options);
     * @endcode
     *
     * The `last_column` formatting is shown in the image in the previous
     * section above.
     */
        ubyte last_column;
        /**
     * The `style_type` parameter can be used to set the style of the table,
     * in conjunction with the `style_type_number` parameter:
     *
     * @code
     *     lxw_table_options options = {
     *         .style_type = LXW_TABLE_STYLE_TYPE_LIGHT,
     *         .style_type_number = 11,
     *     };
     *
     *     worksheet_add_table(worksheet, RANGE("B3:G8"), &options);
     * @endcode
     *
     *
     * @image html tables11.png
     *
     * There are three types of table style in Excel: Light, Medium and Dark
     * which are represented using the #lxw_table_style_type enum values:
     *
     * - #LXW_TABLE_STYLE_TYPE_LIGHT
     *
     * - #LXW_TABLE_STYLE_TYPE_MEDIUM
     *
     * - #LXW_TABLE_STYLE_TYPE_DARK
     *
     * Within those ranges there are between 11 and 28 other style types which
     * can be set with `style_type_number` (depending on the style type).
     * Check Excel to find the style that you want. The dialog with the
     * options laid out in numeric order are shown below:
     *
     * @image html tables14.png
     *
     * The default table style in Excel is 'Table Style Medium 9' (highlighted
     * with a green border in the image above), which is set by default in
     * libxlsxwriter as:
     *
     * @code
     *     lxw_table_options options = {
     *         .style_type = LXW_TABLE_STYLE_TYPE_MEDIUM,
     *         .style_type_number = 9,
     *     };
     * @endcode
     *
     * You can also turn the table style off by setting it to Light 0:
     *
     * @code
     *     lxw_table_options options = {
     *         .style_type = LXW_TABLE_STYLE_TYPE_LIGHT,
     *         .style_type_number = 0,
     *     };
     * @endcode
     *
     * @image html tables13.png
     *
     */
        ubyte style_type;
        /**
     * The `style_type_number` parameter is used with `style_type` to set the
     * style of a worksheet table. */
        ubyte style_type_number;
        /**
     * The `total_row` parameter can be used to turn on the total row in the
     * last row of a table. It is distinguished from the other rows by a
     * different formatting and also with dropdown `SUBTOTAL` functions:
     *
     * @code
     *     lxw_table_options options = {.total_row = LXW_TRUE};
     *
     *     worksheet_add_table(worksheet, RANGE("B3:G8"), &options);
     * @endcode
     *
     * @image html tables9.png
     *
     * The default total row doesn't have any captions or functions. These
     * must by specified via the `columns` parameter below.
     */
        ubyte total_row;
        /**
     * The `columns` parameter can be used to set properties for columns
     * within the table. See @ref ww_tables_columns for a detailed
     * explanation.
     */
        lxw_table_column** columns;
    }
    /**
 * @brief Table columns options.
 *
 * Structure to set the options of a table column added with
 * worksheet_add_table(). See @ref ww_tables_columns.
 */
    struct lxw_table_column
    {
        /** Set the header name/caption for the column. If NULL the header defaults
     *  to  Column 1, Column 2, etc. */
        char* header;
        /** Set the formula for the column. */
        char* formula;
        /** Set the string description for the column total.  */
        char* total_string;
        /** Set the function for the column total.  */
        ubyte total_function;
        /** Set the format for the column header.  */
        lxw_format* header_format;
        /** Set the format for the data rows in the column.  */
        lxw_format* format;
        /** Set the formula value for the column total (not generally required). */
        double total_value;
    }
    /**
 * @brief Worksheet conditional formatting options.
 *
 * The fields/options in the the lxw_conditional_format are used to define a
 * worksheet conditional format. It is used in conjunction with
 * `worksheet_conditional_format()`.
 *
 */
    struct lxw_conditional_format
    {
        /** The type of conditional format such as #LXW_CONDITIONAL_TYPE_CELL or
     *  #LXW_CONDITIONAL_DATA_BAR. Should be a #lxw_conditional_format_types
     *  value.*/
        ubyte type;
        /** The criteria parameter is used to set the criteria by which the cell
     *  data will be evaluated. For example in the expression `a > 5 the
     *  criteria is `>` or, in libxlsxwriter terms,
     *  #LXW_CONDITIONAL_CRITERIA_GREATER_THAN. The criteria that are
     *  applicable depend on the conditional format type.  The criteria
     *  options are defined in #lxw_conditional_criteria. */
        ubyte criteria;
        /** The number value to which the condition refers. For example in the
     * expression `a > 5`, the value is 5.*/
        double value;
        /** The string value to which the condition refers, such as `"=A1"`. If a
     *  value_string exists in the struct then the number value is
     *  ignored. Note, if the condition refers to a text string then it must
     *  be double quoted like this `"foo"`. */
        char* value_string;
        /** The format field is used to specify the #lxw_format format that will
     *  be applied to the cell when the conditional formatting criterion is
     *  met. The #lxw_format is created using the `workbook_add_format()`
     *  method in the same way as cell formats.
     *
     *  @note In Excel, a conditional format is superimposed over the existing
     *  cell format and not all cell format properties can be
     *  modified. Properties that @b cannot be modified, in Excel, by a
     *  conditional format are: font name, font size, superscript and
     *  subscript, diagonal borders, all alignment properties and all
     *  protection properties. */
        lxw_format* format;
        /** The minimum value used for Cell, Color Scale and Data Bar conditional
     *  formats. For Cell types this is usually used with a "Between" style criteria. */
        double min_value;
        /** The minimum string value used for Cell, Color Scale and Data Bar conditional
     *  formats. Usually used to set ranges like `=A1`. */
        char* min_value_string;
        /** The rule used for the minimum condition in Color Scale and Data Bar
     *  conditional formats. The rule types are defined in
     *  #lxw_conditional_format_rule_types. */
        ubyte min_rule_type;
        /** The color used for the minimum Color Scale conditional format.
     *  See @ref working_with_colors. */
        uint min_color;
        /** The middle value used for Color Scale and Data Bar conditional
     *  formats.  */
        double mid_value;
        /** The middle string value used for Color Scale and Data Bar conditional
     *  formats. Usually used to set ranges like `=A1`. */
        char* mid_value_string;
        /** The rule used for the middle condition in Color Scale and Data Bar
     *  conditional formats. The rule types are defined in
     *  #lxw_conditional_format_rule_types. */
        ubyte mid_rule_type;
        /** The color used for the middle Color Scale conditional format.
     *  See @ref working_with_colors. */
        uint mid_color;
        /** The maximum value used for Cell, Color Scale and Data Bar conditional
     *  formats. For Cell types this is usually used with a "Between" style
     *  criteria. */
        double max_value;
        /** The maximum string value used for Cell, Color Scale and Data Bar conditional
     *  formats. Usually used to set ranges like `=A1`. */
        char* max_value_string;
        /** The rule used for the maximum condition in Color Scale and Data Bar
     *  conditional formats. The rule types are defined in
     *  #lxw_conditional_format_rule_types. */
        ubyte max_rule_type;
        /** The color used for the maximum Color Scale conditional format.
     *  See @ref working_with_colors. */
        uint max_color;
        /** The bar_color field sets the fill color for data bars. See @ref
     *  working_with_colors. */
        uint bar_color;
        /** The bar_only field sets The bar_only field displays a bar data but
     *  not the data in the cells. */
        ubyte bar_only;
        /** In Excel 2010 additional data bar properties were added such as solid
     *  (non-gradient) bars and control over how negative values are
     *  displayed. These properties can shown below.
     *
     *  The data_bar_2010 field sets Excel 2010 style data bars even when
     *  Excel 2010 specific properties aren't used. */
        ubyte data_bar_2010;
        /** The bar_solid field turns on a solid (non-gradient) fill for data
     *  bars. Set to LXW_TRUE to turn on. Excel 2010 only. */
        ubyte bar_solid;
        /** The bar_negative_color field sets the color fill for the negative
     *  portion of a data bar. See @ref working_with_colors. Excel 2010 only. */
        uint bar_negative_color;
        /** The bar_border_color field sets the color for the border line of a
     *  data bar. See @ref working_with_colors. Excel 2010 only. */
        uint bar_border_color;
        /** The bar_negative_border_color field sets the color for the border of
     *  the negative portion of a data bar. See @ref
     *  working_with_colors. Excel 2010 only. */
        uint bar_negative_border_color;
        /** The bar_negative_color_same field sets the fill color for the negative
     *  portion of a data bar to be the same as the fill color for the
     *  positive portion of the data bar. Set to LXW_TRUE to turn on. Excel
     *  2010 only. */
        ubyte bar_negative_color_same;
        /** The bar_negative_border_color_same field sets the border color for the
     *  negative portion of a data bar to be the same as the border color for
     *  the positive portion of the data bar. Set to LXW_TRUE to turn
     *  on. Excel 2010 only. */
        ubyte bar_negative_border_color_same;
        /** The bar_no_border field turns off the border for data bars. Set to
     *  LXW_TRUE to enable. Excel 2010 only. */
        ubyte bar_no_border;
        /** The bar_direction field sets the direction for data bars. This
     *  property can be either left for left-to-right or right for
     *  right-to-left. If the property isn't set then Excel will adjust the
     *  position automatically based on the context. Should be a
     *  #lxw_conditional_format_bar_direction value. Excel 2010 only. */
        ubyte bar_direction;
        /** The bar_axis_position field sets the position within the cells for the
     *  axis that is shown in data bars when there are negative values to
     *  display. The property can be either middle or none. If the property
     *  isn't set then Excel will position the axis based on the range of
     *  positive and negative values. Should be a
     *  lxw_conditional_bar_axis_position value. Excel 2010 only. */
        ubyte bar_axis_position;
        /** The bar_axis_color field sets the color for the axis that is shown
     *  in data bars when there are negative values to display. See @ref
     *  working_with_colors. Excel 2010 only. */
        uint bar_axis_color;
        /** The Icons Sets style is specified by the icon_style parameter. Should
     *  be a #lxw_conditional_icon_types. */
        ubyte icon_style;
        /** The order of Icon Sets icons can be reversed by setting reverse_icons
     *  to LXW_TRUE.  */
        ubyte reverse_icons;
        /** The icons can be displayed without the cell value by settings the
     *  icons_only parameter to LXW_TRUE.  */
        ubyte icons_only;
        /** The multi_range field is used to extend a conditional format over
     *  non-contiguous ranges.
     *
     *  It is possible to apply the conditional format to different cell
     *  ranges in a worksheet using multiple calls to
     *  `worksheet_conditional_format()`. However, as a minor optimization it
     *  is also possible in Excel to apply the same conditional format to
     *  different non-contiguous cell ranges.
     *
     *  This is replicated in `worksheet_conditional_format()` using the
     *  multi_range option. The range must contain the primary range for the
     *  conditional format and any others separated by spaces. For example
     *  `"A1 C1:C5 E2 G1:G100"`.
     */
        char* multi_range;
        /** The stop_if_true parameter can be used to set the "stop if true"
     *  feature of a conditional formatting rule when more than one rule is
     *  applied to a cell or a range of cells. When this parameter is set then
     *  subsequent rules are not evaluated if the current rule is true. Set to
     *  LXW_TRUE to turn on. */
        ubyte stop_if_true;
    }
    /**
 * @brief Worksheet data validation options.
 */
    struct lxw_data_validation
    {
        /**
     * Set the validation type. Should be a #lxw_validation_types value.
     */
        ubyte validate;
        /**
     * Set the validation criteria type to select the data. Should be a
     * #lxw_validation_criteria value.
     */
        ubyte criteria;
        /** Controls whether a data validation is not applied to blank data in the
     * cell. Should be a #lxw_validation_boolean value. It is on by
     * default.
     */
        ubyte ignore_blank;
        /**
     * This parameter is used to toggle on and off the 'Show input message
     * when cell is selected' option in the Excel data validation dialog. When
     * the option is off an input message is not displayed even if it has been
     * set using input_message. Should be a #lxw_validation_boolean value. It
     * is on by default.
     */
        ubyte show_input;
        /**
     * This parameter is used to toggle on and off the 'Show error alert
     * after invalid data is entered' option in the Excel data validation
     * dialog. When the option is off an error message is not displayed even
     * if it has been set using error_message. Should be a
     * #lxw_validation_boolean value. It is on by default.
     */
        ubyte show_error;
        /**
     * This parameter is used to specify the type of error dialog that is
     * displayed. Should be a #lxw_validation_error_types value.
     */
        ubyte error_type;
        /**
     * This parameter is used to toggle on and off the 'In-cell dropdown'
     * option in the Excel data validation dialog. When the option is on a
     * dropdown list will be shown for list validations. Should be a
     * #lxw_validation_boolean value. It is on by default.
     */
        ubyte dropdown;
        /**
     * This parameter is used to set the limiting value to which the criteria
     * is applied using a whole or decimal number.
     */
        double value_number;
        /**
     * This parameter is used to set the limiting value to which the criteria
     * is applied using a cell reference. It is valid for any of the
     * `_FORMULA` validation types.
     */
        char* value_formula;
        /**
     * This parameter is used to set a list of strings for a drop down list.
     * The list should be a `NULL` terminated array of char* strings:
     *
     * @code
     *    char *list[] = {"open", "high", "close", NULL};
     *
     *    data_validation->validate   = LXW_VALIDATION_TYPE_LIST;
     *    data_validation->value_list = list;
     * @endcode
     *
     * The `value_formula` parameter can also be used to specify a list from
     * an Excel cell range.
     *
     * Note, the string list is restricted by Excel to 255 characters,
     * including comma separators.
     */
        char** value_list;
        /**
     * This parameter is used to set the limiting value to which the date or
     * time criteria is applied using a #lxw_datetime struct.
     */
        lxw_datetime value_datetime;
        /**
     * This parameter is the same as `value_number` but for the minimum value
     * when a `BETWEEN` criteria is used.
     */
        double minimum_number;
        /**
     * This parameter is the same as `value_formula` but for the minimum value
     * when a `BETWEEN` criteria is used.
     */
        char* minimum_formula;
        /**
     * This parameter is the same as `value_datetime` but for the minimum value
     * when a `BETWEEN` criteria is used.
     */
        lxw_datetime minimum_datetime;
        /**
     * This parameter is the same as `value_number` but for the maximum value
     * when a `BETWEEN` criteria is used.
     */
        double maximum_number;
        /**
     * This parameter is the same as `value_formula` but for the maximum value
     * when a `BETWEEN` criteria is used.
     */
        char* maximum_formula;
        /**
     * This parameter is the same as `value_datetime` but for the maximum value
     * when a `BETWEEN` criteria is used.
     */
        lxw_datetime maximum_datetime;
        /**
     * The input_title parameter is used to set the title of the input message
     * that is displayed when a cell is entered. It has no default value and
     * is only displayed if the input message is displayed. See the
     * `input_message` parameter below.
     *
     * The maximum title length is 32 characters.
     */
        char* input_title;
        /**
     * The input_message parameter is used to set the input message that is
     * displayed when a cell is entered. It has no default value.
     *
     * The message can be split over several lines using newlines. The maximum
     * message length is 255 characters.
     */
        char* input_message;
        /**
     * The error_title parameter is used to set the title of the error message
     * that is displayed when the data validation criteria is not met. The
     * default error title is 'Microsoft Excel'. The maximum title length is
     * 32 characters.
     */
        char* error_title;
        /**
     * The error_message parameter is used to set the error message that is
     * displayed when a cell is entered. The default error message is "The
     * value you entered is not valid. A user has restricted values that can
     * be entered into the cell".
     *
     * The message can be split over several lines using newlines. The maximum
     * message length is 255 characters.
     */
        char* error_message;
    }

    struct lxw_panes
    {

        ubyte type;

        uint first_row;

        ushort first_col;

        uint top_row;

        ushort left_col;

        double x_split;

        double y_split;
    }

    struct lxw_autofilter
    {

        ubyte in_use;

        ubyte has_rules;

        uint first_row;

        uint last_row;

        ushort first_col;

        ushort last_col;
    }

    struct lxw_print_area
    {

        ubyte in_use;

        uint first_row;

        uint last_row;

        ushort first_col;

        ushort last_col;
    }

    struct lxw_repeat_cols
    {

        ubyte in_use;

        ushort first_col;

        ushort last_col;
    }

    struct lxw_repeat_rows
    {

        ubyte in_use;

        uint first_row;

        uint last_row;
    }

    struct lxw_col_options
    {

        ushort firstcol;

        ushort lastcol;

        double width;

        lxw_format* format;

        ubyte hidden;

        ubyte level;

        ubyte collapsed;
    }
    /**
 * @brief Options for rows and columns.
 *
 * Options struct for the worksheet_set_column() and worksheet_set_row()
 * functions.
 *
 * It has the following members:
 *
 * * `hidden`
 * * `level`
 * * `collapsed`
 *
 * The members of this struct are explained in @ref ww_outlines_grouping.
 *
 */
    struct lxw_row_col_options
    {
        /** Hide the row/column. @ref ww_outlines_grouping.*/
        ubyte hidden;
        /** Outline level. See @ref ww_outlines_grouping.*/
        ubyte level;
        /** Set the outline row as collapsed. See @ref ww_outlines_grouping.*/
        ubyte collapsed;
    }

    struct lxw_table_objs
    {

        lxw_table_obj* stqh_first;

        lxw_table_obj** stqh_last;
    }

    struct lxw_table_obj
    {

        char* name;

        char* total_string;

        lxw_table_column** columns;

        ubyte banded_columns;

        ubyte first_column;

        ubyte last_column;

        ubyte no_autofilter;

        ubyte no_banded_rows;

        ubyte no_header_row;

        ubyte style_type;

        ubyte style_type_number;

        ubyte total_row;

        uint first_row;

        ushort first_col;

        uint last_row;

        ushort last_col;

        ushort num_cols;

        uint id;

        char[2080] sqref;

        char[2080] filter_sqref;

        static struct _Anonymous_2
        {

            lxw_table_obj* stqe_next;
        }

        _Anonymous_2 list_pointers;
    }

    struct lxw_vml_obj
    {

        uint row;

        ushort col;

        uint start_row;

        ushort start_col;

        int x_offset;

        int y_offset;

        uint col_absolute;

        uint row_absolute;

        uint width;

        uint height;

        double x_dpi;

        double y_dpi;

        uint color;

        ubyte font_family;

        ubyte visible;

        uint author_id;

        uint rel_index;

        double font_size;

        lxw_drawing_coords from;

        lxw_drawing_coords to;

        char* author;

        char* font_name;

        char* text;

        char* image_position;

        char* name;

        char* macro_;

        static struct _Anonymous_3
        {

            lxw_vml_obj* stqe_next;
        }

        _Anonymous_3 list_pointers;
    }

    struct lxw_comment_objs
    {

        lxw_vml_obj* stqh_first;

        lxw_vml_obj** stqh_last;
    }

    struct lxw_chart_props
    {

        lxw_object_properties* stqh_first;

        lxw_object_properties** stqh_last;
    }

    struct lxw_image_props
    {

        lxw_object_properties* stqh_first;

        lxw_object_properties** stqh_last;
    }

    struct lxw_object_properties
    {

        int x_offset;

        int y_offset;

        double x_scale;

        double y_scale;

        uint row;

        ushort col;

        char* filename;

        char* description;

        char* url;

        char* tip;

        ubyte object_position;

        _IO_FILE* stream;

        ubyte image_type;

        ubyte is_image_buffer;

        char* image_buffer;

        c_ulong image_buffer_size;

        double width;

        double height;

        char* extension;

        double x_dpi;

        double y_dpi;

        lxw_chart* chart;

        ubyte is_duplicate;

        ubyte is_background;

        char* md5;

        char* image_position;

        ubyte decorative;

        static struct _Anonymous_4
        {

            lxw_object_properties* stqe_next;
        }

        _Anonymous_4 list_pointers;
    }

    struct lxw_cond_format_obj
    {

        ubyte type;

        ubyte criteria;

        double min_value;

        char* min_value_string;

        ubyte min_rule_type;

        uint min_color;

        double mid_value;

        char* mid_value_string;

        ubyte mid_value_type;

        ubyte mid_rule_type;

        uint mid_color;

        double max_value;

        char* max_value_string;

        ubyte max_value_type;

        ubyte max_rule_type;

        uint max_color;

        ubyte data_bar_2010;

        ubyte auto_min;

        ubyte auto_max;

        ubyte bar_only;

        ubyte bar_solid;

        ubyte bar_negative_color_same;

        ubyte bar_negative_border_color_same;

        ubyte bar_no_border;

        ubyte bar_direction;

        ubyte bar_axis_position;

        uint bar_color;

        uint bar_negative_color;

        uint bar_border_color;

        uint bar_negative_border_color;

        uint bar_axis_color;

        ubyte icon_style;

        ubyte reverse_icons;

        ubyte icons_only;

        ubyte stop_if_true;

        ubyte has_max;

        char* type_string;

        char* guid;

        int dxf_index;

        uint dxf_priority;

        char[14] first_cell;

        char[2080] sqref;

        static struct _Anonymous_5
        {

            lxw_cond_format_obj* stqe_next;
        }

        _Anonymous_5 list_pointers;
    }

    struct lxw_cond_format_list
    {

        lxw_cond_format_obj* stqh_first;

        lxw_cond_format_obj** stqh_last;
    }

    struct lxw_data_val_obj
    {

        ubyte validate;

        ubyte criteria;

        ubyte ignore_blank;

        ubyte show_input;

        ubyte show_error;

        ubyte error_type;

        ubyte dropdown;

        double value_number;

        char* value_formula;

        char** value_list;

        double minimum_number;

        char* minimum_formula;

        lxw_datetime minimum_datetime;

        double maximum_number;

        char* maximum_formula;

        lxw_datetime maximum_datetime;

        char* input_title;

        char* input_message;

        char* error_title;

        char* error_message;

        char[28] sqref;

        static struct _Anonymous_6
        {

            lxw_data_val_obj* stqe_next;
        }

        _Anonymous_6 list_pointers;
    }

    struct lxw_data_validations
    {

        lxw_data_val_obj* stqh_first;

        lxw_data_val_obj** stqh_last;
    }

    struct lxw_selections
    {

        lxw_selection* stqh_first;

        lxw_selection** stqh_last;
    }

    struct lxw_selection
    {

        char[12] pane;

        char[28] active_cell;

        char[28] sqref;

        static struct _Anonymous_7
        {

            lxw_selection* stqe_next;
        }

        _Anonymous_7 list_pointers;
    }

    struct lxw_merged_ranges
    {

        lxw_merged_range* stqh_first;

        lxw_merged_range** stqh_last;
    }

    struct lxw_merged_range
    {

        uint first_row;

        uint last_row;

        ushort first_col;

        ushort last_col;

        static struct _Anonymous_8
        {

            lxw_merged_range* stqe_next;
        }

        _Anonymous_8 list_pointers;
    }

    struct lxw_row
    {

        uint row_num;

        double height;

        lxw_format* format;

        ubyte hidden;

        ubyte level;

        ubyte collapsed;

        ubyte row_changed;

        ubyte data_changed;

        ubyte height_changed;

        lxw_table_cells* cells;

        static struct _Anonymous_9
        {

            lxw_row* rbe_left;

            lxw_row* rbe_right;

            lxw_row* rbe_parent;

            int rbe_color;
        }

        _Anonymous_9 tree_pointers;
    }

    struct lxw_table_rows
    {

        lxw_row* rbh_root;

        lxw_row* cached_row;

        uint cached_row_num;
    }

    struct lxw_cond_format_hash_element
    {

        char[2080] sqref;

        lxw_cond_format_list* cond_formats;

        static struct _Anonymous_10
        {

            lxw_cond_format_hash_element* rbe_left;

            lxw_cond_format_hash_element* rbe_right;

            lxw_cond_format_hash_element* rbe_parent;

            int rbe_color;
        }

        _Anonymous_10 tree_pointers;
    }

    struct lxw_cond_format_hash
    {

        lxw_cond_format_hash_element* rbh_root;
    }

    struct lxw_vml_drawing_rel_ids
    {

        lxw_drawing_rel_id* rbh_root;
    }

    struct lxw_drawing_rel_id
    {

        uint id;

        char* target;

        static struct _Anonymous_11
        {

            lxw_drawing_rel_id* rbe_left;

            lxw_drawing_rel_id* rbe_right;

            lxw_drawing_rel_id* rbe_parent;

            int rbe_color;
        }

        _Anonymous_11 tree_pointers;
    }

    struct lxw_drawing_rel_ids
    {

        lxw_drawing_rel_id* rbh_root;
    }

    struct lxw_cell
    {

        uint row_num;

        ushort col_num;

        cell_types type;

        lxw_format* format;

        lxw_vml_obj* comment;

        static union _Anonymous_12
        {

            double number;

            int string_id;

            char* string_;
        }

        _Anonymous_12 u;

        double formula_result;

        char* user_data1;

        char* user_data2;

        char* sst_string;

        static struct _Anonymous_13
        {

            lxw_cell* rbe_left;

            lxw_cell* rbe_right;

            lxw_cell* rbe_parent;

            int rbe_color;
        }

        _Anonymous_13 tree_pointers;
    }

    struct lxw_table_cells
    {

        lxw_cell* rbh_root;
    }

    enum lxw_image_position
    {

        HEADER_LEFT = 0,

        HEADER_CENTER = 1,

        HEADER_RIGHT = 2,

        FOOTER_LEFT = 3,

        FOOTER_CENTER = 4,

        FOOTER_RIGHT = 5,
    }
    enum HEADER_LEFT = lxw_image_position.HEADER_LEFT;
    enum HEADER_CENTER = lxw_image_position.HEADER_CENTER;
    enum HEADER_RIGHT = lxw_image_position.HEADER_RIGHT;
    enum FOOTER_LEFT = lxw_image_position.FOOTER_LEFT;
    enum FOOTER_CENTER = lxw_image_position.FOOTER_CENTER;
    enum FOOTER_RIGHT = lxw_image_position.FOOTER_RIGHT;

    enum pane_types
    {

        NO_PANES = 0,

        FREEZE_PANES = 1,

        SPLIT_PANES = 2,

        FREEZE_SPLIT_PANES = 3,
    }
    enum NO_PANES = pane_types.NO_PANES;
    enum FREEZE_PANES = pane_types.FREEZE_PANES;
    enum SPLIT_PANES = pane_types.SPLIT_PANES;
    enum FREEZE_SPLIT_PANES = pane_types.FREEZE_SPLIT_PANES;

    enum cell_types
    {

        NUMBER_CELL = 1,

        STRING_CELL = 2,

        INLINE_STRING_CELL = 3,

        INLINE_RICH_STRING_CELL = 4,

        FORMULA_CELL = 5,

        ARRAY_FORMULA_CELL = 6,

        DYNAMIC_ARRAY_FORMULA_CELL = 7,

        BLANK_CELL = 8,

        BOOLEAN_CELL = 9,

        COMMENT = 10,

        HYPERLINK_URL = 11,

        HYPERLINK_INTERNAL = 12,

        HYPERLINK_EXTERNAL = 13,
    }
    enum NUMBER_CELL = cell_types.NUMBER_CELL;
    enum STRING_CELL = cell_types.STRING_CELL;
    enum INLINE_STRING_CELL = cell_types.INLINE_STRING_CELL;
    enum INLINE_RICH_STRING_CELL = cell_types.INLINE_RICH_STRING_CELL;
    enum FORMULA_CELL = cell_types.FORMULA_CELL;
    enum ARRAY_FORMULA_CELL = cell_types.ARRAY_FORMULA_CELL;
    enum DYNAMIC_ARRAY_FORMULA_CELL = cell_types.DYNAMIC_ARRAY_FORMULA_CELL;
    enum BLANK_CELL = cell_types.BLANK_CELL;
    enum BOOLEAN_CELL = cell_types.BOOLEAN_CELL;
    enum COMMENT = cell_types.COMMENT;
    enum HYPERLINK_URL = cell_types.HYPERLINK_URL;
    enum HYPERLINK_INTERNAL = cell_types.HYPERLINK_INTERNAL;
    enum HYPERLINK_EXTERNAL = cell_types.HYPERLINK_EXTERNAL;
    /** Options for ignoring worksheet errors/warnings. See worksheet_ignore_errors(). */
    enum lxw_ignore_errors
    {
        /** Turn off errors/warnings for numbers stores as text. */
        LXW_IGNORE_NUMBER_STORED_AS_TEXT = 1,
        /** Turn off errors/warnings for formula errors (such as divide by
     *  zero). */
        LXW_IGNORE_EVAL_ERROR = 2,
        /** Turn off errors/warnings for formulas that differ from surrounding
     *  formulas. */
        LXW_IGNORE_FORMULA_DIFFERS = 3,
        /** Turn off errors/warnings for formulas that omit cells in a range. */
        LXW_IGNORE_FORMULA_RANGE = 4,
        /** Turn off errors/warnings for unlocked cells that contain formulas. */
        LXW_IGNORE_FORMULA_UNLOCKED = 5,
        /** Turn off errors/warnings for formulas that refer to empty cells. */
        LXW_IGNORE_EMPTY_CELL_REFERENCE = 6,
        /** Turn off errors/warnings for cells in a table that do not comply with
     *  applicable data validation rules. */
        LXW_IGNORE_LIST_DATA_VALIDATION = 7,
        /** Turn off errors/warnings for cell formulas that differ from the column
     *  formula. */
        LXW_IGNORE_CALCULATED_COLUMN = 8,
        /** Turn off errors/warnings for formulas that contain a two digit text
     *  representation of a year. */
        LXW_IGNORE_TWO_DIGIT_TEXT_YEAR = 9,
        /** Turn off errors/warnings for formulas that contain a two digit text
     *  representation of a year. */
        LXW_IGNORE_LAST_OPTION = 10,
    }
    enum LXW_IGNORE_NUMBER_STORED_AS_TEXT = lxw_ignore_errors.LXW_IGNORE_NUMBER_STORED_AS_TEXT;
    enum LXW_IGNORE_EVAL_ERROR = lxw_ignore_errors.LXW_IGNORE_EVAL_ERROR;
    enum LXW_IGNORE_FORMULA_DIFFERS = lxw_ignore_errors.LXW_IGNORE_FORMULA_DIFFERS;
    enum LXW_IGNORE_FORMULA_RANGE = lxw_ignore_errors.LXW_IGNORE_FORMULA_RANGE;
    enum LXW_IGNORE_FORMULA_UNLOCKED = lxw_ignore_errors.LXW_IGNORE_FORMULA_UNLOCKED;
    enum LXW_IGNORE_EMPTY_CELL_REFERENCE = lxw_ignore_errors.LXW_IGNORE_EMPTY_CELL_REFERENCE;
    enum LXW_IGNORE_LIST_DATA_VALIDATION = lxw_ignore_errors.LXW_IGNORE_LIST_DATA_VALIDATION;
    enum LXW_IGNORE_CALCULATED_COLUMN = lxw_ignore_errors.LXW_IGNORE_CALCULATED_COLUMN;
    enum LXW_IGNORE_TWO_DIGIT_TEXT_YEAR = lxw_ignore_errors.LXW_IGNORE_TWO_DIGIT_TEXT_YEAR;
    enum LXW_IGNORE_LAST_OPTION = lxw_ignore_errors.LXW_IGNORE_LAST_OPTION;
    /** Options to control the positioning of worksheet objects such as images
 *  or charts. See @ref working_with_object_positioning. */
    enum lxw_object_position
    {
        /** Default positioning for the object. */
        LXW_OBJECT_POSITION_DEFAULT = 0,
        /** Move and size with the worksheet object with the cells. */
        LXW_OBJECT_MOVE_AND_SIZE = 1,
        /** Move but don't size with the worksheet object with the cells. */
        LXW_OBJECT_MOVE_DONT_SIZE = 2,
        /** Don't move or size the worksheet object with the cells. */
        LXW_OBJECT_DONT_MOVE_DONT_SIZE = 3,
        /** Same as #LXW_OBJECT_MOVE_AND_SIZE except libxlsxwriter applies hidden
     *  cells after the object is inserted. */
        LXW_OBJECT_MOVE_AND_SIZE_AFTER = 4,
    }
    enum LXW_OBJECT_POSITION_DEFAULT = lxw_object_position.LXW_OBJECT_POSITION_DEFAULT;
    enum LXW_OBJECT_MOVE_AND_SIZE = lxw_object_position.LXW_OBJECT_MOVE_AND_SIZE;
    enum LXW_OBJECT_MOVE_DONT_SIZE = lxw_object_position.LXW_OBJECT_MOVE_DONT_SIZE;
    enum LXW_OBJECT_DONT_MOVE_DONT_SIZE = lxw_object_position.LXW_OBJECT_DONT_MOVE_DONT_SIZE;
    enum LXW_OBJECT_MOVE_AND_SIZE_AFTER = lxw_object_position.LXW_OBJECT_MOVE_AND_SIZE_AFTER;

    enum lxw_filter_type
    {

        LXW_FILTER_TYPE_NONE = 0,

        LXW_FILTER_TYPE_SINGLE = 1,

        LXW_FILTER_TYPE_AND = 2,

        LXW_FILTER_TYPE_OR = 3,

        LXW_FILTER_TYPE_STRING_LIST = 4,
    }
    enum LXW_FILTER_TYPE_NONE = lxw_filter_type.LXW_FILTER_TYPE_NONE;
    enum LXW_FILTER_TYPE_SINGLE = lxw_filter_type.LXW_FILTER_TYPE_SINGLE;
    enum LXW_FILTER_TYPE_AND = lxw_filter_type.LXW_FILTER_TYPE_AND;
    enum LXW_FILTER_TYPE_OR = lxw_filter_type.LXW_FILTER_TYPE_OR;
    enum LXW_FILTER_TYPE_STRING_LIST = lxw_filter_type.LXW_FILTER_TYPE_STRING_LIST;
    /**
 * @brief And/or operator when using 2 filter rules.
 *
 * And/or operator conditions when using 2 filter rules with
 * worksheet_filter_column2(). In general LXW_FILTER_OR is used with
 * LXW_FILTER_CRITERIA_EQUAL_TO and LXW_FILTER_AND is used with the other
 * filter criteria.
 */
    enum lxw_filter_operator
    {
        /** Logical "and" of 2 filter rules. */
        LXW_FILTER_AND = 0,
        /** Logical "or" of 2 filter rules. */
        LXW_FILTER_OR = 1,
    }
    enum LXW_FILTER_AND = lxw_filter_operator.LXW_FILTER_AND;
    enum LXW_FILTER_OR = lxw_filter_operator.LXW_FILTER_OR;
    /** @brief The criteria used in autofilter rules.
 *
 * Criteria used to define an autofilter rule condition.
 */
    enum lxw_filter_criteria
    {

        LXW_FILTER_CRITERIA_NONE = 0,
        /** Filter cells equal to a value. */
        LXW_FILTER_CRITERIA_EQUAL_TO = 1,
        /** Filter cells not equal to a value. */
        LXW_FILTER_CRITERIA_NOT_EQUAL_TO = 2,
        /** Filter cells greater than a value. */
        LXW_FILTER_CRITERIA_GREATER_THAN = 3,
        /** Filter cells less than a value. */
        LXW_FILTER_CRITERIA_LESS_THAN = 4,
        /** Filter cells greater than or equal to a value. */
        LXW_FILTER_CRITERIA_GREATER_THAN_OR_EQUAL_TO = 5,
        /** Filter cells less than or equal to a value. */
        LXW_FILTER_CRITERIA_LESS_THAN_OR_EQUAL_TO = 6,
        /** Filter cells that are blank. */
        LXW_FILTER_CRITERIA_BLANKS = 7,
        /** Filter cells that are not blank. */
        LXW_FILTER_CRITERIA_NON_BLANKS = 8,
    }
    enum LXW_FILTER_CRITERIA_NONE = lxw_filter_criteria.LXW_FILTER_CRITERIA_NONE;
    enum LXW_FILTER_CRITERIA_EQUAL_TO = lxw_filter_criteria.LXW_FILTER_CRITERIA_EQUAL_TO;
    enum LXW_FILTER_CRITERIA_NOT_EQUAL_TO = lxw_filter_criteria.LXW_FILTER_CRITERIA_NOT_EQUAL_TO;
    enum LXW_FILTER_CRITERIA_GREATER_THAN = lxw_filter_criteria.LXW_FILTER_CRITERIA_GREATER_THAN;
    enum LXW_FILTER_CRITERIA_LESS_THAN = lxw_filter_criteria.LXW_FILTER_CRITERIA_LESS_THAN;
    enum LXW_FILTER_CRITERIA_GREATER_THAN_OR_EQUAL_TO = lxw_filter_criteria.LXW_FILTER_CRITERIA_GREATER_THAN_OR_EQUAL_TO;
    enum LXW_FILTER_CRITERIA_LESS_THAN_OR_EQUAL_TO = lxw_filter_criteria.LXW_FILTER_CRITERIA_LESS_THAN_OR_EQUAL_TO;
    enum LXW_FILTER_CRITERIA_BLANKS = lxw_filter_criteria.LXW_FILTER_CRITERIA_BLANKS;
    enum LXW_FILTER_CRITERIA_NON_BLANKS = lxw_filter_criteria.LXW_FILTER_CRITERIA_NON_BLANKS;
    /**
 * @brief Standard Excel functions for totals in tables.
 *
 * Definitions for the standard Excel functions that are available via the
 * dropdown in the total row of an Excel table.
 *
 */
    enum lxw_table_total_functions
    {

        LXW_TABLE_FUNCTION_NONE = 0,
        /** Use the average function as the table total. */
        LXW_TABLE_FUNCTION_AVERAGE = 101,
        /** Use the count numbers function as the table total. */
        LXW_TABLE_FUNCTION_COUNT_NUMS = 102,
        /** Use the count function as the table total. */
        LXW_TABLE_FUNCTION_COUNT = 103,
        /** Use the max function as the table total. */
        LXW_TABLE_FUNCTION_MAX = 104,
        /** Use the min function as the table total. */
        LXW_TABLE_FUNCTION_MIN = 105,
        /** Use the standard deviation function as the table total. */
        LXW_TABLE_FUNCTION_STD_DEV = 107,
        /** Use the sum function as the table total. */
        LXW_TABLE_FUNCTION_SUM = 109,
        /** Use the var function as the table total. */
        LXW_TABLE_FUNCTION_VAR = 110,
    }
    enum LXW_TABLE_FUNCTION_NONE = lxw_table_total_functions.LXW_TABLE_FUNCTION_NONE;
    enum LXW_TABLE_FUNCTION_AVERAGE = lxw_table_total_functions.LXW_TABLE_FUNCTION_AVERAGE;
    enum LXW_TABLE_FUNCTION_COUNT_NUMS = lxw_table_total_functions.LXW_TABLE_FUNCTION_COUNT_NUMS;
    enum LXW_TABLE_FUNCTION_COUNT = lxw_table_total_functions.LXW_TABLE_FUNCTION_COUNT;
    enum LXW_TABLE_FUNCTION_MAX = lxw_table_total_functions.LXW_TABLE_FUNCTION_MAX;
    enum LXW_TABLE_FUNCTION_MIN = lxw_table_total_functions.LXW_TABLE_FUNCTION_MIN;
    enum LXW_TABLE_FUNCTION_STD_DEV = lxw_table_total_functions.LXW_TABLE_FUNCTION_STD_DEV;
    enum LXW_TABLE_FUNCTION_SUM = lxw_table_total_functions.LXW_TABLE_FUNCTION_SUM;
    enum LXW_TABLE_FUNCTION_VAR = lxw_table_total_functions.LXW_TABLE_FUNCTION_VAR;
    /** @brief The type of table style.
 *
 * The type of table style (Light, Medium or Dark).
 */
    enum lxw_table_style_type
    {

        LXW_TABLE_STYLE_TYPE_DEFAULT = 0,
        /** Light table style. */
        LXW_TABLE_STYLE_TYPE_LIGHT = 1,
        /** Light table style. */
        LXW_TABLE_STYLE_TYPE_MEDIUM = 2,
        /** Light table style. */
        LXW_TABLE_STYLE_TYPE_DARK = 3,
    }
    enum LXW_TABLE_STYLE_TYPE_DEFAULT = lxw_table_style_type.LXW_TABLE_STYLE_TYPE_DEFAULT;
    enum LXW_TABLE_STYLE_TYPE_LIGHT = lxw_table_style_type.LXW_TABLE_STYLE_TYPE_LIGHT;
    enum LXW_TABLE_STYLE_TYPE_MEDIUM = lxw_table_style_type.LXW_TABLE_STYLE_TYPE_MEDIUM;
    enum LXW_TABLE_STYLE_TYPE_DARK = lxw_table_style_type.LXW_TABLE_STYLE_TYPE_DARK;
    /** @brief Icon types used in the #lxw_conditional_format icon_style field.
 *
 * Definitions of icon styles used with Icon Set conditional formats.
 */
    enum lxw_conditional_icon_types
    {
        /** Icon style: 3 colored arrows showing up, sideways and down. */
        LXW_CONDITIONAL_ICONS_3_ARROWS_COLORED = 0,
        /** Icon style: 3 gray arrows showing up, sideways and down. */
        LXW_CONDITIONAL_ICONS_3_ARROWS_GRAY = 1,
        /** Icon style: 3 colored flags in red, yellow and green. */
        LXW_CONDITIONAL_ICONS_3_FLAGS = 2,
        /** Icon style: 3 traffic lights - rounded. */
        LXW_CONDITIONAL_ICONS_3_TRAFFIC_LIGHTS_UNRIMMED = 3,
        /** Icon style: 3 traffic lights with a rim - squarish. */
        LXW_CONDITIONAL_ICONS_3_TRAFFIC_LIGHTS_RIMMED = 4,
        /** Icon style: 3 colored shapes - a circle, triangle and diamond. */
        LXW_CONDITIONAL_ICONS_3_SIGNS = 5,
        /** Icon style: 3 circled symbols with tick mark, exclamation and
     *  cross. */
        LXW_CONDITIONAL_ICONS_3_SYMBOLS_CIRCLED = 6,
        /** Icon style: 3 symbols with tick mark, exclamation and cross. */
        LXW_CONDITIONAL_ICONS_3_SYMBOLS_UNCIRCLED = 7,
        /** Icon style: 3 colored arrows showing up, diagonal up, diagonal down
     *  and down. */
        LXW_CONDITIONAL_ICONS_4_ARROWS_COLORED = 8,
        /** Icon style: 3 gray arrows showing up, diagonal up, diagonal down and
     * down. */
        LXW_CONDITIONAL_ICONS_4_ARROWS_GRAY = 9,
        /** Icon style: 4 circles in 4 colors going from red to black. */
        LXW_CONDITIONAL_ICONS_4_RED_TO_BLACK = 10,
        /** Icon style: 4 histogram ratings. */
        LXW_CONDITIONAL_ICONS_4_RATINGS = 11,
        /** Icon style: 4 traffic lights. */
        LXW_CONDITIONAL_ICONS_4_TRAFFIC_LIGHTS = 12,
        /** Icon style: 5 colored arrows showing up, diagonal up, sideways,
     * diagonal down and down. */
        LXW_CONDITIONAL_ICONS_5_ARROWS_COLORED = 13,
        /** Icon style: 5 gray arrows showing up, diagonal up, sideways, diagonal
     *  down and down. */
        LXW_CONDITIONAL_ICONS_5_ARROWS_GRAY = 14,
        /** Icon style: 5 histogram ratings. */
        LXW_CONDITIONAL_ICONS_5_RATINGS = 15,
        /** Icon style: 5 quarters, from 0 to 4 quadrants filled. */
        LXW_CONDITIONAL_ICONS_5_QUARTERS = 16,
    }
    enum LXW_CONDITIONAL_ICONS_3_ARROWS_COLORED = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_ARROWS_COLORED;
    enum LXW_CONDITIONAL_ICONS_3_ARROWS_GRAY = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_ARROWS_GRAY;
    enum LXW_CONDITIONAL_ICONS_3_FLAGS = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_FLAGS;
    enum LXW_CONDITIONAL_ICONS_3_TRAFFIC_LIGHTS_UNRIMMED = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_TRAFFIC_LIGHTS_UNRIMMED;
    enum LXW_CONDITIONAL_ICONS_3_TRAFFIC_LIGHTS_RIMMED = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_TRAFFIC_LIGHTS_RIMMED;
    enum LXW_CONDITIONAL_ICONS_3_SIGNS = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_SIGNS;
    enum LXW_CONDITIONAL_ICONS_3_SYMBOLS_CIRCLED = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_SYMBOLS_CIRCLED;
    enum LXW_CONDITIONAL_ICONS_3_SYMBOLS_UNCIRCLED = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_3_SYMBOLS_UNCIRCLED;
    enum LXW_CONDITIONAL_ICONS_4_ARROWS_COLORED = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_4_ARROWS_COLORED;
    enum LXW_CONDITIONAL_ICONS_4_ARROWS_GRAY = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_4_ARROWS_GRAY;
    enum LXW_CONDITIONAL_ICONS_4_RED_TO_BLACK = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_4_RED_TO_BLACK;
    enum LXW_CONDITIONAL_ICONS_4_RATINGS = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_4_RATINGS;
    enum LXW_CONDITIONAL_ICONS_4_TRAFFIC_LIGHTS = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_4_TRAFFIC_LIGHTS;
    enum LXW_CONDITIONAL_ICONS_5_ARROWS_COLORED = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_5_ARROWS_COLORED;
    enum LXW_CONDITIONAL_ICONS_5_ARROWS_GRAY = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_5_ARROWS_GRAY;
    enum LXW_CONDITIONAL_ICONS_5_RATINGS = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_5_RATINGS;
    enum LXW_CONDITIONAL_ICONS_5_QUARTERS = lxw_conditional_icon_types.LXW_CONDITIONAL_ICONS_5_QUARTERS;
    /** @brief Conditional format data bar axis options.
 *
 * Values used to set the position of the axis in a conditional format data
 * bar.
 */
    enum lxw_conditional_bar_axis_position
    {
        /** Data bar axis position is set by Excel based on the context of the
     *  data displayed. */
        LXW_CONDITIONAL_BAR_AXIS_AUTOMATIC = 0,
        /** Data bar axis position is set at the midpoint. */
        LXW_CONDITIONAL_BAR_AXIS_MIDPOINT = 1,
        /** Data bar axis is turned off. */
        LXW_CONDITIONAL_BAR_AXIS_NONE = 2,
    }
    enum LXW_CONDITIONAL_BAR_AXIS_AUTOMATIC = lxw_conditional_bar_axis_position.LXW_CONDITIONAL_BAR_AXIS_AUTOMATIC;
    enum LXW_CONDITIONAL_BAR_AXIS_MIDPOINT = lxw_conditional_bar_axis_position.LXW_CONDITIONAL_BAR_AXIS_MIDPOINT;
    enum LXW_CONDITIONAL_BAR_AXIS_NONE = lxw_conditional_bar_axis_position.LXW_CONDITIONAL_BAR_AXIS_NONE;
    /** @brief Conditional format data bar directions.
 *
 * Values used to set the bar direction of a conditional format data bar.
 */
    enum lxw_conditional_format_bar_direction
    {
        /** Data bar direction is set by Excel based on the context of the data
     *  displayed. */
        LXW_CONDITIONAL_BAR_DIRECTION_CONTEXT = 0,
        /** Data bar direction is from right to left. */
        LXW_CONDITIONAL_BAR_DIRECTION_RIGHT_TO_LEFT = 1,
        /** Data bar direction is from left to right. */
        LXW_CONDITIONAL_BAR_DIRECTION_LEFT_TO_RIGHT = 2,
    }
    enum LXW_CONDITIONAL_BAR_DIRECTION_CONTEXT = lxw_conditional_format_bar_direction.LXW_CONDITIONAL_BAR_DIRECTION_CONTEXT;
    enum LXW_CONDITIONAL_BAR_DIRECTION_RIGHT_TO_LEFT = lxw_conditional_format_bar_direction.LXW_CONDITIONAL_BAR_DIRECTION_RIGHT_TO_LEFT;
    enum LXW_CONDITIONAL_BAR_DIRECTION_LEFT_TO_RIGHT = lxw_conditional_format_bar_direction.LXW_CONDITIONAL_BAR_DIRECTION_LEFT_TO_RIGHT;
    /** @brief Conditional format rule types.
 *
 * Conditional format rule types that apply to Color Scale and Data Bars.
 */
    enum lxw_conditional_format_rule_types
    {

        LXW_CONDITIONAL_RULE_TYPE_NONE = 0,
        /** Conditional format rule type: matches the minimum values in the
     *  range. Can only be applied to min_rule_type.*/
        LXW_CONDITIONAL_RULE_TYPE_MINIMUM = 1,
        /** Conditional format rule type: use a number to set the bound.*/
        LXW_CONDITIONAL_RULE_TYPE_NUMBER = 2,
        /** Conditional format rule type: use a percentage to set the bound.*/
        LXW_CONDITIONAL_RULE_TYPE_PERCENT = 3,
        /** Conditional format rule type: use a percentile to set the bound.*/
        LXW_CONDITIONAL_RULE_TYPE_PERCENTILE = 4,
        /** Conditional format rule type: use a formula to set the bound.*/
        LXW_CONDITIONAL_RULE_TYPE_FORMULA = 5,
        /** Conditional format rule type: matches the maximum values in the
     *  range. Can only be applied to max_rule_type.*/
        LXW_CONDITIONAL_RULE_TYPE_MAXIMUM = 6,
        /** Conditional format rule type: matches the maximum values in the
     *  range. Can only be applied to max_rule_type.*/
        LXW_CONDITIONAL_RULE_TYPE_AUTO_MIN = 7,
        /** Conditional format rule type: matches the maximum values in the
     *  range. Can only be applied to max_rule_type.*/
        LXW_CONDITIONAL_RULE_TYPE_AUTO_MAX = 8,
    }
    enum LXW_CONDITIONAL_RULE_TYPE_NONE = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_NONE;
    enum LXW_CONDITIONAL_RULE_TYPE_MINIMUM = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_MINIMUM;
    enum LXW_CONDITIONAL_RULE_TYPE_NUMBER = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_NUMBER;
    enum LXW_CONDITIONAL_RULE_TYPE_PERCENT = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_PERCENT;
    enum LXW_CONDITIONAL_RULE_TYPE_PERCENTILE = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_PERCENTILE;
    enum LXW_CONDITIONAL_RULE_TYPE_FORMULA = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_FORMULA;
    enum LXW_CONDITIONAL_RULE_TYPE_MAXIMUM = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_MAXIMUM;
    enum LXW_CONDITIONAL_RULE_TYPE_AUTO_MIN = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_AUTO_MIN;
    enum LXW_CONDITIONAL_RULE_TYPE_AUTO_MAX = lxw_conditional_format_rule_types.LXW_CONDITIONAL_RULE_TYPE_AUTO_MAX;
    /** @brief The criteria used in a conditional format.
 *
 * Criteria used to define how a conditional format works.
 */
    enum lxw_conditional_criteria
    {

        LXW_CONDITIONAL_CRITERIA_NONE = 0,
        /** Format cells equal to a value. */
        LXW_CONDITIONAL_CRITERIA_EQUAL_TO = 1,
        /** Format cells not equal to a value. */
        LXW_CONDITIONAL_CRITERIA_NOT_EQUAL_TO = 2,
        /** Format cells greater than a value. */
        LXW_CONDITIONAL_CRITERIA_GREATER_THAN = 3,
        /** Format cells less than a value. */
        LXW_CONDITIONAL_CRITERIA_LESS_THAN = 4,
        /** Format cells greater than or equal to a value. */
        LXW_CONDITIONAL_CRITERIA_GREATER_THAN_OR_EQUAL_TO = 5,
        /** Format cells less than or equal to a value. */
        LXW_CONDITIONAL_CRITERIA_LESS_THAN_OR_EQUAL_TO = 6,
        /** Format cells between two values. */
        LXW_CONDITIONAL_CRITERIA_BETWEEN = 7,
        /** Format cells that is not between two values. */
        LXW_CONDITIONAL_CRITERIA_NOT_BETWEEN = 8,
        /** Format cells that contain the specified text. */
        LXW_CONDITIONAL_CRITERIA_TEXT_CONTAINING = 9,
        /** Format cells that don't contain the specified text. */
        LXW_CONDITIONAL_CRITERIA_TEXT_NOT_CONTAINING = 10,
        /** Format cells that begin with the specified text. */
        LXW_CONDITIONAL_CRITERIA_TEXT_BEGINS_WITH = 11,
        /** Format cells that end with the specified text. */
        LXW_CONDITIONAL_CRITERIA_TEXT_ENDS_WITH = 12,
        /** Format cells with a date of yesterday. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_YESTERDAY = 13,
        /** Format cells with a date of today. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_TODAY = 14,
        /** Format cells with a date of tomorrow. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_TOMORROW = 15,
        /** Format cells with a date in the last 7 days. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_7_DAYS = 16,
        /** Format cells with a date in the last week. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_WEEK = 17,
        /** Format cells with a date in the current week. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_THIS_WEEK = 18,
        /** Format cells with a date in the next week. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_NEXT_WEEK = 19,
        /** Format cells with a date in the last month. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_MONTH = 20,
        /** Format cells with a date in the current month. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_THIS_MONTH = 21,
        /** Format cells with a date in the next month. */
        LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_NEXT_MONTH = 22,
        /** Format cells above the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_ABOVE = 23,
        /** Format cells below the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_BELOW = 24,
        /** Format cells above or equal to the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_ABOVE_OR_EQUAL = 25,
        /** Format cells below or equal to the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_BELOW_OR_EQUAL = 26,
        /** Format cells 1 standard deviation above the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_1_STD_DEV_ABOVE = 27,
        /** Format cells 1 standard deviation below the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_1_STD_DEV_BELOW = 28,
        /** Format cells 2 standard deviation above the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_2_STD_DEV_ABOVE = 29,
        /** Format cells 2 standard deviation below the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_2_STD_DEV_BELOW = 30,
        /** Format cells 3 standard deviation above the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_3_STD_DEV_ABOVE = 31,
        /** Format cells 3 standard deviation below the average for the range. */
        LXW_CONDITIONAL_CRITERIA_AVERAGE_3_STD_DEV_BELOW = 32,
        /** Format cells in the top of bottom percentage. */
        LXW_CONDITIONAL_CRITERIA_TOP_OR_BOTTOM_PERCENT = 33,
    }
    enum LXW_CONDITIONAL_CRITERIA_NONE = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_NONE;
    enum LXW_CONDITIONAL_CRITERIA_EQUAL_TO = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_EQUAL_TO;
    enum LXW_CONDITIONAL_CRITERIA_NOT_EQUAL_TO = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_NOT_EQUAL_TO;
    enum LXW_CONDITIONAL_CRITERIA_GREATER_THAN = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_GREATER_THAN;
    enum LXW_CONDITIONAL_CRITERIA_LESS_THAN = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_LESS_THAN;
    enum LXW_CONDITIONAL_CRITERIA_GREATER_THAN_OR_EQUAL_TO = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_GREATER_THAN_OR_EQUAL_TO;
    enum LXW_CONDITIONAL_CRITERIA_LESS_THAN_OR_EQUAL_TO = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_LESS_THAN_OR_EQUAL_TO;
    enum LXW_CONDITIONAL_CRITERIA_BETWEEN = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_BETWEEN;
    enum LXW_CONDITIONAL_CRITERIA_NOT_BETWEEN = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_NOT_BETWEEN;
    enum LXW_CONDITIONAL_CRITERIA_TEXT_CONTAINING = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TEXT_CONTAINING;
    enum LXW_CONDITIONAL_CRITERIA_TEXT_NOT_CONTAINING = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TEXT_NOT_CONTAINING;
    enum LXW_CONDITIONAL_CRITERIA_TEXT_BEGINS_WITH = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TEXT_BEGINS_WITH;
    enum LXW_CONDITIONAL_CRITERIA_TEXT_ENDS_WITH = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TEXT_ENDS_WITH;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_YESTERDAY = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_YESTERDAY;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_TODAY = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_TODAY;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_TOMORROW = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_TOMORROW;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_7_DAYS = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_7_DAYS;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_WEEK = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_WEEK;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_THIS_WEEK = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_THIS_WEEK;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_NEXT_WEEK = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_NEXT_WEEK;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_MONTH = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_LAST_MONTH;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_THIS_MONTH = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_THIS_MONTH;
    enum LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_NEXT_MONTH = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TIME_PERIOD_NEXT_MONTH;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_ABOVE = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_ABOVE;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_BELOW = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_BELOW;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_ABOVE_OR_EQUAL = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_ABOVE_OR_EQUAL;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_BELOW_OR_EQUAL = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_BELOW_OR_EQUAL;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_1_STD_DEV_ABOVE = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_1_STD_DEV_ABOVE;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_1_STD_DEV_BELOW = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_1_STD_DEV_BELOW;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_2_STD_DEV_ABOVE = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_2_STD_DEV_ABOVE;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_2_STD_DEV_BELOW = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_2_STD_DEV_BELOW;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_3_STD_DEV_ABOVE = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_3_STD_DEV_ABOVE;
    enum LXW_CONDITIONAL_CRITERIA_AVERAGE_3_STD_DEV_BELOW = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_AVERAGE_3_STD_DEV_BELOW;
    enum LXW_CONDITIONAL_CRITERIA_TOP_OR_BOTTOM_PERCENT = lxw_conditional_criteria.LXW_CONDITIONAL_CRITERIA_TOP_OR_BOTTOM_PERCENT;
    /** @brief Type definitions for conditional formats.
 *
 * Values used to set the "type" field of conditional format.
 */
    enum lxw_conditional_format_types
    {

        LXW_CONDITIONAL_TYPE_NONE = 0,
        /** The Cell type is the most common conditional formatting type. It is
     *  used when a format is applied to a cell based on a simple
     *  criterion.  */
        LXW_CONDITIONAL_TYPE_CELL = 1,
        /** The Text type is used to specify Excel's "Specific Text" style
     *  conditional format. */
        LXW_CONDITIONAL_TYPE_TEXT = 2,
        /** The Time Period type is used to specify Excel's "Dates Occurring"
     *  style conditional format. */
        LXW_CONDITIONAL_TYPE_TIME_PERIOD = 3,
        /** The Average type is used to specify Excel's "Average" style
     *  conditional format. */
        LXW_CONDITIONAL_TYPE_AVERAGE = 4,
        /** The Duplicate type is used to highlight duplicate cells in a range. */
        LXW_CONDITIONAL_TYPE_DUPLICATE = 5,
        /** The Unique type is used to highlight unique cells in a range. */
        LXW_CONDITIONAL_TYPE_UNIQUE = 6,
        /** The Top type is used to specify the top n values by number or
     *  percentage in a range. */
        LXW_CONDITIONAL_TYPE_TOP = 7,
        /** The Bottom type is used to specify the bottom n values by number or
     *  percentage in a range. */
        LXW_CONDITIONAL_TYPE_BOTTOM = 8,
        /** The Blanks type is used to highlight blank cells in a range. */
        LXW_CONDITIONAL_TYPE_BLANKS = 9,
        /** The No Blanks type is used to highlight non blank cells in a range. */
        LXW_CONDITIONAL_TYPE_NO_BLANKS = 10,
        /** The Errors type is used to highlight error cells in a range. */
        LXW_CONDITIONAL_TYPE_ERRORS = 11,
        /** The No Errors type is used to highlight non error cells in a range. */
        LXW_CONDITIONAL_TYPE_NO_ERRORS = 12,
        /** The Formula type is used to specify a conditional format based on a
     *  user defined formula. */
        LXW_CONDITIONAL_TYPE_FORMULA = 13,
        /** The 2 Color Scale type is used to specify Excel's "2 Color Scale"
     *  style conditional format. */
        LXW_CONDITIONAL_2_COLOR_SCALE = 14,
        /** The 3 Color Scale type is used to specify Excel's "3 Color Scale"
     *  style conditional format. */
        LXW_CONDITIONAL_3_COLOR_SCALE = 15,
        /** The Data Bar type is used to specify Excel's "Data Bar" style
     *  conditional format. */
        LXW_CONDITIONAL_DATA_BAR = 16,
        /** The Icon Set type is used to specify a conditional format with a set
     *  of icons such as traffic lights or arrows. */
        LXW_CONDITIONAL_TYPE_ICON_SETS = 17,
        /** The Icon Set type is used to specify a conditional format with a set
     *  of icons such as traffic lights or arrows. */
        LXW_CONDITIONAL_TYPE_LAST = 18,
    }
    enum LXW_CONDITIONAL_TYPE_NONE = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_NONE;
    enum LXW_CONDITIONAL_TYPE_CELL = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_CELL;
    enum LXW_CONDITIONAL_TYPE_TEXT = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_TEXT;
    enum LXW_CONDITIONAL_TYPE_TIME_PERIOD = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_TIME_PERIOD;
    enum LXW_CONDITIONAL_TYPE_AVERAGE = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_AVERAGE;
    enum LXW_CONDITIONAL_TYPE_DUPLICATE = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_DUPLICATE;
    enum LXW_CONDITIONAL_TYPE_UNIQUE = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_UNIQUE;
    enum LXW_CONDITIONAL_TYPE_TOP = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_TOP;
    enum LXW_CONDITIONAL_TYPE_BOTTOM = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_BOTTOM;
    enum LXW_CONDITIONAL_TYPE_BLANKS = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_BLANKS;
    enum LXW_CONDITIONAL_TYPE_NO_BLANKS = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_NO_BLANKS;
    enum LXW_CONDITIONAL_TYPE_ERRORS = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_ERRORS;
    enum LXW_CONDITIONAL_TYPE_NO_ERRORS = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_NO_ERRORS;
    enum LXW_CONDITIONAL_TYPE_FORMULA = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_FORMULA;
    enum LXW_CONDITIONAL_2_COLOR_SCALE = lxw_conditional_format_types.LXW_CONDITIONAL_2_COLOR_SCALE;
    enum LXW_CONDITIONAL_3_COLOR_SCALE = lxw_conditional_format_types.LXW_CONDITIONAL_3_COLOR_SCALE;
    enum LXW_CONDITIONAL_DATA_BAR = lxw_conditional_format_types.LXW_CONDITIONAL_DATA_BAR;
    enum LXW_CONDITIONAL_TYPE_ICON_SETS = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_ICON_SETS;
    enum LXW_CONDITIONAL_TYPE_LAST = lxw_conditional_format_types.LXW_CONDITIONAL_TYPE_LAST;
    /** Set the display type for a cell comment. This is hidden by default but
 *  can be set to visible with the `worksheet_show_comments()` function. */
    enum lxw_comment_display_types
    {
        /** Default to the worksheet default which can be hidden or visible.*/
        LXW_COMMENT_DISPLAY_DEFAULT = 0,
        /** Hide the cell comment. Usually the default. */
        LXW_COMMENT_DISPLAY_HIDDEN = 1,
        /** Show the cell comment. Can also be set for the worksheet with the
     *  `worksheet_show_comments()` function.*/
        LXW_COMMENT_DISPLAY_VISIBLE = 2,
    }
    enum LXW_COMMENT_DISPLAY_DEFAULT = lxw_comment_display_types.LXW_COMMENT_DISPLAY_DEFAULT;
    enum LXW_COMMENT_DISPLAY_HIDDEN = lxw_comment_display_types.LXW_COMMENT_DISPLAY_HIDDEN;
    enum LXW_COMMENT_DISPLAY_VISIBLE = lxw_comment_display_types.LXW_COMMENT_DISPLAY_VISIBLE;
    /** Data validation error types for pop-up messages. */
    enum lxw_validation_error_types
    {
        /** Show a "Stop" data validation pop-up message. This is the default. */
        LXW_VALIDATION_ERROR_TYPE_STOP = 0,
        /** Show an "Error" data validation pop-up message. */
        LXW_VALIDATION_ERROR_TYPE_WARNING = 1,
        /** Show an "Information" data validation pop-up message. */
        LXW_VALIDATION_ERROR_TYPE_INFORMATION = 2,
    }
    enum LXW_VALIDATION_ERROR_TYPE_STOP = lxw_validation_error_types.LXW_VALIDATION_ERROR_TYPE_STOP;
    enum LXW_VALIDATION_ERROR_TYPE_WARNING = lxw_validation_error_types.LXW_VALIDATION_ERROR_TYPE_WARNING;
    enum LXW_VALIDATION_ERROR_TYPE_INFORMATION = lxw_validation_error_types.LXW_VALIDATION_ERROR_TYPE_INFORMATION;
    /** Data validation criteria uses to control the selection of data. */
    enum lxw_validation_criteria
    {

        LXW_VALIDATION_CRITERIA_NONE = 0,
        /** Select data between two values. */
        LXW_VALIDATION_CRITERIA_BETWEEN = 1,
        /** Select data that is not between two values. */
        LXW_VALIDATION_CRITERIA_NOT_BETWEEN = 2,
        /** Select data equal to a value. */
        LXW_VALIDATION_CRITERIA_EQUAL_TO = 3,
        /** Select data not equal to a value. */
        LXW_VALIDATION_CRITERIA_NOT_EQUAL_TO = 4,
        /** Select data greater than a value. */
        LXW_VALIDATION_CRITERIA_GREATER_THAN = 5,
        /** Select data less than a value. */
        LXW_VALIDATION_CRITERIA_LESS_THAN = 6,
        /** Select data greater than or equal to a value. */
        LXW_VALIDATION_CRITERIA_GREATER_THAN_OR_EQUAL_TO = 7,
        /** Select data less than or equal to a value. */
        LXW_VALIDATION_CRITERIA_LESS_THAN_OR_EQUAL_TO = 8,
    }
    enum LXW_VALIDATION_CRITERIA_NONE = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_NONE;
    enum LXW_VALIDATION_CRITERIA_BETWEEN = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_BETWEEN;
    enum LXW_VALIDATION_CRITERIA_NOT_BETWEEN = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_NOT_BETWEEN;
    enum LXW_VALIDATION_CRITERIA_EQUAL_TO = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_EQUAL_TO;
    enum LXW_VALIDATION_CRITERIA_NOT_EQUAL_TO = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_NOT_EQUAL_TO;
    enum LXW_VALIDATION_CRITERIA_GREATER_THAN = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_GREATER_THAN;
    enum LXW_VALIDATION_CRITERIA_LESS_THAN = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_LESS_THAN;
    enum LXW_VALIDATION_CRITERIA_GREATER_THAN_OR_EQUAL_TO = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_GREATER_THAN_OR_EQUAL_TO;
    enum LXW_VALIDATION_CRITERIA_LESS_THAN_OR_EQUAL_TO = lxw_validation_criteria.LXW_VALIDATION_CRITERIA_LESS_THAN_OR_EQUAL_TO;
    /** Data validation types. */
    enum lxw_validation_types
    {

        LXW_VALIDATION_TYPE_NONE = 0,
        /** Restrict cell input to whole/integer numbers only. */
        LXW_VALIDATION_TYPE_INTEGER = 1,
        /** Restrict cell input to whole/integer numbers only, using a cell
     *  reference. */
        LXW_VALIDATION_TYPE_INTEGER_FORMULA = 2,
        /** Restrict cell input to decimal numbers only. */
        LXW_VALIDATION_TYPE_DECIMAL = 3,
        /** Restrict cell input to decimal numbers only, using a cell
     * reference. */
        LXW_VALIDATION_TYPE_DECIMAL_FORMULA = 4,
        /** Restrict cell input to a list of strings in a dropdown. */
        LXW_VALIDATION_TYPE_LIST = 5,
        /** Restrict cell input to a list of strings in a dropdown, using a
     * cell range. */
        LXW_VALIDATION_TYPE_LIST_FORMULA = 6,
        /** Restrict cell input to date values only, using a lxw_datetime type. */
        LXW_VALIDATION_TYPE_DATE = 7,
        /** Restrict cell input to date values only, using a cell reference. */
        LXW_VALIDATION_TYPE_DATE_FORMULA = 8,
        /** Restrict cell input to date values only, using a cell reference. */
        LXW_VALIDATION_TYPE_DATE_NUMBER = 9,
        /** Restrict cell input to time values only, using a lxw_datetime type. */
        LXW_VALIDATION_TYPE_TIME = 10,
        /** Restrict cell input to time values only, using a cell reference. */
        LXW_VALIDATION_TYPE_TIME_FORMULA = 11,
        /** Restrict cell input to time values only, using a cell reference. */
        LXW_VALIDATION_TYPE_TIME_NUMBER = 12,
        /** Restrict cell input to strings of defined length, using a cell
     * reference. */
        LXW_VALIDATION_TYPE_LENGTH = 13,
        /** Restrict cell input to strings of defined length, using a cell
     * reference. */
        LXW_VALIDATION_TYPE_LENGTH_FORMULA = 14,
        /** Restrict cell to input controlled by a custom formula that returns
     * `TRUE/FALSE`. */
        LXW_VALIDATION_TYPE_CUSTOM_FORMULA = 15,
        /** Allow any type of input. Mainly only useful for pop-up messages. */
        LXW_VALIDATION_TYPE_ANY = 16,
    }
    enum LXW_VALIDATION_TYPE_NONE = lxw_validation_types.LXW_VALIDATION_TYPE_NONE;
    enum LXW_VALIDATION_TYPE_INTEGER = lxw_validation_types.LXW_VALIDATION_TYPE_INTEGER;
    enum LXW_VALIDATION_TYPE_INTEGER_FORMULA = lxw_validation_types.LXW_VALIDATION_TYPE_INTEGER_FORMULA;
    enum LXW_VALIDATION_TYPE_DECIMAL = lxw_validation_types.LXW_VALIDATION_TYPE_DECIMAL;
    enum LXW_VALIDATION_TYPE_DECIMAL_FORMULA = lxw_validation_types.LXW_VALIDATION_TYPE_DECIMAL_FORMULA;
    enum LXW_VALIDATION_TYPE_LIST = lxw_validation_types.LXW_VALIDATION_TYPE_LIST;
    enum LXW_VALIDATION_TYPE_LIST_FORMULA = lxw_validation_types.LXW_VALIDATION_TYPE_LIST_FORMULA;
    enum LXW_VALIDATION_TYPE_DATE = lxw_validation_types.LXW_VALIDATION_TYPE_DATE;
    enum LXW_VALIDATION_TYPE_DATE_FORMULA = lxw_validation_types.LXW_VALIDATION_TYPE_DATE_FORMULA;
    enum LXW_VALIDATION_TYPE_DATE_NUMBER = lxw_validation_types.LXW_VALIDATION_TYPE_DATE_NUMBER;
    enum LXW_VALIDATION_TYPE_TIME = lxw_validation_types.LXW_VALIDATION_TYPE_TIME;
    enum LXW_VALIDATION_TYPE_TIME_FORMULA = lxw_validation_types.LXW_VALIDATION_TYPE_TIME_FORMULA;
    enum LXW_VALIDATION_TYPE_TIME_NUMBER = lxw_validation_types.LXW_VALIDATION_TYPE_TIME_NUMBER;
    enum LXW_VALIDATION_TYPE_LENGTH = lxw_validation_types.LXW_VALIDATION_TYPE_LENGTH;
    enum LXW_VALIDATION_TYPE_LENGTH_FORMULA = lxw_validation_types.LXW_VALIDATION_TYPE_LENGTH_FORMULA;
    enum LXW_VALIDATION_TYPE_CUSTOM_FORMULA = lxw_validation_types.LXW_VALIDATION_TYPE_CUSTOM_FORMULA;
    enum LXW_VALIDATION_TYPE_ANY = lxw_validation_types.LXW_VALIDATION_TYPE_ANY;
    /** Data validation property values. */
    enum lxw_validation_boolean
    {

        LXW_VALIDATION_DEFAULT = 0,
        /** Turn a data validation property off. */
        LXW_VALIDATION_OFF = 1,
        /** Turn a data validation property on. Data validation properties are
     * generally on by default. */
        LXW_VALIDATION_ON = 2,
    }
    enum LXW_VALIDATION_DEFAULT = lxw_validation_boolean.LXW_VALIDATION_DEFAULT;
    enum LXW_VALIDATION_OFF = lxw_validation_boolean.LXW_VALIDATION_OFF;
    enum LXW_VALIDATION_ON = lxw_validation_boolean.LXW_VALIDATION_ON;
    /** Gridline options using in `worksheet_gridlines()`. */
    enum lxw_gridlines
    {
        /** Hide screen and print gridlines. */
        LXW_HIDE_ALL_GRIDLINES = 0,
        /** Show screen gridlines. */
        LXW_SHOW_SCREEN_GRIDLINES = 1,
        /** Show print gridlines. */
        LXW_SHOW_PRINT_GRIDLINES = 2,
        /** Show screen and print gridlines. */
        LXW_SHOW_ALL_GRIDLINES = 3,
    }
    enum LXW_HIDE_ALL_GRIDLINES = lxw_gridlines.LXW_HIDE_ALL_GRIDLINES;
    enum LXW_SHOW_SCREEN_GRIDLINES = lxw_gridlines.LXW_SHOW_SCREEN_GRIDLINES;
    enum LXW_SHOW_PRINT_GRIDLINES = lxw_gridlines.LXW_SHOW_PRINT_GRIDLINES;
    enum LXW_SHOW_ALL_GRIDLINES = lxw_gridlines.LXW_SHOW_ALL_GRIDLINES;

    void workbook_unset_default_url_format(lxw_workbook*) @nogc nothrow;

    void lxw_workbook_set_default_xf_indices(lxw_workbook*) @nogc nothrow;

    void lxw_workbook_assemble_xml_file(lxw_workbook*) @nogc nothrow;

    void lxw_workbook_free(lxw_workbook*) @nogc nothrow;
    /**
 * @brief Add a recommendation to open the file in "read-only" mode.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 *
 * This function can be used to set the Excel "Read-only Recommended" option
 * that is available when saving a file. This presents the user of the file
 * with an option to open it in "read-only" mode. This means that any changes
 * to the file can't be saved back to the same file and must be saved to a new
 * file. It can be set as follows:
 *
 * @code
 *     workbook_read_only_recommended(workbook);
 * @endcode
 *
 * Which will raise a dialog like the following when opening the file:
 *
 * @image html read_only.png
 */
    void workbook_read_only_recommended(lxw_workbook*) @nogc nothrow;
    /**
 * @brief Set the VBA name for the workbook.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     Name of the workbook used by VBA.
 *
 * The `workbook_set_vba_name()` function can be used to set the VBA name for
 * the workbook. This is sometimes required when a vbaProject macro included
 * via `workbook_add_vba_project()` refers to the workbook by a name other
 * than `ThisWorkbook`.
 *
 * @code
 *     workbook_set_vba_name(workbook, "MyWorkbook");
 * @endcode
 *
 * If an Excel VBA name for the workbook isn't specified then libxlsxwriter
 * will use `ThisWorkbook`.
 *
 * See also @ref working_with_macros
 *
 * @return A #lxw_error.
 */
    lxw_error workbook_set_vba_name(lxw_workbook*, const(char)*) @nogc nothrow;
    /**
 * @brief Add a vbaProject binary to the Excel workbook.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param filename The path/filename of the vbaProject.bin file.
 *
 * The `%workbook_add_vba_project()` function can be used to add macros or
 * functions to a workbook using a binary VBA project file that has been
 * extracted from an existing Excel xlsm file:
 *
 * @code
 *     workbook_add_vba_project(workbook, "vbaProject.bin");
 * @endcode
 *
 * Only one `vbaProject.bin file` can be added per workbook. The name doesn't
 * have to be `vbaProject.bin`. Any suitable path/name for an existing VBA bin
 * file will do.
 *
 * Once you add a VBA project had been add to an libxlsxwriter workbook you
 * should ensure that the file extension is `.xlsm` to prevent Excel from
 * giving a warning when it opens the file:
 *
 * @code
 *     lxw_workbook *workbook = new_workbook("macro.xlsm");
 * @endcode
 *
 * See also @ref working_with_macros
 *
 * @return A #lxw_error.
 */
    lxw_error workbook_add_vba_project(lxw_workbook*, const(char)*) @nogc nothrow;
    /**
 * @brief Validate a worksheet or chartsheet name.
 *
 * @param workbook  Pointer to a lxw_workbook instance.
 * @param sheetname Sheet name to validate.
 *
 * @return A #lxw_error.
 *
 * This function is used to validate a worksheet or chartsheet name according
 * to the rules used by Excel:
 *
 * - The name is less than or equal to 31 UTF-8 characters.
 * - The name doesn't contain any of the characters: ` [ ] : * ? / \ `
 * - The name doesn't start or end with an apostrophe.
 * - The name isn't already in use. (Case insensitive, see the note below).
 *
 * @code
 *     lxw_error err = workbook_validate_sheet_name(workbook, "Foglio");
 * @endcode
 *
 * This function is called by `workbook_add_worksheet()` and
 * `workbook_add_chartsheet()` but it can be explicitly called by the user
 * beforehand to ensure that the sheet name is valid.
 *
 * @note You should also avoid using the worksheet name "History" (case
 * insensitive) which is reserved in English language versions of
 * Excel. Non-English versions may have restrictions on the equivalent word.
 *
 * @note This function does an ASCII lowercase string comparison to determine
 * if the sheet name is already in use. It doesn't take UTF-8 characters into
 * account. Thus it would flag "Café" and "café" as a duplicate (just like
 * Excel) but it wouldn't catch "CAFÉ". If you need a full UTF-8 case
 * insensitive check you should use a third party library to implement it.
 *
 */
    lxw_error workbook_validate_sheet_name(lxw_workbook*, const(char)*) @nogc nothrow;
    /**
 * @brief Get a chartsheet object from its name.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     chartsheet name.
 *
 * @return A lxw_chartsheet object.
 *
 * This function returns a lxw_chartsheet object reference based on its name:
 *
 * @code
 *     chartsheet = workbook_get_chartsheet_by_name(workbook, "Chart1");
 * @endcode
 *
 */
    lxw_chartsheet* workbook_get_chartsheet_by_name(lxw_workbook*, const(char)*) @nogc nothrow;
    /**
 * @brief Get a worksheet object from its name.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     Worksheet name.
 *
 * @return A lxw_worksheet object.
 *
 * This function returns a lxw_worksheet object reference based on its name:
 *
 * @code
 *     worksheet = workbook_get_worksheet_by_name(workbook, "Sheet1");
 * @endcode
 *
 */
    lxw_worksheet* workbook_get_worksheet_by_name(lxw_workbook*, const(char)*) @nogc nothrow;
    /**
 * @brief Get the default URL format used with `worksheet_write_url()`.
 *
 * @param  workbook Pointer to a lxw_workbook instance.
 * @return A lxw_format instance that has hyperlink properties set.
 *
 * This function returns a lxw_format instance that is used for the default
 * blue underline hyperlink in the `worksheet_write_url()` function when a
 * format isn't specified:
 *
 * @code
 *     lxw_format *url_format = workbook_get_default_url_format(workbook);
 * @endcode
 *
 * The format is the hyperlink style defined by Excel for the default theme.
 * This format is only ever required when overwriting a string URL with
 * data of a different type. See the example below.
 */
    lxw_format* workbook_get_default_url_format(lxw_workbook*) @nogc nothrow;
    /**
 * @brief Create a defined name in the workbook to use as a variable.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     The defined name.
 * @param formula  The cell or range that the defined name refers to.
 *
 * @return A #lxw_error.
 *
 * This function is used to defined a name that can be used to represent a
 * value, a single cell or a range of cells in a workbook: These defined names
 * can then be used in formulas:
 *
 * @code
 *     workbook_define_name(workbook, "Exchange_rate", "=0.96");
 *     worksheet_write_formula(worksheet, 2, 1, "=Exchange_rate", NULL);
 *
 * @endcode
 *
 * @image html defined_name.png
 *
 * As in Excel a name defined like this is "global" to the workbook and can be
 * referred to from any worksheet:
 *
 * @code
 *     // Global workbook name.
 *     workbook_define_name(workbook, "Sales", "=Sheet1!$G$1:$H$10");
 * @endcode
 *
 * It is also possible to define a local/worksheet name by prefixing it with
 * the sheet name using the syntax `'sheetname!definedname'`:
 *
 * @code
 *     // Local worksheet name.
 *     workbook_define_name(workbook, "Sheet2!Sales", "=Sheet2!$G$1:$G$10");
 * @endcode
 *
 * If the sheet name contains spaces or special characters you must follow the
 * Excel convention and enclose it in single quotes:
 *
 * @code
 *     workbook_define_name(workbook, "'New Data'!Sales", "=Sheet2!$G$1:$G$10");
 * @endcode
 *
 * The rules for names in Excel are explained in the
 * [Microsoft Office documentation](http://office.microsoft.com/en-001/excel-help/define-and-use-names-in-formulas-HA010147120.aspx).
 *
 */
    lxw_error workbook_define_name(lxw_workbook*, const(char)*, const(char)*) @nogc nothrow;
    /**
 * @brief Set a custom document date or time property.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     The name of the custom property.
 * @param datetime The value of the custom property.
 *
 * @return A #lxw_error.
 *
 * Set a custom date or time number property.
 * See `workbook_set_custom_property_string()` above for details.
 *
 * @code
 *     lxw_datetime datetime  = {2016, 12, 1,  11, 55, 0.0};
 *
 *     workbook_set_custom_property_datetime(workbook, "Date completed", &datetime);
 * @endcode
 */
    lxw_error workbook_set_custom_property_datetime(lxw_workbook*, const(char)*, lxw_datetime*) @nogc nothrow;
    /**
 * @brief Set a custom document boolean property.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     The name of the custom property.
 * @param value    The value of the custom property.
 *
 * @return A #lxw_error.
 *
 * Set a custom document boolean property.
 * See `workbook_set_custom_property_string()` above for details.
 *
 * @code
 *     workbook_set_custom_property_boolean(workbook, "Has Review", 1);
 * @endcode
 */
    lxw_error workbook_set_custom_property_boolean(lxw_workbook*, const(char)*, ubyte) @nogc nothrow;

    lxw_error workbook_set_custom_property_integer(lxw_workbook*, const(char)*, int) @nogc nothrow;
    /**
 * @brief Set a custom document number property.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     The name of the custom property.
 * @param value    The value of the custom property.
 *
 * @return A #lxw_error.
 *
 * Set a custom document number property.
 * See `workbook_set_custom_property_string()` above for details.
 *
 * @code
 *     workbook_set_custom_property_number(workbook, "Document number", 12345);
 * @endcode
 */
    lxw_error workbook_set_custom_property_number(lxw_workbook*, const(char)*, double) @nogc nothrow;
    /**
 * @brief Set a custom document text property.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 * @param name     The name of the custom property.
 * @param value    The value of the custom property.
 *
 * @return A #lxw_error.
 *
 * The `%workbook_set_custom_property_string()` function can be used to set one
 * or more custom document text properties not covered by the standard
 * properties in the `workbook_set_properties()` function above.
 *
 *  For example:
 *
 * @code
 *     workbook_set_custom_property_string(workbook, "Checked by", "Eve");
 * @endcode
 *
 * @image html custom_properties.png
 *
 * There are 4 `workbook_set_custom_property_string_*()` functions for each
 * of the custom property types supported by Excel:
 *
 * - text/string: `workbook_set_custom_property_string()`
 * - number:      `workbook_set_custom_property_number()`
 * - datetime:    `workbook_set_custom_property_datetime()`
 * - boolean:     `workbook_set_custom_property_boolean()`
 *
 * **Note**: the name and value parameters are limited to 255 characters
 * by Excel.
 *
 */
    lxw_error workbook_set_custom_property_string(lxw_workbook*, const(char)*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the document properties such as Title, Author etc.
 *
 * @param workbook   Pointer to a lxw_workbook instance.
 * @param properties Document properties to set.
 *
 * @return A #lxw_error.
 *
 * The `%workbook_set_properties` function can be used to set the document
 * properties of the Excel file created by `libxlsxwriter`. These properties
 * are visible when you use the `Office Button -> Prepare -> Properties`
 * option in Excel and are also available to external applications that read
 * or index windows files.
 *
 * The properties that can be set are:
 *
 * - `title`
 * - `subject`
 * - `author`
 * - `manager`
 * - `company`
 * - `category`
 * - `keywords`
 * - `comments`
 * - `hyperlink_base`
 * - `created`
 *
 * The properties are specified via a `lxw_doc_properties` struct. All the
 * fields are all optional. An example of how to create and pass the
 * properties is:
 *
 * @code
 *     // Create a properties structure and set some of the fields.
 *     lxw_doc_properties properties = {
 *         .title    = "This is an example spreadsheet",
 *         .subject  = "With document properties",
 *         .author   = "John McNamara",
 *         .manager  = "Dr. Heinz Doofenshmirtz",
 *         .company  = "of Wolves",
 *         .category = "Example spreadsheets",
 *         .keywords = "Sample, Example, Properties",
 *         .comments = "Created with libxlsxwriter",
 *         .status   = "Quo",
 *     };
 *
 *     // Set the properties in the workbook.
 *     workbook_set_properties(workbook, &properties);
 * @endcode
 *
 * @image html doc_properties.png
 *
 * The `created` parameter sets the file creation date/time shown in
 * Excel. This defaults to the current time and date if set to 0. If you wish
 * to create files that are binary equivalent (for the same input data) then
 * you should set this creation date/time to a known value using a `time_t`
 * value.
 *
 */
    lxw_error workbook_set_properties(lxw_workbook*, lxw_doc_properties*) @nogc nothrow;
    /**
 * @brief Close the Workbook object and write the XLSX file.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 *
 * @return A #lxw_error.
 *
 * The `%workbook_close()` function closes a Workbook object, writes the Excel
 * file to disk, frees any memory allocated internally to the Workbook and
 * frees the object itself.
 *
 * @code
 *     workbook_close(workbook);
 * @endcode
 *
 * The `%workbook_close()` function returns any #lxw_error error codes
 * encountered when creating the Excel file. The error code can be returned
 * from the program main or the calling function:
 *
 * @code
 *     return workbook_close(workbook);
 * @endcode
 *
 */
    lxw_error workbook_close(lxw_workbook*) @nogc nothrow;
    /**
 * @brief Create a new chart to be added to a worksheet:
 *
 * @param workbook   Pointer to a lxw_workbook instance.
 * @param chart_type The type of chart to be created. See #lxw_chart_type.
 *
 * @return A lxw_chart object.
 *
 * The `%workbook_add_chart()` function creates a new chart object that can
 * be added to a worksheet:
 *
 * @code
 *     // Create a chart object.
 *     lxw_chart *chart = workbook_add_chart(workbook, LXW_CHART_COLUMN);
 *
 *     // Add data series to the chart.
 *     chart_add_series(chart, NULL, "Sheet1!$A$1:$A$5");
 *     chart_add_series(chart, NULL, "Sheet1!$B$1:$B$5");
 *     chart_add_series(chart, NULL, "Sheet1!$C$1:$C$5");
 *
 *     // Insert the chart into the worksheet
 *     worksheet_insert_chart(worksheet, CELL("B7"), chart);
 * @endcode
 *
 * The available chart types are defined in #lxw_chart_type. The types of
 * charts that are supported are:
 *
 * | Chart type                               | Description                            |
 * | :--------------------------------------- | :------------------------------------  |
 * | #LXW_CHART_AREA                          | Area chart.                            |
 * | #LXW_CHART_AREA_STACKED                  | Area chart - stacked.                  |
 * | #LXW_CHART_AREA_STACKED_PERCENT          | Area chart - percentage stacked.       |
 * | #LXW_CHART_BAR                           | Bar chart.                             |
 * | #LXW_CHART_BAR_STACKED                   | Bar chart - stacked.                   |
 * | #LXW_CHART_BAR_STACKED_PERCENT           | Bar chart - percentage stacked.        |
 * | #LXW_CHART_COLUMN                        | Column chart.                          |
 * | #LXW_CHART_COLUMN_STACKED                | Column chart - stacked.                |
 * | #LXW_CHART_COLUMN_STACKED_PERCENT        | Column chart - percentage stacked.     |
 * | #LXW_CHART_DOUGHNUT                      | Doughnut chart.                        |
 * | #LXW_CHART_LINE                          | Line chart.                            |
 * | #LXW_CHART_LINE_STACKED                  | Line chart - stacked.                  |
 * | #LXW_CHART_LINE_STACKED_PERCENT          | Line chart - percentage stacked.       |
 * | #LXW_CHART_PIE                           | Pie chart.                             |
 * | #LXW_CHART_SCATTER                       | Scatter chart.                         |
 * | #LXW_CHART_SCATTER_STRAIGHT              | Scatter chart - straight.              |
 * | #LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS | Scatter chart - straight with markers. |
 * | #LXW_CHART_SCATTER_SMOOTH                | Scatter chart - smooth.                |
 * | #LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS   | Scatter chart - smooth with markers.   |
 * | #LXW_CHART_RADAR                         | Radar chart.                           |
 * | #LXW_CHART_RADAR_WITH_MARKERS            | Radar chart - with markers.            |
 * | #LXW_CHART_RADAR_FILLED                  | Radar chart - filled.                  |
 *
 *
 *
 * See @ref chart.h for details.
 */
    lxw_chart* workbook_add_chart(lxw_workbook*, ubyte) @nogc nothrow;
    /**
 * @brief Create a new @ref format.h "Format" object to formats cells in
 *        worksheets.
 *
 * @param workbook Pointer to a lxw_workbook instance.
 *
 * @return A lxw_format instance.
 *
 * The `workbook_add_format()` function can be used to create new @ref
 * format.h "Format" objects which are used to apply formatting to a cell.
 *
 * @code
 *    // Create the Format.
 *    lxw_format *format = workbook_add_format(workbook);
 *
 *    // Set some of the format properties.
 *    format_set_bold(format);
 *    format_set_font_color(format, LXW_COLOR_RED);
 *
 *    // Use the format to change the text format in a cell.
 *    worksheet_write_string(worksheet, 0, 0, "Hello", format);
 * @endcode
 *
 * See @ref format.h "the Format object" and @ref working_with_formats
 * sections for more details about Format properties and how to set them.
 *
 */
    lxw_format* workbook_add_format(lxw_workbook*) @nogc nothrow;
    /**
 * @brief Add a new chartsheet to a workbook.
 *
 * @param workbook  Pointer to a lxw_workbook instance.
 * @param sheetname Optional chartsheet name, defaults to Chart1, etc.
 *
 * @return A lxw_chartsheet object.
 *
 * The `%workbook_add_chartsheet()` function adds a new chartsheet to a
 * workbook. The @ref chartsheet.h "Chartsheet" object is like a worksheet
 * except it displays a chart instead of cell data.
 *
 * @image html chartsheet.png
 *
 * The `sheetname` parameter is optional. If it is `NULL` the default
 * Excel convention will be followed, i.e. Chart1, Chart2, etc.:
 *
 * @code
 *     chartsheet = workbook_add_chartsheet(workbook, NULL  );     // Chart1
 *     chartsheet = workbook_add_chartsheet(workbook, "My Chart"); // My Chart
 *     chartsheet = workbook_add_chartsheet(workbook, NULL  );     // Chart3
 *
 * @endcode
 *
 * The chartsheet name must be a valid Excel worksheet name, i.e.:
 *
 * - The name is less than or equal to 31 UTF-8 characters.
 * - The name doesn't contain any of the characters: ` [ ] : * ? / \ `
 * - The name doesn't start or end with an apostrophe.
 * - The name isn't already in use. (Case insensitive).
 *
 * If any of these errors are encountered the function will return NULL.
 * You can check for valid name using the `workbook_validate_sheet_name()`
 * function.
 *
 * @note You should also avoid using the worksheet name "History" (case
 * insensitive) which is reserved in English language versions of
 * Excel. Non-English versions may have restrictions on the equivalent word.
 *
 * At least one worksheet should be added to a new workbook when creating a
 * chartsheet in order to provide data for the chart. The @ref worksheet.h
 * "Worksheet" object is used to write data and configure a worksheet in the
 * workbook.
 */
    lxw_chartsheet* workbook_add_chartsheet(lxw_workbook*, const(char)*) @nogc nothrow;
    /**
 * @brief Add a new worksheet to a workbook.
 *
 * @param workbook  Pointer to a lxw_workbook instance.
 * @param sheetname Optional worksheet name, defaults to Sheet1, etc.
 *
 * @return A lxw_worksheet object.
 *
 * The `%workbook_add_worksheet()` function adds a new worksheet to a workbook.
 *
 * At least one worksheet should be added to a new workbook: The @ref
 * worksheet.h "Worksheet" object is used to write data and configure a
 * worksheet in the workbook.
 *
 * The `sheetname` parameter is optional. If it is `NULL` the default
 * Excel convention will be followed, i.e. Sheet1, Sheet2, etc.:
 *
 * @code
 *     worksheet = workbook_add_worksheet(workbook, NULL  );     // Sheet1
 *     worksheet = workbook_add_worksheet(workbook, "Foglio2");  // Foglio2
 *     worksheet = workbook_add_worksheet(workbook, "Data");     // Data
 *     worksheet = workbook_add_worksheet(workbook, NULL  );     // Sheet4
 *
 * @endcode
 *
 * @image html workbook02.png
 *
 * The worksheet name must be a valid Excel worksheet name, i.e:
 *
 * - The name is less than or equal to 31 UTF-8 characters.
 * - The name doesn't contain any of the characters: ` [ ] : * ? / \ `
 * - The name doesn't start or end with an apostrophe.
 * - The name isn't already in use. (Case insensitive).
 *
 * If any of these errors are encountered the function will return NULL.
 * You can check for valid name using the `workbook_validate_sheet_name()`
 * function.
 *
 * @note You should also avoid using the worksheet name "History" (case
 * insensitive) which is reserved in English language versions of
 * Excel. Non-English versions may have restrictions on the equivalent word.
 */
    lxw_worksheet* workbook_add_worksheet(lxw_workbook*, const(char)*) @nogc nothrow;
    /**
 * @brief Create a new workbook object, and set the workbook options.
 *
 * @param filename The name of the new Excel file to create.
 * @param options  Workbook options.
 *
 * @return A lxw_workbook instance.
 *
 * This function is the same as the `workbook_new()` constructor but allows
 * additional options to be set.
 *
 * @code
 *    lxw_workbook_options options = {.constant_memory = LXW_TRUE,
 *                                    .tmpdir = "C:\\Temp",
 *                                    .use_zip64 = LXW_FALSE,
 *                                    .output_buffer = NULL,
 *                                    .output_buffer_size = NULL};
 *
 *    lxw_workbook  *workbook  = workbook_new_opt("filename.xlsx", &options);
 * @endcode
 *
 * The options that can be set via #lxw_workbook_options are:
 *
 * - `constant_memory`: This option reduces the amount of data stored in
 *   memory so that large files can be written efficiently. This option is off
 *   by default. See the note below for limitations when this mode is on.
 *
 * - `tmpdir`: libxlsxwriter stores workbook data in temporary files prior to
 *   assembling the final XLSX file. The temporary files are created in the
 *   system's temp directory. If the default temporary directory isn't
 *   accessible to your application, or doesn't contain enough space, you can
 *   specify an alternative location using the `tmpdir` option.
 *
 * - `use_zip64`: Make the zip library use ZIP64 extensions when writing very
 *   large xlsx files to allow the zip container, or individual XML files
 *   within it, to be greater than 4 GB. See [ZIP64 on Wikipedia][zip64_wiki]
 *   for more information. This option is off by default.
 *
 *   [zip64_wiki]: https://en.wikipedia.org/wiki/Zip_(file_format)#ZIP64
 *
 * - `output_buffer`: Output to a memory buffer instead of a file. The buffer
 *   must be freed manually by calling `free()`. This option can only be used if
 *   filename is NULL.
 *
 * - `output_buffer_size`: Used with output_buffer to get the size of the
 *   created buffer. This option can only be used if filename is `NULL`.
 *
 * @note In `constant_memory` mode each row of in-memory data is written to
 * disk and then freed when a new row is started via one of the
 * `worksheet_write_*()` functions. Therefore, once this option is active data
 * should be written in sequential row by row order. For this reason
 * `worksheet_merge_range()` and some other row based functionality doesn't
 * work in this mode. See @ref ww_mem_constant for more details.
 *
 * @note Also, in `constant_memory` mode the library uses temp file storage
 * for worksheet data. This can lead to an issue on OSes that map the `/tmp`
 * directory into memory since it is possible to consume the "system" memory
 * even though the "process" memory remains constant. In these cases you
 * should use an alternative temp file location by using the `tmpdir` option
 * shown above. See @ref ww_mem_temp for more details.
 */
    lxw_workbook* workbook_new_opt(const(char)*, lxw_workbook_options*) @nogc nothrow;
    /**
 * @brief Create a new workbook object.
 *
 * @param filename The name of the new Excel file to create.
 *
 * @return A lxw_workbook instance.
 *
 * The `%workbook_new()` constructor is used to create a new Excel workbook
 * with a given filename:
 *
 * @code
 *     lxw_workbook *workbook  = workbook_new("filename.xlsx");
 * @endcode
 *
 * When specifying a filename it is recommended that you use an `.xlsx`
 * extension or Excel will generate a warning when opening the file.
 *
 */
    lxw_workbook* workbook_new(const(char)*) @nogc nothrow;
    /**
 * @brief Struct to represent an Excel workbook.
 *
 * The members of the lxw_workbook struct aren't modified directly. Instead
 * the workbook properties are set by calling the functions shown in
 * workbook.h.
 */
    struct lxw_workbook
    {

        _IO_FILE* file;

        lxw_sheets* sheets;

        lxw_worksheets* worksheets;

        lxw_chartsheets* chartsheets;

        lxw_worksheet_names* worksheet_names;

        lxw_chartsheet_names* chartsheet_names;

        lxw_image_md5s* image_md5s;

        lxw_image_md5s* header_image_md5s;

        lxw_image_md5s* background_md5s;

        lxw_charts* charts;

        lxw_charts* ordered_charts;

        lxw_formats* formats;

        lxw_defined_names* defined_names;

        lxw_sst* sst;

        lxw_doc_properties* properties;

        lxw_custom_properties* custom_properties;

        char* filename;

        lxw_workbook_options options;

        ushort num_sheets;

        ushort num_worksheets;

        ushort num_chartsheets;

        ushort first_sheet;

        ushort active_sheet;

        ushort num_xf_formats;

        ushort num_dxf_formats;

        ushort num_format_count;

        ushort drawing_count;

        ushort comment_count;

        ushort font_count;

        ushort border_count;

        ushort fill_count;

        ubyte optimize;

        ushort max_url_length;

        ubyte read_only;

        ubyte has_png;

        ubyte has_jpeg;

        ubyte has_bmp;

        ubyte has_gif;

        ubyte has_vml;

        ubyte has_comments;

        ubyte has_metadata;

        lxw_hash_table* used_xf_formats;

        lxw_hash_table* used_dxf_formats;

        char* vba_project;

        char* vba_codename;

        lxw_format* default_url_format;
    }
    /**
 * @brief Workbook options.
 *
 * Optional parameters when creating a new Workbook object via
 * workbook_new_opt().
 *
 * The following properties are supported:
 *
 * - `constant_memory`: This option reduces the amount of data stored in
 *   memory so that large files can be written efficiently. This option is off
 *   by default. See the notes below for limitations when this mode is on.
 *
 * - `tmpdir`: libxlsxwriter stores workbook data in temporary files prior to
 *   assembling the final XLSX file. The temporary files are created in the
 *   system's temp directory. If the default temporary directory isn't
 *   accessible to your application, or doesn't contain enough space, you can
 *   specify an alternative location using the `tmpdir` option.
 *
 * - `use_zip64`: Make the zip library use ZIP64 extensions when writing very
 *   large xlsx files to allow the zip container, or individual XML files
 *   within it, to be greater than 4 GB. See [ZIP64 on Wikipedia][zip64_wiki]
 *   for more information. This option is off by default.
 *
 *   [zip64_wiki]: https://en.wikipedia.org/wiki/Zip_(file_format)#ZIP64

 * - `output_buffer`: Output to a buffer instead of a file. The buffer must be
 *   freed manually by calling free(). This option can only be used if filename
 *   is NULL.
 *
 * - `output_buffer_size`: Used with output_buffer to get the size of the
 *   created buffer. This option can only be used if filename is NULL.
 *
 * @note In `constant_memory` mode each row of in-memory data is written to
 * disk and then freed when a new row is started via one of the
 * `worksheet_write_*()` functions. Therefore, once this option is active data
 * should be written in sequential row by row order. For this reason
 * `worksheet_merge_range()` and some other row based functionality doesn't
 * work in this mode. See @ref ww_mem_constant for more details.
 *
 * @note Also, in `constant_memory` mode the library uses temp file storage
 * for worksheet data. This can lead to an issue on OSes that map the `/tmp`
 * directory into memory since it is possible to consume the "system" memory
 * even though the "process" memory remains constant. In these cases you
 * should use an alternative temp file location by using the `tmpdir` option
 * shown above. See @ref ww_mem_temp for more details.
 */
    struct lxw_workbook_options
    {
        /** Optimize the workbook to use constant memory for worksheets. */
        ubyte constant_memory;
        /** Directory to use for the temporary files created by libxlsxwriter. */
        char* tmpdir;
        /** Allow ZIP64 extensions when creating the xlsx file zip container. */
        ubyte use_zip64;
        /** Output buffer to use instead of writing to a file */
        char** output_buffer;
        /** Used with output_buffer to get the size of the created buffer */
        c_ulong* output_buffer_size;
    }
    /**
 * Workbook document properties. Set any unused fields to NULL or 0.
 */
    struct lxw_doc_properties
    {
        /** The title of the Excel Document. */
        char* title;
        /** The subject of the Excel Document. */
        char* subject;
        /** The author of the Excel Document. */
        char* author;
        /** The manager field of the Excel Document. */
        char* manager;
        /** The company field of the Excel Document. */
        char* company;
        /** The category of the Excel Document. */
        char* category;
        /** The keywords of the Excel Document. */
        char* keywords;
        /** The comment field of the Excel Document. */
        char* comments;
        /** The status of the Excel Document. */
        char* status;
        /** The hyperlink base URL of the Excel Document. */
        char* hyperlink_base;
        /** The file creation date/time shown in Excel. This defaults to the
     * current time and date if set to 0. If you wish to create files that are
     * binary equivalent (for the same input data) then you should set this
     * creation date/time to a known value. */
        c_long created;
    }

    struct lxw_defined_name
    {

        short index;

        ubyte hidden;

        char[128] name;

        char[128] app_name;

        char[128] formula;

        char[128] normalised_name;

        char[128] normalised_sheetname;

        static struct _Anonymous_14
        {

            lxw_defined_name* tqe_next;

            lxw_defined_name** tqe_prev;
        }

        _Anonymous_14 list_pointers;
    }

    struct lxw_defined_names
    {

        lxw_defined_name* tqh_first;

        lxw_defined_name** tqh_last;
    }

    struct lxw_charts
    {

        lxw_chart* stqh_first;

        lxw_chart** stqh_last;
    }

    struct lxw_chartsheets
    {

        lxw_chartsheet* stqh_first;

        lxw_chartsheet** stqh_last;
    }

    struct lxw_worksheets
    {

        lxw_worksheet* stqh_first;

        lxw_worksheet** stqh_last;
    }

    struct lxw_sheets
    {

        lxw_sheet* stqh_first;

        lxw_sheet** stqh_last;
    }

    struct lxw_sheet
    {

        ubyte is_chartsheet;

        static union _Anonymous_15
        {

            lxw_worksheet* worksheet;

            lxw_chartsheet* chartsheet;
        }

        _Anonymous_15 u;

        static struct _Anonymous_16
        {

            lxw_sheet* stqe_next;
        }

        _Anonymous_16 list_pointers;
    }

    struct lxw_image_md5s
    {

        lxw_image_md5* rbh_root;
    }

    struct lxw_image_md5
    {

        uint id;

        char* md5;

        static struct _Anonymous_17
        {

            lxw_image_md5* rbe_left;

            lxw_image_md5* rbe_right;

            lxw_image_md5* rbe_parent;

            int rbe_color;
        }

        _Anonymous_17 tree_pointers;
    }

    struct lxw_chartsheet_names
    {

        lxw_chartsheet_name* rbh_root;
    }

    struct lxw_chartsheet_name
    {

        const(char)* name;

        lxw_chartsheet* chartsheet;

        static struct _Anonymous_18
        {

            lxw_chartsheet_name* rbe_left;

            lxw_chartsheet_name* rbe_right;

            lxw_chartsheet_name* rbe_parent;

            int rbe_color;
        }

        _Anonymous_18 tree_pointers;
    }

    struct lxw_worksheet_names
    {

        lxw_worksheet_name* rbh_root;
    }

    struct lxw_worksheet_name
    {

        const(char)* name;

        lxw_worksheet* worksheet;

        static struct _Anonymous_19
        {

            lxw_worksheet_name* rbe_left;

            lxw_worksheet_name* rbe_right;

            lxw_worksheet_name* rbe_parent;

            int rbe_color;
        }

        _Anonymous_19 tree_pointers;
    }

    void lxw_vml_assemble_xml_file(lxw_vml*) @nogc nothrow;

    void lxw_vml_free(lxw_vml*) @nogc nothrow;

    lxw_vml* lxw_vml_new() @nogc nothrow;

    struct lxw_vml
    {

        _IO_FILE* file;

        ubyte type;

        lxw_comment_objs* button_objs;

        lxw_comment_objs* comment_objs;

        lxw_comment_objs* image_objs;

        char* vml_data_id_str;

        uint vml_shape_id;

        ubyte comment_display_default;
    }

    ushort lxw_hash_password(const(char)*) @nogc nothrow;

    _IO_FILE* lxw_fopen(const(char)*, const(char)*) @nogc nothrow;

    _IO_FILE* lxw_get_filehandle(char**, c_ulong*, char*) @nogc nothrow;

    _IO_FILE* lxw_tmpfile(char*) @nogc nothrow;

    void lxw_str_tolower(char*) @nogc nothrow;

    c_ulong lxw_utf8_strlen(const(char)*) @nogc nothrow;

    char* lxw_strdup_formula(const(char)*) @nogc nothrow;

    char* lxw_strdup(const(char)*) @nogc nothrow;

    void* alloca(c_ulong) @nogc nothrow;

    double lxw_unixtime_to_excel_date_epoch(c_long, ubyte) @nogc nothrow;
    /**
 * @brief Converts a unix datetime to an Excel datetime number.
 *
 * @param unixtime Unix time (seconds since 1970-01-01)
 *
 * @return A double representing an Excel datetime.
 *
 * The `%lxw_unixtime_to_excel_date()` function converts a unix datetime to
 * an Excel datetime number:
 *
 * @code
 *     double excel_datetime = lxw_unixtime_to_excel_date(946684800);
 * @endcode
 *
 * See @ref working_with_dates for more details.
 */
    double lxw_unixtime_to_excel_date(c_long) @nogc nothrow;

    double lxw_datetime_to_excel_date_epoch(lxw_datetime*, ubyte) @nogc nothrow;
    /**
 * @brief Converts a #lxw_datetime to an Excel datetime number.
 *
 * @param datetime A pointer to a #lxw_datetime struct.
 *
 * @return A double representing an Excel datetime.
 *
 * The `%lxw_datetime_to_excel_datetime()` function converts a datetime in
 * #lxw_datetime to an Excel datetime number:
 *
 * @code
 *     lxw_datetime datetime = {2013, 2, 28, 12, 0, 0.0};
 *
 *     double excel_datetime = lxw_datetime_to_excel_date(&datetime);
 * @endcode
 *
 * See @ref working_with_dates for more details on the Excel datetime format.
 */
    double lxw_datetime_to_excel_datetime(lxw_datetime*) @nogc nothrow;

    ushort lxw_name_to_col_2(const(char)*) @nogc nothrow;

    uint lxw_name_to_row_2(const(char)*) @nogc nothrow;

    ushort lxw_name_to_col(const(char)*) @nogc nothrow;

    uint lxw_name_to_row(const(char)*) @nogc nothrow;

    void lxw_rowcol_to_formula_abs(char*, const(char)*, uint, ushort, uint, ushort) @nogc nothrow;

    void lxw_rowcol_to_range_abs(char*, uint, ushort, uint, ushort) @nogc nothrow;

    void lxw_rowcol_to_range(char*, uint, ushort, uint, ushort) @nogc nothrow;

    void lxw_rowcol_to_cell_abs(char*, uint, ushort, ubyte, ubyte) @nogc nothrow;

    void lxw_rowcol_to_cell(char*, uint, ushort) @nogc nothrow;

    void lxw_col_to_name(char*, ushort, ubyte) @nogc nothrow;

    char* lxw_quote_sheetname(const(char)*) @nogc nothrow;
    /**
 * @brief Converts a libxlsxwriter error number to a string.
 *
 * The `%lxw_strerror` function converts a libxlsxwriter error number defined
 * by #lxw_error to a pointer to a string description of the error.
 * Similar to the standard library strerror(3) function.
 *
 * For example:
 *
 * @code
 *     lxw_error error = workbook_close(workbook);
 *
 *     if (error)
 *         printf("Error in workbook_close().\n"
 *                "Error %d = %s\n", error, lxw_strerror(error));
 * @endcode
 *
 * This would produce output like the following if the target file wasn't
 * writable:
 *
 *     Error in workbook_close().
 *     Error 2 = Error creating output xlsx file. Usually a permissions error.
 *
 * @param error_num The error number returned by a libxlsxwriter function.
 *
 * @return A pointer to a statically allocated string. Do not free.
 */
    char* lxw_strerror(lxw_error) @nogc nothrow;
    /**
 * @brief Retrieve the library version ID.
 *
 * @return The version ID.
 *
 * Get the library version such as "X.Y.Z" as a XYZ integer.
 *
 *  @code
 *      printf("Libxlsxwriter version id = %d\n", lxw_version_id());
 *  @endcode
 *
 */
    ushort lxw_version_id() @nogc nothrow;
    /**
 * @brief Retrieve the library version.
 *
 * @return The "X.Y.Z" version string.
 *
 * Get the library version as a "X.Y.Z" version string
 *
 *  @code
 *      printf("Libxlsxwriter version = %s\n", lxw_version());
 *  @endcode
 *
 */
    const(char)* lxw_version() @nogc nothrow;

    int zipRemoveExtraInfoBlock(char*, int*, short) @nogc nothrow;

    int zipClose(void*, const(char)*) @nogc nothrow;

    int zipCloseFileInZipRaw64(void*, ulong, c_ulong) @nogc nothrow;

    int zipCloseFileInZipRaw(void*, c_ulong, c_ulong) @nogc nothrow;

    int zipCloseFileInZip(void*) @nogc nothrow;

    int zipWriteInFileInZip(void*, const(void)*, uint) @nogc nothrow;

    int zipOpenNewFileInZip4_64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong, c_ulong, c_ulong, int) @nogc nothrow;

    int zipOpenNewFileInZip4(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong, c_ulong, c_ulong) @nogc nothrow;

    int zipOpenNewFileInZip3_64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong, int) @nogc nothrow;

    int zipOpenNewFileInZip3(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong) @nogc nothrow;

    int zipOpenNewFileInZip2_64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int) @nogc nothrow;

    int zipOpenNewFileInZip2(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int) @nogc nothrow;

    int zipOpenNewFileInZip64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int) @nogc nothrow;

    int zipOpenNewFileInZip(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int) @nogc nothrow;

    void* zipOpen2_64(const(void)*, int, const(char)**, zlib_filefunc64_def_s*) @nogc nothrow;

    void* zipOpen2(const(char)*, int, const(char)**, zlib_filefunc_def_s*) @nogc nothrow;

    void* zipOpen64(const(void)*, int) @nogc nothrow;

    void* zipOpen(const(char)*, int) @nogc nothrow;

    alias zipcharpc = const(char)*;

    struct zip_fileinfo
    {

        tm_zip_s tmz_date;

        c_ulong dosDate;

        c_ulong internal_fa;

        c_ulong external_fa;
    }

    struct tm_zip_s
    {

        uint tm_sec;

        uint tm_min;

        uint tm_hour;

        uint tm_mday;

        uint tm_mon;

        uint tm_year;
    }

    alias tm_zip = tm_zip_s;

    alias zipFile = void*;

    void fill_zlib_filefunc64_32_def_from_filefunc32(zlib_filefunc64_32_def_s*, const(zlib_filefunc_def_s)*) @nogc nothrow;

    ulong call_ztell64(const(zlib_filefunc64_32_def_s)*, void*) @nogc nothrow;

    c_long call_zseek64(const(zlib_filefunc64_32_def_s)*, void*, ulong, int) @nogc nothrow;

    void* call_zopen64(const(zlib_filefunc64_32_def_s)*, const(void)*, int) @nogc nothrow;

    struct zlib_filefunc64_32_def_s
    {

        zlib_filefunc64_def_s zfile_func64;

        void* function(void*, const(char)*, int) zopen32_file;

        c_long function(void*, void*) ztell32_file;

        c_long function(void*, void*, c_ulong, int) zseek32_file;
    }

    alias zlib_filefunc64_32_def = zlib_filefunc64_32_def_s;

    void fill_fopen_filefunc(zlib_filefunc_def_s*) @nogc nothrow;

    void fill_fopen64_filefunc(zlib_filefunc64_def_s*) @nogc nothrow;

    struct zlib_filefunc64_def_s
    {

        void* function(void*, const(void)*, int) zopen64_file;

        c_ulong function(void*, void*, void*, c_ulong) zread_file;

        c_ulong function(void*, void*, const(void)*, c_ulong) zwrite_file;

        ulong function(void*, void*) ztell64_file;

        c_long function(void*, void*, ulong, int) zseek64_file;

        int function(void*, void*) zclose_file;

        int function(void*, void*) zerror_file;

        void* opaque;
    }

    alias zlib_filefunc64_def = zlib_filefunc64_def_s;
    alias open64_file_func = void* function(void*, const(void)*, int);
    alias seek64_file_func = c_long function(void*, void*, ulong, int);
    alias tell64_file_func = ulong function(void*, void*);

    struct zlib_filefunc_def_s
    {

        void* function(void*, const(char)*, int) zopen_file;

        c_ulong function(void*, void*, void*, c_ulong) zread_file;

        c_ulong function(void*, void*, const(void)*, c_ulong) zwrite_file;

        c_long function(void*, void*) ztell_file;

        c_long function(void*, void*, c_ulong, int) zseek_file;

        int function(void*, void*) zclose_file;

        int function(void*, void*) zerror_file;

        void* opaque;
    }

    alias zlib_filefunc_def = zlib_filefunc_def_s;
    alias seek_file_func = c_long function(void*, void*, c_ulong, int);
    alias tell_file_func = c_long function(void*, void*);
    alias testerror_file_func = int function(void*, void*);
    alias close_file_func = int function(void*, void*);
    alias write_file_func = c_ulong function(void*, void*, const(void)*, c_ulong);
    alias read_file_func = c_ulong function(void*, void*, void*, c_ulong);
    alias open_file_func = void* function(void*, const(char)*, int);

    alias ZPOS64_T = ulong;

    union __atomic_wide_counter
    {

        ulong __value64;

        static struct _Anonymous_20
        {

            uint __low;

            uint __high;
        }

        _Anonymous_20 __value32;
    }

    void lxw_theme_assemble_xml_file(lxw_theme*) @nogc nothrow;

    void lxw_theme_xml_declaration(lxw_theme*) @nogc nothrow;

    void lxw_theme_free(lxw_theme*) @nogc nothrow;

    lxw_theme* lxw_theme_new() @nogc nothrow;

    enum _Anonymous_21
    {

        _PC_LINK_MAX = 0,

        _PC_MAX_CANON = 1,

        _PC_MAX_INPUT = 2,

        _PC_NAME_MAX = 3,

        _PC_PATH_MAX = 4,

        _PC_PIPE_BUF = 5,

        _PC_CHOWN_RESTRICTED = 6,

        _PC_NO_TRUNC = 7,

        _PC_VDISABLE = 8,

        _PC_SYNC_IO = 9,

        _PC_ASYNC_IO = 10,

        _PC_PRIO_IO = 11,

        _PC_SOCK_MAXBUF = 12,

        _PC_FILESIZEBITS = 13,

        _PC_REC_INCR_XFER_SIZE = 14,

        _PC_REC_MAX_XFER_SIZE = 15,

        _PC_REC_MIN_XFER_SIZE = 16,

        _PC_REC_XFER_ALIGN = 17,

        _PC_ALLOC_SIZE_MIN = 18,

        _PC_SYMLINK_MAX = 19,

        _PC_2_SYMLINKS = 20,
    }
    enum _PC_LINK_MAX = _Anonymous_21._PC_LINK_MAX;
    enum _PC_MAX_CANON = _Anonymous_21._PC_MAX_CANON;
    enum _PC_MAX_INPUT = _Anonymous_21._PC_MAX_INPUT;
    enum _PC_NAME_MAX = _Anonymous_21._PC_NAME_MAX;
    enum _PC_PATH_MAX = _Anonymous_21._PC_PATH_MAX;
    enum _PC_PIPE_BUF = _Anonymous_21._PC_PIPE_BUF;
    enum _PC_CHOWN_RESTRICTED = _Anonymous_21._PC_CHOWN_RESTRICTED;
    enum _PC_NO_TRUNC = _Anonymous_21._PC_NO_TRUNC;
    enum _PC_VDISABLE = _Anonymous_21._PC_VDISABLE;
    enum _PC_SYNC_IO = _Anonymous_21._PC_SYNC_IO;
    enum _PC_ASYNC_IO = _Anonymous_21._PC_ASYNC_IO;
    enum _PC_PRIO_IO = _Anonymous_21._PC_PRIO_IO;
    enum _PC_SOCK_MAXBUF = _Anonymous_21._PC_SOCK_MAXBUF;
    enum _PC_FILESIZEBITS = _Anonymous_21._PC_FILESIZEBITS;
    enum _PC_REC_INCR_XFER_SIZE = _Anonymous_21._PC_REC_INCR_XFER_SIZE;
    enum _PC_REC_MAX_XFER_SIZE = _Anonymous_21._PC_REC_MAX_XFER_SIZE;
    enum _PC_REC_MIN_XFER_SIZE = _Anonymous_21._PC_REC_MIN_XFER_SIZE;
    enum _PC_REC_XFER_ALIGN = _Anonymous_21._PC_REC_XFER_ALIGN;
    enum _PC_ALLOC_SIZE_MIN = _Anonymous_21._PC_ALLOC_SIZE_MIN;
    enum _PC_SYMLINK_MAX = _Anonymous_21._PC_SYMLINK_MAX;
    enum _PC_2_SYMLINKS = _Anonymous_21._PC_2_SYMLINKS;

    struct lxw_theme
    {

        _IO_FILE* file;
    }

    void lxw_table_assemble_xml_file(lxw_table*) @nogc nothrow;

    void lxw_table_free(lxw_table*) @nogc nothrow;

    lxw_table* lxw_table_new() @nogc nothrow;

    struct lxw_table
    {

        _IO_FILE* file;

        lxw_table_obj* table_obj;
    }

    void lxw_styles_write_rich_font(lxw_styles*, lxw_format*) @nogc nothrow;

    void lxw_styles_write_string_fragment(lxw_styles*, char*) @nogc nothrow;

    void lxw_styles_assemble_xml_file(lxw_styles*) @nogc nothrow;

    void lxw_styles_free(lxw_styles*) @nogc nothrow;

    lxw_styles* lxw_styles_new() @nogc nothrow;

    struct lxw_styles
    {

        _IO_FILE* file;

        uint font_count;

        uint xf_count;

        uint dxf_count;

        uint num_format_count;

        uint border_count;

        uint fill_count;

        lxw_formats* xf_formats;

        lxw_formats* dxf_formats;

        ubyte has_hyperlink;

        ushort hyperlink_font_id;

        ubyte has_comments;
    }

    enum _Anonymous_22
    {

        _SC_ARG_MAX = 0,

        _SC_CHILD_MAX = 1,

        _SC_CLK_TCK = 2,

        _SC_NGROUPS_MAX = 3,

        _SC_OPEN_MAX = 4,

        _SC_STREAM_MAX = 5,

        _SC_TZNAME_MAX = 6,

        _SC_JOB_CONTROL = 7,

        _SC_SAVED_IDS = 8,

        _SC_REALTIME_SIGNALS = 9,

        _SC_PRIORITY_SCHEDULING = 10,

        _SC_TIMERS = 11,

        _SC_ASYNCHRONOUS_IO = 12,

        _SC_PRIORITIZED_IO = 13,

        _SC_SYNCHRONIZED_IO = 14,

        _SC_FSYNC = 15,

        _SC_MAPPED_FILES = 16,

        _SC_MEMLOCK = 17,

        _SC_MEMLOCK_RANGE = 18,

        _SC_MEMORY_PROTECTION = 19,

        _SC_MESSAGE_PASSING = 20,

        _SC_SEMAPHORES = 21,

        _SC_SHARED_MEMORY_OBJECTS = 22,

        _SC_AIO_LISTIO_MAX = 23,

        _SC_AIO_MAX = 24,

        _SC_AIO_PRIO_DELTA_MAX = 25,

        _SC_DELAYTIMER_MAX = 26,

        _SC_MQ_OPEN_MAX = 27,

        _SC_MQ_PRIO_MAX = 28,

        _SC_VERSION = 29,

        _SC_PAGESIZE = 30,

        _SC_RTSIG_MAX = 31,

        _SC_SEM_NSEMS_MAX = 32,

        _SC_SEM_VALUE_MAX = 33,

        _SC_SIGQUEUE_MAX = 34,

        _SC_TIMER_MAX = 35,

        _SC_BC_BASE_MAX = 36,

        _SC_BC_DIM_MAX = 37,

        _SC_BC_SCALE_MAX = 38,

        _SC_BC_STRING_MAX = 39,

        _SC_COLL_WEIGHTS_MAX = 40,

        _SC_EQUIV_CLASS_MAX = 41,

        _SC_EXPR_NEST_MAX = 42,

        _SC_LINE_MAX = 43,

        _SC_RE_DUP_MAX = 44,

        _SC_CHARCLASS_NAME_MAX = 45,

        _SC_2_VERSION = 46,

        _SC_2_C_BIND = 47,

        _SC_2_C_DEV = 48,

        _SC_2_FORT_DEV = 49,

        _SC_2_FORT_RUN = 50,

        _SC_2_SW_DEV = 51,

        _SC_2_LOCALEDEF = 52,

        _SC_PII = 53,

        _SC_PII_XTI = 54,

        _SC_PII_SOCKET = 55,

        _SC_PII_INTERNET = 56,

        _SC_PII_OSI = 57,

        _SC_POLL = 58,

        _SC_SELECT = 59,

        _SC_UIO_MAXIOV = 60,

        _SC_IOV_MAX = 60,

        _SC_PII_INTERNET_STREAM = 61,

        _SC_PII_INTERNET_DGRAM = 62,

        _SC_PII_OSI_COTS = 63,

        _SC_PII_OSI_CLTS = 64,

        _SC_PII_OSI_M = 65,

        _SC_T_IOV_MAX = 66,

        _SC_THREADS = 67,

        _SC_THREAD_SAFE_FUNCTIONS = 68,

        _SC_GETGR_R_SIZE_MAX = 69,

        _SC_GETPW_R_SIZE_MAX = 70,

        _SC_LOGIN_NAME_MAX = 71,

        _SC_TTY_NAME_MAX = 72,

        _SC_THREAD_DESTRUCTOR_ITERATIONS = 73,

        _SC_THREAD_KEYS_MAX = 74,

        _SC_THREAD_STACK_MIN = 75,

        _SC_THREAD_THREADS_MAX = 76,

        _SC_THREAD_ATTR_STACKADDR = 77,

        _SC_THREAD_ATTR_STACKSIZE = 78,

        _SC_THREAD_PRIORITY_SCHEDULING = 79,

        _SC_THREAD_PRIO_INHERIT = 80,

        _SC_THREAD_PRIO_PROTECT = 81,

        _SC_THREAD_PROCESS_SHARED = 82,

        _SC_NPROCESSORS_CONF = 83,

        _SC_NPROCESSORS_ONLN = 84,

        _SC_PHYS_PAGES = 85,

        _SC_AVPHYS_PAGES = 86,

        _SC_ATEXIT_MAX = 87,

        _SC_PASS_MAX = 88,

        _SC_XOPEN_VERSION = 89,

        _SC_XOPEN_XCU_VERSION = 90,

        _SC_XOPEN_UNIX = 91,

        _SC_XOPEN_CRYPT = 92,

        _SC_XOPEN_ENH_I18N = 93,

        _SC_XOPEN_SHM = 94,

        _SC_2_CHAR_TERM = 95,

        _SC_2_C_VERSION = 96,

        _SC_2_UPE = 97,

        _SC_XOPEN_XPG2 = 98,

        _SC_XOPEN_XPG3 = 99,

        _SC_XOPEN_XPG4 = 100,

        _SC_CHAR_BIT = 101,

        _SC_CHAR_MAX = 102,

        _SC_CHAR_MIN = 103,

        _SC_INT_MAX = 104,

        _SC_INT_MIN = 105,

        _SC_LONG_BIT = 106,

        _SC_WORD_BIT = 107,

        _SC_MB_LEN_MAX = 108,

        _SC_NZERO = 109,

        _SC_SSIZE_MAX = 110,

        _SC_SCHAR_MAX = 111,

        _SC_SCHAR_MIN = 112,

        _SC_SHRT_MAX = 113,

        _SC_SHRT_MIN = 114,

        _SC_UCHAR_MAX = 115,

        _SC_UINT_MAX = 116,

        _SC_ULONG_MAX = 117,

        _SC_USHRT_MAX = 118,

        _SC_NL_ARGMAX = 119,

        _SC_NL_LANGMAX = 120,

        _SC_NL_MSGMAX = 121,

        _SC_NL_NMAX = 122,

        _SC_NL_SETMAX = 123,

        _SC_NL_TEXTMAX = 124,

        _SC_XBS5_ILP32_OFF32 = 125,

        _SC_XBS5_ILP32_OFFBIG = 126,

        _SC_XBS5_LP64_OFF64 = 127,

        _SC_XBS5_LPBIG_OFFBIG = 128,

        _SC_XOPEN_LEGACY = 129,

        _SC_XOPEN_REALTIME = 130,

        _SC_XOPEN_REALTIME_THREADS = 131,

        _SC_ADVISORY_INFO = 132,

        _SC_BARRIERS = 133,

        _SC_BASE = 134,

        _SC_C_LANG_SUPPORT = 135,

        _SC_C_LANG_SUPPORT_R = 136,

        _SC_CLOCK_SELECTION = 137,

        _SC_CPUTIME = 138,

        _SC_THREAD_CPUTIME = 139,

        _SC_DEVICE_IO = 140,

        _SC_DEVICE_SPECIFIC = 141,

        _SC_DEVICE_SPECIFIC_R = 142,

        _SC_FD_MGMT = 143,

        _SC_FIFO = 144,

        _SC_PIPE = 145,

        _SC_FILE_ATTRIBUTES = 146,

        _SC_FILE_LOCKING = 147,

        _SC_FILE_SYSTEM = 148,

        _SC_MONOTONIC_CLOCK = 149,

        _SC_MULTI_PROCESS = 150,

        _SC_SINGLE_PROCESS = 151,

        _SC_NETWORKING = 152,

        _SC_READER_WRITER_LOCKS = 153,

        _SC_SPIN_LOCKS = 154,

        _SC_REGEXP = 155,

        _SC_REGEX_VERSION = 156,

        _SC_SHELL = 157,

        _SC_SIGNALS = 158,

        _SC_SPAWN = 159,

        _SC_SPORADIC_SERVER = 160,

        _SC_THREAD_SPORADIC_SERVER = 161,

        _SC_SYSTEM_DATABASE = 162,

        _SC_SYSTEM_DATABASE_R = 163,

        _SC_TIMEOUTS = 164,

        _SC_TYPED_MEMORY_OBJECTS = 165,

        _SC_USER_GROUPS = 166,

        _SC_USER_GROUPS_R = 167,

        _SC_2_PBS = 168,

        _SC_2_PBS_ACCOUNTING = 169,

        _SC_2_PBS_LOCATE = 170,

        _SC_2_PBS_MESSAGE = 171,

        _SC_2_PBS_TRACK = 172,

        _SC_SYMLOOP_MAX = 173,

        _SC_STREAMS = 174,

        _SC_2_PBS_CHECKPOINT = 175,

        _SC_V6_ILP32_OFF32 = 176,

        _SC_V6_ILP32_OFFBIG = 177,

        _SC_V6_LP64_OFF64 = 178,

        _SC_V6_LPBIG_OFFBIG = 179,

        _SC_HOST_NAME_MAX = 180,

        _SC_TRACE = 181,

        _SC_TRACE_EVENT_FILTER = 182,

        _SC_TRACE_INHERIT = 183,

        _SC_TRACE_LOG = 184,

        _SC_LEVEL1_ICACHE_SIZE = 185,

        _SC_LEVEL1_ICACHE_ASSOC = 186,

        _SC_LEVEL1_ICACHE_LINESIZE = 187,

        _SC_LEVEL1_DCACHE_SIZE = 188,

        _SC_LEVEL1_DCACHE_ASSOC = 189,

        _SC_LEVEL1_DCACHE_LINESIZE = 190,

        _SC_LEVEL2_CACHE_SIZE = 191,

        _SC_LEVEL2_CACHE_ASSOC = 192,

        _SC_LEVEL2_CACHE_LINESIZE = 193,

        _SC_LEVEL3_CACHE_SIZE = 194,

        _SC_LEVEL3_CACHE_ASSOC = 195,

        _SC_LEVEL3_CACHE_LINESIZE = 196,

        _SC_LEVEL4_CACHE_SIZE = 197,

        _SC_LEVEL4_CACHE_ASSOC = 198,

        _SC_LEVEL4_CACHE_LINESIZE = 199,

        _SC_IPV6 = 235,

        _SC_RAW_SOCKETS = 236,

        _SC_V7_ILP32_OFF32 = 237,

        _SC_V7_ILP32_OFFBIG = 238,

        _SC_V7_LP64_OFF64 = 239,

        _SC_V7_LPBIG_OFFBIG = 240,

        _SC_SS_REPL_MAX = 241,

        _SC_TRACE_EVENT_NAME_MAX = 242,

        _SC_TRACE_NAME_MAX = 243,

        _SC_TRACE_SYS_MAX = 244,

        _SC_TRACE_USER_EVENT_MAX = 245,

        _SC_XOPEN_STREAMS = 246,

        _SC_THREAD_ROBUST_PRIO_INHERIT = 247,

        _SC_THREAD_ROBUST_PRIO_PROTECT = 248,

        _SC_MINSIGSTKSZ = 249,

        _SC_SIGSTKSZ = 250,
    }
    enum _SC_ARG_MAX = _Anonymous_22._SC_ARG_MAX;
    enum _SC_CHILD_MAX = _Anonymous_22._SC_CHILD_MAX;
    enum _SC_CLK_TCK = _Anonymous_22._SC_CLK_TCK;
    enum _SC_NGROUPS_MAX = _Anonymous_22._SC_NGROUPS_MAX;
    enum _SC_OPEN_MAX = _Anonymous_22._SC_OPEN_MAX;
    enum _SC_STREAM_MAX = _Anonymous_22._SC_STREAM_MAX;
    enum _SC_TZNAME_MAX = _Anonymous_22._SC_TZNAME_MAX;
    enum _SC_JOB_CONTROL = _Anonymous_22._SC_JOB_CONTROL;
    enum _SC_SAVED_IDS = _Anonymous_22._SC_SAVED_IDS;
    enum _SC_REALTIME_SIGNALS = _Anonymous_22._SC_REALTIME_SIGNALS;
    enum _SC_PRIORITY_SCHEDULING = _Anonymous_22._SC_PRIORITY_SCHEDULING;
    enum _SC_TIMERS = _Anonymous_22._SC_TIMERS;
    enum _SC_ASYNCHRONOUS_IO = _Anonymous_22._SC_ASYNCHRONOUS_IO;
    enum _SC_PRIORITIZED_IO = _Anonymous_22._SC_PRIORITIZED_IO;
    enum _SC_SYNCHRONIZED_IO = _Anonymous_22._SC_SYNCHRONIZED_IO;
    enum _SC_FSYNC = _Anonymous_22._SC_FSYNC;
    enum _SC_MAPPED_FILES = _Anonymous_22._SC_MAPPED_FILES;
    enum _SC_MEMLOCK = _Anonymous_22._SC_MEMLOCK;
    enum _SC_MEMLOCK_RANGE = _Anonymous_22._SC_MEMLOCK_RANGE;
    enum _SC_MEMORY_PROTECTION = _Anonymous_22._SC_MEMORY_PROTECTION;
    enum _SC_MESSAGE_PASSING = _Anonymous_22._SC_MESSAGE_PASSING;
    enum _SC_SEMAPHORES = _Anonymous_22._SC_SEMAPHORES;
    enum _SC_SHARED_MEMORY_OBJECTS = _Anonymous_22._SC_SHARED_MEMORY_OBJECTS;
    enum _SC_AIO_LISTIO_MAX = _Anonymous_22._SC_AIO_LISTIO_MAX;
    enum _SC_AIO_MAX = _Anonymous_22._SC_AIO_MAX;
    enum _SC_AIO_PRIO_DELTA_MAX = _Anonymous_22._SC_AIO_PRIO_DELTA_MAX;
    enum _SC_DELAYTIMER_MAX = _Anonymous_22._SC_DELAYTIMER_MAX;
    enum _SC_MQ_OPEN_MAX = _Anonymous_22._SC_MQ_OPEN_MAX;
    enum _SC_MQ_PRIO_MAX = _Anonymous_22._SC_MQ_PRIO_MAX;
    enum _SC_VERSION = _Anonymous_22._SC_VERSION;
    enum _SC_PAGESIZE = _Anonymous_22._SC_PAGESIZE;
    enum _SC_RTSIG_MAX = _Anonymous_22._SC_RTSIG_MAX;
    enum _SC_SEM_NSEMS_MAX = _Anonymous_22._SC_SEM_NSEMS_MAX;
    enum _SC_SEM_VALUE_MAX = _Anonymous_22._SC_SEM_VALUE_MAX;
    enum _SC_SIGQUEUE_MAX = _Anonymous_22._SC_SIGQUEUE_MAX;
    enum _SC_TIMER_MAX = _Anonymous_22._SC_TIMER_MAX;
    enum _SC_BC_BASE_MAX = _Anonymous_22._SC_BC_BASE_MAX;
    enum _SC_BC_DIM_MAX = _Anonymous_22._SC_BC_DIM_MAX;
    enum _SC_BC_SCALE_MAX = _Anonymous_22._SC_BC_SCALE_MAX;
    enum _SC_BC_STRING_MAX = _Anonymous_22._SC_BC_STRING_MAX;
    enum _SC_COLL_WEIGHTS_MAX = _Anonymous_22._SC_COLL_WEIGHTS_MAX;
    enum _SC_EQUIV_CLASS_MAX = _Anonymous_22._SC_EQUIV_CLASS_MAX;
    enum _SC_EXPR_NEST_MAX = _Anonymous_22._SC_EXPR_NEST_MAX;
    enum _SC_LINE_MAX = _Anonymous_22._SC_LINE_MAX;
    enum _SC_RE_DUP_MAX = _Anonymous_22._SC_RE_DUP_MAX;
    enum _SC_CHARCLASS_NAME_MAX = _Anonymous_22._SC_CHARCLASS_NAME_MAX;
    enum _SC_2_VERSION = _Anonymous_22._SC_2_VERSION;
    enum _SC_2_C_BIND = _Anonymous_22._SC_2_C_BIND;
    enum _SC_2_C_DEV = _Anonymous_22._SC_2_C_DEV;
    enum _SC_2_FORT_DEV = _Anonymous_22._SC_2_FORT_DEV;
    enum _SC_2_FORT_RUN = _Anonymous_22._SC_2_FORT_RUN;
    enum _SC_2_SW_DEV = _Anonymous_22._SC_2_SW_DEV;
    enum _SC_2_LOCALEDEF = _Anonymous_22._SC_2_LOCALEDEF;
    enum _SC_PII = _Anonymous_22._SC_PII;
    enum _SC_PII_XTI = _Anonymous_22._SC_PII_XTI;
    enum _SC_PII_SOCKET = _Anonymous_22._SC_PII_SOCKET;
    enum _SC_PII_INTERNET = _Anonymous_22._SC_PII_INTERNET;
    enum _SC_PII_OSI = _Anonymous_22._SC_PII_OSI;
    enum _SC_POLL = _Anonymous_22._SC_POLL;
    enum _SC_SELECT = _Anonymous_22._SC_SELECT;
    enum _SC_UIO_MAXIOV = _Anonymous_22._SC_UIO_MAXIOV;
    enum _SC_IOV_MAX = _Anonymous_22._SC_IOV_MAX;
    enum _SC_PII_INTERNET_STREAM = _Anonymous_22._SC_PII_INTERNET_STREAM;
    enum _SC_PII_INTERNET_DGRAM = _Anonymous_22._SC_PII_INTERNET_DGRAM;
    enum _SC_PII_OSI_COTS = _Anonymous_22._SC_PII_OSI_COTS;
    enum _SC_PII_OSI_CLTS = _Anonymous_22._SC_PII_OSI_CLTS;
    enum _SC_PII_OSI_M = _Anonymous_22._SC_PII_OSI_M;
    enum _SC_T_IOV_MAX = _Anonymous_22._SC_T_IOV_MAX;
    enum _SC_THREADS = _Anonymous_22._SC_THREADS;
    enum _SC_THREAD_SAFE_FUNCTIONS = _Anonymous_22._SC_THREAD_SAFE_FUNCTIONS;
    enum _SC_GETGR_R_SIZE_MAX = _Anonymous_22._SC_GETGR_R_SIZE_MAX;
    enum _SC_GETPW_R_SIZE_MAX = _Anonymous_22._SC_GETPW_R_SIZE_MAX;
    enum _SC_LOGIN_NAME_MAX = _Anonymous_22._SC_LOGIN_NAME_MAX;
    enum _SC_TTY_NAME_MAX = _Anonymous_22._SC_TTY_NAME_MAX;
    enum _SC_THREAD_DESTRUCTOR_ITERATIONS = _Anonymous_22._SC_THREAD_DESTRUCTOR_ITERATIONS;
    enum _SC_THREAD_KEYS_MAX = _Anonymous_22._SC_THREAD_KEYS_MAX;
    enum _SC_THREAD_STACK_MIN = _Anonymous_22._SC_THREAD_STACK_MIN;
    enum _SC_THREAD_THREADS_MAX = _Anonymous_22._SC_THREAD_THREADS_MAX;
    enum _SC_THREAD_ATTR_STACKADDR = _Anonymous_22._SC_THREAD_ATTR_STACKADDR;
    enum _SC_THREAD_ATTR_STACKSIZE = _Anonymous_22._SC_THREAD_ATTR_STACKSIZE;
    enum _SC_THREAD_PRIORITY_SCHEDULING = _Anonymous_22._SC_THREAD_PRIORITY_SCHEDULING;
    enum _SC_THREAD_PRIO_INHERIT = _Anonymous_22._SC_THREAD_PRIO_INHERIT;
    enum _SC_THREAD_PRIO_PROTECT = _Anonymous_22._SC_THREAD_PRIO_PROTECT;
    enum _SC_THREAD_PROCESS_SHARED = _Anonymous_22._SC_THREAD_PROCESS_SHARED;
    enum _SC_NPROCESSORS_CONF = _Anonymous_22._SC_NPROCESSORS_CONF;
    enum _SC_NPROCESSORS_ONLN = _Anonymous_22._SC_NPROCESSORS_ONLN;
    enum _SC_PHYS_PAGES = _Anonymous_22._SC_PHYS_PAGES;
    enum _SC_AVPHYS_PAGES = _Anonymous_22._SC_AVPHYS_PAGES;
    enum _SC_ATEXIT_MAX = _Anonymous_22._SC_ATEXIT_MAX;
    enum _SC_PASS_MAX = _Anonymous_22._SC_PASS_MAX;
    enum _SC_XOPEN_VERSION = _Anonymous_22._SC_XOPEN_VERSION;
    enum _SC_XOPEN_XCU_VERSION = _Anonymous_22._SC_XOPEN_XCU_VERSION;
    enum _SC_XOPEN_UNIX = _Anonymous_22._SC_XOPEN_UNIX;
    enum _SC_XOPEN_CRYPT = _Anonymous_22._SC_XOPEN_CRYPT;
    enum _SC_XOPEN_ENH_I18N = _Anonymous_22._SC_XOPEN_ENH_I18N;
    enum _SC_XOPEN_SHM = _Anonymous_22._SC_XOPEN_SHM;
    enum _SC_2_CHAR_TERM = _Anonymous_22._SC_2_CHAR_TERM;
    enum _SC_2_C_VERSION = _Anonymous_22._SC_2_C_VERSION;
    enum _SC_2_UPE = _Anonymous_22._SC_2_UPE;
    enum _SC_XOPEN_XPG2 = _Anonymous_22._SC_XOPEN_XPG2;
    enum _SC_XOPEN_XPG3 = _Anonymous_22._SC_XOPEN_XPG3;
    enum _SC_XOPEN_XPG4 = _Anonymous_22._SC_XOPEN_XPG4;
    enum _SC_CHAR_BIT = _Anonymous_22._SC_CHAR_BIT;
    enum _SC_CHAR_MAX = _Anonymous_22._SC_CHAR_MAX;
    enum _SC_CHAR_MIN = _Anonymous_22._SC_CHAR_MIN;
    enum _SC_INT_MAX = _Anonymous_22._SC_INT_MAX;
    enum _SC_INT_MIN = _Anonymous_22._SC_INT_MIN;
    enum _SC_LONG_BIT = _Anonymous_22._SC_LONG_BIT;
    enum _SC_WORD_BIT = _Anonymous_22._SC_WORD_BIT;
    enum _SC_MB_LEN_MAX = _Anonymous_22._SC_MB_LEN_MAX;
    enum _SC_NZERO = _Anonymous_22._SC_NZERO;
    enum _SC_SSIZE_MAX = _Anonymous_22._SC_SSIZE_MAX;
    enum _SC_SCHAR_MAX = _Anonymous_22._SC_SCHAR_MAX;
    enum _SC_SCHAR_MIN = _Anonymous_22._SC_SCHAR_MIN;
    enum _SC_SHRT_MAX = _Anonymous_22._SC_SHRT_MAX;
    enum _SC_SHRT_MIN = _Anonymous_22._SC_SHRT_MIN;
    enum _SC_UCHAR_MAX = _Anonymous_22._SC_UCHAR_MAX;
    enum _SC_UINT_MAX = _Anonymous_22._SC_UINT_MAX;
    enum _SC_ULONG_MAX = _Anonymous_22._SC_ULONG_MAX;
    enum _SC_USHRT_MAX = _Anonymous_22._SC_USHRT_MAX;
    enum _SC_NL_ARGMAX = _Anonymous_22._SC_NL_ARGMAX;
    enum _SC_NL_LANGMAX = _Anonymous_22._SC_NL_LANGMAX;
    enum _SC_NL_MSGMAX = _Anonymous_22._SC_NL_MSGMAX;
    enum _SC_NL_NMAX = _Anonymous_22._SC_NL_NMAX;
    enum _SC_NL_SETMAX = _Anonymous_22._SC_NL_SETMAX;
    enum _SC_NL_TEXTMAX = _Anonymous_22._SC_NL_TEXTMAX;
    enum _SC_XBS5_ILP32_OFF32 = _Anonymous_22._SC_XBS5_ILP32_OFF32;
    enum _SC_XBS5_ILP32_OFFBIG = _Anonymous_22._SC_XBS5_ILP32_OFFBIG;
    enum _SC_XBS5_LP64_OFF64 = _Anonymous_22._SC_XBS5_LP64_OFF64;
    enum _SC_XBS5_LPBIG_OFFBIG = _Anonymous_22._SC_XBS5_LPBIG_OFFBIG;
    enum _SC_XOPEN_LEGACY = _Anonymous_22._SC_XOPEN_LEGACY;
    enum _SC_XOPEN_REALTIME = _Anonymous_22._SC_XOPEN_REALTIME;
    enum _SC_XOPEN_REALTIME_THREADS = _Anonymous_22._SC_XOPEN_REALTIME_THREADS;
    enum _SC_ADVISORY_INFO = _Anonymous_22._SC_ADVISORY_INFO;
    enum _SC_BARRIERS = _Anonymous_22._SC_BARRIERS;
    enum _SC_BASE = _Anonymous_22._SC_BASE;
    enum _SC_C_LANG_SUPPORT = _Anonymous_22._SC_C_LANG_SUPPORT;
    enum _SC_C_LANG_SUPPORT_R = _Anonymous_22._SC_C_LANG_SUPPORT_R;
    enum _SC_CLOCK_SELECTION = _Anonymous_22._SC_CLOCK_SELECTION;
    enum _SC_CPUTIME = _Anonymous_22._SC_CPUTIME;
    enum _SC_THREAD_CPUTIME = _Anonymous_22._SC_THREAD_CPUTIME;
    enum _SC_DEVICE_IO = _Anonymous_22._SC_DEVICE_IO;
    enum _SC_DEVICE_SPECIFIC = _Anonymous_22._SC_DEVICE_SPECIFIC;
    enum _SC_DEVICE_SPECIFIC_R = _Anonymous_22._SC_DEVICE_SPECIFIC_R;
    enum _SC_FD_MGMT = _Anonymous_22._SC_FD_MGMT;
    enum _SC_FIFO = _Anonymous_22._SC_FIFO;
    enum _SC_PIPE = _Anonymous_22._SC_PIPE;
    enum _SC_FILE_ATTRIBUTES = _Anonymous_22._SC_FILE_ATTRIBUTES;
    enum _SC_FILE_LOCKING = _Anonymous_22._SC_FILE_LOCKING;
    enum _SC_FILE_SYSTEM = _Anonymous_22._SC_FILE_SYSTEM;
    enum _SC_MONOTONIC_CLOCK = _Anonymous_22._SC_MONOTONIC_CLOCK;
    enum _SC_MULTI_PROCESS = _Anonymous_22._SC_MULTI_PROCESS;
    enum _SC_SINGLE_PROCESS = _Anonymous_22._SC_SINGLE_PROCESS;
    enum _SC_NETWORKING = _Anonymous_22._SC_NETWORKING;
    enum _SC_READER_WRITER_LOCKS = _Anonymous_22._SC_READER_WRITER_LOCKS;
    enum _SC_SPIN_LOCKS = _Anonymous_22._SC_SPIN_LOCKS;
    enum _SC_REGEXP = _Anonymous_22._SC_REGEXP;
    enum _SC_REGEX_VERSION = _Anonymous_22._SC_REGEX_VERSION;
    enum _SC_SHELL = _Anonymous_22._SC_SHELL;
    enum _SC_SIGNALS = _Anonymous_22._SC_SIGNALS;
    enum _SC_SPAWN = _Anonymous_22._SC_SPAWN;
    enum _SC_SPORADIC_SERVER = _Anonymous_22._SC_SPORADIC_SERVER;
    enum _SC_THREAD_SPORADIC_SERVER = _Anonymous_22._SC_THREAD_SPORADIC_SERVER;
    enum _SC_SYSTEM_DATABASE = _Anonymous_22._SC_SYSTEM_DATABASE;
    enum _SC_SYSTEM_DATABASE_R = _Anonymous_22._SC_SYSTEM_DATABASE_R;
    enum _SC_TIMEOUTS = _Anonymous_22._SC_TIMEOUTS;
    enum _SC_TYPED_MEMORY_OBJECTS = _Anonymous_22._SC_TYPED_MEMORY_OBJECTS;
    enum _SC_USER_GROUPS = _Anonymous_22._SC_USER_GROUPS;
    enum _SC_USER_GROUPS_R = _Anonymous_22._SC_USER_GROUPS_R;
    enum _SC_2_PBS = _Anonymous_22._SC_2_PBS;
    enum _SC_2_PBS_ACCOUNTING = _Anonymous_22._SC_2_PBS_ACCOUNTING;
    enum _SC_2_PBS_LOCATE = _Anonymous_22._SC_2_PBS_LOCATE;
    enum _SC_2_PBS_MESSAGE = _Anonymous_22._SC_2_PBS_MESSAGE;
    enum _SC_2_PBS_TRACK = _Anonymous_22._SC_2_PBS_TRACK;
    enum _SC_SYMLOOP_MAX = _Anonymous_22._SC_SYMLOOP_MAX;
    enum _SC_STREAMS = _Anonymous_22._SC_STREAMS;
    enum _SC_2_PBS_CHECKPOINT = _Anonymous_22._SC_2_PBS_CHECKPOINT;
    enum _SC_V6_ILP32_OFF32 = _Anonymous_22._SC_V6_ILP32_OFF32;
    enum _SC_V6_ILP32_OFFBIG = _Anonymous_22._SC_V6_ILP32_OFFBIG;
    enum _SC_V6_LP64_OFF64 = _Anonymous_22._SC_V6_LP64_OFF64;
    enum _SC_V6_LPBIG_OFFBIG = _Anonymous_22._SC_V6_LPBIG_OFFBIG;
    enum _SC_HOST_NAME_MAX = _Anonymous_22._SC_HOST_NAME_MAX;
    enum _SC_TRACE = _Anonymous_22._SC_TRACE;
    enum _SC_TRACE_EVENT_FILTER = _Anonymous_22._SC_TRACE_EVENT_FILTER;
    enum _SC_TRACE_INHERIT = _Anonymous_22._SC_TRACE_INHERIT;
    enum _SC_TRACE_LOG = _Anonymous_22._SC_TRACE_LOG;
    enum _SC_LEVEL1_ICACHE_SIZE = _Anonymous_22._SC_LEVEL1_ICACHE_SIZE;
    enum _SC_LEVEL1_ICACHE_ASSOC = _Anonymous_22._SC_LEVEL1_ICACHE_ASSOC;
    enum _SC_LEVEL1_ICACHE_LINESIZE = _Anonymous_22._SC_LEVEL1_ICACHE_LINESIZE;
    enum _SC_LEVEL1_DCACHE_SIZE = _Anonymous_22._SC_LEVEL1_DCACHE_SIZE;
    enum _SC_LEVEL1_DCACHE_ASSOC = _Anonymous_22._SC_LEVEL1_DCACHE_ASSOC;
    enum _SC_LEVEL1_DCACHE_LINESIZE = _Anonymous_22._SC_LEVEL1_DCACHE_LINESIZE;
    enum _SC_LEVEL2_CACHE_SIZE = _Anonymous_22._SC_LEVEL2_CACHE_SIZE;
    enum _SC_LEVEL2_CACHE_ASSOC = _Anonymous_22._SC_LEVEL2_CACHE_ASSOC;
    enum _SC_LEVEL2_CACHE_LINESIZE = _Anonymous_22._SC_LEVEL2_CACHE_LINESIZE;
    enum _SC_LEVEL3_CACHE_SIZE = _Anonymous_22._SC_LEVEL3_CACHE_SIZE;
    enum _SC_LEVEL3_CACHE_ASSOC = _Anonymous_22._SC_LEVEL3_CACHE_ASSOC;
    enum _SC_LEVEL3_CACHE_LINESIZE = _Anonymous_22._SC_LEVEL3_CACHE_LINESIZE;
    enum _SC_LEVEL4_CACHE_SIZE = _Anonymous_22._SC_LEVEL4_CACHE_SIZE;
    enum _SC_LEVEL4_CACHE_ASSOC = _Anonymous_22._SC_LEVEL4_CACHE_ASSOC;
    enum _SC_LEVEL4_CACHE_LINESIZE = _Anonymous_22._SC_LEVEL4_CACHE_LINESIZE;
    enum _SC_IPV6 = _Anonymous_22._SC_IPV6;
    enum _SC_RAW_SOCKETS = _Anonymous_22._SC_RAW_SOCKETS;
    enum _SC_V7_ILP32_OFF32 = _Anonymous_22._SC_V7_ILP32_OFF32;
    enum _SC_V7_ILP32_OFFBIG = _Anonymous_22._SC_V7_ILP32_OFFBIG;
    enum _SC_V7_LP64_OFF64 = _Anonymous_22._SC_V7_LP64_OFF64;
    enum _SC_V7_LPBIG_OFFBIG = _Anonymous_22._SC_V7_LPBIG_OFFBIG;
    enum _SC_SS_REPL_MAX = _Anonymous_22._SC_SS_REPL_MAX;
    enum _SC_TRACE_EVENT_NAME_MAX = _Anonymous_22._SC_TRACE_EVENT_NAME_MAX;
    enum _SC_TRACE_NAME_MAX = _Anonymous_22._SC_TRACE_NAME_MAX;
    enum _SC_TRACE_SYS_MAX = _Anonymous_22._SC_TRACE_SYS_MAX;
    enum _SC_TRACE_USER_EVENT_MAX = _Anonymous_22._SC_TRACE_USER_EVENT_MAX;
    enum _SC_XOPEN_STREAMS = _Anonymous_22._SC_XOPEN_STREAMS;
    enum _SC_THREAD_ROBUST_PRIO_INHERIT = _Anonymous_22._SC_THREAD_ROBUST_PRIO_INHERIT;
    enum _SC_THREAD_ROBUST_PRIO_PROTECT = _Anonymous_22._SC_THREAD_ROBUST_PRIO_PROTECT;
    enum _SC_MINSIGSTKSZ = _Anonymous_22._SC_MINSIGSTKSZ;
    enum _SC_SIGSTKSZ = _Anonymous_22._SC_SIGSTKSZ;

    void lxw_sst_assemble_xml_file(lxw_sst*) @nogc nothrow;

    sst_element* lxw_get_sst_index(lxw_sst*, const(char)*, ubyte) @nogc nothrow;

    void lxw_sst_free(lxw_sst*) @nogc nothrow;

    lxw_sst* lxw_sst_new() @nogc nothrow;

    struct lxw_sst
    {

        _IO_FILE* file;

        uint string_count;

        uint unique_count;

        sst_order_list* order_list;

        sst_rb_tree* rb_tree;
    }

    struct sst_order_list
    {

        sst_element* stqh_first;

        sst_element** stqh_last;
    }

    struct sst_rb_tree
    {

        sst_element* rbh_root;
    }

    struct sst_element
    {

        uint index;

        char* string_;

        ubyte is_rich_string;

        static struct _Anonymous_23
        {

            sst_element* stqe_next;
        }

        _Anonymous_23 sst_order_pointers;

        static struct _Anonymous_24
        {

            sst_element* rbe_left;

            sst_element* rbe_right;

            sst_element* rbe_parent;

            int rbe_color;
        }

        _Anonymous_24 sst_tree_pointers;
    }

    void lxw_add_worksheet_relationship(lxw_relationships*, const(char)*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_add_ms_package_relationship(lxw_relationships*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_add_package_relationship(lxw_relationships*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_add_document_relationship(lxw_relationships*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_relationships_assemble_xml_file(lxw_relationships*) @nogc nothrow;

    void lxw_free_relationships(lxw_relationships*) @nogc nothrow;

    lxw_relationships* lxw_relationships_new() @nogc nothrow;

    struct lxw_relationships
    {

        _IO_FILE* file;

        uint rel_id;

        lxw_rel_tuples* relationships;
    }

    struct lxw_rel_tuple
    {

        char* type;

        char* target;

        char* target_mode;

        static struct _Anonymous_25
        {

            lxw_rel_tuple* stqe_next;
        }

        _Anonymous_25 list_pointers;
    }

    struct lxw_rel_tuples
    {

        lxw_rel_tuple* stqh_first;

        lxw_rel_tuple** stqh_last;
    }

    lxw_error lxw_create_package(lxw_packager*) @nogc nothrow;

    void lxw_packager_free(lxw_packager*) @nogc nothrow;

    lxw_packager* lxw_packager_new(const(char)*, char*, ubyte) @nogc nothrow;

    struct lxw_packager
    {

        _IO_FILE* file;

        lxw_workbook* workbook;

        c_ulong buffer_size;

        c_ulong output_buffer_size;

        void* zipfile;

        zip_fileinfo zipfile_info;

        char* filename;

        char* buffer;

        char* output_buffer;

        char* tmpdir;

        ubyte use_zip64;
    }

    void lxw_metadata_assemble_xml_file(lxw_metadata*) @nogc nothrow;

    void lxw_metadata_free(lxw_metadata*) @nogc nothrow;

    lxw_metadata* lxw_metadata_new() @nogc nothrow;

    struct lxw_metadata
    {

        _IO_FILE* file;
    }

    void lxw_hash_free(lxw_hash_table*) @nogc nothrow;

    lxw_hash_table* lxw_hash_new(uint, ubyte, ubyte) @nogc nothrow;

    lxw_hash_element* lxw_insert_hash_element(lxw_hash_table*, void*, void*, c_ulong) @nogc nothrow;

    lxw_hash_element* lxw_hash_key_exists(lxw_hash_table*, void*, c_ulong) @nogc nothrow;

    struct lxw_hash_table
    {

        uint num_buckets;

        uint used_buckets;

        uint unique_count;

        ubyte free_key;

        ubyte free_value;

        lxw_hash_order_list* order_list;

        lxw_hash_bucket_list** buckets;
    }

    struct lxw_hash_bucket_list
    {

        lxw_hash_element* slh_first;
    }

    struct lxw_hash_order_list
    {

        lxw_hash_element* stqh_first;

        lxw_hash_element** stqh_last;
    }

    struct lxw_hash_element
    {

        void* key;

        void* value;

        static struct _Anonymous_26
        {

            lxw_hash_element* stqe_next;
        }

        _Anonymous_26 lxw_hash_order_pointers;

        static struct _Anonymous_27
        {

            lxw_hash_element* sle_next;
        }

        _Anonymous_27 lxw_hash_list_pointers;
    }

    void format_set_font_only(lxw_format*) @nogc nothrow;

    void format_set_color_indexed(lxw_format*, ubyte) @nogc nothrow;

    void format_set_hyperlink(lxw_format*) @nogc nothrow;

    void format_set_theme(lxw_format*, ubyte) @nogc nothrow;

    void format_set_reading_order(lxw_format*, ubyte) @nogc nothrow;

    void format_set_font_extend(lxw_format*) @nogc nothrow;

    void format_set_font_condense(lxw_format*) @nogc nothrow;

    void format_set_font_scheme(lxw_format*, const(char)*) @nogc nothrow;

    void format_set_font_charset(lxw_format*, ubyte) @nogc nothrow;

    void format_set_font_family(lxw_format*, ubyte) @nogc nothrow;

    void format_set_font_shadow(lxw_format*) @nogc nothrow;

    void format_set_font_outline(lxw_format*) @nogc nothrow;
    /**
 * @brief Set the diagonal cell border color.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell diagonal border color.
 *
 * Set the diagonal border color. The color should be an RGB integer value,
 * see @ref working_with_colors and the above example.
 */
    void format_set_diag_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the diagonal cell border style.
 *
 * @param format Pointer to a Format instance.
 * @param style  The #lxw_format_borders style.
 *
 * Set the diagonal border style. This should be a #lxw_format_borders value.
 * See the example above.
 *
 */
    void format_set_diag_border(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the diagonal cell border type.
 *
 * @param format Pointer to a Format instance.
 * @param type   The #lxw_format_diagonal_types diagonal border type.
 *
 * Set the diagonal cell border type:
 *
 * @code
 *     lxw_format *format1 = workbook_add_format(workbook);
 *     format_set_diag_type(  format1, LXW_DIAGONAL_BORDER_UP);
 *
 *     lxw_format *format2 = workbook_add_format(workbook);
 *     format_set_diag_type(  format2, LXW_DIAGONAL_BORDER_DOWN);
 *
 *     lxw_format *format3 = workbook_add_format(workbook);
 *     format_set_diag_type(  format3, LXW_DIAGONAL_BORDER_UP_DOWN);
 *
 *     lxw_format *format4 = workbook_add_format(workbook);
 *     format_set_diag_type(  format4, LXW_DIAGONAL_BORDER_UP_DOWN);
 *     format_set_diag_border(format4, LXW_BORDER_HAIR);
 *     format_set_diag_color( format4, LXW_COLOR_RED);
 *
 *     worksheet_write_string(worksheet, CELL("B3"),  "Text", format1);
 *     worksheet_write_string(worksheet, CELL("B6"),  "Text", format2);
 *     worksheet_write_string(worksheet, CELL("B9"),  "Text", format3);
 *     worksheet_write_string(worksheet, CELL("B12"), "Text", format4);
 * @endcode
 *
 * @image html diagonal_border.png
 *
 * The allowable border types are defined in #lxw_format_diagonal_types:
 *
 * - #LXW_DIAGONAL_BORDER_UP: Cell diagonal border from bottom left to top
 *   right.
 *
 * - #LXW_DIAGONAL_BORDER_DOWN: Cell diagonal border from top left to bottom
 *   right.
 *
 * - #LXW_DIAGONAL_BORDER_UP_DOWN: Cell diagonal border from top left to
 *   bottom right. A combination of the 2 previous types.
 *
 * If the border style isn't specified with `format_set_diag_border()` then it
 * will default to #LXW_BORDER_THIN.
 */
    void format_set_diag_type(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the color of the right cell border.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell border color.
 *
 * See format_set_border_color() for details on the border colors.
 */
    void format_set_right_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the color of the left cell border.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell border color.
 *
 * See format_set_border_color() for details on the border colors.
 */
    void format_set_left_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the color of the top cell border.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell border color.
 *
 * See format_set_border_color() for details on the border colors.
 */
    void format_set_top_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the color of the bottom cell border.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell border color.
 *
 * See format_set_border_color() for details on the border colors.
 */
    void format_set_bottom_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the color of the cell border.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell border color.
 *
 * Individual border elements can be configured using the following methods with
 * the same parameters:
 *
 * - format_set_bottom_color()
 * - format_set_top_color()
 * - format_set_left_color()
 * - format_set_right_color()
 *
 * Set the color of the cell borders. A cell border is comprised of a border
 * on the bottom, top, left and right. These can be set to the same color
 * using format_set_border_color() or individually using the relevant method
 * calls shown above.
 *
 * The color should be an RGB integer value, see @ref working_with_colors.
 */
    void format_set_border_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the cell right border style.
 *
 * @param format Pointer to a Format instance.
 * @param style  Border style index.
 *
 * Set the cell right border style. See format_set_border() for details on the
 * border styles.
 */
    void format_set_right(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the cell left border style.
 *
 * @param format Pointer to a Format instance.
 * @param style  Border style index.
 *
 * Set the cell left border style. See format_set_border() for details on the
 * border styles.
 */
    void format_set_left(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the cell top border style.
 *
 * @param format Pointer to a Format instance.
 * @param style  Border style index.
 *
 * Set the cell top border style. See format_set_border() for details on the border
 * styles.
 */
    void format_set_top(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the cell bottom border style.
 *
 * @param format Pointer to a Format instance.
 * @param style  Border style index.
 *
 * Set the cell bottom border style. See format_set_border() for details on the
 * border styles.
 */
    void format_set_bottom(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the cell border style.
 *
 * @param format Pointer to a Format instance.
 * @param style  Border style index.
 *
 * Set the cell border style:
 *
 * @code
 *     format_set_border(format, LXW_BORDER_THIN);
 * @endcode
 *
 * Individual border elements can be configured using the following functions with
 * the same parameters:
 *
 * - format_set_bottom()
 * - format_set_top()
 * - format_set_left()
 * - format_set_right()
 *
 * A cell border is comprised of a border on the bottom, top, left and right.
 * These can be set to the same value using format_set_border() or
 * individually using the relevant method calls shown above.
 *
 * The following border styles are available:
 *
 * - #LXW_BORDER_THIN
 * - #LXW_BORDER_MEDIUM
 * - #LXW_BORDER_DASHED
 * - #LXW_BORDER_DOTTED
 * - #LXW_BORDER_THICK
 * - #LXW_BORDER_DOUBLE
 * - #LXW_BORDER_HAIR
 * - #LXW_BORDER_MEDIUM_DASHED
 * - #LXW_BORDER_DASH_DOT
 * - #LXW_BORDER_MEDIUM_DASH_DOT
 * - #LXW_BORDER_DASH_DOT_DOT
 * - #LXW_BORDER_MEDIUM_DASH_DOT_DOT
 * - #LXW_BORDER_SLANT_DASH_DOT
 *
 *  The most commonly used style is the `thin` style.
 */
    void format_set_border(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the pattern foreground color for a cell.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell pattern foreground  color.
 *
 * The format_set_fg_color() method can be used to set the foreground color of
 * a pattern.
 *
 * The color should be an RGB integer value, see @ref working_with_colors.
 *
 */
    void format_set_fg_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the pattern background color for a cell.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell pattern background color.
 *
 * The format_set_bg_color() method can be used to set the background color of
 * a pattern. Patterns are defined via the format_set_pattern() method. If a
 * pattern hasn't been defined then a solid fill pattern is used as the
 * default.
 *
 * Here is an example of how to set up a solid fill in a cell:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *
 *     format_set_pattern (format, LXW_PATTERN_SOLID);
 *     format_set_bg_color(format, LXW_COLOR_GREEN);
 *
 *     worksheet_write_string(worksheet, 0, 0, "Ray", format);
 * @endcode
 *
 * @image html formats_set_bg_color.png
 *
 * The color should be an RGB integer value, see @ref working_with_colors.
 *
 */
    void format_set_bg_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the background fill pattern for a cell
 *
 * @param format Pointer to a Format instance.
 * @param index  Pattern index.
 *
 * Set the background pattern for a cell.
 *
 * The most common pattern is a solid fill of the background color:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *
 *     format_set_pattern (format, LXW_PATTERN_SOLID);
 *     format_set_bg_color(format, LXW_COLOR_YELLOW);
 * @endcode
 *
 * The available fill patterns are:
 *
 *    Fill Type                     | Define
 *    ----------------------------- | -----------------------------
 *    Solid                         | #LXW_PATTERN_SOLID
 *    Medium gray                   | #LXW_PATTERN_MEDIUM_GRAY
 *    Dark gray                     | #LXW_PATTERN_DARK_GRAY
 *    Light gray                    | #LXW_PATTERN_LIGHT_GRAY
 *    Dark horizontal line          | #LXW_PATTERN_DARK_HORIZONTAL
 *    Dark vertical line            | #LXW_PATTERN_DARK_VERTICAL
 *    Dark diagonal stripe          | #LXW_PATTERN_DARK_DOWN
 *    Reverse dark diagonal stripe  | #LXW_PATTERN_DARK_UP
 *    Dark grid                     | #LXW_PATTERN_DARK_GRID
 *    Dark trellis                  | #LXW_PATTERN_DARK_TRELLIS
 *    Light horizontal line         | #LXW_PATTERN_LIGHT_HORIZONTAL
 *    Light vertical line           | #LXW_PATTERN_LIGHT_VERTICAL
 *    Light diagonal stripe         | #LXW_PATTERN_LIGHT_DOWN
 *    Reverse light diagonal stripe | #LXW_PATTERN_LIGHT_UP
 *    Light grid                    | #LXW_PATTERN_LIGHT_GRID
 *    Light trellis                 | #LXW_PATTERN_LIGHT_TRELLIS
 *    12.5% gray                    | #LXW_PATTERN_GRAY_125
 *    6.25% gray                    | #LXW_PATTERN_GRAY_0625
 *
 */
    void format_set_pattern(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Turn on the text "shrink to fit" for a cell.
 *
 * @param format Pointer to a Format instance.
 *
 * This method can be used to shrink text so that it fits in a cell:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_shrink(format);
 *
 *     worksheet_write_string(worksheet, 0, 0, "Honey, I shrunk the text!", format);
 * @endcode
 */
    void format_set_shrink(lxw_format*) @nogc nothrow;
    /**
 * @brief Set the cell text indentation level.
 *
 * @param format Pointer to a Format instance.
 * @param level  Indentation level.
 *
 * This method can be used to indent text in a cell. The argument, which should be
 * an integer, is taken as the level of indentation:
 *
 * @code
 *     format1 = workbook_add_format(workbook);
 *     format2 = workbook_add_format(workbook);
 *
 *     format_set_indent(format1, 1);
 *     format_set_indent(format2, 2);
 *
 *     worksheet_write_string(worksheet, 0, 0, "This text is indented 1 level",  format1);
 *     worksheet_write_string(worksheet, 1, 0, "This text is indented 2 levels", format2);
 * @endcode
 *
 * @image html text_indent.png
 *
 * @note
 * Indentation is a horizontal alignment property. It will override any other
 * horizontal properties but it can be used in conjunction with vertical
 * properties.
 */
    void format_set_indent(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the rotation of the text in a cell.
 *
 * @param format Pointer to a Format instance.
 * @param angle  Rotation angle in the range -90 to 90 and 270.
 *
 * Set the rotation of the text in a cell. The rotation can be any angle in the
 * range -90 to 90 degrees:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_rotation(format, 30);
 *
 *     worksheet_write_string(worksheet, 0, 0, "This text is rotated", format);
 * @endcode
 *
 * @image html format_font_text_rotated.png
 *
 * The angle 270 is also supported. This indicates text where the letters run from
 * top to bottom.
 */
    void format_set_rotation(lxw_format*, short) @nogc nothrow;
    /**
 * @brief Wrap text in a cell.
 *
 * Turn text wrapping on for text in a cell.
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_text_wrap(format);
 *
 *     worksheet_write_string(worksheet, 0, 0, "Some long text to wrap in a cell", format);
 * @endcode
 *
 * If you wish to control where the text is wrapped you can add newline characters
 * to the string:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_text_wrap(format);
 *
 *     worksheet_write_string(worksheet, 0, 0, "It's\na bum\nwrap", format);
 * @endcode
 *
 * @image html format_font_text_wrap.png
 *
 * Excel will adjust the height of the row to accommodate the wrapped text. A
 * similar effect can be obtained without newlines using the
 * format_set_align() function with #LXW_ALIGN_VERTICAL_JUSTIFY.
 */
    void format_set_text_wrap(lxw_format*) @nogc nothrow;
    /**
 * @brief Set the alignment for data in the cell.
 *
 * @param format    Pointer to a Format instance.
 * @param alignment The horizontal and or vertical alignment direction.
 *
 * This method is used to set the horizontal and vertical text alignment within a
 * cell. The following are the available horizontal alignments:
 *
 * - #LXW_ALIGN_LEFT
 * - #LXW_ALIGN_CENTER
 * - #LXW_ALIGN_RIGHT
 * - #LXW_ALIGN_FILL
 * - #LXW_ALIGN_JUSTIFY
 * - #LXW_ALIGN_CENTER_ACROSS
 * - #LXW_ALIGN_DISTRIBUTED
 *
 * The following are the available vertical alignments:
 *
 * - #LXW_ALIGN_VERTICAL_TOP
 * - #LXW_ALIGN_VERTICAL_BOTTOM
 * - #LXW_ALIGN_VERTICAL_CENTER
 * - #LXW_ALIGN_VERTICAL_JUSTIFY
 * - #LXW_ALIGN_VERTICAL_DISTRIBUTED
 *
 * As in Excel, vertical and horizontal alignments can be combined:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *
 *     format_set_align(format, LXW_ALIGN_CENTER);
 *     format_set_align(format, LXW_ALIGN_VERTICAL_CENTER);
 *
 *     worksheet_set_row(0, 30);
 *     worksheet_write_string(worksheet, 0, 0, "Some Text", format);
 * @endcode
 *
 * @image html format_font_align.png
 *
 * Text can be aligned across two or more adjacent cells using the
 * center_across property. However, for genuine merged cells it is better to
 * use the worksheet_merge_range() worksheet method.
 *
 * The vertical justify option can be used to provide automatic text wrapping
 * in a cell. The height of the cell will be adjusted to accommodate the
 * wrapped text. To specify where the text wraps use the
 * format_set_text_wrap() method.
 */
    void format_set_align(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Hide formulas in a cell.
 *
 * @param format Pointer to a Format instance.
 *
 * This property is used to hide a formula while still displaying its
 * result. This is generally used to hide complex calculations from end users
 * who are only interested in the result. It only has an effect if the
 * worksheet has been protected using the worksheet worksheet_protect()
 * function:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_hidden(format);
 *
 *     // Enable worksheet protection, without password or options.
 *     worksheet_protect(worksheet, NULL, NULL);
 *
 *     // The formula in this cell isn't visible.
 *     worksheet_write_formula(worksheet, 0, 0, "=1+2", format);
 * @endcode
 */
    void format_set_hidden(lxw_format*) @nogc nothrow;
    /**
 * @brief Set the cell unlocked state.
 *
 * @param format Pointer to a Format instance.
 *
 * This property can be used to allow modification of a cell in a protected
 * worksheet. In Excel, cell locking is turned on by default for all
 * cells. However, it only has an effect if the worksheet has been protected
 * using the worksheet worksheet_protect() function:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_unlocked(format);
 *
 *     // Enable worksheet protection, without password or options.
 *     worksheet_protect(worksheet, NULL, NULL);
 *
 *     // This cell cannot be edited.
 *     worksheet_write_formula(worksheet, 0, 0, "=1+2", NULL);
 *
 *     // This cell can be edited.
 *     worksheet_write_formula(worksheet, 1, 0, "=1+2", format);
 * @endcode
 */
    void format_set_unlocked(lxw_format*) @nogc nothrow;
    /**
 * @brief Set the Excel built-in number format for a cell.
 *
 * @param format Pointer to a Format instance.
 * @param index  The built-in number format index for the cell.
 *
 * This function is similar to format_set_num_format() except that it takes an
 * index to a limited number of Excel's built-in number formats instead of a
 * user defined format string:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_num_format_index(format, 0x0F); // d-mmm-yy
 * @endcode
 *
 * @note
 * Unless you need to specifically access one of Excel's built-in number
 * formats the format_set_num_format() function above is a better
 * solution. The format_set_num_format_index() function is mainly included for
 * backward compatibility and completeness.
 *
 * The Excel built-in number formats as shown in the table below:
 *
 *   | Index | Index | Format String                                        |
 *   | ----- | ----- | ---------------------------------------------------- |
 *   | 0     | 0x00  | `General`                                            |
 *   | 1     | 0x01  | `0`                                                  |
 *   | 2     | 0x02  | `0.00`                                               |
 *   | 3     | 0x03  | `#,##0`                                              |
 *   | 4     | 0x04  | `#,##0.00`                                           |
 *   | 5     | 0x05  | `($#,##0_);($#,##0)`                                 |
 *   | 6     | 0x06  | `($#,##0_);[Red]($#,##0)`                            |
 *   | 7     | 0x07  | `($#,##0.00_);($#,##0.00)`                           |
 *   | 8     | 0x08  | `($#,##0.00_);[Red]($#,##0.00)`                      |
 *   | 9     | 0x09  | `0%`                                                 |
 *   | 10    | 0x0a  | `0.00%`                                              |
 *   | 11    | 0x0b  | `0.00E+00`                                           |
 *   | 12    | 0x0c  | `# ?/?`                                              |
 *   | 13    | 0x0d  | `# ??/??`                                            |
 *   | 14    | 0x0e  | `m/d/yy`                                             |
 *   | 15    | 0x0f  | `d-mmm-yy`                                           |
 *   | 16    | 0x10  | `d-mmm`                                              |
 *   | 17    | 0x11  | `mmm-yy`                                             |
 *   | 18    | 0x12  | `h:mm AM/PM`                                         |
 *   | 19    | 0x13  | `h:mm:ss AM/PM`                                      |
 *   | 20    | 0x14  | `h:mm`                                               |
 *   | 21    | 0x15  | `h:mm:ss`                                            |
 *   | 22    | 0x16  | `m/d/yy h:mm`                                        |
 *   | ...   | ...   | ...                                                  |
 *   | 37    | 0x25  | `(#,##0_);(#,##0)`                                   |
 *   | 38    | 0x26  | `(#,##0_);[Red](#,##0)`                              |
 *   | 39    | 0x27  | `(#,##0.00_);(#,##0.00)`                             |
 *   | 40    | 0x28  | `(#,##0.00_);[Red](#,##0.00)`                        |
 *   | 41    | 0x29  | `_(* #,##0_);_(* (#,##0);_(* "-"_);_(@_)`            |
 *   | 42    | 0x2a  | `_($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)`         |
 *   | 43    | 0x2b  | `_(* #,##0.00_);_(* (#,##0.00);_(* "-"??_);_(@_)`    |
 *   | 44    | 0x2c  | `_($* #,##0.00_);_($* (#,##0.00);_($* "-"??_);_(@_)` |
 *   | 45    | 0x2d  | `mm:ss`                                              |
 *   | 46    | 0x2e  | `[h]:mm:ss`                                          |
 *   | 47    | 0x2f  | `mm:ss.0`                                            |
 *   | 48    | 0x30  | `##0.0E+0`                                           |
 *   | 49    | 0x31  | `@`                                                  |
 *
 * @note
 *  -  Numeric formats 23 to 36 are not documented by Microsoft and may differ
 *     in international versions. The listed date and currency formats may also
 *     vary depending on system settings.
 *  - The dollar sign in the above format appears as the defined local currency
 *    symbol.
 *  - These formats can also be set via format_set_num_format().
 *  - See also @ref ww_formats_categories.
 */
    void format_set_num_format_index(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the number format for a cell.
 *
 * @param format      Pointer to a Format instance.
 * @param num_format The cell number format string.
 *
 * This method is used to define the numerical format of a number in
 * Excel. It controls whether a number is displayed as an integer, a
 * floating point number, a date, a currency value or some other user
 * defined format.
 *
 * The numerical format of a cell can be specified by using a format
 * string:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_num_format(format, "d mmm yyyy");
 * @endcode
 *
 * Format strings can control any aspect of number formatting allowed by Excel:
 *
 * @dontinclude format_num_format.c
 * @skipline set_num_format
 * @until 1209
 *
 * @image html format_set_num_format.png
 *
 * To set a number format that matches an Excel format category such as "Date"
 * or "Currency" see @ref ww_formats_categories.
 *
 * The number system used for dates is described in @ref working_with_dates.
 *
 * For more information on number formats in Excel refer to the
 * [Microsoft documentation on cell formats](http://office.microsoft.com/en-gb/assistance/HP051995001033.aspx).
 */
    void format_set_num_format(lxw_format*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the superscript/subscript property of the font.
 *
 * @param format Pointer to a Format instance.
 * @param style  Superscript or subscript style.
 *
 * Set the superscript o subscript property of the font.
 *
 * @image html format_font_script.png
 *
 * The available script styles are:
 *
 * - #LXW_FONT_SUPERSCRIPT
 * - #LXW_FONT_SUBSCRIPT
 */
    void format_set_font_script(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Set the strikeout property of the font.
 *
 * @param format Pointer to a Format instance.
 *
 * @image html format_font_strikeout.png
 *
 */
    void format_set_font_strikeout(lxw_format*) @nogc nothrow;
    /**
 * @brief Turn on underline for the format:
 *
 * @param format Pointer to a Format instance.
 * @param style Underline style.
 *
 * Set the underline property of the format:
 *
 * @code
 *     format_set_underline(format, LXW_UNDERLINE_SINGLE);
 * @endcode
 *
 * @image html format_font_underlined.png
 *
 * The available underline styles are:
 *
 * - #LXW_UNDERLINE_SINGLE
 * - #LXW_UNDERLINE_DOUBLE
 * - #LXW_UNDERLINE_SINGLE_ACCOUNTING
 * - #LXW_UNDERLINE_DOUBLE_ACCOUNTING
 *
 */
    void format_set_underline(lxw_format*, ubyte) @nogc nothrow;
    /**
 * @brief Turn on italic for the format font.
 *
 * @param format Pointer to a Format instance.
 *
 * Set the italic property of the font:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_italic(format);
 *
 *     worksheet_write_string(worksheet, 0, 0, "Italic Text", format);
 * @endcode
 *
 * @image html format_font_italic.png
 */
    void format_set_italic(lxw_format*) @nogc nothrow;
    /**
 * @brief Turn on bold for the format font.
 *
 * @param format Pointer to a Format instance.
 *
 * Set the bold property of the font:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_bold(format);
 *
 *     worksheet_write_string(worksheet, 0, 0, "Bold Text", format);
 * @endcode
 *
 * @image html format_font_bold.png
 */
    void format_set_bold(lxw_format*) @nogc nothrow;
    /**
 * @brief Set the color of the font used in the cell.
 *
 * @param format Pointer to a Format instance.
 * @param color  The cell font color.
 *
 *
 * Set the font color:
 *
 * @code
 *     format = workbook_add_format(workbook);
 *     format_set_font_color(format, LXW_COLOR_RED);
 *
 *     worksheet_write_string(worksheet, 0, 0, "Wheelbarrow", format);
 * @endcode
 *
 * @image html format_font_color.png
 *
 * The color should be an RGB integer value, see @ref working_with_colors.
 *
 * @note
 * The format_set_font_color() method is used to set the font color in a
 * cell. To set the color of a cell background use the format_set_bg_color()
 * and format_set_pattern() methods.
 */
    void format_set_font_color(lxw_format*, uint) @nogc nothrow;
    /**
 * @brief Set the size of the font used in the cell.
 *
 * @param format Pointer to a Format instance.
 * @param size   The cell font size.
 *
 * Set the font size of the cell format:
 *
 * @code
 *     format_set_font_size(format, 30);
 * @endcode
 *
 * @image html format_font_size.png
 *
 * Excel adjusts the height of a row to accommodate the largest font
 * size in the row. You can also explicitly specify the height of a
 * row using the worksheet_set_row() function.
 */
    void format_set_font_size(lxw_format*, double) @nogc nothrow;
    /**
 * @brief Set the font used in the cell.
 *
 * @param format    Pointer to a Format instance.
 * @param font_name Cell font name.
 *
 * Specify the font used used in the cell format:
 *
 * @code
 *     format_set_font_name(format, "Avenir Black Oblique");
 * @endcode
 *
 * @image html format_set_font_name.png
 *
 * Excel can only display fonts that are installed on the system that it is
 * running on. Therefore it is generally best to use the fonts that come as
 * standard with Excel such as Calibri, Times New Roman and Courier New.
 *
 * The default font in Excel 2007, and later, is Calibri.
 */
    void format_set_font_name(lxw_format*, const(char)*) @nogc nothrow;

    lxw_fill* lxw_format_get_fill_key(lxw_format*) @nogc nothrow;

    lxw_border* lxw_format_get_border_key(lxw_format*) @nogc nothrow;

    lxw_font* lxw_format_get_font_key(lxw_format*) @nogc nothrow;

    int lxw_format_get_dxf_index(lxw_format*) @nogc nothrow;

    int lxw_format_get_xf_index(lxw_format*) @nogc nothrow;

    void lxw_format_free(lxw_format*) @nogc nothrow;

    lxw_format* lxw_format_new() @nogc nothrow;

    struct lxw_fill
    {

        uint fg_color;

        uint bg_color;

        ubyte pattern;
    }

    struct lxw_border
    {

        ubyte bottom;

        ubyte diag_border;

        ubyte diag_type;

        ubyte left;

        ubyte right;

        ubyte top;

        uint bottom_color;

        uint diag_color;

        uint left_color;

        uint right_color;

        uint top_color;
    }

    struct lxw_font
    {

        char[128] font_name;

        double font_size;

        ubyte bold;

        ubyte italic;

        ubyte underline;

        ubyte theme;

        ubyte font_strikeout;

        ubyte font_outline;

        ubyte font_shadow;

        ubyte font_script;

        ubyte font_family;

        ubyte font_charset;

        ubyte font_condense;

        ubyte font_extend;

        uint font_color;
    }
    /** Cell border styles for use with format_set_border(). */
    enum lxw_format_borders
    {
        /** No border */
        LXW_BORDER_NONE = 0,
        /** Thin border style */
        LXW_BORDER_THIN = 1,
        /** Medium border style */
        LXW_BORDER_MEDIUM = 2,
        /** Dashed border style */
        LXW_BORDER_DASHED = 3,
        /** Dotted border style */
        LXW_BORDER_DOTTED = 4,
        /** Thick border style */
        LXW_BORDER_THICK = 5,
        /** Double border style */
        LXW_BORDER_DOUBLE = 6,
        /** Hair border style */
        LXW_BORDER_HAIR = 7,
        /** Medium dashed border style */
        LXW_BORDER_MEDIUM_DASHED = 8,
        /** Dash-dot border style */
        LXW_BORDER_DASH_DOT = 9,
        /** Medium dash-dot border style */
        LXW_BORDER_MEDIUM_DASH_DOT = 10,
        /** Dash-dot-dot border style */
        LXW_BORDER_DASH_DOT_DOT = 11,
        /** Medium dash-dot-dot border style */
        LXW_BORDER_MEDIUM_DASH_DOT_DOT = 12,
        /** Slant dash-dot border style */
        LXW_BORDER_SLANT_DASH_DOT = 13,
    }
    enum LXW_BORDER_NONE = lxw_format_borders.LXW_BORDER_NONE;
    enum LXW_BORDER_THIN = lxw_format_borders.LXW_BORDER_THIN;
    enum LXW_BORDER_MEDIUM = lxw_format_borders.LXW_BORDER_MEDIUM;
    enum LXW_BORDER_DASHED = lxw_format_borders.LXW_BORDER_DASHED;
    enum LXW_BORDER_DOTTED = lxw_format_borders.LXW_BORDER_DOTTED;
    enum LXW_BORDER_THICK = lxw_format_borders.LXW_BORDER_THICK;
    enum LXW_BORDER_DOUBLE = lxw_format_borders.LXW_BORDER_DOUBLE;
    enum LXW_BORDER_HAIR = lxw_format_borders.LXW_BORDER_HAIR;
    enum LXW_BORDER_MEDIUM_DASHED = lxw_format_borders.LXW_BORDER_MEDIUM_DASHED;
    enum LXW_BORDER_DASH_DOT = lxw_format_borders.LXW_BORDER_DASH_DOT;
    enum LXW_BORDER_MEDIUM_DASH_DOT = lxw_format_borders.LXW_BORDER_MEDIUM_DASH_DOT;
    enum LXW_BORDER_DASH_DOT_DOT = lxw_format_borders.LXW_BORDER_DASH_DOT_DOT;
    enum LXW_BORDER_MEDIUM_DASH_DOT_DOT = lxw_format_borders.LXW_BORDER_MEDIUM_DASH_DOT_DOT;
    enum LXW_BORDER_SLANT_DASH_DOT = lxw_format_borders.LXW_BORDER_SLANT_DASH_DOT;
    /** Pattern value for use with format_set_pattern(). */
    enum lxw_format_patterns
    {
        /** Empty pattern */
        LXW_PATTERN_NONE = 0,
        /** Solid pattern */
        LXW_PATTERN_SOLID = 1,
        /** Medium gray pattern */
        LXW_PATTERN_MEDIUM_GRAY = 2,
        /** Dark gray pattern */
        LXW_PATTERN_DARK_GRAY = 3,
        /** Light gray pattern */
        LXW_PATTERN_LIGHT_GRAY = 4,
        /** Dark horizontal line pattern */
        LXW_PATTERN_DARK_HORIZONTAL = 5,
        /** Dark vertical line pattern */
        LXW_PATTERN_DARK_VERTICAL = 6,
        /** Dark diagonal stripe pattern */
        LXW_PATTERN_DARK_DOWN = 7,
        /** Reverse dark diagonal stripe pattern */
        LXW_PATTERN_DARK_UP = 8,
        /** Dark grid pattern */
        LXW_PATTERN_DARK_GRID = 9,
        /** Dark trellis pattern */
        LXW_PATTERN_DARK_TRELLIS = 10,
        /** Light horizontal Line pattern */
        LXW_PATTERN_LIGHT_HORIZONTAL = 11,
        /** Light vertical line pattern */
        LXW_PATTERN_LIGHT_VERTICAL = 12,
        /** Light diagonal stripe pattern */
        LXW_PATTERN_LIGHT_DOWN = 13,
        /** Reverse light diagonal stripe pattern */
        LXW_PATTERN_LIGHT_UP = 14,
        /** Light grid pattern */
        LXW_PATTERN_LIGHT_GRID = 15,
        /** Light trellis pattern */
        LXW_PATTERN_LIGHT_TRELLIS = 16,
        /** 12.5% gray pattern */
        LXW_PATTERN_GRAY_125 = 17,
        /** 6.25% gray pattern */
        LXW_PATTERN_GRAY_0625 = 18,
    }
    enum LXW_PATTERN_NONE = lxw_format_patterns.LXW_PATTERN_NONE;
    enum LXW_PATTERN_SOLID = lxw_format_patterns.LXW_PATTERN_SOLID;
    enum LXW_PATTERN_MEDIUM_GRAY = lxw_format_patterns.LXW_PATTERN_MEDIUM_GRAY;
    enum LXW_PATTERN_DARK_GRAY = lxw_format_patterns.LXW_PATTERN_DARK_GRAY;
    enum LXW_PATTERN_LIGHT_GRAY = lxw_format_patterns.LXW_PATTERN_LIGHT_GRAY;
    enum LXW_PATTERN_DARK_HORIZONTAL = lxw_format_patterns.LXW_PATTERN_DARK_HORIZONTAL;
    enum LXW_PATTERN_DARK_VERTICAL = lxw_format_patterns.LXW_PATTERN_DARK_VERTICAL;
    enum LXW_PATTERN_DARK_DOWN = lxw_format_patterns.LXW_PATTERN_DARK_DOWN;
    enum LXW_PATTERN_DARK_UP = lxw_format_patterns.LXW_PATTERN_DARK_UP;
    enum LXW_PATTERN_DARK_GRID = lxw_format_patterns.LXW_PATTERN_DARK_GRID;
    enum LXW_PATTERN_DARK_TRELLIS = lxw_format_patterns.LXW_PATTERN_DARK_TRELLIS;
    enum LXW_PATTERN_LIGHT_HORIZONTAL = lxw_format_patterns.LXW_PATTERN_LIGHT_HORIZONTAL;
    enum LXW_PATTERN_LIGHT_VERTICAL = lxw_format_patterns.LXW_PATTERN_LIGHT_VERTICAL;
    enum LXW_PATTERN_LIGHT_DOWN = lxw_format_patterns.LXW_PATTERN_LIGHT_DOWN;
    enum LXW_PATTERN_LIGHT_UP = lxw_format_patterns.LXW_PATTERN_LIGHT_UP;
    enum LXW_PATTERN_LIGHT_GRID = lxw_format_patterns.LXW_PATTERN_LIGHT_GRID;
    enum LXW_PATTERN_LIGHT_TRELLIS = lxw_format_patterns.LXW_PATTERN_LIGHT_TRELLIS;
    enum LXW_PATTERN_GRAY_125 = lxw_format_patterns.LXW_PATTERN_GRAY_125;
    enum LXW_PATTERN_GRAY_0625 = lxw_format_patterns.LXW_PATTERN_GRAY_0625;
    /** Predefined values for common colors. */
    enum lxw_defined_colors
    {
        /** Black */
        LXW_COLOR_BLACK = 16777216,
        /** Blue */
        LXW_COLOR_BLUE = 255,
        /** Brown */
        LXW_COLOR_BROWN = 8388608,
        /** Cyan */
        LXW_COLOR_CYAN = 65535,
        /** Gray */
        LXW_COLOR_GRAY = 8421504,
        /** Green */
        LXW_COLOR_GREEN = 32768,
        /** Lime */
        LXW_COLOR_LIME = 65280,
        /** Magenta */
        LXW_COLOR_MAGENTA = 16711935,
        /** Navy */
        LXW_COLOR_NAVY = 128,
        /** Orange */
        LXW_COLOR_ORANGE = 16737792,
        /** Pink */
        LXW_COLOR_PINK = 16711935,
        /** Purple */
        LXW_COLOR_PURPLE = 8388736,
        /** Red */
        LXW_COLOR_RED = 16711680,
        /** Silver */
        LXW_COLOR_SILVER = 12632256,
        /** White */
        LXW_COLOR_WHITE = 16777215,
        /** Yellow */
        LXW_COLOR_YELLOW = 16776960,
    }
    enum LXW_COLOR_BLACK = lxw_defined_colors.LXW_COLOR_BLACK;
    enum LXW_COLOR_BLUE = lxw_defined_colors.LXW_COLOR_BLUE;
    enum LXW_COLOR_BROWN = lxw_defined_colors.LXW_COLOR_BROWN;
    enum LXW_COLOR_CYAN = lxw_defined_colors.LXW_COLOR_CYAN;
    enum LXW_COLOR_GRAY = lxw_defined_colors.LXW_COLOR_GRAY;
    enum LXW_COLOR_GREEN = lxw_defined_colors.LXW_COLOR_GREEN;
    enum LXW_COLOR_LIME = lxw_defined_colors.LXW_COLOR_LIME;
    enum LXW_COLOR_MAGENTA = lxw_defined_colors.LXW_COLOR_MAGENTA;
    enum LXW_COLOR_NAVY = lxw_defined_colors.LXW_COLOR_NAVY;
    enum LXW_COLOR_ORANGE = lxw_defined_colors.LXW_COLOR_ORANGE;
    enum LXW_COLOR_PINK = lxw_defined_colors.LXW_COLOR_PINK;
    enum LXW_COLOR_PURPLE = lxw_defined_colors.LXW_COLOR_PURPLE;
    enum LXW_COLOR_RED = lxw_defined_colors.LXW_COLOR_RED;
    enum LXW_COLOR_SILVER = lxw_defined_colors.LXW_COLOR_SILVER;
    enum LXW_COLOR_WHITE = lxw_defined_colors.LXW_COLOR_WHITE;
    enum LXW_COLOR_YELLOW = lxw_defined_colors.LXW_COLOR_YELLOW;
    /**
 * Diagonal border types.
 *
 */
    enum lxw_format_diagonal_types
    {
        /** Cell diagonal border from bottom left to top right. */
        LXW_DIAGONAL_BORDER_UP = 1,
        /** Cell diagonal border from top left to bottom right. */
        LXW_DIAGONAL_BORDER_DOWN = 2,
        /** Cell diagonal border in both directions. */
        LXW_DIAGONAL_BORDER_UP_DOWN = 3,
    }
    enum LXW_DIAGONAL_BORDER_UP = lxw_format_diagonal_types.LXW_DIAGONAL_BORDER_UP;
    enum LXW_DIAGONAL_BORDER_DOWN = lxw_format_diagonal_types.LXW_DIAGONAL_BORDER_DOWN;
    enum LXW_DIAGONAL_BORDER_UP_DOWN = lxw_format_diagonal_types.LXW_DIAGONAL_BORDER_UP_DOWN;
    /** Alignment values for format_set_align(). */
    enum lxw_format_alignments
    {
        /** No alignment. Cell will use Excel's default for the data type */
        LXW_ALIGN_NONE = 0,
        /** Left horizontal alignment */
        LXW_ALIGN_LEFT = 1,
        /** Center horizontal alignment */
        LXW_ALIGN_CENTER = 2,
        /** Right horizontal alignment */
        LXW_ALIGN_RIGHT = 3,
        /** Cell fill horizontal alignment */
        LXW_ALIGN_FILL = 4,
        /** Justify horizontal alignment */
        LXW_ALIGN_JUSTIFY = 5,
        /** Center Across horizontal alignment */
        LXW_ALIGN_CENTER_ACROSS = 6,
        /** Left horizontal alignment */
        LXW_ALIGN_DISTRIBUTED = 7,
        /** Top vertical alignment */
        LXW_ALIGN_VERTICAL_TOP = 8,
        /** Bottom vertical alignment */
        LXW_ALIGN_VERTICAL_BOTTOM = 9,
        /** Center vertical alignment */
        LXW_ALIGN_VERTICAL_CENTER = 10,
        /** Justify vertical alignment */
        LXW_ALIGN_VERTICAL_JUSTIFY = 11,
        /** Distributed vertical alignment */
        LXW_ALIGN_VERTICAL_DISTRIBUTED = 12,
    }
    enum LXW_ALIGN_NONE = lxw_format_alignments.LXW_ALIGN_NONE;
    enum LXW_ALIGN_LEFT = lxw_format_alignments.LXW_ALIGN_LEFT;
    enum LXW_ALIGN_CENTER = lxw_format_alignments.LXW_ALIGN_CENTER;
    enum LXW_ALIGN_RIGHT = lxw_format_alignments.LXW_ALIGN_RIGHT;
    enum LXW_ALIGN_FILL = lxw_format_alignments.LXW_ALIGN_FILL;
    enum LXW_ALIGN_JUSTIFY = lxw_format_alignments.LXW_ALIGN_JUSTIFY;
    enum LXW_ALIGN_CENTER_ACROSS = lxw_format_alignments.LXW_ALIGN_CENTER_ACROSS;
    enum LXW_ALIGN_DISTRIBUTED = lxw_format_alignments.LXW_ALIGN_DISTRIBUTED;
    enum LXW_ALIGN_VERTICAL_TOP = lxw_format_alignments.LXW_ALIGN_VERTICAL_TOP;
    enum LXW_ALIGN_VERTICAL_BOTTOM = lxw_format_alignments.LXW_ALIGN_VERTICAL_BOTTOM;
    enum LXW_ALIGN_VERTICAL_CENTER = lxw_format_alignments.LXW_ALIGN_VERTICAL_CENTER;
    enum LXW_ALIGN_VERTICAL_JUSTIFY = lxw_format_alignments.LXW_ALIGN_VERTICAL_JUSTIFY;
    enum LXW_ALIGN_VERTICAL_DISTRIBUTED = lxw_format_alignments.LXW_ALIGN_VERTICAL_DISTRIBUTED;
    /** Superscript and subscript values for format_set_font_script(). */
    enum lxw_format_scripts
    {
        /** Superscript font */
        LXW_FONT_SUPERSCRIPT = 1,
        /** Subscript font */
        LXW_FONT_SUBSCRIPT = 2,
    }
    enum LXW_FONT_SUPERSCRIPT = lxw_format_scripts.LXW_FONT_SUPERSCRIPT;
    enum LXW_FONT_SUBSCRIPT = lxw_format_scripts.LXW_FONT_SUBSCRIPT;
    /** Format underline values for format_set_underline(). */
    enum lxw_format_underlines
    {

        LXW_UNDERLINE_NONE = 0,
        /** Single underline */
        LXW_UNDERLINE_SINGLE = 1,
        /** Double underline */
        LXW_UNDERLINE_DOUBLE = 2,
        /** Single accounting underline */
        LXW_UNDERLINE_SINGLE_ACCOUNTING = 3,
        /** Double accounting underline */
        LXW_UNDERLINE_DOUBLE_ACCOUNTING = 4,
    }
    enum LXW_UNDERLINE_NONE = lxw_format_underlines.LXW_UNDERLINE_NONE;
    enum LXW_UNDERLINE_SINGLE = lxw_format_underlines.LXW_UNDERLINE_SINGLE;
    enum LXW_UNDERLINE_DOUBLE = lxw_format_underlines.LXW_UNDERLINE_DOUBLE;
    enum LXW_UNDERLINE_SINGLE_ACCOUNTING = lxw_format_underlines.LXW_UNDERLINE_SINGLE_ACCOUNTING;
    enum LXW_UNDERLINE_DOUBLE_ACCOUNTING = lxw_format_underlines.LXW_UNDERLINE_DOUBLE_ACCOUNTING;
    /**
 * @brief The type for RGB colors in libxlsxwriter.
 *
 * The type for RGB colors in libxlsxwriter. The valid range is `0x000000`
 * (black) to `0xFFFFFF` (white). See @ref working_with_colors.
 */
    alias lxw_color_t = uint;

    void lxw_add_drawing_object(lxw_drawing*, lxw_drawing_object*) @nogc nothrow;

    void lxw_free_drawing_object(lxw_drawing_object*) @nogc nothrow;

    void lxw_drawing_assemble_xml_file(lxw_drawing*) @nogc nothrow;

    void lxw_drawing_free(lxw_drawing*) @nogc nothrow;

    lxw_drawing* lxw_drawing_new() @nogc nothrow;

    struct lxw_drawing
    {

        _IO_FILE* file;

        ubyte embedded;

        ubyte orientation;

        lxw_drawing_objects* drawing_objects;
    }

    struct lxw_drawing_coords
    {

        uint col;

        uint row;

        double col_offset;

        double row_offset;
    }

    enum image_types
    {

        LXW_IMAGE_UNKNOWN = 0,

        LXW_IMAGE_PNG = 1,

        LXW_IMAGE_JPEG = 2,

        LXW_IMAGE_BMP = 3,

        LXW_IMAGE_GIF = 4,
    }
    enum LXW_IMAGE_UNKNOWN = image_types.LXW_IMAGE_UNKNOWN;
    enum LXW_IMAGE_PNG = image_types.LXW_IMAGE_PNG;
    enum LXW_IMAGE_JPEG = image_types.LXW_IMAGE_JPEG;
    enum LXW_IMAGE_BMP = image_types.LXW_IMAGE_BMP;
    enum LXW_IMAGE_GIF = image_types.LXW_IMAGE_GIF;

    enum lxw_drawing_types
    {

        LXW_DRAWING_NONE = 0,

        LXW_DRAWING_IMAGE = 1,

        LXW_DRAWING_CHART = 2,

        LXW_DRAWING_SHAPE = 3,
    }
    enum LXW_DRAWING_NONE = lxw_drawing_types.LXW_DRAWING_NONE;
    enum LXW_DRAWING_IMAGE = lxw_drawing_types.LXW_DRAWING_IMAGE;
    enum LXW_DRAWING_CHART = lxw_drawing_types.LXW_DRAWING_CHART;
    enum LXW_DRAWING_SHAPE = lxw_drawing_types.LXW_DRAWING_SHAPE;

    struct lxw_drawing_objects
    {

        lxw_drawing_object* stqh_first;

        lxw_drawing_object** stqh_last;
    }

    struct lxw_drawing_object
    {

        ubyte type;

        ubyte anchor;

        lxw_drawing_coords from;

        lxw_drawing_coords to;

        uint col_absolute;

        uint row_absolute;

        uint width;

        uint height;

        ubyte shape;

        uint rel_index;

        uint url_rel_index;

        char* description;

        char* tip;

        ubyte decorative;

        static struct _Anonymous_28
        {

            lxw_drawing_object* stqe_next;
        }

        _Anonymous_28 list_pointers;
    }

    void lxw_custom_assemble_xml_file(lxw_custom*) @nogc nothrow;

    void lxw_custom_free(lxw_custom*) @nogc nothrow;

    lxw_custom* lxw_custom_new() @nogc nothrow;

    struct lxw_custom
    {

        _IO_FILE* file;

        lxw_custom_properties* custom_properties;

        uint pid;
    }

    void lxw_core_assemble_xml_file(lxw_core*) @nogc nothrow;

    void lxw_core_free(lxw_core*) @nogc nothrow;

    lxw_core* lxw_core_new() @nogc nothrow;

    struct lxw_core
    {

        _IO_FILE* file;

        lxw_doc_properties* properties;
    }

    void lxw_ct_add_metadata(lxw_content_types*) @nogc nothrow;

    void lxw_ct_add_custom_properties(lxw_content_types*) @nogc nothrow;

    void lxw_ct_add_calc_chain(lxw_content_types*) @nogc nothrow;

    void lxw_ct_add_shared_strings(lxw_content_types*) @nogc nothrow;

    void lxw_ct_add_vml_name(lxw_content_types*) @nogc nothrow;

    void lxw_ct_add_comment_name(lxw_content_types*, const(char)*) @nogc nothrow;

    void lxw_ct_add_table_name(lxw_content_types*, const(char)*) @nogc nothrow;

    void lxw_ct_add_drawing_name(lxw_content_types*, const(char)*) @nogc nothrow;

    void lxw_ct_add_chart_name(lxw_content_types*, const(char)*) @nogc nothrow;

    void lxw_ct_add_chartsheet_name(lxw_content_types*, const(char)*) @nogc nothrow;

    void lxw_ct_add_worksheet_name(lxw_content_types*, const(char)*) @nogc nothrow;

    void lxw_ct_add_override(lxw_content_types*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_ct_add_default(lxw_content_types*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_content_types_assemble_xml_file(lxw_content_types*) @nogc nothrow;

    void lxw_content_types_free(lxw_content_types*) @nogc nothrow;

    lxw_content_types* lxw_content_types_new() @nogc nothrow;

    struct lxw_content_types
    {

        _IO_FILE* file;

        lxw_tuples* default_types;

        lxw_tuples* overrides;
    }

    struct lxw_custom_properties
    {

        lxw_custom_property* stqh_first;

        lxw_custom_property** stqh_last;
    }

    struct lxw_custom_property
    {

        lxw_custom_property_types type;

        char* name;

        static union _Anonymous_29
        {

            char* string_;

            double number;

            int integer;

            ubyte boolean;

            lxw_datetime datetime;
        }

        _Anonymous_29 u;

        static struct _Anonymous_30
        {

            lxw_custom_property* stqe_next;
        }

        _Anonymous_30 list_pointers;
    }

    struct lxw_tuples
    {

        lxw_tuple* stqh_first;

        lxw_tuple** stqh_last;
    }

    struct lxw_tuple
    {

        char* key;

        char* value;

        static struct _Anonymous_31
        {

            lxw_tuple* stqe_next;
        }

        _Anonymous_31 list_pointers;
    }

    enum _Anonymous_32
    {

        _CS_PATH = 0,

        _CS_V6_WIDTH_RESTRICTED_ENVS = 1,

        _CS_GNU_LIBC_VERSION = 2,

        _CS_GNU_LIBPTHREAD_VERSION = 3,

        _CS_V5_WIDTH_RESTRICTED_ENVS = 4,

        _CS_V7_WIDTH_RESTRICTED_ENVS = 5,

        _CS_LFS_CFLAGS = 1000,

        _CS_LFS_LDFLAGS = 1001,

        _CS_LFS_LIBS = 1002,

        _CS_LFS_LINTFLAGS = 1003,

        _CS_LFS64_CFLAGS = 1004,

        _CS_LFS64_LDFLAGS = 1005,

        _CS_LFS64_LIBS = 1006,

        _CS_LFS64_LINTFLAGS = 1007,

        _CS_XBS5_ILP32_OFF32_CFLAGS = 1100,

        _CS_XBS5_ILP32_OFF32_LDFLAGS = 1101,

        _CS_XBS5_ILP32_OFF32_LIBS = 1102,

        _CS_XBS5_ILP32_OFF32_LINTFLAGS = 1103,

        _CS_XBS5_ILP32_OFFBIG_CFLAGS = 1104,

        _CS_XBS5_ILP32_OFFBIG_LDFLAGS = 1105,

        _CS_XBS5_ILP32_OFFBIG_LIBS = 1106,

        _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = 1107,

        _CS_XBS5_LP64_OFF64_CFLAGS = 1108,

        _CS_XBS5_LP64_OFF64_LDFLAGS = 1109,

        _CS_XBS5_LP64_OFF64_LIBS = 1110,

        _CS_XBS5_LP64_OFF64_LINTFLAGS = 1111,

        _CS_XBS5_LPBIG_OFFBIG_CFLAGS = 1112,

        _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = 1113,

        _CS_XBS5_LPBIG_OFFBIG_LIBS = 1114,

        _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = 1115,

        _CS_POSIX_V6_ILP32_OFF32_CFLAGS = 1116,

        _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = 1117,

        _CS_POSIX_V6_ILP32_OFF32_LIBS = 1118,

        _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = 1119,

        _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = 1120,

        _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = 1121,

        _CS_POSIX_V6_ILP32_OFFBIG_LIBS = 1122,

        _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = 1123,

        _CS_POSIX_V6_LP64_OFF64_CFLAGS = 1124,

        _CS_POSIX_V6_LP64_OFF64_LDFLAGS = 1125,

        _CS_POSIX_V6_LP64_OFF64_LIBS = 1126,

        _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = 1127,

        _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = 1128,

        _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = 1129,

        _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = 1130,

        _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = 1131,

        _CS_POSIX_V7_ILP32_OFF32_CFLAGS = 1132,

        _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = 1133,

        _CS_POSIX_V7_ILP32_OFF32_LIBS = 1134,

        _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = 1135,

        _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = 1136,

        _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = 1137,

        _CS_POSIX_V7_ILP32_OFFBIG_LIBS = 1138,

        _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = 1139,

        _CS_POSIX_V7_LP64_OFF64_CFLAGS = 1140,

        _CS_POSIX_V7_LP64_OFF64_LDFLAGS = 1141,

        _CS_POSIX_V7_LP64_OFF64_LIBS = 1142,

        _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = 1143,

        _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = 1144,

        _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = 1145,

        _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = 1146,

        _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = 1147,

        _CS_V6_ENV = 1148,

        _CS_V7_ENV = 1149,
    }
    enum _CS_PATH = _Anonymous_32._CS_PATH;
    enum _CS_V6_WIDTH_RESTRICTED_ENVS = _Anonymous_32._CS_V6_WIDTH_RESTRICTED_ENVS;
    enum _CS_GNU_LIBC_VERSION = _Anonymous_32._CS_GNU_LIBC_VERSION;
    enum _CS_GNU_LIBPTHREAD_VERSION = _Anonymous_32._CS_GNU_LIBPTHREAD_VERSION;
    enum _CS_V5_WIDTH_RESTRICTED_ENVS = _Anonymous_32._CS_V5_WIDTH_RESTRICTED_ENVS;
    enum _CS_V7_WIDTH_RESTRICTED_ENVS = _Anonymous_32._CS_V7_WIDTH_RESTRICTED_ENVS;
    enum _CS_LFS_CFLAGS = _Anonymous_32._CS_LFS_CFLAGS;
    enum _CS_LFS_LDFLAGS = _Anonymous_32._CS_LFS_LDFLAGS;
    enum _CS_LFS_LIBS = _Anonymous_32._CS_LFS_LIBS;
    enum _CS_LFS_LINTFLAGS = _Anonymous_32._CS_LFS_LINTFLAGS;
    enum _CS_LFS64_CFLAGS = _Anonymous_32._CS_LFS64_CFLAGS;
    enum _CS_LFS64_LDFLAGS = _Anonymous_32._CS_LFS64_LDFLAGS;
    enum _CS_LFS64_LIBS = _Anonymous_32._CS_LFS64_LIBS;
    enum _CS_LFS64_LINTFLAGS = _Anonymous_32._CS_LFS64_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFF32_CFLAGS = _Anonymous_32._CS_XBS5_ILP32_OFF32_CFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LDFLAGS = _Anonymous_32._CS_XBS5_ILP32_OFF32_LDFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LIBS = _Anonymous_32._CS_XBS5_ILP32_OFF32_LIBS;
    enum _CS_XBS5_ILP32_OFF32_LINTFLAGS = _Anonymous_32._CS_XBS5_ILP32_OFF32_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_CFLAGS = _Anonymous_32._CS_XBS5_ILP32_OFFBIG_CFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LDFLAGS = _Anonymous_32._CS_XBS5_ILP32_OFFBIG_LDFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LIBS = _Anonymous_32._CS_XBS5_ILP32_OFFBIG_LIBS;
    enum _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = _Anonymous_32._CS_XBS5_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_XBS5_LP64_OFF64_CFLAGS = _Anonymous_32._CS_XBS5_LP64_OFF64_CFLAGS;
    enum _CS_XBS5_LP64_OFF64_LDFLAGS = _Anonymous_32._CS_XBS5_LP64_OFF64_LDFLAGS;
    enum _CS_XBS5_LP64_OFF64_LIBS = _Anonymous_32._CS_XBS5_LP64_OFF64_LIBS;
    enum _CS_XBS5_LP64_OFF64_LINTFLAGS = _Anonymous_32._CS_XBS5_LP64_OFF64_LINTFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_CFLAGS = _Anonymous_32._CS_XBS5_LPBIG_OFFBIG_CFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _Anonymous_32._CS_XBS5_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LIBS = _Anonymous_32._CS_XBS5_LPBIG_OFFBIG_LIBS;
    enum _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_32._CS_XBS5_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_CFLAGS = _Anonymous_32._CS_POSIX_V6_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _Anonymous_32._CS_POSIX_V6_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LIBS = _Anonymous_32._CS_POSIX_V6_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = _Anonymous_32._CS_POSIX_V6_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _Anonymous_32._CS_POSIX_V6_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _Anonymous_32._CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LIBS = _Anonymous_32._CS_POSIX_V6_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = _Anonymous_32._CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_CFLAGS = _Anonymous_32._CS_POSIX_V6_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LDFLAGS = _Anonymous_32._CS_POSIX_V6_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LIBS = _Anonymous_32._CS_POSIX_V6_LP64_OFF64_LIBS;
    enum _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = _Anonymous_32._CS_POSIX_V6_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _Anonymous_32._CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _Anonymous_32._CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _Anonymous_32._CS_POSIX_V6_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_32._CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_CFLAGS = _Anonymous_32._CS_POSIX_V7_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = _Anonymous_32._CS_POSIX_V7_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LIBS = _Anonymous_32._CS_POSIX_V7_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = _Anonymous_32._CS_POSIX_V7_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = _Anonymous_32._CS_POSIX_V7_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = _Anonymous_32._CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LIBS = _Anonymous_32._CS_POSIX_V7_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = _Anonymous_32._CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_CFLAGS = _Anonymous_32._CS_POSIX_V7_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LDFLAGS = _Anonymous_32._CS_POSIX_V7_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LIBS = _Anonymous_32._CS_POSIX_V7_LP64_OFF64_LIBS;
    enum _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = _Anonymous_32._CS_POSIX_V7_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = _Anonymous_32._CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = _Anonymous_32._CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = _Anonymous_32._CS_POSIX_V7_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_32._CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_V6_ENV = _Anonymous_32._CS_V6_ENV;
    enum _CS_V7_ENV = _Anonymous_32._CS_V7_ENV;

    struct lxw_formats
    {

        lxw_format* stqh_first;

        lxw_format** stqh_last;
    }
    /**
 * @brief Struct to represent the formatting properties of an Excel format.
 *
 * Formats in `libxlsxwriter` are accessed via this struct.
 *
 * The members of the lxw_format struct aren't modified directly. Instead the
 * format properties are set by calling the functions shown in format.h.
 *
 * For example:
 *
 * @code
 *    // Create the Format.
 *    lxw_format *format = workbook_add_format(workbook);
 *
 *    // Set some of the format properties.
 *    format_set_bold(format);
 *    format_set_font_color(format, LXW_COLOR_RED);
 *
 *    // Use the format to change the text format in a cell.
 *    worksheet_write_string(worksheet, 0, 0, "Hello", format);
 *
 * @endcode
 *
 */
    struct lxw_format
    {

        _IO_FILE* file;

        lxw_hash_table* xf_format_indices;

        lxw_hash_table* dxf_format_indices;

        ushort* num_xf_formats;

        ushort* num_dxf_formats;

        int xf_index;

        int dxf_index;

        int xf_id;

        char[128] num_format;

        char[128] font_name;

        char[128] font_scheme;

        ushort num_format_index;

        ushort font_index;

        ubyte has_font;

        ubyte has_dxf_font;

        double font_size;

        ubyte bold;

        ubyte italic;

        uint font_color;

        ubyte underline;

        ubyte font_strikeout;

        ubyte font_outline;

        ubyte font_shadow;

        ubyte font_script;

        ubyte font_family;

        ubyte font_charset;

        ubyte font_condense;

        ubyte font_extend;

        ubyte theme;

        ubyte hyperlink;

        ubyte hidden;

        ubyte locked;

        ubyte text_h_align;

        ubyte text_wrap;

        ubyte text_v_align;

        ubyte text_justlast;

        short rotation;

        uint fg_color;

        uint bg_color;

        uint dxf_fg_color;

        uint dxf_bg_color;

        ubyte pattern;

        ubyte has_fill;

        ubyte has_dxf_fill;

        int fill_index;

        int fill_count;

        int border_index;

        ubyte has_border;

        ubyte has_dxf_border;

        int border_count;

        ubyte bottom;

        ubyte diag_border;

        ubyte diag_type;

        ubyte left;

        ubyte right;

        ubyte top;

        uint bottom_color;

        uint diag_color;

        uint left_color;

        uint right_color;

        uint top_color;

        ubyte indent;

        ubyte shrink;

        ubyte merge_range;

        ubyte reading_order;

        ubyte just_distrib;

        ubyte color_indexed;

        ubyte font_only;

        static struct _Anonymous_33
        {

            lxw_format* stqe_next;
        }

        _Anonymous_33 list_pointers;
    }

    enum lxw_custom_property_types
    {

        LXW_CUSTOM_NONE = 0,

        LXW_CUSTOM_STRING = 1,

        LXW_CUSTOM_DOUBLE = 2,

        LXW_CUSTOM_INTEGER = 3,

        LXW_CUSTOM_BOOLEAN = 4,

        LXW_CUSTOM_DATETIME = 5,
    }
    enum LXW_CUSTOM_NONE = lxw_custom_property_types.LXW_CUSTOM_NONE;
    enum LXW_CUSTOM_STRING = lxw_custom_property_types.LXW_CUSTOM_STRING;
    enum LXW_CUSTOM_DOUBLE = lxw_custom_property_types.LXW_CUSTOM_DOUBLE;
    enum LXW_CUSTOM_INTEGER = lxw_custom_property_types.LXW_CUSTOM_INTEGER;
    enum LXW_CUSTOM_BOOLEAN = lxw_custom_property_types.LXW_CUSTOM_BOOLEAN;
    enum LXW_CUSTOM_DATETIME = lxw_custom_property_types.LXW_CUSTOM_DATETIME;
    /** @brief Struct to represent a date and time in Excel.
 *
 * Struct to represent a date and time in Excel. See @ref working_with_dates.
 */
    struct lxw_datetime
    {
        /** Year     : 1900 - 9999 */
        int year;
        /** Month    : 1 - 12 */
        int month;
        /** Day      : 1 - 31 */
        int day;
        /** Hour     : 0 - 23 */
        int hour;
        /** Minute   : 0 - 59 */
        int min;
        /** Seconds  : 0 - 59.999 */
        double sec;
    }
    /**
 * @brief Error codes from libxlsxwriter functions.
 *
 * See the `lxw_strerror()` function for an example of how to convert the
 * enum number to a descriptive error message string.
 */
    enum lxw_error
    {
        /** No error. */
        LXW_NO_ERROR = 0,
        /** Memory error, failed to malloc() required memory. */
        LXW_ERROR_MEMORY_MALLOC_FAILED = 1,
        /** Error creating output xlsx file. Usually a permissions error. */
        LXW_ERROR_CREATING_XLSX_FILE = 2,
        /** Error encountered when creating a tmpfile during file assembly. */
        LXW_ERROR_CREATING_TMPFILE = 3,
        /** Error reading a tmpfile. */
        LXW_ERROR_READING_TMPFILE = 4,
        /** Zip generic error ZIP_ERRNO while creating the xlsx file. */
        LXW_ERROR_ZIP_FILE_OPERATION = 5,
        /** Zip error ZIP_PARAMERROR while creating the xlsx file. */
        LXW_ERROR_ZIP_PARAMETER_ERROR = 6,
        /** Zip error ZIP_BADZIPFILE (use_zip64 option may be required). */
        LXW_ERROR_ZIP_BAD_ZIP_FILE = 7,
        /** Zip error ZIP_INTERNALERROR while creating the xlsx file. */
        LXW_ERROR_ZIP_INTERNAL_ERROR = 8,
        /** File error or unknown zip error when adding sub file to xlsx file. */
        LXW_ERROR_ZIP_FILE_ADD = 9,
        /** Unknown zip error when closing xlsx file. */
        LXW_ERROR_ZIP_CLOSE = 10,
        /** Feature is not currently supported in this configuration. */
        LXW_ERROR_FEATURE_NOT_SUPPORTED = 11,
        /** NULL function parameter ignored. */
        LXW_ERROR_NULL_PARAMETER_IGNORED = 12,
        /** Function parameter validation error. */
        LXW_ERROR_PARAMETER_VALIDATION = 13,
        /** Worksheet name exceeds Excel's limit of 31 characters. */
        LXW_ERROR_SHEETNAME_LENGTH_EXCEEDED = 14,
        /** Worksheet name cannot contain invalid characters: '[ ] : * ? / \\' */
        LXW_ERROR_INVALID_SHEETNAME_CHARACTER = 15,
        /** Worksheet name cannot start or end with an apostrophe. */
        LXW_ERROR_SHEETNAME_START_END_APOSTROPHE = 16,
        /** Worksheet name is already in use. */
        LXW_ERROR_SHEETNAME_ALREADY_USED = 17,
        /** Parameter exceeds Excel's limit of 32 characters. */
        LXW_ERROR_32_STRING_LENGTH_EXCEEDED = 18,
        /** Parameter exceeds Excel's limit of 128 characters. */
        LXW_ERROR_128_STRING_LENGTH_EXCEEDED = 19,
        /** Parameter exceeds Excel's limit of 255 characters. */
        LXW_ERROR_255_STRING_LENGTH_EXCEEDED = 20,
        /** String exceeds Excel's limit of 32,767 characters. */
        LXW_ERROR_MAX_STRING_LENGTH_EXCEEDED = 21,
        /** Error finding internal string index. */
        LXW_ERROR_SHARED_STRING_INDEX_NOT_FOUND = 22,
        /** Worksheet row or column index out of range. */
        LXW_ERROR_WORKSHEET_INDEX_OUT_OF_RANGE = 23,
        /** Maximum hyperlink length (2079) exceeded. */
        LXW_ERROR_WORKSHEET_MAX_URL_LENGTH_EXCEEDED = 24,
        /** Maximum number of worksheet URLs (65530) exceeded. */
        LXW_ERROR_WORKSHEET_MAX_NUMBER_URLS_EXCEEDED = 25,
        /** Couldn't read image dimensions or DPI. */
        LXW_ERROR_IMAGE_DIMENSIONS = 26,
        /** Couldn't read image dimensions or DPI. */
        LXW_MAX_ERRNO = 27,
    }
    enum LXW_NO_ERROR = lxw_error.LXW_NO_ERROR;
    enum LXW_ERROR_MEMORY_MALLOC_FAILED = lxw_error.LXW_ERROR_MEMORY_MALLOC_FAILED;
    enum LXW_ERROR_CREATING_XLSX_FILE = lxw_error.LXW_ERROR_CREATING_XLSX_FILE;
    enum LXW_ERROR_CREATING_TMPFILE = lxw_error.LXW_ERROR_CREATING_TMPFILE;
    enum LXW_ERROR_READING_TMPFILE = lxw_error.LXW_ERROR_READING_TMPFILE;
    enum LXW_ERROR_ZIP_FILE_OPERATION = lxw_error.LXW_ERROR_ZIP_FILE_OPERATION;
    enum LXW_ERROR_ZIP_PARAMETER_ERROR = lxw_error.LXW_ERROR_ZIP_PARAMETER_ERROR;
    enum LXW_ERROR_ZIP_BAD_ZIP_FILE = lxw_error.LXW_ERROR_ZIP_BAD_ZIP_FILE;
    enum LXW_ERROR_ZIP_INTERNAL_ERROR = lxw_error.LXW_ERROR_ZIP_INTERNAL_ERROR;
    enum LXW_ERROR_ZIP_FILE_ADD = lxw_error.LXW_ERROR_ZIP_FILE_ADD;
    enum LXW_ERROR_ZIP_CLOSE = lxw_error.LXW_ERROR_ZIP_CLOSE;
    enum LXW_ERROR_FEATURE_NOT_SUPPORTED = lxw_error.LXW_ERROR_FEATURE_NOT_SUPPORTED;
    enum LXW_ERROR_NULL_PARAMETER_IGNORED = lxw_error.LXW_ERROR_NULL_PARAMETER_IGNORED;
    enum LXW_ERROR_PARAMETER_VALIDATION = lxw_error.LXW_ERROR_PARAMETER_VALIDATION;
    enum LXW_ERROR_SHEETNAME_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_SHEETNAME_LENGTH_EXCEEDED;
    enum LXW_ERROR_INVALID_SHEETNAME_CHARACTER = lxw_error.LXW_ERROR_INVALID_SHEETNAME_CHARACTER;
    enum LXW_ERROR_SHEETNAME_START_END_APOSTROPHE = lxw_error.LXW_ERROR_SHEETNAME_START_END_APOSTROPHE;
    enum LXW_ERROR_SHEETNAME_ALREADY_USED = lxw_error.LXW_ERROR_SHEETNAME_ALREADY_USED;
    enum LXW_ERROR_32_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_32_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_128_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_128_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_255_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_255_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_MAX_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_MAX_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_SHARED_STRING_INDEX_NOT_FOUND = lxw_error.LXW_ERROR_SHARED_STRING_INDEX_NOT_FOUND;
    enum LXW_ERROR_WORKSHEET_INDEX_OUT_OF_RANGE = lxw_error.LXW_ERROR_WORKSHEET_INDEX_OUT_OF_RANGE;
    enum LXW_ERROR_WORKSHEET_MAX_URL_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_WORKSHEET_MAX_URL_LENGTH_EXCEEDED;
    enum LXW_ERROR_WORKSHEET_MAX_NUMBER_URLS_EXCEEDED = lxw_error.LXW_ERROR_WORKSHEET_MAX_NUMBER_URLS_EXCEEDED;
    enum LXW_ERROR_IMAGE_DIMENSIONS = lxw_error.LXW_ERROR_IMAGE_DIMENSIONS;
    enum LXW_MAX_ERRNO = lxw_error.LXW_MAX_ERRNO;
    /** Boolean values used in libxlsxwriter. */
    enum lxw_boolean
    {
        /** False value. */
        LXW_FALSE = 0,
        /** True value. */
        LXW_TRUE = 1,
        /** False value. Used to turn off a property that is default on, in order
     *  to distinguish it from an uninitialized value. */
        LXW_EXPLICIT_FALSE = 2,
    }
    enum LXW_FALSE = lxw_boolean.LXW_FALSE;
    enum LXW_TRUE = lxw_boolean.LXW_TRUE;
    enum LXW_EXPLICIT_FALSE = lxw_boolean.LXW_EXPLICIT_FALSE;
    /** Integer data type to represent a column value. Equivalent to `uint16_t`.
 *
 * The maximum column in Excel is 16,384.
 */
    alias lxw_col_t = ushort;
    /** Integer data type to represent a row value. Equivalent to `uint32_t`.
 *
 * The maximum row in Excel is 1,048,576.
 */
    alias lxw_row_t = uint;

    void lxw_comment_assemble_xml_file(lxw_comment*) @nogc nothrow;

    void lxw_comment_free(lxw_comment*) @nogc nothrow;

    lxw_comment* lxw_comment_new() @nogc nothrow;

    struct lxw_comment
    {

        _IO_FILE* file;

        lxw_comment_objs* comment_objs;

        lxw_author_ids* author_ids;

        char* comment_author;

        uint author_id;
    }

    struct lxw_author_id
    {

        uint id;

        char* author;

        static struct _Anonymous_34
        {

            lxw_author_id* rbe_left;

            lxw_author_id* rbe_right;

            lxw_author_id* rbe_parent;

            int rbe_color;
        }

        _Anonymous_34 tree_pointers;
    }

    struct lxw_author_ids
    {

        lxw_author_id* rbh_root;
    }

    void lxw_chartsheet_assemble_xml_file(lxw_chartsheet*) @nogc nothrow;

    void lxw_chartsheet_free(lxw_chartsheet*) @nogc nothrow;

    lxw_chartsheet* lxw_chartsheet_new(lxw_worksheet_init_data*) @nogc nothrow;
    /**
 * @brief Set the printed page footer caption with additional options.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param string     The footer string.
 * @param options    Footer options.
 *
 * @return A #lxw_error code.
 *
 * The syntax of this function is the same as chartsheet_set_header_opt().
 *
 */
    lxw_error chartsheet_set_footer_opt(lxw_chartsheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    /**
 * @brief Set the printed page header caption with additional options.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param string     The header string.
 * @param options    Header options.
 *
 * @return A #lxw_error code.
 *
 * The syntax of this function is the same as chartsheet_set_header() with an
 * additional parameter to specify options for the header.
 *
 * Currently, the only available option is the header margin:
 *
 * @code
 *
 *    lxw_header_footer_options header_options = { 0.2 };
 *
 *    chartsheet_set_header_opt(chartsheet, "Some text", &header_options);
 *
 * @endcode
 *
 */
    lxw_error chartsheet_set_header_opt(lxw_chartsheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    /**
 * @brief Set the printed page footer caption.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param string     The footer string.
 *
 * @return A #lxw_error code.
 *
 * The syntax of this function is the same as chartsheet_set_header().
 *
 */
    lxw_error chartsheet_set_footer(lxw_chartsheet*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the printed page header caption.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param string     The header string.
 *
 * @return A #lxw_error code.
 *
 * Headers and footers are generated using a string which is a combination of
 * plain text and control characters
 *
 * @code
 *     chartsheet_set_header(chartsheet, "&LHello");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    | Hello                                                         |
 *     //    |                                                               |
 *
 *
 *     chartsheet_set_header(chartsheet, "&CHello");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    |                          Hello                                |
 *     //    |                                                               |
 *
 *
 *     chartsheet_set_header(chartsheet, "&RHello");
 *
 *     //     ---------------------------------------------------------------
 *     //    |                                                               |
 *     //    |                                                         Hello |
 *     //    |                                                               |
 *
 *
 * @endcode
 *
 * See `worksheet_set_header()` for a full explanation of the syntax of
 * Excel's header formatting and control characters.
 *
 */
    lxw_error chartsheet_set_header(lxw_chartsheet*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the chartsheet margins for the printed page.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param left       Left margin in inches.   Excel default is 0.7.
 * @param right      Right margin in inches.  Excel default is 0.7.
 * @param top        Top margin in inches.    Excel default is 0.75.
 * @param bottom     Bottom margin in inches. Excel default is 0.75.
 *
 * The `%chartsheet_set_margins()` function is used to set the margins of the
 * chartsheet when it is printed. The units are in inches. Specifying `-1` for
 * any parameter will give the default Excel value as shown above.
 *
 * @code
 *    chartsheet_set_margins(chartsheet, 1.3, 1.2, -1, -1);
 * @endcode
 *
 */
    void chartsheet_set_margins(lxw_chartsheet*, double, double, double, double) @nogc nothrow;
    /**
 * @brief Set the paper type for printing.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param paper_type The Excel paper format type.
 *
 * This function is used to set the paper format for the printed output of a
 * chartsheet:
 *
 * @code
 *     chartsheet_set_paper(chartsheet1, 1);  // US Letter
 *     chartsheet_set_paper(chartsheet2, 9);  // A4
 * @endcode
 *
 * If you do not specify a paper type the chartsheet will print using the
 * printer's default paper style.
 *
 * See `worksheet_set_paper()` for a full list of available paper sizes.
 */
    void chartsheet_set_paper(lxw_chartsheet*, ubyte) @nogc nothrow;
    /**
 * @brief Set the page orientation as portrait.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 *
 * This function is used to set the orientation of a chartsheet's printed page
 * to portrait:
 *
 * @code
 *     chartsheet_set_portrait(chartsheet);
 * @endcode
 */
    void chartsheet_set_portrait(lxw_chartsheet*) @nogc nothrow;
    /**
 * @brief Set the page orientation as landscape.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 *
 * This function is used to set the orientation of a chartsheet's printed page
 * to landscape. The default chartsheet orientation is landscape, so this
 * function isn't generally required:
 *
 * @code
 *     chartsheet_set_landscape(chartsheet);
 * @endcode
 */
    void chartsheet_set_landscape(lxw_chartsheet*) @nogc nothrow;
    /**
 * @brief Set the chartsheet zoom factor.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param scale      Chartsheet zoom factor.
 *
 * Set the chartsheet zoom factor in the range `10 <= zoom <= 400`:
 *
 * @code
 *     chartsheet_set_zoom(chartsheet, 75);
 * @endcode
 *
 * The default zoom factor is 100. It isn't possible to set the zoom to
 * "Selection" because it is calculated by Excel at run-time.
 *
 * See also `worksheet_set_zoom()`.
 */
    void chartsheet_set_zoom(lxw_chartsheet*, ushort) @nogc nothrow;
    /**
 * @brief Protect elements of a chartsheet from modification.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param password   A chartsheet password.
 * @param options    Chartsheet elements to protect.
 *
 * The `%chartsheet_protect()` function protects chartsheet elements from
 * modification:
 *
 * @code
 *     chartsheet_protect(chartsheet, "Some Password", options);
 * @endcode
 *
 * The `password` and lxw_protection pointer are both optional:
 *
 * @code
 *     chartsheet_protect(chartsheet2, NULL,       my_options);
 *     chartsheet_protect(chartsheet3, "password", NULL);
 *     chartsheet_protect(chartsheet4, "password", my_options);
 * @endcode
 *
 * Passing a `NULL` password is the same as turning on protection without a
 * password. Passing a `NULL` password and `NULL` options had no effect on
 * chartsheets.
 *
 * You can specify which chartsheet elements you wish to protect by passing a
 * lxw_protection pointer in the `options` argument. In Excel chartsheets only
 * have two protection options:
 *
 *     no_content
 *     no_objects
 *
 * All parameters are off by default. Individual elements can be protected as
 * follows:
 *
 * @code
 *     lxw_protection options = {
 *         .no_content  = 1,
 *         .no_objects  = 1,
 *     };
 *
 *     chartsheet_protect(chartsheet, NULL, &options);
 *
 * @endcode
 *
 * See also worksheet_protect().
 *
 * **Note:** Sheet level passwords in Excel offer **very** weak
 * protection. They don't encrypt your data and are very easy to
 * deactivate. Full workbook encryption is not supported by `libxlsxwriter`
 * since it requires a completely different file format.
 */
    void chartsheet_protect(lxw_chartsheet*, const(char)*, lxw_protection*) @nogc nothrow;
    /**
 * @brief Set the color of the chartsheet tab.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 * @param color      The tab color.
 *
 * The `%chartsheet_set_tab_color()` function is used to change the color of
 * the chartsheet tab:
 *
 * @code
 *      chartsheet_set_tab_color(chartsheet1, LXW_COLOR_RED);
 *      chartsheet_set_tab_color(chartsheet2, LXW_COLOR_GREEN);
 *      chartsheet_set_tab_color(chartsheet3, 0xFF9900); // Orange.
 * @endcode
 *
 * The color should be an RGB integer value, see @ref working_with_colors.
 *
 * See also `worksheet_set_tab_color()`.
 */
    void chartsheet_set_tab_color(lxw_chartsheet*, uint) @nogc nothrow;
    /**
 * @brief Set current chartsheet as the first visible sheet tab.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 *
 * The `chartsheet_activate()` function determines which chartsheet is
 * initially selected.  However, if there are a large number of chartsheets the
 * selected chartsheet may not appear on the screen. To avoid this you can
 * select the leftmost visible chartsheet tab using
 * `%chartsheet_set_first_sheet()`:
 *
 * @code
 *     chartsheet_set_first_sheet(chartsheet19); // First visible chartsheet tab.
 *     chartsheet_activate(chartsheet20);        // First visible chartsheet.
 * @endcode
 *
 * This function is not required very often. The default value is the first
 * chartsheet.
 *
 * See also `worksheet_set_first_sheet()`.
 *
 */
    void chartsheet_set_first_sheet(lxw_chartsheet*) @nogc nothrow;
    /**
 * @brief Hide the current chartsheet.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 *
 * The `%chartsheet_hide()` function is used to hide a chartsheet:
 *
 * @code
 *     chartsheet_hide(chartsheet2);
 * @endcode
 *
 * You may wish to hide a chartsheet in order to avoid confusing a user with
 * intermediate data or calculations.
 *
 * @image html hide_sheet.png
 *
 * A hidden chartsheet can not be activated or selected so this function is
 * mutually exclusive with the `chartsheet_activate()` and
 * `chartsheet_select()` functions. In addition, since the first chartsheet
 * will default to being the active chartsheet, you cannot hide the first
 * chartsheet without activating another sheet:
 *
 * @code
 *     chartsheet_activate(chartsheet2);
 *     chartsheet_hide(chartsheet1);
 * @endcode
 *
 * See also `worksheet_hide()`.
 *
 */
    void chartsheet_hide(lxw_chartsheet*) @nogc nothrow;
    /**
 * @brief Set a chartsheet tab as selected.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 *
 * The `%chartsheet_select()` function is used to indicate that a chartsheet
 * is selected in a multi-sheet workbook:
 *
 * @code
 *     chartsheet_activate(chartsheet1);
 *     chartsheet_select(chartsheet2);
 *     chartsheet_select(chartsheet3);
 *
 * @endcode
 *
 * A selected chartsheet has its tab highlighted. Selecting chartsheets is a
 * way of grouping them together so that, for example, several chartsheets
 * could be printed in one go. A chartsheet that has been activated via the
 * `chartsheet_activate()` function will also appear as selected.
 *
 * See also `worksheet_select()`.
 *
 */
    void chartsheet_select(lxw_chartsheet*) @nogc nothrow;
    /**
 * @brief Make a chartsheet the active, i.e., visible chartsheet.
 *
 * @param chartsheet Pointer to a lxw_chartsheet instance to be updated.
 *
 * The `%chartsheet_activate()` function is used to specify which chartsheet
 * is initially visible in a multi-sheet workbook:
 *
 * @code
 *     lxw_worksheet  *worksheet1  = workbook_add_worksheet(workbook, NULL);
 *     lxw_chartsheet *chartsheet1 = workbook_add_chartsheet(workbook, NULL);
 *     lxw_chartsheet *chartsheet2 = workbook_add_chartsheet(workbook, NULL);
 *     lxw_chartsheet *chartsheet3 = workbook_add_chartsheet(workbook, NULL);
 *
 *     chartsheet_activate(chartsheet3);
 * @endcode
 *
 * @image html chartsheet_activate.png
 *
 * More than one chartsheet can be selected via the `chartsheet_select()`
 * function, see below, however only one chartsheet can be active.
 *
 * The default active chartsheet is the first chartsheet.
 *
 * See also `worksheet_activate()`.
 *
 */
    void chartsheet_activate(lxw_chartsheet*) @nogc nothrow;

    lxw_error chartsheet_set_chart_opt(lxw_chartsheet*, lxw_chart*, lxw_chart_options*) @nogc nothrow;
    /**
 * @brief Insert a chart object into a chartsheet.
 *
 * @param chartsheet   Pointer to a lxw_chartsheet instance to be updated.
 * @param chart        A #lxw_chart object created via workbook_add_chart().
 *
 * @return A #lxw_error code.
 *
 * The `%chartsheet_set_chart()` function can be used to insert a chart into a
 * chartsheet. The chart object must be created first using the
 * `workbook_add_chart()` function and configured using the @ref chart.h
 * functions.
 *
 * @code
 *     // Create the chartsheet.
 *     lxw_chartsheet *chartsheet = workbook_add_chartsheet(workbook, NULL);
 *
 *     // Create a chart object.
 *     lxw_chart *chart = workbook_add_chart(workbook, LXW_CHART_LINE);
 *
 *     // Add a data series to the chart.
 *     chart_add_series(chart, NULL, "=Sheet1!$A$1:$A$6");
 *
 *     // Insert the chart into the chartsheet.
 *     chartsheet_set_chart(chartsheet, chart);
 * @endcode
 *
 * @image html chartsheet2.png
 *
 * **Note:**
 *
 * A chart may only be inserted once into a chartsheet or a worksheet. If
 * several similar charts are required then each one must be created
 * separately.
 *
 */
    lxw_error chartsheet_set_chart(lxw_chartsheet*, lxw_chart*) @nogc nothrow;
    /**
 * @brief Struct to represent an Excel chartsheet.
 *
 * The members of the lxw_chartsheet struct aren't modified directly. Instead
 * the chartsheet properties are set by calling the functions shown in
 * chartsheet.h.
 */
    struct lxw_chartsheet
    {

        _IO_FILE* file;

        lxw_worksheet* worksheet;

        lxw_chart* chart;

        lxw_protection_obj protection;

        ubyte is_protected;

        char* name;

        char* quoted_name;

        char* tmpdir;

        ushort index;

        ubyte active;

        ubyte selected;

        ubyte hidden;

        ushort* active_sheet;

        ushort* first_sheet;

        ushort rel_count;

        static struct _Anonymous_35
        {

            lxw_chartsheet* stqe_next;
        }

        _Anonymous_35 list_pointers;
    }

    lxw_error lxw_chart_add_data_cache(lxw_series_range*, ubyte*, ushort, ubyte, ubyte) @nogc nothrow;
    /**
 * @brief Set the Doughnut chart hole size.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param size  The hole size as a percentage.
 *
 * The `chart_set_hole_size()` function is used to set the hole size of a
 * Doughnut chart:
 *
 * @code
 *     chart_set_hole_size(chart, 33);
 * @endcode
 *
 * The hole size must be in the range `10 <= size <= 90`.
 *
 * This option is only available for Doughnut charts.
 *
 */
    void chart_set_hole_size(lxw_chart*, ubyte) @nogc nothrow;
    /**
 * @brief Set the Pie/Doughnut chart rotation.
 *
 * @param chart    Pointer to a lxw_chart instance to be configured.
 * @param rotation The angle of rotation.
 *
 * The `chart_set_rotation()` function is used to set the rotation of the
 * first segment of a Pie/Doughnut chart. This has the effect of rotating
 * the entire chart:
 *
 * @code
 *     chart_set_rotation(chart, 28);
 * @endcode
 *
 * The angle of rotation must be in the range `0 <= rotation <= 360`.
 *
 * This option is only available for Pie/Doughnut charts.
 *
 */
    void chart_set_rotation(lxw_chart*, ushort) @nogc nothrow;
    /**
 * @brief Display data on charts from hidden rows or columns.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 *
 * Display data that is in hidden rows or columns on the chart:
 *
 * @code
 *     chart_show_hidden_data(chart);
 * @endcode
 */
    void chart_show_hidden_data(lxw_chart*) @nogc nothrow;
    /**
 * @brief Set the option for displaying blank data in a chart.
 *
 * @param chart    Pointer to a lxw_chart instance to be configured.
 * @param option The display option. A #lxw_chart_blank option.
 *
 * The `%chart_show_blanks_as()` function controls how blank data is displayed
 * in a chart:
 *
 * @code
 *     chart_show_blanks_as(chart, LXW_CHART_BLANKS_AS_CONNECTED);
 * @endcode
 *
 * The `option` parameter can have one of the following values:
 *
 * - #LXW_CHART_BLANKS_AS_GAP: Show empty chart cells as gaps in the data.
 *   This is the default option for Excel charts.
 * - #LXW_CHART_BLANKS_AS_ZERO: Show empty chart cells as zeros.
 * - #LXW_CHART_BLANKS_AS_CONNECTED: Show empty chart cells as connected.
 *   Only for charts with lines.
 */
    void chart_show_blanks_as(lxw_chart*, ubyte) @nogc nothrow;
    /**
 * @brief Set the gap between series in a Bar/Column chart.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param gap   The gap between the series.  0 to 500.
 *
 * The `%chart_set_series_gap()` function sets the gap between series in
 * Bar and Column charts.
 *
 * @code
 *     chart_set_series_gap(chart, 400);
 * @endcode
 *
 * @image html chart_gap.png
 *
 * The gap value must be in the range `0 <= gap <= 500`. The default value
 * is 150.
 *
 * This option is only available for Bar/Column charts.
 */
    void chart_set_series_gap(lxw_chart*, ushort) @nogc nothrow;
    /**
 * @brief Set the overlap between series in a Bar/Column chart.
 *
 * @param chart   Pointer to a lxw_chart instance to be configured.
 * @param overlap The overlap between the series. -100 to 100.
 *
 * The `%chart_set_series_overlap()` function sets the overlap between series
 * in Bar and Column charts.
 *
 * @code
 *     chart_set_series_overlap(chart, -50);
 * @endcode
 *
 * @image html chart_overlap.png
 *
 * The overlap value must be in the range `0 <= overlap <= 500`.
 * The default value is 0.
 *
 * This option is only available for Bar/Column charts.
 */
    void chart_set_series_overlap(lxw_chart*, byte) @nogc nothrow;
    /**
 * @brief Turn on and format high-low Lines for a chart.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param line  A #lxw_chart_line struct.
 *
 * The `%chart_set_high_low_lines()` function adds High-Low Lines to charts
 * to show the Category value of points in the data:
 *
 * @code
 *     chart_set_high_low_lines(chart, NULL);
 * @endcode
 *
 * @image html chart_data_tools5.png
 *
 * It is possible to format the High-Low Line line properties if required:
 *
 * @code
 *     lxw_chart_line line = {.color     = LXW_COLOR_RED,
 *                            .dash_type = LXW_CHART_LINE_DASH_SQUARE_DOT};
 *
 *     chart_set_high_low_lines(chart, &line);
 * @endcode
 *
 * High-Low Lines are only available in Line charts.
 * For more format information see @ref chart_lines.
 */
    void chart_set_high_low_lines(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Turn on and format Drop Lines for a chart.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param line  A #lxw_chart_line struct.
 *
 * The `%chart_set_drop_lines()` function adds Drop Lines to charts to
 * show the Category value of points in the data:
 *
 * @code
 *     chart_set_drop_lines(chart, NULL);
 * @endcode
 *
 * @image html chart_data_tools6.png
 *
 * It is possible to format the Drop Line line properties if required:
 *
 * @code
 *     lxw_chart_line line = {.color     = LXW_COLOR_RED,
 *                            .dash_type = LXW_CHART_LINE_DASH_SQUARE_DOT};
 *
 *     chart_set_drop_lines(chart, &line);
 * @endcode
 *
 * Drop Lines are only available in Line and Area charts.
 * For more format information see @ref chart_lines.
 */
    void chart_set_drop_lines(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Turn on up-down bars for the chart, with formatting.
 *
 * @param chart         Pointer to a lxw_chart instance to be configured.
 * @param up_bar_line   A #lxw_chart_line struct for the up-bar border.
 * @param up_bar_fill   A #lxw_chart_fill struct for the up-bar fill.
 * @param down_bar_line A #lxw_chart_line struct for the down-bar border.
 * @param down_bar_fill A #lxw_chart_fill struct for the down-bar fill.
 *
 * The `%chart_set_up_down_bars_format()` function adds Up-Down bars to Line
 * charts to indicate the difference between the first and last data series.
 * It also allows the up and down bars to be formatted:
 *
 * @code
 *     lxw_chart_line line      = {.color = LXW_COLOR_BLACK};
 *     lxw_chart_fill up_fill   = {.color = 0x00B050};
 *     lxw_chart_fill down_fill = {.color = LXW_COLOR_RED};
 *
 *     chart_set_up_down_bars_format(chart, &line, &up_fill, &line, &down_fill);
 * @endcode
 *
 * @image html chart_up_down_bars.png
 *
 * Up-Down bars are only available in Line charts.
 * For more format information  see @ref chart_lines and @ref chart_fills.
 */
    void chart_set_up_down_bars_format(lxw_chart*, lxw_chart_line*, lxw_chart_fill*, lxw_chart_line*, lxw_chart_fill*) @nogc nothrow;
    /**
 * @brief Turn on up-down bars for the chart.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 *
 * The `%chart_set_up_down_bars()` function adds Up-Down bars to Line charts
 * to indicate the difference between the first and last data series:
 *
 * @code
 *     chart_set_up_down_bars(chart);
 * @endcode
 *
 * @image html chart_data_tools4.png
 *
 * Up-Down bars are only available in Line charts. By default Up-Down bars are
 * black and white like in the above example. To format the border or fill
 * of the bars see the `chart_set_up_down_bars_format()` function below.
 */
    void chart_set_up_down_bars(lxw_chart*) @nogc nothrow;

    void chart_set_table_font(lxw_chart*, lxw_chart_font*) @nogc nothrow;
    /**
 * @brief Turn on/off grid options for a chart data table.
 *
 * @param chart       Pointer to a lxw_chart instance to be configured.
 * @param horizontal  Turn on/off the horizontal grid lines in the table.
 * @param vertical    Turn on/off the vertical grid lines in the table.
 * @param outline     Turn on/off the outline lines in the table.
 * @param legend_keys Turn on/off the legend keys in the table.
 *
 * The `%chart_set_table_grid()` function turns on/off grid options for a
 * chart data table. The data table grid options in Excel are shown in the
 * dialog below:
 *
 * @image html chart_data_table3.png
 *
 * These options can be passed to the `%chart_set_table_grid()` function.
 * The values for a default chart are:
 *
 * - `horizontal`: On.
 * - `vertical`: On.
 * - `outline`:  On.
 * - `legend_keys`: Off.
 *
 * Example:
 *
 * @code
 *     // Turn on the data table with default options.
 *     chart_set_table(chart);
 *
 *     // Turn on all grid lines and the grid legend.
 *     chart_set_table_grid(chart, LXW_TRUE, LXW_TRUE, LXW_TRUE, LXW_TRUE);
 *
 *     // Turn off the legend since it is show in the table.
 *     chart_legend_set_position(chart, LXW_CHART_LEGEND_NONE);
 *
 * @endcode
 *
 * @image html chart_data_table2.png
 *
 * The data table can only be shown with Bar, Column, Line and Area charts.
 *
 */
    void chart_set_table_grid(lxw_chart*, ubyte, ubyte, ubyte, ubyte) @nogc nothrow;
    /**
 * @brief Turn on a data table below the horizontal axis.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 *
 * The `%chart_set_table()` function adds a data table below the horizontal
 * axis with the data used to plot the chart:
 *
 * @code
 *     // Turn on the data table with default options.
 *     chart_set_table(chart);
 * @endcode
 *
 * @image html chart_data_table1.png
 *
 * The data table can only be shown with Bar, Column, Line and Area charts.
 *
 */
    void chart_set_table(lxw_chart*) @nogc nothrow;
    /**
 * @brief Set the chart style type.
 *
 * @param chart    Pointer to a lxw_chart instance to be configured.
 * @param style_id An index representing the chart style, 1 - 48.
 *
 * The `%chart_set_style()` function is used to set the style of the chart to
 * one of the 48 built-in styles available on the "Design" tab in Excel 2007:
 *
 * @code
 *     chart_set_style(chart, 37)
 * @endcode
 *
 * @image html chart_style.png
 *
 * The style index number is counted from 1 on the top left in the Excel
 * dialog. The default style is 2.
 *
 * **Note:**
 *
 * In Excel 2013 the Styles section of the "Design" tab in Excel shows what
 * were referred to as "Layouts" in previous versions of Excel. These layouts
 * are not defined in the file format. They are a collection of modifications
 * to the base chart type. They can not be defined by the `chart_set_style()``
 * function.
 *
 */
    void chart_set_style(lxw_chart*, ubyte) @nogc nothrow;
    /**
 * @brief Set the pattern properties for a plotarea.
 *
 * @param chart   Pointer to a lxw_chart instance to be configured.
 * @param pattern A #lxw_chart_pattern struct.
 *
 * Set the pattern properties of a plotarea:
 *
 * @code
 *     chart_plotarea_set_pattern(series1, &pattern);
 * @endcode
 *
 * For more information see #lxw_chart_pattern_type and @ref chart_patterns.
 */
    void chart_plotarea_set_pattern(lxw_chart*, lxw_chart_pattern*) @nogc nothrow;
    /**
 * @brief Set the fill properties for a plotarea.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param fill  A #lxw_chart_fill struct.
 *
 * Set the fill properties of a plotarea:
 *
 * @code
 *     chart_plotarea_set_fill(chart, &fill);
 * @endcode
 *
 * See the example and image above.
 *
 * For more information see @ref chart_fills.
 */
    void chart_plotarea_set_fill(lxw_chart*, lxw_chart_fill*) @nogc nothrow;
    /**
 * @brief Set the line properties for a plotarea.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param line  A #lxw_chart_line struct.
 *
 * Set the line/border properties of a plotarea. In Excel the plotarea is
 * the area between the axes on which the chart series are plotted:
 *
 * @code
 *     lxw_chart_line line = {.color     = LXW_COLOR_RED,
 *                            .width     = 2,
 *                            .dash_type = LXW_CHART_LINE_DASH_DASH};
 *     lxw_chart_fill fill = {.color     = 0xFFFFC2};
 *
 *     chart_plotarea_set_line(chart, &line);
 *     chart_plotarea_set_fill(chart, &fill);
 *
 * @endcode
 *
 * @image html chart_plotarea.png
 *
 * For more information see @ref chart_lines.
 */
    void chart_plotarea_set_line(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set the pattern properties for a chartarea.
 *
 * @param chart   Pointer to a lxw_chart instance to be configured.
 * @param pattern A #lxw_chart_pattern struct.
 *
 * Set the pattern properties of a chartarea:
 *
 * @code
 *     chart_chartarea_set_pattern(series1, &pattern);
 * @endcode
 *
 * For more information see #lxw_chart_pattern_type and @ref chart_patterns.
 */
    void chart_chartarea_set_pattern(lxw_chart*, lxw_chart_pattern*) @nogc nothrow;
    /**
 * @brief Set the fill properties for a chartarea.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param fill  A #lxw_chart_fill struct.
 *
 * Set the fill properties of a chartarea:
 *
 * @code
 *     chart_chartarea_set_fill(chart, &fill);
 * @endcode
 *
 * See the example and image above.
 *
 * For more information see @ref chart_fills.
 */
    void chart_chartarea_set_fill(lxw_chart*, lxw_chart_fill*) @nogc nothrow;
    /**
 * @brief Set the line properties for a chartarea.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param line  A #lxw_chart_line struct.
 *
 * Set the line/border properties of a chartarea. In Excel the chartarea
 * is the background area behind the chart:
 *
 * @code
 *     lxw_chart_line line = {.none  = LXW_TRUE};
 *     lxw_chart_fill fill = {.color = LXW_COLOR_RED};
 *
 *     chart_chartarea_set_line(chart, &line);
 *     chart_chartarea_set_fill(chart, &fill);
 * @endcode
 *
 * @image html chart_chartarea.png
 *
 * For more information see @ref chart_lines.
 */
    void chart_chartarea_set_line(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Remove one or more series from the the legend.
 *
 * @param chart         Pointer to a lxw_chart instance to be configured.
 * @param delete_series An array of zero-indexed values to delete from series.
 *
 * @return A #lxw_error.
 *
 * The `%chart_legend_delete_series()` function allows you to remove/hide one
 * or more series in a chart legend (the series will still display on the chart).
 *
 * This function takes an array of one or more zero indexed series
 * numbers. The array should be terminated with -1.
 *
 * For example to remove the first and third zero-indexed series from the
 * legend of a chart with 3 series:
 *
 * @code
 *     int16_t series[] = {0, 2, -1};
 *
 *     chart_legend_delete_series(chart, series);
 * @endcode
 *
 * @image html chart_legend_delete.png
 */
    lxw_error chart_legend_delete_series(lxw_chart*, short*) @nogc nothrow;
    /**
 * @brief Set the font properties for a chart legend.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param font  A pointer to a chart #lxw_chart_font font struct.
 *
 * The `%chart_legend_set_font()` function is used to set the font of a
 * chart legend:
 *
 * @code
 *     lxw_chart_font font = {.bold = LXW_TRUE, .color = LXW_COLOR_BLUE};
 *
 *     chart_legend_set_font(chart, &font);
 * @endcode
 *
 * @image html chart_legend_set_font.png
 *
 * For more information see @ref chart_fonts.
 */
    void chart_legend_set_font(lxw_chart*, lxw_chart_font*) @nogc nothrow;
    /**
 * @brief Set the position of the chart legend.
 *
 * @param chart    Pointer to a lxw_chart instance to be configured.
 * @param position The #lxw_chart_legend_position value for the legend.
 *
 * The `%chart_legend_set_position()` function is used to set the chart
 * legend to one of the #lxw_chart_legend_position values:
 *
 *     LXW_CHART_LEGEND_NONE
 *     LXW_CHART_LEGEND_RIGHT
 *     LXW_CHART_LEGEND_LEFT
 *     LXW_CHART_LEGEND_TOP
 *     LXW_CHART_LEGEND_BOTTOM
 *     LXW_CHART_LEGEND_TOP_RIGHT
 *     LXW_CHART_LEGEND_OVERLAY_RIGHT
 *     LXW_CHART_LEGEND_OVERLAY_LEFT
 *     LXW_CHART_LEGEND_OVERLAY_TOP_RIGHT
 *
 * For example:
 *
 * @code
 *     chart_legend_set_position(chart, LXW_CHART_LEGEND_BOTTOM);
 * @endcode
 *
 * @image html chart_legend_bottom.png
 *
 * This function can also be used to turn off a chart legend:
 *
 * @code
 *     chart_legend_set_position(chart, LXW_CHART_LEGEND_NONE);
 * @endcode
 *
 * @image html chart_legend_none.png
 *
 */
    void chart_legend_set_position(lxw_chart*, ubyte) @nogc nothrow;
    /**
 * @brief Turn off an automatic chart title.
 *
 * @param chart  Pointer to a lxw_chart instance to be configured.
 *
 * In general in Excel a chart title isn't displayed unless the user
 * explicitly adds one. However, Excel adds an automatic chart title to charts
 * with a single series and a user defined series name. The
 * `chart_title_off()` function allows you to turn off this automatic chart
 * title:
 *
 * @code
 *     chart_title_off(chart);
 * @endcode
 */
    void chart_title_off(lxw_chart*) @nogc nothrow;
    /**
 * @brief  Set the font properties for a chart title.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param font  A pointer to a chart #lxw_chart_font font struct.
 *
 * The `%chart_title_set_name_font()` function is used to set the font of a
 * chart title:
 *
 * @code
 *     lxw_chart_font font = {.color = LXW_COLOR_BLUE};
 *
 *     chart_title_set_name(chart, "Year End Results");
 *     chart_title_set_name_font(chart, &font);
 * @endcode
 *
 * @image html chart_title_set_name_font.png
 *
 * In Excel a chart title font is bold by default (as shown in the image
 * above). To turn off bold in the font you cannot use #LXW_FALSE (0) since
 * that is indistinguishable from an uninitialized value. Instead you should
 * use #LXW_EXPLICIT_FALSE:
 *
 * @code
 *     lxw_chart_font font = {.bold = LXW_EXPLICIT_FALSE, .color = LXW_COLOR_BLUE};
 *
 *     chart_title_set_name(chart, "Year End Results");
 *     chart_title_set_name_font(chart, &font);
 * @endcode
 *
 * @image html chart_title_set_name_font2.png
 *
 * For more information see @ref chart_fonts.
 */
    void chart_title_set_name_font(lxw_chart*, lxw_chart_font*) @nogc nothrow;
    /**
 * @brief Set a chart title formula using row and column values.
 *
 * @param chart     Pointer to a lxw_chart instance to be configured.
 * @param sheetname The name of the worksheet that contains the cell range.
 * @param row       The zero indexed row number of the range.
 * @param col       The zero indexed column number of the range.
 *
 * The `%chart_title_set_name_range()` function can be used to set a chart
 * title range and is an alternative to using `chart_title_set_name()` and a
 * string formula:
 *
 * @code
 *     chart_title_set_name_range(chart, "Sheet1", 1, 0);
 * @endcode
 */
    void chart_title_set_name_range(lxw_chart*, const(char)*, uint, ushort) @nogc nothrow;
    /**
 * @brief Set the title of the chart.
 *
 * @param chart Pointer to a lxw_chart instance to be configured.
 * @param name  The chart title name.
 *
 * The `%chart_title_set_name()` function sets the name (title) for the
 * chart. The name is displayed above the chart.
 *
 * @code
 *     chart_title_set_name(chart, "Year End Results");
 * @endcode
 *
 * @image html chart_title_set_name.png
 *
 * The name parameter can also be a formula such as `=Sheet1!$A$1` to point to
 * a cell in the workbook that contains the name:
 *
 * @code
 *     chart_title_set_name(chart, "=Sheet1!$B$1");
 * @endcode
 *
 * See also the `chart_title_set_name_range()` function to see how to set the
 * name formula programmatically.
 *
 * The Excel default is to have no chart title.
 */
    void chart_title_set_name(lxw_chart*, const(char)*) @nogc nothrow;
    /**
 * @brief Set the line properties for the chart axis minor gridlines.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param line A #lxw_chart_line struct.
 *
 * Format the line properties of the minor gridlines of a chart, see the
 * example above.
 *
 * For more information see @ref chart_lines.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_minor_gridlines_set_line(lxw_chart_axis*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set the line properties for the chart axis major gridlines.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param line A #lxw_chart_line struct.
 *
 * Format the line properties of the major gridlines of a chart:
 *
 * @code
 *     lxw_chart_line line1 = {.color = LXW_COLOR_RED,
 *                             .width = 0.5,
 *                             .dash_type = LXW_CHART_LINE_DASH_SQUARE_DOT};
 *
 *     lxw_chart_line line2 = {.color = LXW_COLOR_YELLOW};
 *
 *     lxw_chart_line line3 = {.width = 1.25,
 *                             .dash_type = LXW_CHART_LINE_DASH_DASH};
 *
 *     lxw_chart_line line4 = {.color =  0x00B050};
 *
 *     chart_axis_major_gridlines_set_line(chart->x_axis, &line1);
 *     chart_axis_minor_gridlines_set_line(chart->x_axis, &line2);
 *     chart_axis_major_gridlines_set_line(chart->y_axis, &line3);
 *     chart_axis_minor_gridlines_set_line(chart->y_axis, &line4);
 * @endcode
 *
 * @image html chart_gridline3.png
 *
 * For more information see @ref chart_lines.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_major_gridlines_set_line(lxw_chart_axis*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Turn on/off the minor gridlines for an axis.
 *
 * @param axis    A pointer to a chart #lxw_chart_axis object.
 * @param visible Turn off/on the minor gridline. (0/1)
 *
 * Turn on or off the minor gridlines for an X or Y axis. In most Excel charts
 * the X and Y axis minor gridlines are off by default.
 *
 * Example, turn on all major and minor gridlines:
 *
 * @code
 *     chart_axis_major_gridlines_set_visible(chart->x_axis, LXW_TRUE);
 *     chart_axis_minor_gridlines_set_visible(chart->x_axis, LXW_TRUE);
 *     chart_axis_major_gridlines_set_visible(chart->y_axis, LXW_TRUE);
 *     chart_axis_minor_gridlines_set_visible(chart->y_axis, LXW_TRUE);
 * @endcode
 *
 * @image html chart_gridline2.png
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_minor_gridlines_set_visible(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Turn on/off the major gridlines for an axis.
 *
 * @param axis    A pointer to a chart #lxw_chart_axis object.
 * @param visible Turn off/on the major gridline. (0/1)
 *
 * Turn on or off the major gridlines for an X or Y axis. In most Excel charts
 * the Y axis major gridlines are on by default and the X axis major
 * gridlines are off by default.
 *
 * Example:
 *
 * @code
 *     // Reverse the normal visible/hidden gridlines for a column chart.
 *     chart_axis_major_gridlines_set_visible(chart->x_axis, LXW_TRUE);
 *     chart_axis_major_gridlines_set_visible(chart->y_axis, LXW_FALSE);
 * @endcode
 *
 * @image html chart_gridline1.png
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_major_gridlines_set_visible(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Turn on/off the display units for a value axis.

 * @param axis    A pointer to a chart #lxw_chart_axis object.
 * @param visible Turn off/on the display units. (0/1)
 *
 * Turn on or off the display units for the axis. This option is set on
 * automatically by `chart_axis_set_display_units()`.
 *
 * @code
 *     chart_axis_set_display_units_visible(chart->y_axis, LXW_TRUE);
 * @endcode
 *
 * **Axis types**: This function is applicable to value axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_display_units_visible(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Set the display units for a value axis.
 *
 * @param axis  A pointer to a chart #lxw_chart_axis object.
 * @param units The display units: #lxw_chart_axis_display_unit.
 *
 * Set the display units for the axis. This can be useful if the axis numbers
 * are very large but you don't want to represent them in scientific notation:
 *
 * @code
 *     chart_axis_set_display_units(chart->x_axis, LXW_CHART_AXIS_UNITS_THOUSANDS);
 *     chart_axis_set_display_units(chart->y_axis, LXW_CHART_AXIS_UNITS_MILLIONS);
 * @endcode
 *
 * @image html chart_display_units.png
 *
 * **Axis types**: This function is applicable to value axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_display_units(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Set the increment of the minor units in the axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param unit The increment of the minor units.
 *
 * Set the increment of the minor units in the axis range.
 *
 * @code
 *     chart_axis_set_minor_unit(chart->y_axis, 2);
 * @endcode
 *
 * See the image above
 *
 * **Axis types**: This function is applicable to value and date axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_minor_unit(lxw_chart_axis*, double) @nogc nothrow;
    /**
 * @brief Set the increment of the major units in the axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param unit The increment of the major units.
 *
 * Set the increment of the major units in the axis range.
 *
 * @code
 *     // Turn on the minor gridline (it is off by default).
 *     chart_axis_minor_gridlines_set_visible(chart->y_axis, LXW_TRUE);
 *
 *     chart_axis_set_major_unit(chart->y_axis, 4);
 *     chart_axis_set_minor_unit(chart->y_axis, 2);
 * @endcode
 *
 * @image html chart_set_major_units.png
 *
 * **Axis types**: This function is applicable to value and date axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_major_unit(lxw_chart_axis*, double) @nogc nothrow;
    /**
 * @brief Set the interval between category tick marks.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param unit The interval between the category ticks.
 *
 * Set the interval between the category tick marks. The default interval is 1
 * between each category but it can be set to other integer values:
 *
 * @code
 *     chart_axis_set_interval_tick(chart->x_axis, 2);
 * @endcode
 *
 * @image html chart_set_interval2.png
 *
 * **Axis types**: This function is applicable to category and date axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_interval_tick(lxw_chart_axis*, ushort) @nogc nothrow;
    /**
 * @brief Set the interval between category values.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param unit The interval between the categories.
 *
 * Set the interval between the category values. The default interval is 1
 * which gives the intervals shown in the charts above:
 *
 *     1, 2, 3, 4, 5, etc.
 *
 * Setting it to 2 gives:
 *
 *     1, 3, 5, 7, etc.
 *
 * For example:
 *
 * @code
 *     chart_axis_set_interval_unit(chart->x_axis, 2);
 * @endcode
 *
 * @image html chart_set_interval1.png
 *
 * **Axis types**: This function is applicable to category and date axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_interval_unit(lxw_chart_axis*, ushort) @nogc nothrow;
    /**
 * @brief Set the minor axis tick mark type.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param type The tick mark type, defined by #lxw_chart_tick_mark.
 *
 * Set the type of the minor axis tick mark:
 *
 * @code
 *     chart_axis_set_minor_tick_mark(chart->x_axis, LXW_CHART_AXIS_TICK_MARK_INSIDE);
 * @endcode
 *
 * See the image and example above.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_minor_tick_mark(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Set the major axis tick mark type.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param type The tick mark type, defined by #lxw_chart_tick_mark.
 *
 * Set the type of the major axis tick mark:
 *
 * @code
 *     chart_axis_set_major_tick_mark(chart->x_axis, LXW_CHART_AXIS_TICK_MARK_CROSSING);
 *     chart_axis_set_minor_tick_mark(chart->x_axis, LXW_CHART_AXIS_TICK_MARK_INSIDE);
 *
 *     chart_axis_set_major_tick_mark(chart->x_axis, LXW_CHART_AXIS_TICK_MARK_OUTSIDE);
 *     chart_axis_set_minor_tick_mark(chart->y_axis, LXW_CHART_AXIS_TICK_MARK_INSIDE);
 *
 *     // Hide the default gridlines so the tick marks are visible.
 *     chart_axis_major_gridlines_set_visible(chart->y_axis, LXW_FALSE);
 * @endcode
 *
 * @image html chart_tick_marks.png
 *
 * The tick mark types are:
 *
 * - #LXW_CHART_AXIS_TICK_MARK_NONE
 * - #LXW_CHART_AXIS_TICK_MARK_INSIDE
 * - #LXW_CHART_AXIS_TICK_MARK_OUTSIDE
 * - #LXW_CHART_AXIS_TICK_MARK_CROSSING
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_major_tick_mark(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Set the log base of the axis range.
 *
 * @param axis     A pointer to a chart #lxw_chart_axis object.
 * @param log_base The log base for value axis. Value axes only.
 *
 * Set the log base for the axis:
 *
 * @code
 *     chart_axis_set_log_base(chart->y_axis, 10);
 * @endcode
 *
 * @image html chart_log_base.png
 *
 * The allowable range of values for the log base in Excel is between 2 and
 * 1000.
 *
 * **Axis types**: This function is applicable to value axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_log_base(lxw_chart_axis*, ushort) @nogc nothrow;
    /**
 * @brief Set the maximum value for a chart axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param max  Maximum value for chart axis. Value axes only.
 *
 * Set the maximum value for the axis range.
 *
 * @code
 *     chart_axis_set_min(chart->y_axis, -4);
 *     chart_axis_set_max(chart->y_axis, 21);
 * @endcode
 *
 * See the above image.
 *
 * **Axis types**: This function is applicable to value and date axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_max(lxw_chart_axis*, double) @nogc nothrow;
    /**
 * @brief Set the minimum value for a chart axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param min  Minimum value for chart axis. Value axes only.
 *
 * Set the minimum value for the axis range.
 *
 * @code
 *     chart_axis_set_min(chart->y_axis, -4);
 *     chart_axis_set_max(chart->y_axis, 21);
 * @endcode
 *
 * @image html chart_max_min.png
 *
 * **Axis types**: This function is applicable to value and date axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_min(lxw_chart_axis*, double) @nogc nothrow;
    /**
 * @brief Set the alignment of the axis labels.
 *
 * @param axis  A pointer to a chart #lxw_chart_axis object.
 * @param align A #lxw_chart_axis_label_alignment value.
 *
 * Position the category axis labels for the chart. The labels are the
 * numbers, or strings or dates, on the axis that indicate the categories
 * of the axis.
 *
 * The allowable values:
 *
 * - #LXW_CHART_AXIS_LABEL_ALIGN_CENTER - Align label center (default).
 * - #LXW_CHART_AXIS_LABEL_ALIGN_LEFT - Align label left.
 * - #LXW_CHART_AXIS_LABEL_ALIGN_RIGHT - Align label right.
 *
 * @code
 *     chart_axis_set_label_align(chart->x_axis, LXW_CHART_AXIS_LABEL_ALIGN_RIGHT);
 * @endcode
 *
 * **Axis types**: This function is applicable to category axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_label_align(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Position the axis labels.
 *
 * @param axis     A pointer to a chart #lxw_chart_axis object.
 * @param position A #lxw_chart_axis_label_position value.
 *
 * Position the axis labels for the chart. The labels are the numbers, or
 * strings or dates, on the axis that indicate the categories or values of
 * the axis.
 *
 * For example:
 *
 * @code
 *     chart_axis_set_label_position(chart->x_axis, LXW_CHART_AXIS_LABEL_POSITION_HIGH);
 *     chart_axis_set_label_position(chart->y_axis, LXW_CHART_AXIS_LABEL_POSITION_HIGH);
 * @endcode
 *
 * @image html chart_label_position2.png
 *
 * The allowable values:
 *
 * - #LXW_CHART_AXIS_LABEL_POSITION_NEXT_TO - The default.
 * - #LXW_CHART_AXIS_LABEL_POSITION_HIGH - Also right for vertical axes.
 * - #LXW_CHART_AXIS_LABEL_POSITION_LOW - Also left for vertical axes.
 * - #LXW_CHART_AXIS_LABEL_POSITION_NONE
 *
 * @image html chart_label_position1.png
 *
 * The #LXW_CHART_AXIS_LABEL_POSITION_NONE turns off the axis labels. This
 * is slightly different from `chart_axis_off()` which also turns off the
 * labels but also turns off tick marks.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_label_position(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Position a category axis on or between the axis tick marks.
 *
 * @param axis     A pointer to a chart #lxw_chart_axis object.
 * @param position A #lxw_chart_axis_tick_position value.
 *
 * Position a category axis horizontally on, or between, the axis tick marks.
 *
 * There are two allowable values:
 *
 * - #LXW_CHART_AXIS_POSITION_ON_TICK
 * - #LXW_CHART_AXIS_POSITION_BETWEEN
 *
 * @code
 *     chart_axis_set_position(chart->x_axis, LXW_CHART_AXIS_POSITION_BETWEEN);
 * @endcode
 *
 * @image html chart_axis_set_position.png
 *
 * **Axis types**: This function is applicable to category axes only.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_position(lxw_chart_axis*, ubyte) @nogc nothrow;
    /**
 * @brief Turn off/hide an axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 *
 * Turn off, hide, a chart axis:
 *
 * @code
 *     chart_axis_off(chart->x_axis);
 * @endcode
 *
 * @image html chart_axis_off.png
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_off(lxw_chart_axis*) @nogc nothrow;
    /**
 * @brief Set the opposite axis crossing position as the axis minimum.
 *
 * @param axis  A pointer to a chart #lxw_chart_axis object.
 *
 * Set the position that the opposite axis will cross as the axis minimum.
 * The default axis crossing position is generally the axis minimum so this
 * function can be used to reverse the location of the axes without reversing
 * the number sequence:
 *
 * @code
 *     chart_axis_set_crossing_min(chart->x_axis);
 *     chart_axis_set_crossing_min(chart->y_axis);
 * @endcode
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_crossing_min(lxw_chart_axis*) @nogc nothrow;
    /**
 * @brief Set the opposite axis crossing position as the axis maximum.
 *
 * @param axis  A pointer to a chart #lxw_chart_axis object.
 *
 * Set the position that the opposite axis will cross as the axis maximum.
 * The default axis crossing position is generally the axis minimum so this
 * function can be used to reverse the location of the axes without reversing
 * the number sequence:
 *
 * @code
 *     chart_axis_set_crossing_max(chart->x_axis);
 *     chart_axis_set_crossing_max(chart->y_axis);
 * @endcode
 *
 * @image html chart_crossing2.png
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_crossing_max(lxw_chart_axis*) @nogc nothrow;
    /**
 * @brief Set the position that the axis will cross the opposite axis.
 *
 * @param axis  A pointer to a chart #lxw_chart_axis object.
 * @param value The category or value that the axis crosses at.
 *
 * Set the position that the axis will cross the opposite axis:
 *
 * @code
 *     chart_axis_set_crossing(chart->x_axis, 3);
 *     chart_axis_set_crossing(chart->y_axis, 8);
 * @endcode
 *
 * @image html chart_crossing1.png
 *
 * If crossing is omitted (the default) the crossing will be set automatically
 * by Excel based on the chart data.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_crossing(lxw_chart_axis*, double) @nogc nothrow;
    /**
 * @brief Reverse the order of the axis categories or values.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 *
 * Reverse the order of the axis categories or values:
 *
 * @code
 *     chart_axis_set_reverse(chart->x_axis);
 * @endcode
 *
 * @image html chart_reverse.png
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_reverse(lxw_chart_axis*) @nogc nothrow;
    /**
 * @brief Set the pattern properties for a chart axis.
 *
 * @param axis    A pointer to a chart #lxw_chart_axis object.
 * @param pattern A #lxw_chart_pattern struct.
 *
 * Set the pattern properties of a chart axis:
 *
 * @code
 *     chart_axis_set_pattern(chart->y_axis, &pattern);
 * @endcode
 *
 * For more information see #lxw_chart_pattern_type and @ref chart_patterns.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_pattern(lxw_chart_axis*, lxw_chart_pattern*) @nogc nothrow;
    /**
 * @brief Set the fill properties for a chart axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param fill A #lxw_chart_fill struct.
 *
 * Set the fill properties of a chart axis:
 *
 * @code
 *     lxw_chart_fill fill = {.color = LXW_COLOR_YELLOW};
 *
 *     chart_axis_set_fill(chart->y_axis, &fill);
 * @endcode
 *
 * @image html chart_axis_set_fill.png
 *
 * For more information see @ref chart_fills.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_fill(lxw_chart_axis*, lxw_chart_fill*) @nogc nothrow;
    /**
 * @brief Set the line properties for a chart axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param line A #lxw_chart_line struct.
 *
 * Set the line properties of a chart axis:
 *
 * @code
 *     // Hide the Y axis.
 *     lxw_chart_line line = {.none = LXW_TRUE};
 *
 *     chart_axis_set_line(chart->y_axis, &line);
 * @endcode
 *
 * @image html chart_axis_set_line.png
 *
 * For more information see @ref chart_lines.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_line(lxw_chart_axis*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set the number format for a chart axis.
 *
 * @param axis       A pointer to a chart #lxw_chart_axis object.
 * @param num_format The number format string.
 *
 * The `%chart_axis_set_num_format()` function is used to set the format of
 * the numbers on an axis:
 *
 * @code
 *     chart_axis_set_num_format(chart->x_axis, "0.00%");
 *     chart_axis_set_num_format(chart->y_axis, "$#,##0.00");
 * @endcode
 *
 * The number format is similar to the Worksheet Cell Format num_format,
 * see `format_set_num_format()`.
 *
 * @image html chart_axis_num_format.png
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_num_format(lxw_chart_axis*, const(char)*) @nogc nothrow;

    alias _Float32 = float;
    /**
 * @brief Set the font properties for the numbers of a chart axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param font A pointer to a chart #lxw_chart_font font struct.
 *
 * The `%chart_axis_set_num_font()` function is used to set the font of the
 * numbers on an axis:
 *
 * @code
 *     lxw_chart_font font = {.bold = LXW_TRUE, .color = LXW_COLOR_BLUE};
 *
 *     chart_axis_set_num_font(chart->x_axis, &font1);
 * @endcode
 *
 * @image html chart_axis_set_num_font.png
 *
 * For more information see @ref chart_fonts.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_num_font(lxw_chart_axis*, lxw_chart_font*) @nogc nothrow;
    /**
 * @brief Set the font properties for a chart axis name.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param font A pointer to a chart #lxw_chart_font font struct.
 *
 * The `%chart_axis_set_name_font()` function is used to set the font of an
 * axis name:
 *
 * @code
 *     lxw_chart_font font = {.bold = LXW_TRUE, .color = LXW_COLOR_BLUE};
 *
 *     chart_axis_set_name(chart->x_axis, "Yearly data");
 *     chart_axis_set_name_font(chart->x_axis, &font);
 * @endcode
 *
 * @image html chart_axis_set_name_font.png
 *
 * For more information see @ref chart_fonts.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_name_font(lxw_chart_axis*, lxw_chart_font*) @nogc nothrow;
    /**
 * @brief Set a chart axis name formula using row and column values.
 *
 * @param axis      A pointer to a chart #lxw_chart_axis object.
 * @param sheetname The name of the worksheet that contains the cell range.
 * @param row       The zero indexed row number of the range.
 * @param col       The zero indexed column number of the range.
 *
 * The `%chart_axis_set_name_range()` function can be used to set an axis name
 * range and is an alternative to using `chart_axis_set_name()` and a string
 * formula:
 *
 * @code
 *     chart_axis_set_name_range(chart->x_axis, "Sheet1", 1, 0);
 *     chart_axis_set_name_range(chart->y_axis, "Sheet1", 2, 0);
 * @endcode
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_name_range(lxw_chart_axis*, const(char)*, uint, ushort) @nogc nothrow;
    /**
 * @brief Set the name caption of the an axis.
 *
 * @param axis A pointer to a chart #lxw_chart_axis object.
 * @param name The name caption of the axis.
 *
 * The `%chart_axis_set_name()` function sets the name (also known as title or
 * caption) for an axis. It can be used for the X or Y axes. The name is
 * displayed below an X axis and to the side of a Y axis.
 *
 * @code
 *     chart_axis_set_name(chart->x_axis, "Earnings per Quarter");
 *     chart_axis_set_name(chart->y_axis, "US Dollars (Millions)");
 * @endcode
 *
 * @image html chart_axis_set_name.png
 *
 * The name parameter can also be a formula such as `=Sheet1!$A$1` to point to
 * a cell in the workbook that contains the name:
 *
 * @code
 *     chart_axis_set_name(chart->x_axis, "=Sheet1!$B$1");
 * @endcode
 *
 * See also the `chart_axis_set_name_range()` function to see how to set the
 * name formula programmatically.
 *
 * **Axis types**: This function is applicable to to all axes types.
 *                 See @ref ww_charts_axes.
 */
    void chart_axis_set_name(lxw_chart_axis*, const(char)*) @nogc nothrow;

    alias _Float64 = double;
    /**
 * @brief           Get an axis pointer from a chart.
 *
 * @param chart     Pointer to a lxw_chart instance to be configured.
 * @param axis_type The axis type (X or Y): #lxw_chart_axis_type.
 *
 * The `%chart_axis_get()` function returns a pointer to a chart axis based
 * on the  #lxw_chart_axis_type:
 *
 * @code
 *     lxw_chart_axis *x_axis = chart_axis_get(chart, LXW_CHART_AXIS_TYPE_X);
 *     lxw_chart_axis *y_axis = chart_axis_get(chart, LXW_CHART_AXIS_TYPE_Y);
 *
 *     // Use the axis pointer in other functions.
 *     chart_axis_major_gridlines_set_visible(x_axis, LXW_TRUE);
 *     chart_axis_major_gridlines_set_visible(y_axis, LXW_TRUE);
 * @endcode
 *
 * Note, the axis pointer can also be accessed directly:
 *
 * @code
 *     // Equivalent to the above example, without function calls.
 *     chart_axis_major_gridlines_set_visible(chart->x_axis, LXW_TRUE);
 *     chart_axis_major_gridlines_set_visible(chart->y_axis, LXW_TRUE);
 * @endcode
 *
 * @return Pointer to the chart axis, or NULL if not found.
 */
    lxw_chart_axis* chart_axis_get(lxw_chart*, lxw_chart_axis_type) @nogc nothrow;
    /**
 * @brief Set the line properties for a chart series error bars.
 *
 * @param error_bars A pointer to the series X or Y error bars.
 * @param line       A #lxw_chart_line struct.
 *
 * The `%chart_series_set_error_bars_line()` function sets the line
 * properties for the error bars:
 *
 * @code
 *     lxw_chart_line line = {.color     = LXW_COLOR_RED,
 *                            .dash_type = LXW_CHART_LINE_DASH_ROUND_DOT};
 *
 *     chart_series_set_error_bars(series->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_ERROR, 0);
 *
 *     chart_series_set_error_bars_line(series->y_error_bars, &line);
 * @endcode
 *
 * @image html chart_error_bars4.png
 *
 * For more information see @ref chart_lines and @ref chart_error_bars.
 */
    void chart_series_set_error_bars_line(lxw_series_error_bars*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set the end cap type for the error bars of a chart series.
 *
 * @param error_bars A pointer to the series X or Y error bars.
 * @param endcap     The error bar end cap type: #lxw_chart_error_bar_cap .
 *
 * The `%chart_series_set_error_bars_endcap()` function sets the end cap
 * type for the error bars:
 *
 * @code
 *     chart_series_set_error_bars(series->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_ERROR, 0);
 *
 *     chart_series_set_error_bars_endcap(series->y_error_bars,
                                          LXW_CHART_ERROR_BAR_NO_CAP);
 * @endcode
 *
 * @image html chart_error_bars3.png
 *
 * The valid values are:
 *
 * - #LXW_CHART_ERROR_BAR_END_CAP: Flat end cap. The default.
 * - #LXW_CHART_ERROR_BAR_NO_CAP: No end cap.
 *
 * For more information see @ref chart_error_bars.
 */
    void chart_series_set_error_bars_endcap(lxw_series_error_bars*, ubyte) @nogc nothrow;
    /**
 * @brief Set the direction (up, down or both) of the error bars for a chart
 *        series.
 *
 * @param error_bars A pointer to the series X or Y error bars.
 * @param direction  The bar direction: #lxw_chart_error_bar_direction.
 *
 * The `%chart_series_set_error_bars_direction()` function sets the
 * direction of the error bars:
 *
 * @code
 *     chart_series_set_error_bars(series->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_ERROR, 0);
 *
 *     chart_series_set_error_bars_direction(series->y_error_bars,
 *                                           LXW_CHART_ERROR_BAR_DIR_PLUS);
 * @endcode
 *
 * @image html chart_error_bars2.png
 *
 * The valid directions are:
 *
 * - #LXW_CHART_ERROR_BAR_DIR_BOTH: Error bar extends in both directions.
 *   The default.
 * - #LXW_CHART_ERROR_BAR_DIR_PLUS: Error bar extends in positive direction.
 * - #LXW_CHART_ERROR_BAR_DIR_MINUS: Error bar extends in negative direction.
 *
 * For more information see @ref chart_error_bars.
 */
    void chart_series_set_error_bars_direction(lxw_series_error_bars*, ubyte) @nogc nothrow;

    alias _Float32x = double;
    /**
 * Set the X or Y error bars for a chart series.
 *
 * @param error_bars A pointer to the series X or Y error bars.
 * @param type       The type of error bar: #lxw_chart_error_bar_type.
 * @param value      The error value.
 *
 * Error bars can be added to a chart series to indicate error bounds in the
 * data. The error bars can be vertical `y_error_bars` (the most common type)
 * or horizontal `x_error_bars` (for Bar and Scatter charts only).
 *
 * @image html chart_error_bars0.png
 *
 * The `%chart_series_set_error_bars()` function sets the error bar type
 * and value associated with the type:
 *
 * @code
 *     lxw_chart_series *series = chart_add_series(chart,
 *                                                 "=Sheet1!$A$1:$A$5",
 *                                                 "=Sheet1!$B$1:$B$5");
 *
 *     chart_series_set_error_bars(series->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_ERROR, 0);
 * @endcode
 *
 * @image html chart_error_bars1.png
 *
 * The error bar types that be used are:
 *
 * - #LXW_CHART_ERROR_BAR_TYPE_STD_ERROR: Standard error.
 * - #LXW_CHART_ERROR_BAR_TYPE_FIXED: Fixed value.
 * - #LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE: Percentage.
 * - #LXW_CHART_ERROR_BAR_TYPE_STD_DEV: Standard deviation(s).
 *
 * @note Custom error bars are not currently supported.
 *
 * All error bar types, apart from Standard error, should have a valid
 * value to set the error range:
 *
 * @code
 *     chart_series_set_error_bars(series1->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_FIXED, 2);
 *
 *     chart_series_set_error_bars(series2->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE, 5);
 *
 *     chart_series_set_error_bars(series3->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_DEV, 1);
 * @endcode
 *
 * For the Standard error type the value is ignored.
 *
 * For more information see @ref chart_error_bars.
 */
    void chart_series_set_error_bars(lxw_series_error_bars*, ubyte, double) @nogc nothrow;
    /**
 * @brief           Get a pointer to X or Y error bars from a chart series.
 *
 * @param series    A series object created via `chart_add_series()`.
 * @param axis_type The axis type (X or Y): #lxw_chart_error_bar_axis.
 *
 * The `%chart_series_get_error_bars()` function returns a pointer to the
 * error bars of a series based on the type of #lxw_chart_error_bar_axis:
 *
 * @code
 *     lxw_series_error_bars *x_error_bars;
 *     lxw_series_error_bars *y_error_bars;
 *
 *     x_error_bars = chart_series_get_error_bars(series, LXW_CHART_ERROR_BAR_AXIS_X);
 *     y_error_bars = chart_series_get_error_bars(series, LXW_CHART_ERROR_BAR_AXIS_Y);
 *
 *     // Use the error bar pointers.
 *     chart_series_set_error_bars(x_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_DEV, 1);
 *
 *     chart_series_set_error_bars(y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_ERROR, 0);
 * @endcode
 *
 * Note, the series error bars can also be accessed directly:
 *
 * @code
 *     // Equivalent to the above example, without function calls.
 *     chart_series_set_error_bars(series->x_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_DEV, 1);
 *
 *     chart_series_set_error_bars(series->y_error_bars,
 *                                 LXW_CHART_ERROR_BAR_TYPE_STD_ERROR, 0);
 * @endcode
 *
 * @return Pointer to the series error bars, or NULL if not found.
 */
    lxw_series_error_bars* chart_series_get_error_bars(lxw_chart_series*, lxw_chart_error_bar_axis) @nogc nothrow;
    /**
 * @brief Set the trendline line properties for a chart data series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param line   A #lxw_chart_line struct.
 *
 * The `%chart_series_set_trendline_line()` function is used to set the line
 * properties of a trendline:
 *
 * @code
 *     lxw_chart_line line = {.color     = LXW_COLOR_RED,
 *                            .dash_type = LXW_CHART_LINE_DASH_LONG_DASH};
 *
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 *     chart_series_set_trendline_line(series, &line);
 * @endcode
 *
 * @image html chart_trendline10.png
 *
 * For more information see @ref chart_trendlines and @ref chart_lines.
 */
    void chart_series_set_trendline_line(lxw_chart_series*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set the trendline name for a chart data series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param name   The name of the trendline to display in the legend.
 *
 * The `%chart_series_set_trendline_name()` function sets the name of the
 * trendline that is displayed in the chart legend. In the examples above
 * the trendlines are displayed with default names like "Linear (Series 1)"
 * and "2 per Mov. Avg. (Series 1)". If these names are too verbose or not
 * descriptive enough you can set your own trendline name:
 *
 * @code
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 *     chart_series_set_trendline_name(series, "My trendline");
 * @endcode
 *
 * @image html chart_trendline8.png
 *
 * It is often preferable to turn off the trendline caption in the legend.
 * This is down in Excel by deleting the trendline name from the legend.
 * In libxlsxwriter this is done using the `chart_legend_delete_series()`
 * function to delete the zero based series numbers:
 *
 * @code
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 *
 *     // Delete the series name for the second series (=1 in zero base).
 *     // The -1 value indicates the end of the array of values.
 *     int16_t names[] = {1, -1};
 *     chart_legend_delete_series(chart, names);
 * @endcode
 *
 * @image html chart_trendline9.png
 *
 * For more information see @ref chart_trendlines.
 */
    void chart_series_set_trendline_name(lxw_chart_series*, const(char)*) @nogc nothrow;

    alias _Float64x = real;
    /**
 * @brief Set the trendline Y-axis intercept for a chart data series.
 *
 * @param series    A series object created via `chart_add_series()`.
 * @param intercept Y-axis intercept value.
 *
 * The `%chart_series_set_trendline_intercept()` function sets the Y-axis
 * intercept for the trendline:
 *
 * @code
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 *     chart_series_set_trendline_equation(series);
 *     chart_series_set_trendline_intercept(series, 0.8);
 * @endcode
 *
 * @image html chart_trendline7.png
 *
 * As can be seen from the equation on the chart the intercept point
 * (when X=0) is the same as the value set in the equation.
 *
 * @note The intercept feature is only available in Excel for Exponential,
 *       Linear and Polynomial trendline types.
 *
 * For more information see @ref chart_trendlines.
 */
    void chart_series_set_trendline_intercept(lxw_chart_series*, double) @nogc nothrow;
    /**
 * @brief Display the R squared value of a trendline for a chart data series.
 *
 * @param series A series object created via `chart_add_series()`.
 *
 * The `%chart_series_set_trendline_r_squared()` function displays the
 * R-squared value for the trendline on the chart:
 *
 * @code
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 *     chart_series_set_trendline_r_squared(series);
 * @endcode
 *
 * @image html chart_trendline6.png
 *
 * @note This feature isn't available for Moving Average in Excel.
 *
 * For more information see @ref chart_trendlines.
 */
    void chart_series_set_trendline_r_squared(lxw_chart_series*) @nogc nothrow;
    /**
 * @brief Display the equation of a trendline for a chart data series.
 *
 * @param series A series object created via `chart_add_series()`.
 *
 * The `%chart_series_set_trendline_equation()` function displays the
 * equation of the trendline on the chart:
 *
 * @code
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 *     chart_series_set_trendline_equation(series);
 * @endcode
 *
 * @image html chart_trendline5.png
 *
 * @note This feature isn't available for Moving Average in Excel.
 *
 * For more information see @ref chart_trendlines.
 */
    void chart_series_set_trendline_equation(lxw_chart_series*) @nogc nothrow;
    /**
 * @brief Set the trendline forecast for a chart data series.
 *
 * @param series   A series object created via `chart_add_series()`.
 * @param forward  The forward period.
 * @param backward The backwards period.
 *
 * The `%chart_series_set_trendline_forecast()` function sets the forward
 * and backward forecast periods for the trendline:
 *
 * @code
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 *     chart_series_set_trendline_forecast(series, 0.5, 0.5);
 * @endcode
 *
 * @image html chart_trendline4.png
 *
 * @note This feature isn't available for Moving Average in Excel.
 *
 * For more information see @ref chart_trendlines.
 */
    void chart_series_set_trendline_forecast(lxw_chart_series*, double, double) @nogc nothrow;
    /**
 * @brief Turn on a trendline for a chart data series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param type   The type of trendline: #lxw_chart_trendline_type.
 * @param value  The order/period value for polynomial and moving average
 *               trendlines.
 *
 * A trendline can be added to a chart series to indicate trends in the data
 * such as a moving average or a polynomial fit. The trendlines types are
 * shown in the following Excel dialog:
 *
 * @image html chart_trendline0.png
 *
 * The `%chart_series_set_trendline()` function turns on these trendlines for
 * a data series:
 *
 * @code
 *     chart = workbook_add_chart(workbook, LXW_CHART_LINE);
 *     series = chart_add_series(chart, NULL, "Sheet1!$A$1:$A$6");
 *
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_LINEAR, 0);
 * @endcode
 *
 * @image html chart_trendline2.png
 *
 * The `value` parameter corresponds to *order* for a polynomial trendline
 * and *period* for a Moving Average trendline. It both cases it must be >= 2.
 * The `value` parameter  is ignored for all other trendlines:
 *
 * @code
 *     chart_series_set_trendline(series, LXW_CHART_TRENDLINE_TYPE_AVERAGE, 2);
 * @endcode
 *
 * @image html chart_trendline3.png
 *
 * The allowable values for the the trendline `type` are:
 *
 * - #LXW_CHART_TRENDLINE_TYPE_LINEAR: Linear trendline.
 * - #LXW_CHART_TRENDLINE_TYPE_LOG: Logarithm trendline.
 * - #LXW_CHART_TRENDLINE_TYPE_POLY: Polynomial trendline. The `value`
 *   parameter corresponds to *order*.
 * - #LXW_CHART_TRENDLINE_TYPE_POWER: Power trendline.
 * - #LXW_CHART_TRENDLINE_TYPE_EXP: Exponential trendline.
 * - #LXW_CHART_TRENDLINE_TYPE_AVERAGE: Moving Average trendline. The `value`
 *   parameter corresponds to *period*.
 *
 * Other trendline options, such as those shown in the following Excel
 * dialog, can be set using the functions below.
 *
 * @image html chart_trendline1.png
 *
 * For more information see @ref chart_trendlines.
 */
    void chart_series_set_trendline(lxw_chart_series*, ubyte, ubyte) @nogc nothrow;
    /**
 * @brief Set the pattern properties for the data labels in a chart series.
 *
 * @param series  A series object created via `chart_add_series()`.
 * @param pattern A #lxw_chart_pattern struct.
 *
 * Set the pattern properties of the data labels in a chart series:
 *
 * @code
 *     chart_series_set_labels_pattern(series, &pattern);
 * @endcode
 *
 * For more information see #lxw_chart_pattern_type and @ref chart_patterns.
 */
    void chart_series_set_labels_pattern(lxw_chart_series*, lxw_chart_pattern*) @nogc nothrow;
    /**
 * @brief Set the fill properties for the data labels in a chart series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param fill   A #lxw_chart_fill struct.
 *
 * Set the fill properties of the data labels in a chart series:
 *
 * @code
 *     lxw_chart_fill fill = {.color = LXW_COLOR_YELLOW};
 *
 *     chart_series_set_labels_fill(series, &fill);
 * @endcode
 *
 * See the example and image above and also see @ref chart_fills and
 * @ref chart_labels.
 */
    void chart_series_set_labels_fill(lxw_chart_series*, lxw_chart_fill*) @nogc nothrow;
    /**
 * @brief Set the line properties for the data labels in a chart series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param line   A #lxw_chart_line struct.
 *
 * Set the line/border properties of the data labels in a chart series:
 *
 * @code
 *     lxw_chart_line line = {.color = LXW_COLOR_RED};
 *     lxw_chart_fill fill = {.color = LXW_COLOR_YELLOW};
 *
 *     chart_series_set_labels_line(series, &line);
 *     chart_series_set_labels_fill(series, &fill);
 *
 * @endcode
 *
 * @image html chart_data_labels24.png
 *
 * For more information see @ref chart_lines and @ref chart_labels.
 */
    void chart_series_set_labels_line(lxw_chart_series*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set the font properties for chart data labels in a series
 *
 * @param series A series object created via `chart_add_series()`.
 * @param font   A pointer to a chart #lxw_chart_font font struct.
 *
 *
 * The `%chart_series_set_labels_font()` function is used to set the font
 * for data labels:
 *
 * @code
 *     lxw_chart_font font = {.name = "Consolas", .color = LXW_COLOR_RED};
 *
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_font(series, &font);
 * @endcode
 *
 * @image html chart_data_labels9.png
 *
 * For more information see @ref chart_fonts and @ref chart_labels.
 *
 */
    void chart_series_set_labels_font(lxw_chart_series*, lxw_chart_font*) @nogc nothrow;
    /**
 * @brief Set the number format for chart data labels in a series.
 *
 * @param series     A series object created via `chart_add_series()`.
 * @param num_format The number format string.
 *
 * The `%chart_series_set_labels_num_format()` function is used to set the
 * number format for data labels:
 *
 * @code
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_num_format(series, "$0.00");
 * @endcode
 *
 * @image html chart_data_labels8.png
 *
 * The number format is similar to the Worksheet Cell Format num_format,
 * see `format_set_num_format()`.
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels_num_format(lxw_chart_series*, const(char)*) @nogc nothrow;

    extern export __gshared char* optarg;

    extern export __gshared int optind;

    extern export __gshared int opterr;

    extern export __gshared int optopt;

    int getopt(int, char**, const(char)*) @nogc nothrow;
    /**
 * @brief Set the percentage for a Pie/Doughnut data point.
 *
 * @param series A series object created via `chart_add_series()`.
 *
 * The `%chart_series_set_labels_percentage()` function is used to turn on
 * the display of data labels as a percentage for a series. It is mainly
 * used for pie charts:
 *
 * @code
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_options(series, LXW_FALSE, LXW_FALSE, LXW_FALSE);
 *     chart_series_set_labels_percentage(series);
 * @endcode
 *
 * @image html chart_data_labels7.png
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels_percentage(lxw_chart_series*) @nogc nothrow;
    /**
 * @brief Set the legend key for a data label in a chart series.
 *
 * @param series A series object created via `chart_add_series()`.
 *
 * The `%chart_series_set_labels_legend()` function is used to set the
 * legend key for a data series:
 *
 * @code
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_legend(series);
 * @endcode
 *
 * @image html chart_data_labels6.png
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels_legend(lxw_chart_series*) @nogc nothrow;
    /**
 * @brief Set leader lines for Pie and Doughnut charts.
 *
 * @param series A series object created via `chart_add_series()`.
 *
 * The `%chart_series_set_labels_leader_line()` function  is used to turn on
 * leader lines for the data label of a series. It is mainly used for pie
 * or doughnut charts:
 *
 * @code
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_leader_line(series);
 * @endcode
 *
 * @note Even when leader lines are turned on they aren't automatically
 *       visible in Excel or XlsxWriter. Due to an Excel limitation
 *       (or design) leader lines only appear if the data label is moved
 *       manually or if the data labels are very close and need to be
 *       adjusted automatically.
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels_leader_line(lxw_chart_series*) @nogc nothrow;
    /**
 * @brief Set the data label position for a series.
 *
 * @param series   A series object created via `chart_add_series()`.
 * @param position The data label position: #lxw_chart_label_position.
 *
 * The `%chart_series_set_labels_position()` function sets the position of
 * the labels in the data series:
 *
 * @code
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_position(series, LXW_CHART_LABEL_POSITION_ABOVE);
 * @endcode
 *
 * @image html chart_data_labels5.png
 *
 * In Excel the allowable data label positions vary for different chart
 * types. The allowable, and default, positions are:
 *
 * | Position                              | Line, Scatter | Bar, Column   | Pie, Doughnut | Area, Radar   |
 * | :------------------------------------ | :------------ | :------------ | :------------ | :------------ |
 * | #LXW_CHART_LABEL_POSITION_CENTER      | Yes           | Yes           | Yes           | Yes (default) |
 * | #LXW_CHART_LABEL_POSITION_RIGHT       | Yes (default) |               |               |               |
 * | #LXW_CHART_LABEL_POSITION_LEFT        | Yes           |               |               |               |
 * | #LXW_CHART_LABEL_POSITION_ABOVE       | Yes           |               |               |               |
 * | #LXW_CHART_LABEL_POSITION_BELOW       | Yes           |               |               |               |
 * | #LXW_CHART_LABEL_POSITION_INSIDE_BASE |               | Yes           |               |               |
 * | #LXW_CHART_LABEL_POSITION_INSIDE_END  |               | Yes           | Yes           |               |
 * | #LXW_CHART_LABEL_POSITION_OUTSIDE_END |               | Yes (default) | Yes           |               |
 * | #LXW_CHART_LABEL_POSITION_BEST_FIT    |               |               | Yes (default) |               |
 *
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels_position(lxw_chart_series*, ubyte) @nogc nothrow;
    /**
 * @brief Set the separator for the data label captions.
 *
 * @param series    A series object created via `chart_add_series()`.
 * @param separator The separator for the data label options:
 *                  #lxw_chart_label_separator.
 *
 * The `%chart_series_set_labels_separator()` function is used to change the
 * separator between multiple data label items. The default options is a comma
 * separator as shown in the previous example.
 *
 * The available options are:
 *
 * - #LXW_CHART_LABEL_SEPARATOR_SEMICOLON: semicolon separator.
 * - #LXW_CHART_LABEL_SEPARATOR_PERIOD: a period (dot) separator.
 * - #LXW_CHART_LABEL_SEPARATOR_NEWLINE: a newline separator.
 * - #LXW_CHART_LABEL_SEPARATOR_SPACE: a space separator.
 *
 * For example:
 *
 * @code
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_options(series, LXW_TRUE, LXW_TRUE, LXW_TRUE);
 *     chart_series_set_labels_separator(series, LXW_CHART_LABEL_SEPARATOR_NEWLINE);
 * @endcode
 *
 * @image html chart_data_labels4.png
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels_separator(lxw_chart_series*, ubyte) @nogc nothrow;
    /** @brief Set the properties for data labels in a series.
*
* @param series      A series object created via `chart_add_series()`.
* @param data_labels An NULL terminated array of #lxw_chart_data_label pointers.
*
* @return A #lxw_error.
*
* The `%chart_series_set_labels_custom()` function is used to set the properties
* for data labels in a series. It can also be used to delete individual data
* labels in a series.
*
* In general properties are set for all the data labels in a chart
* series. However, it is also possible to set properties for individual data
* labels in a series using `%chart_series_set_labels_custom()`.
*
* The `%chart_series_set_labels_custom()` function takes a pointer to an array
* of #lxw_chart_data_label pointers. The list should be `NULL` terminated:
*
* @code
*     // Add the series data labels.
*     chart_series_set_labels(series);
*
*     // Create some custom labels.
*     lxw_chart_data_label data_label1 = {.value = "Jan"};
*     lxw_chart_data_label data_label2 = {.value = "Feb"};
*     lxw_chart_data_label data_label3 = {.value = "Mar"};
*     lxw_chart_data_label data_label4 = {.value = "Apr"};
*     lxw_chart_data_label data_label5 = {.value = "May"};
*     lxw_chart_data_label data_label6 = {.value = "Jun"};
*
*     // Create an array of label pointers. NULL indicates the end of the array.
*     lxw_chart_data_label *data_labels[] = {
*         &data_label1,
*         &data_label2,
*         &data_label3,
*         &data_label4,
*         &data_label5,
*         &data_label6,
*         NULL
*     };
*
*     // Set the custom labels.
*     chart_series_set_labels_custom(series, data_labels);
* @endcode
*
* @image html chart_data_labels18.png
*
* @note The array of #lxw_chart_point pointers should be NULL terminated as
* shown in the example. Any #lxw_chart_data_label items set to a default
* initialization or omitted from the list will be assigned the default data
* label value.
*
* For more details see @ref chart_custom_labels.
*/
    lxw_error chart_series_set_labels_custom(lxw_chart_series*, lxw_chart_data_label**) @nogc nothrow;
    /**
 * @brief Set the display options for the labels of a data series.
 *
 * @param series        A series object created via `chart_add_series()`.
 * @param show_name     Turn on/off the series name in the label caption.
 * @param show_category Turn on/off the category name in the label caption.
 * @param show_value    Turn on/off the value in the label caption.
 *
 * The `%chart_series_set_labels_options()` function is used to set the
 * parameters that are displayed in the series data label:
 *
 * @code
 *     chart_series_set_labels(series);
 *     chart_series_set_labels_options(series, LXW_TRUE, LXW_TRUE, LXW_TRUE);
 * @endcode
 *
 * @image html chart_data_labels3.png
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels_options(lxw_chart_series*, ubyte, ubyte, ubyte) @nogc nothrow;
    /**
 * @brief Add data labels to a chart series.
 *
 * @param series A series object created via `chart_add_series()`.
 *
 * The `%chart_series_set_labels()` function is used to turn on data labels
 * for a chart series. Data labels indicate the values of the plotted data
 * points.
 *
 * @code
 *     chart_series_set_labels(series);
 * @endcode
 *
 * @image html chart_data_labels1.png
 *
 * By default data labels are displayed in Excel with only the values shown:
 *
 * @image html chart_data_labels2.png
 *
 * However, it is possible to configure other display options, as shown
 * in the functions below.
 *
 * For more information see @ref chart_labels.
 */
    void chart_series_set_labels(lxw_chart_series*) @nogc nothrow;
    /**
 * @brief Smooth a line or scatter chart series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param smooth Turn off/on the line smoothing. (0/1)
 *
 * The `chart_series_set_smooth()` function is used to set the smooth property
 * of a line series. It is only applicable to the line and scatter chart
 * types:
 *
 * @code
 *     chart_series_set_smooth(series2, LXW_TRUE);
 * @endcode
 *
 * @image html chart_smooth.png
 *
 *
 */
    void chart_series_set_smooth(lxw_chart_series*, ubyte) @nogc nothrow;
    /**
 * @brief Set the formatting for points in the series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param points An NULL terminated array of #lxw_chart_point pointers.
 *
 * @return A #lxw_error.
 *
 * In general formatting is applied to an entire series in a chart. However,
 * it is occasionally required to format individual points in a series. In
 * particular this is required for Pie/Doughnut charts where each segment is
 * represented by a point.
 *
 * @dontinclude chart_pie_colors.c
 * @skip Add the data series
 * @until chart_series_set_points
 *
 * @image html chart_points1.png
 *
 * @note The array of #lxw_chart_point pointers should be NULL terminated
 * as shown in the example.
 *
 * For more details see @ref chart_points
 */
    lxw_error chart_series_set_points(lxw_chart_series*, lxw_chart_point**) @nogc nothrow;
    /**
 * @brief Set the pattern properties for a chart series marker.
 *
 * @param series  A series object created via `chart_add_series()`.
 * @param pattern A #lxw_chart_pattern struct.
 *
 * Set the pattern properties of a chart marker:
 *
 * @code
 *     chart_series_set_marker_pattern(series, &pattern);
 * @endcode
 *
 * For more information see #lxw_chart_pattern_type and @ref chart_patterns.
 */
    void chart_series_set_marker_pattern(lxw_chart_series*, lxw_chart_pattern*) @nogc nothrow;
    /**
 * @brief Set the fill properties for a chart series marker.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param fill   A #lxw_chart_fill struct.
 *
 * Set the fill properties of a chart marker:
 *
 * @code
 *     chart_series_set_marker_fill(series, &fill);
 * @endcode
 *
 * See the example and image above and also see @ref chart_fills.
 */
    void chart_series_set_marker_fill(lxw_chart_series*, lxw_chart_fill*) @nogc nothrow;
    /**
 * @brief Set the line properties for a chart series marker.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param line   A #lxw_chart_line struct.
 *
 * Set the line/border properties of a chart marker:
 *
 * @code
 *     lxw_chart_line line = {.color = LXW_COLOR_BLACK};
 *     lxw_chart_fill fill = {.color = LXW_COLOR_RED};
 *
 *     chart_series_set_marker_type(series, LXW_CHART_MARKER_SQUARE);
 *     chart_series_set_marker_size(series, 8);
 *
 *     chart_series_set_marker_line(series, &line);
 *     chart_series_set_marker_fill(series, &fill);
 * @endcode
 *
 * @image html chart_marker2.png
 *
 * For more information see @ref chart_lines.
 */
    void chart_series_set_marker_line(lxw_chart_series*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set the size of a data marker for a series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param size   The size of the marker.
 *
 * The `%chart_series_set_marker_size()` function is used to specify the
 * size of the series marker:
 *
 * @code
 *     chart_series_set_marker_type(series, LXW_CHART_MARKER_CIRCLE);
 *     chart_series_set_marker_size(series, 10);
 * @endcode
 *
 * @image html chart_series_set_marker_size.png
 *
 */
    void chart_series_set_marker_size(lxw_chart_series*, ubyte) @nogc nothrow;
    /**
 * @brief Set the data marker type for a series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param type   The marker type, see #lxw_chart_marker_type.
 *
 * In Excel a chart marker is used to distinguish data points in a plotted
 * series. In general only Line and Scatter and Radar chart types use
 * markers. The libxlsxwriter chart types that can have markers are:
 *
 * - #LXW_CHART_LINE
 * - #LXW_CHART_SCATTER
 * - #LXW_CHART_SCATTER_STRAIGHT
 * - #LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS
 * - #LXW_CHART_SCATTER_SMOOTH
 * - #LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS
 * - #LXW_CHART_RADAR
 * - #LXW_CHART_RADAR_WITH_MARKERS
 *
 * The chart types with `MARKERS` in the name have markers with default colors
 * and shapes turned on by default but it is possible using the various
 * `chart_series_set_marker_xxx()` functions below to change these defaults. It
 * is also possible to turn on an off markers.
 *
 * The `%chart_series_set_marker_type()` function is used to specify the
 * type of the series marker:
 *
 * @code
 *     chart_series_set_marker_type(series, LXW_CHART_MARKER_DIAMOND);
 * @endcode
 *
 * @image html chart_marker1.png
 *
 * The available marker types defined by #lxw_chart_marker_type are:
 *
 * - #LXW_CHART_MARKER_AUTOMATIC
 * - #LXW_CHART_MARKER_NONE
 * - #LXW_CHART_MARKER_SQUARE
 * - #LXW_CHART_MARKER_DIAMOND
 * - #LXW_CHART_MARKER_TRIANGLE
 * - #LXW_CHART_MARKER_X
 * - #LXW_CHART_MARKER_STAR
 * - #LXW_CHART_MARKER_SHORT_DASH
 * - #LXW_CHART_MARKER_LONG_DASH
 * - #LXW_CHART_MARKER_CIRCLE
 * - #LXW_CHART_MARKER_PLUS
 *
 * The `#LXW_CHART_MARKER_NONE` type can be used to turn off default markers:
 *
 * @code
 *     chart_series_set_marker_type(series, LXW_CHART_MARKER_NONE);
 * @endcode
 *
 * @image html chart_series_set_marker_none.png
 *
 * The `#LXW_CHART_MARKER_AUTOMATIC` type is a special case which turns on a
 * marker using the default marker style for the particular series. If
 * automatic is on then other marker properties such as size, line or fill
 * cannot be set.
 */
    void chart_series_set_marker_type(lxw_chart_series*, ubyte) @nogc nothrow;
    /**
 * @brief Set the pattern properties for a chart series.
 *
 * @param series  A series object created via `chart_add_series()`.
 * @param pattern A #lxw_chart_pattern struct.
 *
 * Set the pattern properties of a chart series:
 *
 * @code
 *     lxw_chart_pattern pattern1 = {.type = LXW_CHART_PATTERN_SHINGLE,
 *                                   .fg_color = 0x804000,
 *                                   .bg_color = 0XC68C53};
 *
 *     lxw_chart_pattern pattern2 = {.type = LXW_CHART_PATTERN_HORIZONTAL_BRICK,
 *                                   .fg_color = 0XB30000,
 *                                   .bg_color = 0XFF6666};
 *
 *     chart_series_set_pattern(series1, &pattern1);
 *     chart_series_set_pattern(series2, &pattern2);
 *
 * @endcode
 *
 * @image html chart_pattern.png
 *
 * For more information see #lxw_chart_pattern_type and @ref chart_patterns.
 */
    void chart_series_set_pattern(lxw_chart_series*, lxw_chart_pattern*) @nogc nothrow;
    /**
 * @brief Invert the fill color for negative series values.
 *
 * @param series  A series object created via `chart_add_series()`.
 *
 * Invert the fill color for negative values. Usually only applicable to
 * column and bar charts.
 *
 * @code
 *     chart_series_set_invert_if_negative(series);
 * @endcode
 *
 */
    void chart_series_set_invert_if_negative(lxw_chart_series*) @nogc nothrow;
    /**
 * @brief Set the fill properties for a chart series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param fill   A #lxw_chart_fill struct.
 *
 * Set the fill properties of a chart series:
 *
 * @code
 *     lxw_chart_fill fill1 = {.color = LXW_COLOR_RED};
 *     lxw_chart_fill fill2 = {.color = LXW_COLOR_YELLOW};
 *     lxw_chart_fill fill3 = {.color = LXW_COLOR_GREEN};
 *
 *     chart_series_set_fill(series1, &fill1);
 *     chart_series_set_fill(series2, &fill2);
 *     chart_series_set_fill(series3, &fill3);
 * @endcode
 *
 * @image html chart_series_set_fill.png
 *
 * For more information see @ref chart_fills.
 */
    void chart_series_set_fill(lxw_chart_series*, lxw_chart_fill*) @nogc nothrow;
    /**
 * @brief Set the line properties for a chart series.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param line   A #lxw_chart_line struct.
 *
 * Set the line/border properties of a chart series:
 *
 * @code
 *     lxw_chart_line line = {.color = LXW_COLOR_RED};
 *
 *     chart_series_set_line(series1, &line);
 *     chart_series_set_line(series2, &line);
 *     chart_series_set_line(series3, &line);
 * @endcode
 *
 * @image html chart_series_set_line.png
 *
 * For more information see @ref chart_lines.
 */
    void chart_series_set_line(lxw_chart_series*, lxw_chart_line*) @nogc nothrow;
    /**
 * @brief Set a series name formula using row and column values.
 *
 * @param series    A series object created via `chart_add_series()`.
 * @param sheetname The name of the worksheet that contains the cell range.
 * @param row       The zero indexed row number of the range.
 * @param col       The zero indexed column number of the range.
 *
 * The `%chart_series_set_name_range()` function can be used to set a series
 * name range and is an alternative to using `chart_series_set_name()` and a
 * string formula:
 *
 * @code
 *     lxw_chart_series *series = chart_add_series(chart, NULL, "=Sheet1!$B$2:$B$7");
 *
 *     chart_series_set_name_range(series, "Sheet1", 0, 2); // "=Sheet1!$C$1"
 * @endcode
 */
    void chart_series_set_name_range(lxw_chart_series*, const(char)*, uint, ushort) @nogc nothrow;
    /**
 * @brief Set the name of a chart series range.
 *
 * @param series A series object created via `chart_add_series()`.
 * @param name   The series name.
 *
 * The `%chart_series_set_name` function is used to set the name for a chart
 * data series. The series name in Excel is displayed in the chart legend and
 * in the formula bar. The name property is optional and if it isn't supplied
 * it will default to `Series 1..n`.
 *
 * The function applies to a #lxw_chart_series object created using
 * `chart_add_series()`:
 *
 * @code
 *     lxw_chart_series *series = chart_add_series(chart, NULL, "=Sheet1!$B$2:$B$7");
 *
 *     chart_series_set_name(series, "Quarterly budget data");
 * @endcode
 *
 * The name parameter can also be a formula such as `=Sheet1!$A$1` to point to
 * a cell in the workbook that contains the name:
 *
 * @code
 *     lxw_chart_series *series = chart_add_series(chart, NULL, "=Sheet1!$B$2:$B$7");
 *
 *     chart_series_set_name(series, "=Sheet1!$B$1");
 * @endcode
 *
 * See also the `chart_series_set_name_range()` function to see how to set the
 * name formula programmatically.
 */
    void chart_series_set_name(lxw_chart_series*, const(char)*) @nogc nothrow;
    /**
 * @brief Set a series "values" range using row and column values.
 *
 * @param series    A series object created via `chart_add_series()`.
 * @param sheetname The name of the worksheet that contains the data range.
 * @param first_row The first row of the range. (All zero indexed.)
 * @param first_col The first column of the range.
 * @param last_row  The last row of the range.
 * @param last_col  The last col of the range.
 *
 * The `categories` and `values` of a chart data series are generally set
 * using the `chart_add_series()` function and Excel range formulas like
 * `"=Sheet1!$A$2:$A$7"`.
 *
 * The `%chart_series_set_values()` function is an alternative method that is
 * easier to generate programmatically. See the documentation for
 * `chart_series_set_categories()` above.
 */
    void chart_series_set_values(lxw_chart_series*, const(char)*, uint, ushort, uint, ushort) @nogc nothrow;
    /**
 * @brief Set a series "categories" range using row and column values.
 *
 * @param series    A series object created via `chart_add_series()`.
 * @param sheetname The name of the worksheet that contains the data range.
 * @param first_row The first row of the range. (All zero indexed.)
 * @param first_col The first column of the range.
 * @param last_row  The last row of the range.
 * @param last_col  The last col of the range.
 *
 * The `categories` and `values` of a chart data series are generally set
 * using the `chart_add_series()` function and Excel range formulas like
 * `"=Sheet1!$A$2:$A$7"`.
 *
 * The `%chart_series_set_categories()` function is an alternative method that
 * is easier to generate programmatically. It requires that you set the
 * `categories` and `values` parameters in `chart_add_series()`to `NULL` and
 * then set them using row and column values in
 * `chart_series_set_categories()` and `chart_series_set_values()`:
 *
 * @code
 *     lxw_chart_series *series = chart_add_series(chart, NULL, NULL);
 *
 *     // Configure the series ranges programmatically.
 *     chart_series_set_categories(series, "Sheet1", 1, 0, 6, 0); // "=Sheet1!$A$2:$A$7"
 *     chart_series_set_values(    series, "Sheet1", 1, 2, 6, 2); // "=Sheet1!$C$2:$C$7"
 * @endcode
 *
 */
    void chart_series_set_categories(lxw_chart_series*, const(char)*, uint, ushort, uint, ushort) @nogc nothrow;
    /**
 * @brief Add a data series to a chart.
 *
 * @param chart      Pointer to a lxw_chart instance to be configured.
 * @param categories The range of categories in the data series.
 * @param values     The range of values in the data series.
 *
 * @return A lxw_chart_series object pointer.
 *
 * In Excel a chart **series** is a collection of information that defines
 * which data is plotted such as the categories and values. It is also used to
 * define the formatting for the data.
 *
 * For an libxlsxwriter chart object the `%chart_add_series()` function is
 * used to set the categories and values of the series:
 *
 * @code
 *     chart_add_series(chart, "=Sheet1!$A$2:$A$7", "=Sheet1!$C$2:$C$7");
 * @endcode
 *
 *
 * The series parameters are:
 *
 * - `categories`: This sets the chart category labels. The category is more
 *   or less the same as the X axis. In most Excel chart types the
 *   `categories` property is optional and the chart will just assume a
 *   sequential series from `1..n`:
 *
 * @code
 *     // The NULL category will default to 1 to 5 like in Excel.
 *     chart_add_series(chart, NULL, "Sheet1!$A$1:$A$5");
 * @endcode
 *
 *  - `values`: This is the most important property of a series and is the
 *    only mandatory option for every chart object. This parameter links the
 *    chart with the worksheet data that it displays.
 *
 * The `categories` and `values` should be a string formula like
 * `"=Sheet1!$A$2:$A$7"` in the same way it is represented in Excel. This is
 * convenient when recreating a chart from an example in Excel but it is
 * trickier to generate programmatically. For these cases you can set the
 * `categories` and `values` to `NULL` and use the
 * `chart_series_set_categories()` and `chart_series_set_values()` functions:
 *
 * @code
 *     lxw_chart_series *series = chart_add_series(chart, NULL, NULL);
 *
 *     // Configure the series using a syntax that is easier to define programmatically.
 *     chart_series_set_categories(series, "Sheet1", 1, 0, 6, 0); // "=Sheet1!$A$2:$A$7"
 *     chart_series_set_values(    series, "Sheet1", 1, 2, 6, 2); // "=Sheet1!$C$2:$C$7"
 * @endcode
 *
 * As shown in the previous example the return value from
 * `%chart_add_series()` is a lxw_chart_series pointer. This can be used in
 * other functions that configure a series.
 *
 *
 * More than one series can be added to a chart. The series numbering and
 * order in the Excel chart will be the same as the order in which they are
 * added in libxlsxwriter:
 *
 * @code
 *    chart_add_series(chart, NULL, "Sheet1!$A$1:$A$5");
 *    chart_add_series(chart, NULL, "Sheet1!$B$1:$B$5");
 *    chart_add_series(chart, NULL, "Sheet1!$C$1:$C$5");
 * @endcode
 *
 * It is also possible to specify non-contiguous ranges:
 *
 * @code
 *    chart_add_series(
 *        chart,
 *        "=(Sheet1!$A$1:$A$9,Sheet1!$A$14:$A$25)",
 *        "=(Sheet1!$B$1:$B$9,Sheet1!$B$14:$B$25)"
 *    );
 * @endcode
 *
 */
    lxw_chart_series* chart_add_series(lxw_chart*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_chart_assemble_xml_file(lxw_chart*) @nogc nothrow;

    void lxw_chart_free(lxw_chart*) @nogc nothrow;

    lxw_chart* lxw_chart_new(ubyte) @nogc nothrow;
    /**
 * @brief Struct to represent an Excel chart.
 *
 * The members of the lxw_chart struct aren't modified directly. Instead
 * the chart properties are set by calling the functions shown in chart.h.
 */
    struct lxw_chart
    {

        _IO_FILE* file;

        ubyte type;

        ubyte subtype;

        ushort series_index;

        void function(lxw_chart*) write_chart_type;

        void function(lxw_chart*) write_plot_area;
        /**
     * A pointer to the chart x_axis object which can be used in functions
     * that configures the X axis.
     */
        lxw_chart_axis* x_axis;
        /**
     * A pointer to the chart y_axis object which can be used in functions
     * that configures the Y axis.
     */
        lxw_chart_axis* y_axis;

        lxw_chart_title title;

        uint id;

        uint axis_id_1;

        uint axis_id_2;

        uint axis_id_3;

        uint axis_id_4;

        ubyte in_use;

        ubyte chart_group;

        ubyte cat_has_num_fmt;

        ubyte is_chartsheet;

        ubyte has_horiz_cat_axis;

        ubyte has_horiz_val_axis;

        ubyte style_id;

        ushort rotation;

        ushort hole_size;

        ubyte no_title;

        ubyte has_overlap;

        byte overlap_y1;

        byte overlap_y2;

        ushort gap_y1;

        ushort gap_y2;

        ubyte grouping;

        ubyte default_cross_between;

        lxw_chart_legend legend;

        short* delete_series;

        ushort delete_series_count;

        lxw_chart_marker* default_marker;

        lxw_chart_line* chartarea_line;

        lxw_chart_fill* chartarea_fill;

        lxw_chart_pattern* chartarea_pattern;

        lxw_chart_line* plotarea_line;

        lxw_chart_fill* plotarea_fill;

        lxw_chart_pattern* plotarea_pattern;

        ubyte has_drop_lines;

        lxw_chart_line* drop_lines_line;

        ubyte has_high_low_lines;

        lxw_chart_line* high_low_lines_line;

        lxw_chart_series_list* series_list;

        ubyte has_table;

        ubyte has_table_vertical;

        ubyte has_table_horizontal;

        ubyte has_table_outline;

        ubyte has_table_legend_keys;

        lxw_chart_font* table_font;

        ubyte show_blanks_as;

        ubyte show_hidden_data;

        ubyte has_up_down_bars;

        lxw_chart_line* up_bar_line;

        lxw_chart_line* down_bar_line;

        lxw_chart_fill* up_bar_fill;

        lxw_chart_fill* down_bar_fill;

        ubyte default_label_position;

        ubyte is_protected;

        static struct _Anonymous_36
        {

            lxw_chart* stqe_next;
        }

        _Anonymous_36 ordered_list_pointers;

        static struct _Anonymous_37
        {

            lxw_chart* stqe_next;
        }

        _Anonymous_37 list_pointers;
    }
    /**
 * @brief Struct to represent an Excel chart axis.
 *
 * The lxw_chart_axis struct is used in functions that modify a chart axis
 * but the members of the struct aren't modified directly.
 */
    struct lxw_chart_axis
    {

        lxw_chart_title title;

        char* num_format;

        char* default_num_format;

        ubyte source_linked;

        ubyte major_tick_mark;

        ubyte minor_tick_mark;

        ubyte is_horizontal;

        lxw_chart_gridline major_gridlines;

        lxw_chart_gridline minor_gridlines;

        lxw_chart_font* num_font;

        lxw_chart_line* line;

        lxw_chart_fill* fill;

        lxw_chart_pattern* pattern;

        ubyte is_category;

        ubyte is_date;

        ubyte is_value;

        ubyte axis_position;

        ubyte position_axis;

        ubyte label_position;

        ubyte label_align;

        ubyte hidden;

        ubyte reverse;

        ubyte has_min;

        double min;

        ubyte has_max;

        double max;

        ubyte has_major_unit;

        double major_unit;

        ubyte has_minor_unit;

        double minor_unit;

        ushort interval_unit;

        ushort interval_tick;

        ushort log_base;

        ubyte display_units;

        ubyte display_units_visible;

        ubyte has_crossing;

        ubyte crossing_min;

        ubyte crossing_max;

        double crossing;
    }

    struct lxw_chart_gridline
    {

        ubyte visible;

        lxw_chart_line* line;
    }
    /**
 * @brief Series trendline/regression types.
 */
    enum lxw_chart_trendline_type
    {
        /** Trendline type: Linear. */
        LXW_CHART_TRENDLINE_TYPE_LINEAR = 0,
        /** Trendline type: Logarithm. */
        LXW_CHART_TRENDLINE_TYPE_LOG = 1,
        /** Trendline type: Polynomial. */
        LXW_CHART_TRENDLINE_TYPE_POLY = 2,
        /** Trendline type: Power. */
        LXW_CHART_TRENDLINE_TYPE_POWER = 3,
        /** Trendline type: Exponential. */
        LXW_CHART_TRENDLINE_TYPE_EXP = 4,
        /** Trendline type: Moving Average. */
        LXW_CHART_TRENDLINE_TYPE_AVERAGE = 5,
    }
    enum LXW_CHART_TRENDLINE_TYPE_LINEAR = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_LINEAR;
    enum LXW_CHART_TRENDLINE_TYPE_LOG = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_LOG;
    enum LXW_CHART_TRENDLINE_TYPE_POLY = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_POLY;
    enum LXW_CHART_TRENDLINE_TYPE_POWER = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_POWER;
    enum LXW_CHART_TRENDLINE_TYPE_EXP = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_EXP;
    enum LXW_CHART_TRENDLINE_TYPE_AVERAGE = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_AVERAGE;

    struct lxw_series_error_bars
    {

        ubyte type;

        ubyte direction;

        ubyte endcap;

        ubyte has_value;

        ubyte is_set;

        ubyte is_x;

        ubyte chart_group;

        double value;

        lxw_chart_line* line;
    }
    /**
 * @brief End cap styles for a data series error bar.
 */
    enum lxw_chart_error_bar_cap
    {
        /** Flat end cap. The default. */
        LXW_CHART_ERROR_BAR_END_CAP = 0,
        /** No end cap. */
        LXW_CHART_ERROR_BAR_NO_CAP = 1,
    }
    enum LXW_CHART_ERROR_BAR_END_CAP = lxw_chart_error_bar_cap.LXW_CHART_ERROR_BAR_END_CAP;
    enum LXW_CHART_ERROR_BAR_NO_CAP = lxw_chart_error_bar_cap.LXW_CHART_ERROR_BAR_NO_CAP;
    /**
 * @brief Direction for a data series error bar.
 */
    enum lxw_chart_error_bar_axis
    {
        /** X axis error bar. */
        LXW_CHART_ERROR_BAR_AXIS_X = 0,
        /** Y axis error bar. */
        LXW_CHART_ERROR_BAR_AXIS_Y = 1,
    }
    enum LXW_CHART_ERROR_BAR_AXIS_X = lxw_chart_error_bar_axis.LXW_CHART_ERROR_BAR_AXIS_X;
    enum LXW_CHART_ERROR_BAR_AXIS_Y = lxw_chart_error_bar_axis.LXW_CHART_ERROR_BAR_AXIS_Y;
    /**
 * @brief Direction for a data series error bar.
 */
    enum lxw_chart_error_bar_direction
    {
        /** Error bar extends in both directions. The default. */
        LXW_CHART_ERROR_BAR_DIR_BOTH = 0,
        /** Error bar extends in positive direction. */
        LXW_CHART_ERROR_BAR_DIR_PLUS = 1,
        /** Error bar extends in negative direction. */
        LXW_CHART_ERROR_BAR_DIR_MINUS = 2,
    }
    enum LXW_CHART_ERROR_BAR_DIR_BOTH = lxw_chart_error_bar_direction.LXW_CHART_ERROR_BAR_DIR_BOTH;
    enum LXW_CHART_ERROR_BAR_DIR_PLUS = lxw_chart_error_bar_direction.LXW_CHART_ERROR_BAR_DIR_PLUS;
    enum LXW_CHART_ERROR_BAR_DIR_MINUS = lxw_chart_error_bar_direction.LXW_CHART_ERROR_BAR_DIR_MINUS;
    /**
 * @brief Type/amount of data series error bar.
 */
    enum lxw_chart_error_bar_type
    {
        /** Error bar type: Standard error. */
        LXW_CHART_ERROR_BAR_TYPE_STD_ERROR = 0,
        /** Error bar type: Fixed value. */
        LXW_CHART_ERROR_BAR_TYPE_FIXED = 1,
        /** Error bar type: Percentage. */
        LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE = 2,
        /** Error bar type: Standard deviation(s). */
        LXW_CHART_ERROR_BAR_TYPE_STD_DEV = 3,
    }
    enum LXW_CHART_ERROR_BAR_TYPE_STD_ERROR = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_STD_ERROR;
    enum LXW_CHART_ERROR_BAR_TYPE_FIXED = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_FIXED;
    enum LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE;
    enum LXW_CHART_ERROR_BAR_TYPE_STD_DEV = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_STD_DEV;

    enum lxw_chart_position
    {

        LXW_CHART_AXIS_RIGHT = 0,

        LXW_CHART_AXIS_LEFT = 1,

        LXW_CHART_AXIS_TOP = 2,

        LXW_CHART_AXIS_BOTTOM = 3,
    }
    enum LXW_CHART_AXIS_RIGHT = lxw_chart_position.LXW_CHART_AXIS_RIGHT;
    enum LXW_CHART_AXIS_LEFT = lxw_chart_position.LXW_CHART_AXIS_LEFT;
    enum LXW_CHART_AXIS_TOP = lxw_chart_position.LXW_CHART_AXIS_TOP;
    enum LXW_CHART_AXIS_BOTTOM = lxw_chart_position.LXW_CHART_AXIS_BOTTOM;
    /**
 * @brief Define how blank values are displayed in a chart.
 */
    enum lxw_chart_blank
    {
        /** Show empty chart cells as gaps in the data. The default. */
        LXW_CHART_BLANKS_AS_GAP = 0,
        /** Show empty chart cells as zeros. */
        LXW_CHART_BLANKS_AS_ZERO = 1,
        /** Show empty chart cells as connected. Only for charts with lines. */
        LXW_CHART_BLANKS_AS_CONNECTED = 2,
    }
    enum LXW_CHART_BLANKS_AS_GAP = lxw_chart_blank.LXW_CHART_BLANKS_AS_GAP;
    enum LXW_CHART_BLANKS_AS_ZERO = lxw_chart_blank.LXW_CHART_BLANKS_AS_ZERO;
    enum LXW_CHART_BLANKS_AS_CONNECTED = lxw_chart_blank.LXW_CHART_BLANKS_AS_CONNECTED;

    struct lxw_chart_custom_label
    {

        char* value;

        ubyte hide;

        lxw_chart_font* font;

        lxw_chart_line* line;

        lxw_chart_fill* fill;

        lxw_chart_pattern* pattern;

        lxw_series_range* range;

        lxw_series_data_point data_point;
    }
    /**
 * @brief Struct to represent an Excel chart data label.
 *
 * The lxw_chart_data_label struct is used to represent a data label in a
 * chart series so that custom properties can be set for it.
 */
    struct lxw_chart_data_label
    {
        /** The string or formula value for the data label. See
     *  @ref chart_custom_labels. */
        char* value;
        /** Option to hide/delete the data label from the chart series.
     *  See @ref chart_custom_labels. */
        ubyte hide;
        /** The font properties for the chart data label. @ref chart_fonts. */
        lxw_chart_font* font;
        /** The line/border for the chart data label. See @ref chart_lines. */
        lxw_chart_line* line;
        /** The fill for the chart data label. See @ref chart_fills. */
        lxw_chart_fill* fill;
        /** The pattern for the chart data label. See @ref chart_patterns.*/
        lxw_chart_pattern* pattern;
    }
    /**
 * @brief Struct to represent an Excel chart data point.
 *
 * The lxw_chart_point used to set the line, fill and pattern of one or more
 * points in a chart data series. See @ref chart_points.
 */
    struct lxw_chart_point
    {
        /** The line/border for the chart point. See @ref chart_lines. */
        lxw_chart_line* line;
        /** The fill for the chart point. See @ref chart_fills. */
        lxw_chart_fill* fill;
        /** The pattern for the chart point. See @ref chart_patterns.*/
        lxw_chart_pattern* pattern;
    }

    struct lxw_chart_title
    {

        char* name;

        uint row;

        ushort col;

        lxw_chart_font* font;

        ubyte off;

        ubyte is_horizontal;

        ubyte ignore_cache;

        lxw_series_range* range;

        lxw_series_data_point data_point;
    }

    struct lxw_chart_legend
    {

        lxw_chart_font* font;

        ubyte position;
    }

    struct lxw_chart_marker
    {

        ubyte type;

        ubyte size;

        lxw_chart_line* line;

        lxw_chart_fill* fill;

        lxw_chart_pattern* pattern;
    }
    /**
 * @brief Struct to represent a chart font.
 *
 * See @ref chart_fonts.
 */
    struct lxw_chart_font
    {
        /** The chart font name, such as "Arial" or "Calibri". */
        char* name;
        /** The chart font size. The default is 11. */
        double size;
        /** The chart font bold property. Set to 0 or 1. */
        ubyte bold;
        /** The chart font italic property. Set to 0 or 1. */
        ubyte italic;
        /** The chart font underline property. Set to 0 or 1. */
        ubyte underline;
        /** The chart font rotation property. Range: -90 to 90, and 270, 271 and 360:
     *
     *  - The angles -90 to 90 are the normal range shown in the Excel user interface.
     *  - The angle 270 gives a stacked (top to bottom) alignment.
     *  - The angle 271 gives a stacked alignment for East Asian fonts.
     *  - The angle 360 gives an explicit angle of 0 to override the y axis default.
     * */
        int rotation;
        /** The chart font color. See @ref working_with_colors. */
        uint color;
        /** The chart font pitch family property. Rarely required, set to 0. */
        ubyte pitch_family;
        /** The chart font character set property. Rarely required, set to 0. */
        ubyte charset;
        /** The chart font baseline property. Rarely required, set to 0. */
        byte baseline;
    }
    /**
 * @brief Struct to represent a chart pattern.
 *
 * See @ref chart_patterns.
 */
    struct lxw_chart_pattern
    {
        /** The pattern foreground color. See @ref working_with_colors. */
        uint fg_color;
        /** The pattern background color. See @ref working_with_colors. */
        uint bg_color;
        /** The pattern type. See #lxw_chart_pattern_type. */
        ubyte type;
    }
    /**
 * @brief Struct to represent a chart fill.
 *
 * See @ref chart_fills.
 */
    struct lxw_chart_fill
    {
        /** The chart font color. See @ref working_with_colors. */
        uint color;
        /** Turn off/hide line. Set to 0 or 1.*/
        ubyte none;
        /** Set the transparency of the fill. 0 - 100. Default 0. */
        ubyte transparency;
    }
    /**
 * @brief Struct to represent a chart line.
 *
 * See @ref chart_lines.
 */
    struct lxw_chart_line
    {
        /** The chart font color. See @ref working_with_colors. */
        uint color;
        /** Turn off/hide line. Set to 0 or 1.*/
        ubyte none;
        /** Width of the line in increments of 0.25. Default is 2.25. */
        float width;
        /** The line dash type. See #lxw_chart_line_dash_type. */
        ubyte dash_type;
        /** Set the transparency of the line. 0 - 100. Default 0. */
        ubyte transparency;
    }

    struct lxw_series_range
    {

        char* formula;

        char* sheetname;

        uint first_row;

        uint last_row;

        ushort first_col;

        ushort last_col;

        ubyte ignore_cache;

        ubyte has_string_cache;

        ushort num_data_points;

        lxw_series_data_points* data_cache;
    }
    /**
 * @brief Tick mark types for an axis.
 */
    enum lxw_chart_axis_tick_mark
    {
        /** Default tick mark for the chart axis. Usually outside. */
        LXW_CHART_AXIS_TICK_MARK_DEFAULT = 0,
        /** No tick mark for the axis. */
        LXW_CHART_AXIS_TICK_MARK_NONE = 1,
        /** Tick mark inside the axis only. */
        LXW_CHART_AXIS_TICK_MARK_INSIDE = 2,
        /** Tick mark outside the axis only. */
        LXW_CHART_AXIS_TICK_MARK_OUTSIDE = 3,
        /** Tick mark inside and outside the axis. */
        LXW_CHART_AXIS_TICK_MARK_CROSSING = 4,
    }
    enum LXW_CHART_AXIS_TICK_MARK_DEFAULT = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_DEFAULT;
    enum LXW_CHART_AXIS_TICK_MARK_NONE = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_NONE;
    enum LXW_CHART_AXIS_TICK_MARK_INSIDE = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_INSIDE;
    enum LXW_CHART_AXIS_TICK_MARK_OUTSIDE = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_OUTSIDE;
    enum LXW_CHART_AXIS_TICK_MARK_CROSSING = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_CROSSING;
    /**
 * @brief Tick mark types for an axis.
 */
    alias lxw_chart_tick_mark = lxw_chart_axis_tick_mark;
    /**
 * @brief Display units for chart value axis.
 */
    enum lxw_chart_axis_display_unit
    {
        /** Axis display units: None. The default. */
        LXW_CHART_AXIS_UNITS_NONE = 0,
        /** Axis display units: Hundreds. */
        LXW_CHART_AXIS_UNITS_HUNDREDS = 1,
        /** Axis display units: Thousands. */
        LXW_CHART_AXIS_UNITS_THOUSANDS = 2,
        /** Axis display units: Ten thousands. */
        LXW_CHART_AXIS_UNITS_TEN_THOUSANDS = 3,
        /** Axis display units: Hundred thousands. */
        LXW_CHART_AXIS_UNITS_HUNDRED_THOUSANDS = 4,
        /** Axis display units: Millions. */
        LXW_CHART_AXIS_UNITS_MILLIONS = 5,
        /** Axis display units: Ten millions. */
        LXW_CHART_AXIS_UNITS_TEN_MILLIONS = 6,
        /** Axis display units: Hundred millions. */
        LXW_CHART_AXIS_UNITS_HUNDRED_MILLIONS = 7,
        /** Axis display units: Billions. */
        LXW_CHART_AXIS_UNITS_BILLIONS = 8,
        /** Axis display units: Trillions. */
        LXW_CHART_AXIS_UNITS_TRILLIONS = 9,
    }
    enum LXW_CHART_AXIS_UNITS_NONE = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_NONE;
    enum LXW_CHART_AXIS_UNITS_HUNDREDS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_HUNDREDS;
    enum LXW_CHART_AXIS_UNITS_THOUSANDS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_THOUSANDS;
    enum LXW_CHART_AXIS_UNITS_TEN_THOUSANDS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_TEN_THOUSANDS;
    enum LXW_CHART_AXIS_UNITS_HUNDRED_THOUSANDS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_HUNDRED_THOUSANDS;
    enum LXW_CHART_AXIS_UNITS_MILLIONS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_MILLIONS;
    enum LXW_CHART_AXIS_UNITS_TEN_MILLIONS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_TEN_MILLIONS;
    enum LXW_CHART_AXIS_UNITS_HUNDRED_MILLIONS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_HUNDRED_MILLIONS;
    enum LXW_CHART_AXIS_UNITS_BILLIONS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_BILLIONS;
    enum LXW_CHART_AXIS_UNITS_TRILLIONS = lxw_chart_axis_display_unit.LXW_CHART_AXIS_UNITS_TRILLIONS;
    /**
 * @brief Axis label alignments.
 */
    enum lxw_chart_axis_label_alignment
    {
        /** Chart axis label alignment: center. */
        LXW_CHART_AXIS_LABEL_ALIGN_CENTER = 0,
        /** Chart axis label alignment: left. */
        LXW_CHART_AXIS_LABEL_ALIGN_LEFT = 1,
        /** Chart axis label alignment: right. */
        LXW_CHART_AXIS_LABEL_ALIGN_RIGHT = 2,
    }
    enum LXW_CHART_AXIS_LABEL_ALIGN_CENTER = lxw_chart_axis_label_alignment.LXW_CHART_AXIS_LABEL_ALIGN_CENTER;
    enum LXW_CHART_AXIS_LABEL_ALIGN_LEFT = lxw_chart_axis_label_alignment.LXW_CHART_AXIS_LABEL_ALIGN_LEFT;
    enum LXW_CHART_AXIS_LABEL_ALIGN_RIGHT = lxw_chart_axis_label_alignment.LXW_CHART_AXIS_LABEL_ALIGN_RIGHT;
    /**
 * @brief Axis label positions.
 */
    enum lxw_chart_axis_label_position
    {
        /** Position the axis labels next to the axis. The default. */
        LXW_CHART_AXIS_LABEL_POSITION_NEXT_TO = 0,
        /** Position the axis labels at the top of the chart, for horizontal
     * axes, or to the right for vertical axes.*/
        LXW_CHART_AXIS_LABEL_POSITION_HIGH = 1,
        /** Position the axis labels at the bottom of the chart, for horizontal
     * axes, or to the left for vertical axes.*/
        LXW_CHART_AXIS_LABEL_POSITION_LOW = 2,
        /** Turn off the the axis labels. */
        LXW_CHART_AXIS_LABEL_POSITION_NONE = 3,
    }
    enum LXW_CHART_AXIS_LABEL_POSITION_NEXT_TO = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_NEXT_TO;
    enum LXW_CHART_AXIS_LABEL_POSITION_HIGH = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_HIGH;
    enum LXW_CHART_AXIS_LABEL_POSITION_LOW = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_LOW;
    enum LXW_CHART_AXIS_LABEL_POSITION_NONE = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_NONE;
    /**
 * @brief Axis positions for category axes.
 */
    enum lxw_chart_axis_tick_position
    {

        LXW_CHART_AXIS_POSITION_DEFAULT = 0,
        /** Position category axis on tick marks. */
        LXW_CHART_AXIS_POSITION_ON_TICK = 1,
        /** Position category axis between tick marks. */
        LXW_CHART_AXIS_POSITION_BETWEEN = 2,
    }
    enum LXW_CHART_AXIS_POSITION_DEFAULT = lxw_chart_axis_tick_position.LXW_CHART_AXIS_POSITION_DEFAULT;
    enum LXW_CHART_AXIS_POSITION_ON_TICK = lxw_chart_axis_tick_position.LXW_CHART_AXIS_POSITION_ON_TICK;
    enum LXW_CHART_AXIS_POSITION_BETWEEN = lxw_chart_axis_tick_position.LXW_CHART_AXIS_POSITION_BETWEEN;

    enum lxw_chart_grouping
    {

        LXW_GROUPING_CLUSTERED = 0,

        LXW_GROUPING_STANDARD = 1,

        LXW_GROUPING_PERCENTSTACKED = 2,

        LXW_GROUPING_STACKED = 3,
    }
    enum LXW_GROUPING_CLUSTERED = lxw_chart_grouping.LXW_GROUPING_CLUSTERED;
    enum LXW_GROUPING_STANDARD = lxw_chart_grouping.LXW_GROUPING_STANDARD;
    enum LXW_GROUPING_PERCENTSTACKED = lxw_chart_grouping.LXW_GROUPING_PERCENTSTACKED;
    enum LXW_GROUPING_STACKED = lxw_chart_grouping.LXW_GROUPING_STACKED;

    enum lxw_chart_subtype
    {

        LXW_CHART_SUBTYPE_NONE = 0,

        LXW_CHART_SUBTYPE_STACKED = 1,

        LXW_CHART_SUBTYPE_STACKED_PERCENT = 2,
    }
    enum LXW_CHART_SUBTYPE_NONE = lxw_chart_subtype.LXW_CHART_SUBTYPE_NONE;
    enum LXW_CHART_SUBTYPE_STACKED = lxw_chart_subtype.LXW_CHART_SUBTYPE_STACKED;
    enum LXW_CHART_SUBTYPE_STACKED_PERCENT = lxw_chart_subtype.LXW_CHART_SUBTYPE_STACKED_PERCENT;
    /**
 * @brief Chart axis types.
 */
    enum lxw_chart_axis_type
    {
        /** Chart X axis. */
        LXW_CHART_AXIS_TYPE_X = 0,
        /** Chart Y axis. */
        LXW_CHART_AXIS_TYPE_Y = 1,
    }
    enum LXW_CHART_AXIS_TYPE_X = lxw_chart_axis_type.LXW_CHART_AXIS_TYPE_X;
    enum LXW_CHART_AXIS_TYPE_Y = lxw_chart_axis_type.LXW_CHART_AXIS_TYPE_Y;
    /**
 * @brief Chart data label separator.
 */
    enum lxw_chart_label_separator
    {
        /** Series data label separator: comma (the default). */
        LXW_CHART_LABEL_SEPARATOR_COMMA = 0,
        /** Series data label separator: semicolon. */
        LXW_CHART_LABEL_SEPARATOR_SEMICOLON = 1,
        /** Series data label separator: period. */
        LXW_CHART_LABEL_SEPARATOR_PERIOD = 2,
        /** Series data label separator: newline. */
        LXW_CHART_LABEL_SEPARATOR_NEWLINE = 3,
        /** Series data label separator: space. */
        LXW_CHART_LABEL_SEPARATOR_SPACE = 4,
    }
    enum LXW_CHART_LABEL_SEPARATOR_COMMA = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_COMMA;
    enum LXW_CHART_LABEL_SEPARATOR_SEMICOLON = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_SEMICOLON;
    enum LXW_CHART_LABEL_SEPARATOR_PERIOD = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_PERIOD;
    enum LXW_CHART_LABEL_SEPARATOR_NEWLINE = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_NEWLINE;
    enum LXW_CHART_LABEL_SEPARATOR_SPACE = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_SPACE;
    /**
 * @brief Chart data label positions.
 */
    enum lxw_chart_label_position
    {
        /** Series data label position: default position. */
        LXW_CHART_LABEL_POSITION_DEFAULT = 0,
        /** Series data label position: center. */
        LXW_CHART_LABEL_POSITION_CENTER = 1,
        /** Series data label position: right. */
        LXW_CHART_LABEL_POSITION_RIGHT = 2,
        /** Series data label position: left. */
        LXW_CHART_LABEL_POSITION_LEFT = 3,
        /** Series data label position: above. */
        LXW_CHART_LABEL_POSITION_ABOVE = 4,
        /** Series data label position: below. */
        LXW_CHART_LABEL_POSITION_BELOW = 5,
        /** Series data label position: inside base.  */
        LXW_CHART_LABEL_POSITION_INSIDE_BASE = 6,
        /** Series data label position: inside end. */
        LXW_CHART_LABEL_POSITION_INSIDE_END = 7,
        /** Series data label position: outside end. */
        LXW_CHART_LABEL_POSITION_OUTSIDE_END = 8,
        /** Series data label position: best fit. */
        LXW_CHART_LABEL_POSITION_BEST_FIT = 9,
    }
    enum LXW_CHART_LABEL_POSITION_DEFAULT = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_DEFAULT;
    enum LXW_CHART_LABEL_POSITION_CENTER = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_CENTER;
    enum LXW_CHART_LABEL_POSITION_RIGHT = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_RIGHT;
    enum LXW_CHART_LABEL_POSITION_LEFT = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_LEFT;
    enum LXW_CHART_LABEL_POSITION_ABOVE = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_ABOVE;
    enum LXW_CHART_LABEL_POSITION_BELOW = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_BELOW;
    enum LXW_CHART_LABEL_POSITION_INSIDE_BASE = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_INSIDE_BASE;
    enum LXW_CHART_LABEL_POSITION_INSIDE_END = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_INSIDE_END;
    enum LXW_CHART_LABEL_POSITION_OUTSIDE_END = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_OUTSIDE_END;
    enum LXW_CHART_LABEL_POSITION_BEST_FIT = lxw_chart_label_position.LXW_CHART_LABEL_POSITION_BEST_FIT;
    /**
 * @brief Chart pattern types.
 */
    enum lxw_chart_pattern_type
    {
        /** None pattern. */
        LXW_CHART_PATTERN_NONE = 0,
        /** 5 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_5 = 1,
        /** 10 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_10 = 2,
        /** 20 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_20 = 3,
        /** 25 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_25 = 4,
        /** 30 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_30 = 5,
        /** 40 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_40 = 6,
        /** 50 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_50 = 7,
        /** 60 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_60 = 8,
        /** 70 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_70 = 9,
        /** 75 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_75 = 10,
        /** 80 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_80 = 11,
        /** 90 Percent pattern. */
        LXW_CHART_PATTERN_PERCENT_90 = 12,
        /** Light downward diagonal pattern. */
        LXW_CHART_PATTERN_LIGHT_DOWNWARD_DIAGONAL = 13,
        /** Light upward diagonal pattern. */
        LXW_CHART_PATTERN_LIGHT_UPWARD_DIAGONAL = 14,
        /** Dark downward diagonal pattern. */
        LXW_CHART_PATTERN_DARK_DOWNWARD_DIAGONAL = 15,
        /** Dark upward diagonal pattern. */
        LXW_CHART_PATTERN_DARK_UPWARD_DIAGONAL = 16,
        /** Wide downward diagonal pattern. */
        LXW_CHART_PATTERN_WIDE_DOWNWARD_DIAGONAL = 17,
        /** Wide upward diagonal pattern. */
        LXW_CHART_PATTERN_WIDE_UPWARD_DIAGONAL = 18,
        /** Light vertical pattern. */
        LXW_CHART_PATTERN_LIGHT_VERTICAL = 19,
        /** Light horizontal pattern. */
        LXW_CHART_PATTERN_LIGHT_HORIZONTAL = 20,
        /** Narrow vertical pattern. */
        LXW_CHART_PATTERN_NARROW_VERTICAL = 21,
        /** Narrow horizontal pattern. */
        LXW_CHART_PATTERN_NARROW_HORIZONTAL = 22,
        /** Dark vertical pattern. */
        LXW_CHART_PATTERN_DARK_VERTICAL = 23,
        /** Dark horizontal pattern. */
        LXW_CHART_PATTERN_DARK_HORIZONTAL = 24,
        /** Dashed downward diagonal pattern. */
        LXW_CHART_PATTERN_DASHED_DOWNWARD_DIAGONAL = 25,
        /** Dashed upward diagonal pattern. */
        LXW_CHART_PATTERN_DASHED_UPWARD_DIAGONAL = 26,
        /** Dashed horizontal pattern. */
        LXW_CHART_PATTERN_DASHED_HORIZONTAL = 27,
        /** Dashed vertical pattern. */
        LXW_CHART_PATTERN_DASHED_VERTICAL = 28,
        /** Small confetti pattern. */
        LXW_CHART_PATTERN_SMALL_CONFETTI = 29,
        /** Large confetti pattern. */
        LXW_CHART_PATTERN_LARGE_CONFETTI = 30,
        /** Zigzag pattern. */
        LXW_CHART_PATTERN_ZIGZAG = 31,
        /** Wave pattern. */
        LXW_CHART_PATTERN_WAVE = 32,
        /** Diagonal brick pattern. */
        LXW_CHART_PATTERN_DIAGONAL_BRICK = 33,
        /** Horizontal brick pattern. */
        LXW_CHART_PATTERN_HORIZONTAL_BRICK = 34,
        /** Weave pattern. */
        LXW_CHART_PATTERN_WEAVE = 35,
        /** Plaid pattern. */
        LXW_CHART_PATTERN_PLAID = 36,
        /** Divot pattern. */
        LXW_CHART_PATTERN_DIVOT = 37,
        /** Dotted grid pattern. */
        LXW_CHART_PATTERN_DOTTED_GRID = 38,
        /** Dotted diamond pattern. */
        LXW_CHART_PATTERN_DOTTED_DIAMOND = 39,
        /** Shingle pattern. */
        LXW_CHART_PATTERN_SHINGLE = 40,
        /** Trellis pattern. */
        LXW_CHART_PATTERN_TRELLIS = 41,
        /** Sphere pattern. */
        LXW_CHART_PATTERN_SPHERE = 42,
        /** Small grid pattern. */
        LXW_CHART_PATTERN_SMALL_GRID = 43,
        /** Large grid pattern. */
        LXW_CHART_PATTERN_LARGE_GRID = 44,
        /** Small check pattern. */
        LXW_CHART_PATTERN_SMALL_CHECK = 45,
        /** Large check pattern. */
        LXW_CHART_PATTERN_LARGE_CHECK = 46,
        /** Outlined diamond pattern. */
        LXW_CHART_PATTERN_OUTLINED_DIAMOND = 47,
        /** Solid diamond pattern. */
        LXW_CHART_PATTERN_SOLID_DIAMOND = 48,
    }
    enum LXW_CHART_PATTERN_NONE = lxw_chart_pattern_type.LXW_CHART_PATTERN_NONE;
    enum LXW_CHART_PATTERN_PERCENT_5 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_5;
    enum LXW_CHART_PATTERN_PERCENT_10 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_10;
    enum LXW_CHART_PATTERN_PERCENT_20 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_20;
    enum LXW_CHART_PATTERN_PERCENT_25 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_25;
    enum LXW_CHART_PATTERN_PERCENT_30 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_30;
    enum LXW_CHART_PATTERN_PERCENT_40 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_40;
    enum LXW_CHART_PATTERN_PERCENT_50 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_50;
    enum LXW_CHART_PATTERN_PERCENT_60 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_60;
    enum LXW_CHART_PATTERN_PERCENT_70 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_70;
    enum LXW_CHART_PATTERN_PERCENT_75 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_75;
    enum LXW_CHART_PATTERN_PERCENT_80 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_80;
    enum LXW_CHART_PATTERN_PERCENT_90 = lxw_chart_pattern_type.LXW_CHART_PATTERN_PERCENT_90;
    enum LXW_CHART_PATTERN_LIGHT_DOWNWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_LIGHT_DOWNWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_LIGHT_UPWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_LIGHT_UPWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_DARK_DOWNWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DARK_DOWNWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_DARK_UPWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DARK_UPWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_WIDE_DOWNWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_WIDE_DOWNWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_WIDE_UPWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_WIDE_UPWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_LIGHT_VERTICAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_LIGHT_VERTICAL;
    enum LXW_CHART_PATTERN_LIGHT_HORIZONTAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_LIGHT_HORIZONTAL;
    enum LXW_CHART_PATTERN_NARROW_VERTICAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_NARROW_VERTICAL;
    enum LXW_CHART_PATTERN_NARROW_HORIZONTAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_NARROW_HORIZONTAL;
    enum LXW_CHART_PATTERN_DARK_VERTICAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DARK_VERTICAL;
    enum LXW_CHART_PATTERN_DARK_HORIZONTAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DARK_HORIZONTAL;
    enum LXW_CHART_PATTERN_DASHED_DOWNWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DASHED_DOWNWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_DASHED_UPWARD_DIAGONAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DASHED_UPWARD_DIAGONAL;
    enum LXW_CHART_PATTERN_DASHED_HORIZONTAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DASHED_HORIZONTAL;
    enum LXW_CHART_PATTERN_DASHED_VERTICAL = lxw_chart_pattern_type.LXW_CHART_PATTERN_DASHED_VERTICAL;
    enum LXW_CHART_PATTERN_SMALL_CONFETTI = lxw_chart_pattern_type.LXW_CHART_PATTERN_SMALL_CONFETTI;
    enum LXW_CHART_PATTERN_LARGE_CONFETTI = lxw_chart_pattern_type.LXW_CHART_PATTERN_LARGE_CONFETTI;
    enum LXW_CHART_PATTERN_ZIGZAG = lxw_chart_pattern_type.LXW_CHART_PATTERN_ZIGZAG;
    enum LXW_CHART_PATTERN_WAVE = lxw_chart_pattern_type.LXW_CHART_PATTERN_WAVE;
    enum LXW_CHART_PATTERN_DIAGONAL_BRICK = lxw_chart_pattern_type.LXW_CHART_PATTERN_DIAGONAL_BRICK;
    enum LXW_CHART_PATTERN_HORIZONTAL_BRICK = lxw_chart_pattern_type.LXW_CHART_PATTERN_HORIZONTAL_BRICK;
    enum LXW_CHART_PATTERN_WEAVE = lxw_chart_pattern_type.LXW_CHART_PATTERN_WEAVE;
    enum LXW_CHART_PATTERN_PLAID = lxw_chart_pattern_type.LXW_CHART_PATTERN_PLAID;
    enum LXW_CHART_PATTERN_DIVOT = lxw_chart_pattern_type.LXW_CHART_PATTERN_DIVOT;
    enum LXW_CHART_PATTERN_DOTTED_GRID = lxw_chart_pattern_type.LXW_CHART_PATTERN_DOTTED_GRID;
    enum LXW_CHART_PATTERN_DOTTED_DIAMOND = lxw_chart_pattern_type.LXW_CHART_PATTERN_DOTTED_DIAMOND;
    enum LXW_CHART_PATTERN_SHINGLE = lxw_chart_pattern_type.LXW_CHART_PATTERN_SHINGLE;
    enum LXW_CHART_PATTERN_TRELLIS = lxw_chart_pattern_type.LXW_CHART_PATTERN_TRELLIS;
    enum LXW_CHART_PATTERN_SPHERE = lxw_chart_pattern_type.LXW_CHART_PATTERN_SPHERE;
    enum LXW_CHART_PATTERN_SMALL_GRID = lxw_chart_pattern_type.LXW_CHART_PATTERN_SMALL_GRID;
    enum LXW_CHART_PATTERN_LARGE_GRID = lxw_chart_pattern_type.LXW_CHART_PATTERN_LARGE_GRID;
    enum LXW_CHART_PATTERN_SMALL_CHECK = lxw_chart_pattern_type.LXW_CHART_PATTERN_SMALL_CHECK;
    enum LXW_CHART_PATTERN_LARGE_CHECK = lxw_chart_pattern_type.LXW_CHART_PATTERN_LARGE_CHECK;
    enum LXW_CHART_PATTERN_OUTLINED_DIAMOND = lxw_chart_pattern_type.LXW_CHART_PATTERN_OUTLINED_DIAMOND;
    enum LXW_CHART_PATTERN_SOLID_DIAMOND = lxw_chart_pattern_type.LXW_CHART_PATTERN_SOLID_DIAMOND;
    /**
 * @brief Chart marker types.
 */
    enum lxw_chart_marker_type
    {
        /** Automatic, series default, marker type. */
        LXW_CHART_MARKER_AUTOMATIC = 0,
        /** No marker type. */
        LXW_CHART_MARKER_NONE = 1,
        /** Square marker type. */
        LXW_CHART_MARKER_SQUARE = 2,
        /** Diamond marker type. */
        LXW_CHART_MARKER_DIAMOND = 3,
        /** Triangle marker type. */
        LXW_CHART_MARKER_TRIANGLE = 4,
        /** X shape marker type. */
        LXW_CHART_MARKER_X = 5,
        /** Star marker type. */
        LXW_CHART_MARKER_STAR = 6,
        /** Short dash marker type. */
        LXW_CHART_MARKER_SHORT_DASH = 7,
        /** Long dash marker type. */
        LXW_CHART_MARKER_LONG_DASH = 8,
        /** Circle marker type. */
        LXW_CHART_MARKER_CIRCLE = 9,
        /** Plus (+) marker type. */
        LXW_CHART_MARKER_PLUS = 10,
    }
    enum LXW_CHART_MARKER_AUTOMATIC = lxw_chart_marker_type.LXW_CHART_MARKER_AUTOMATIC;
    enum LXW_CHART_MARKER_NONE = lxw_chart_marker_type.LXW_CHART_MARKER_NONE;
    enum LXW_CHART_MARKER_SQUARE = lxw_chart_marker_type.LXW_CHART_MARKER_SQUARE;
    enum LXW_CHART_MARKER_DIAMOND = lxw_chart_marker_type.LXW_CHART_MARKER_DIAMOND;
    enum LXW_CHART_MARKER_TRIANGLE = lxw_chart_marker_type.LXW_CHART_MARKER_TRIANGLE;
    enum LXW_CHART_MARKER_X = lxw_chart_marker_type.LXW_CHART_MARKER_X;
    enum LXW_CHART_MARKER_STAR = lxw_chart_marker_type.LXW_CHART_MARKER_STAR;
    enum LXW_CHART_MARKER_SHORT_DASH = lxw_chart_marker_type.LXW_CHART_MARKER_SHORT_DASH;
    enum LXW_CHART_MARKER_LONG_DASH = lxw_chart_marker_type.LXW_CHART_MARKER_LONG_DASH;
    enum LXW_CHART_MARKER_CIRCLE = lxw_chart_marker_type.LXW_CHART_MARKER_CIRCLE;
    enum LXW_CHART_MARKER_PLUS = lxw_chart_marker_type.LXW_CHART_MARKER_PLUS;
    /**
 * @brief Chart line dash types.
 *
 * The dash types are shown in the order that they appear in the Excel dialog.
 * See @ref chart_lines.
 */
    enum lxw_chart_line_dash_type
    {
        /** Solid. */
        LXW_CHART_LINE_DASH_SOLID = 0,
        /** Round Dot. */
        LXW_CHART_LINE_DASH_ROUND_DOT = 1,
        /** Square Dot. */
        LXW_CHART_LINE_DASH_SQUARE_DOT = 2,
        /** Dash. */
        LXW_CHART_LINE_DASH_DASH = 3,
        /** Dash Dot. */
        LXW_CHART_LINE_DASH_DASH_DOT = 4,
        /** Long Dash. */
        LXW_CHART_LINE_DASH_LONG_DASH = 5,
        /** Long Dash Dot. */
        LXW_CHART_LINE_DASH_LONG_DASH_DOT = 6,
        /** Long Dash Dot Dot. */
        LXW_CHART_LINE_DASH_LONG_DASH_DOT_DOT = 7,
        /** Long Dash Dot Dot. */
        LXW_CHART_LINE_DASH_DOT = 8,
        /** Long Dash Dot Dot. */
        LXW_CHART_LINE_DASH_SYSTEM_DASH_DOT = 9,
        /** Long Dash Dot Dot. */
        LXW_CHART_LINE_DASH_SYSTEM_DASH_DOT_DOT = 10,
    }
    enum LXW_CHART_LINE_DASH_SOLID = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_SOLID;
    enum LXW_CHART_LINE_DASH_ROUND_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_ROUND_DOT;
    enum LXW_CHART_LINE_DASH_SQUARE_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_SQUARE_DOT;
    enum LXW_CHART_LINE_DASH_DASH = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_DASH;
    enum LXW_CHART_LINE_DASH_DASH_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_DASH_DOT;
    enum LXW_CHART_LINE_DASH_LONG_DASH = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_LONG_DASH;
    enum LXW_CHART_LINE_DASH_LONG_DASH_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_LONG_DASH_DOT;
    enum LXW_CHART_LINE_DASH_LONG_DASH_DOT_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_LONG_DASH_DOT_DOT;
    enum LXW_CHART_LINE_DASH_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_DOT;
    enum LXW_CHART_LINE_DASH_SYSTEM_DASH_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_SYSTEM_DASH_DOT;
    enum LXW_CHART_LINE_DASH_SYSTEM_DASH_DOT_DOT = lxw_chart_line_dash_type.LXW_CHART_LINE_DASH_SYSTEM_DASH_DOT_DOT;
    /**
 * @brief Chart legend positions.
 */
    enum lxw_chart_legend_position
    {
        /** No chart legend. */
        LXW_CHART_LEGEND_NONE = 0,
        /** Chart legend positioned at right side. */
        LXW_CHART_LEGEND_RIGHT = 1,
        /** Chart legend positioned at left side. */
        LXW_CHART_LEGEND_LEFT = 2,
        /** Chart legend positioned at top. */
        LXW_CHART_LEGEND_TOP = 3,
        /** Chart legend positioned at bottom. */
        LXW_CHART_LEGEND_BOTTOM = 4,
        /** Chart legend positioned at top right. */
        LXW_CHART_LEGEND_TOP_RIGHT = 5,
        /** Chart legend overlaid at right side. */
        LXW_CHART_LEGEND_OVERLAY_RIGHT = 6,
        /** Chart legend overlaid at left side. */
        LXW_CHART_LEGEND_OVERLAY_LEFT = 7,
        /** Chart legend overlaid at top right. */
        LXW_CHART_LEGEND_OVERLAY_TOP_RIGHT = 8,
    }
    enum LXW_CHART_LEGEND_NONE = lxw_chart_legend_position.LXW_CHART_LEGEND_NONE;
    enum LXW_CHART_LEGEND_RIGHT = lxw_chart_legend_position.LXW_CHART_LEGEND_RIGHT;
    enum LXW_CHART_LEGEND_LEFT = lxw_chart_legend_position.LXW_CHART_LEGEND_LEFT;
    enum LXW_CHART_LEGEND_TOP = lxw_chart_legend_position.LXW_CHART_LEGEND_TOP;
    enum LXW_CHART_LEGEND_BOTTOM = lxw_chart_legend_position.LXW_CHART_LEGEND_BOTTOM;
    enum LXW_CHART_LEGEND_TOP_RIGHT = lxw_chart_legend_position.LXW_CHART_LEGEND_TOP_RIGHT;
    enum LXW_CHART_LEGEND_OVERLAY_RIGHT = lxw_chart_legend_position.LXW_CHART_LEGEND_OVERLAY_RIGHT;
    enum LXW_CHART_LEGEND_OVERLAY_LEFT = lxw_chart_legend_position.LXW_CHART_LEGEND_OVERLAY_LEFT;
    enum LXW_CHART_LEGEND_OVERLAY_TOP_RIGHT = lxw_chart_legend_position.LXW_CHART_LEGEND_OVERLAY_TOP_RIGHT;
    /**
 * @brief Available chart types.
 */
    enum lxw_chart_type
    {
        /** None. */
        LXW_CHART_NONE = 0,
        /** Area chart. */
        LXW_CHART_AREA = 1,
        /** Area chart - stacked. */
        LXW_CHART_AREA_STACKED = 2,
        /** Area chart - percentage stacked. */
        LXW_CHART_AREA_STACKED_PERCENT = 3,
        /** Bar chart. */
        LXW_CHART_BAR = 4,
        /** Bar chart - stacked. */
        LXW_CHART_BAR_STACKED = 5,
        /** Bar chart - percentage stacked. */
        LXW_CHART_BAR_STACKED_PERCENT = 6,
        /** Column chart. */
        LXW_CHART_COLUMN = 7,
        /** Column chart - stacked. */
        LXW_CHART_COLUMN_STACKED = 8,
        /** Column chart - percentage stacked. */
        LXW_CHART_COLUMN_STACKED_PERCENT = 9,
        /** Doughnut chart. */
        LXW_CHART_DOUGHNUT = 10,
        /** Line chart. */
        LXW_CHART_LINE = 11,
        /** Line chart - stacked. */
        LXW_CHART_LINE_STACKED = 12,
        /** Line chart - percentage stacked. */
        LXW_CHART_LINE_STACKED_PERCENT = 13,
        /** Pie chart. */
        LXW_CHART_PIE = 14,
        /** Scatter chart. */
        LXW_CHART_SCATTER = 15,
        /** Scatter chart - straight. */
        LXW_CHART_SCATTER_STRAIGHT = 16,
        /** Scatter chart - straight with markers. */
        LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS = 17,
        /** Scatter chart - smooth. */
        LXW_CHART_SCATTER_SMOOTH = 18,
        /** Scatter chart - smooth with markers. */
        LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS = 19,
        /** Radar chart. */
        LXW_CHART_RADAR = 20,
        /** Radar chart - with markers. */
        LXW_CHART_RADAR_WITH_MARKERS = 21,
        /** Radar chart - filled. */
        LXW_CHART_RADAR_FILLED = 22,
    }
    enum LXW_CHART_NONE = lxw_chart_type.LXW_CHART_NONE;
    enum LXW_CHART_AREA = lxw_chart_type.LXW_CHART_AREA;
    enum LXW_CHART_AREA_STACKED = lxw_chart_type.LXW_CHART_AREA_STACKED;
    enum LXW_CHART_AREA_STACKED_PERCENT = lxw_chart_type.LXW_CHART_AREA_STACKED_PERCENT;
    enum LXW_CHART_BAR = lxw_chart_type.LXW_CHART_BAR;
    enum LXW_CHART_BAR_STACKED = lxw_chart_type.LXW_CHART_BAR_STACKED;
    enum LXW_CHART_BAR_STACKED_PERCENT = lxw_chart_type.LXW_CHART_BAR_STACKED_PERCENT;
    enum LXW_CHART_COLUMN = lxw_chart_type.LXW_CHART_COLUMN;
    enum LXW_CHART_COLUMN_STACKED = lxw_chart_type.LXW_CHART_COLUMN_STACKED;
    enum LXW_CHART_COLUMN_STACKED_PERCENT = lxw_chart_type.LXW_CHART_COLUMN_STACKED_PERCENT;
    enum LXW_CHART_DOUGHNUT = lxw_chart_type.LXW_CHART_DOUGHNUT;
    enum LXW_CHART_LINE = lxw_chart_type.LXW_CHART_LINE;
    enum LXW_CHART_LINE_STACKED = lxw_chart_type.LXW_CHART_LINE_STACKED;
    enum LXW_CHART_LINE_STACKED_PERCENT = lxw_chart_type.LXW_CHART_LINE_STACKED_PERCENT;
    enum LXW_CHART_PIE = lxw_chart_type.LXW_CHART_PIE;
    enum LXW_CHART_SCATTER = lxw_chart_type.LXW_CHART_SCATTER;
    enum LXW_CHART_SCATTER_STRAIGHT = lxw_chart_type.LXW_CHART_SCATTER_STRAIGHT;
    enum LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS = lxw_chart_type.LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS;
    enum LXW_CHART_SCATTER_SMOOTH = lxw_chart_type.LXW_CHART_SCATTER_SMOOTH;
    enum LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS = lxw_chart_type.LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS;
    enum LXW_CHART_RADAR = lxw_chart_type.LXW_CHART_RADAR;
    enum LXW_CHART_RADAR_WITH_MARKERS = lxw_chart_type.LXW_CHART_RADAR_WITH_MARKERS;
    enum LXW_CHART_RADAR_FILLED = lxw_chart_type.LXW_CHART_RADAR_FILLED;

    struct lxw_series_data_points
    {

        lxw_series_data_point* stqh_first;

        lxw_series_data_point** stqh_last;
    }

    struct lxw_series_data_point
    {

        ubyte is_string;

        double number;

        char* string_;

        ubyte no_data;

        static struct _Anonymous_38
        {

            lxw_series_data_point* stqe_next;
        }

        _Anonymous_38 list_pointers;
    }
    /**
 * @brief Struct to represent an Excel chart data series.
 *
 * The lxw_chart_series is created using the chart_add_series function. It is
 * used in functions that modify a chart series but the members of the struct
 * aren't modified directly.
 */
    struct lxw_chart_series
    {

        lxw_series_range* categories;

        lxw_series_range* values;

        lxw_chart_title title;

        lxw_chart_line* line;

        lxw_chart_fill* fill;

        lxw_chart_pattern* pattern;

        lxw_chart_marker* marker;

        lxw_chart_point* points;

        lxw_chart_custom_label* data_labels;

        ushort point_count;

        ushort data_label_count;

        ubyte smooth;

        ubyte invert_if_negative;

        ubyte has_labels;

        ubyte show_labels_value;

        ubyte show_labels_category;

        ubyte show_labels_name;

        ubyte show_labels_leader;

        ubyte show_labels_legend;

        ubyte show_labels_percent;

        ubyte label_position;

        ubyte label_separator;

        ubyte default_label_position;

        char* label_num_format;

        lxw_chart_font* label_font;

        lxw_chart_line* label_line;

        lxw_chart_fill* label_fill;

        lxw_chart_pattern* label_pattern;

        lxw_series_error_bars* x_error_bars;

        lxw_series_error_bars* y_error_bars;

        ubyte has_trendline;

        ubyte has_trendline_forecast;

        ubyte has_trendline_equation;

        ubyte has_trendline_r_squared;

        ubyte has_trendline_intercept;

        ubyte trendline_type;

        ubyte trendline_value;

        double trendline_forward;

        double trendline_backward;

        ubyte trendline_value_type;

        char* trendline_name;

        lxw_chart_line* trendline_line;

        double trendline_intercept;

        static struct _Anonymous_39
        {

            lxw_chart_series* stqe_next;
        }

        _Anonymous_39 list_pointers;
    }

    struct lxw_chart_series_list
    {

        lxw_chart_series* stqh_first;

        lxw_chart_series** stqh_last;
    }

    void lxw_app_add_heading_pair(lxw_app*, const(char)*, const(char)*) @nogc nothrow;

    void lxw_app_add_part_name(lxw_app*, const(char)*) @nogc nothrow;

    void lxw_app_assemble_xml_file(lxw_app*) @nogc nothrow;

    void lxw_app_free(lxw_app*) @nogc nothrow;

    lxw_app* lxw_app_new() @nogc nothrow;

    struct lxw_app
    {

        _IO_FILE* file;

        lxw_heading_pairs* heading_pairs;

        lxw_part_names* part_names;

        lxw_doc_properties* properties;

        uint num_heading_pairs;

        uint num_part_names;

        ubyte doc_security;
    }

    struct lxw_part_names
    {

        lxw_part_name* stqh_first;

        lxw_part_name** stqh_last;
    }

    struct lxw_part_name
    {

        char* name;

        static struct _Anonymous_40
        {

            lxw_part_name* stqe_next;
        }

        _Anonymous_40 list_pointers;
    }

    struct lxw_heading_pairs
    {

        lxw_heading_pair* stqh_first;

        lxw_heading_pair** stqh_last;
    }

    struct lxw_heading_pair
    {

        char* key;

        char* value;

        static struct _Anonymous_41
        {

            lxw_heading_pair* stqe_next;
        }

        _Anonymous_41 list_pointers;
    }

    alias wchar_t = int;

    alias size_t = c_ulong;

    alias pthread_t = c_ulong;

    union pthread_mutexattr_t
    {

        char[4] __size;

        int __align;
    }

    union pthread_condattr_t
    {

        char[4] __size;

        int __align;
    }

    alias pthread_key_t = uint;

    alias pthread_once_t = int;

    union pthread_attr_t
    {

        char[56] __size;

        c_long __align;
    }

    union pthread_mutex_t
    {

        __pthread_mutex_s __data;

        char[40] __size;

        c_long __align;
    }

    union pthread_cond_t
    {

        __pthread_cond_s __data;

        char[48] __size;

        long __align;
    }

    union pthread_rwlock_t
    {

        __pthread_rwlock_arch_t __data;

        char[56] __size;

        c_long __align;
    }

    union pthread_rwlockattr_t
    {

        char[8] __size;

        c_long __align;
    }

    alias pthread_spinlock_t = int;

    union pthread_barrier_t
    {

        char[32] __size;

        c_long __align;
    }

    union pthread_barrierattr_t
    {

        char[4] __size;

        int __align;
    }

    alias int8_t = byte;

    alias int16_t = short;

    alias int32_t = int;

    alias int64_t = c_long;

    alias uint8_t = ubyte;

    alias uint16_t = ushort;

    alias uint32_t = uint;

    alias uint64_t = ulong;

    alias ptrdiff_t = c_long;

    struct __pthread_mutex_s
    {

        int __lock;

        uint __count;

        int __owner;

        uint __nusers;

        int __kind;

        short __spins;

        short __elision;

        __pthread_internal_list __list;
    }

    struct __pthread_rwlock_arch_t
    {

        uint __readers;

        uint __writers;

        uint __wrphase_futex;

        uint __writers_futex;

        uint __pad3;

        uint __pad4;

        int __cur_writer;

        int __shared;

        byte __rwelision;

        ubyte[7] __pad1;

        c_ulong __pad2;

        uint __flags;
    }

    alias __pthread_list_t = __pthread_internal_list;

    struct __pthread_internal_list
    {

        __pthread_internal_list* __prev;

        __pthread_internal_list* __next;
    }

    alias __pthread_slist_t = __pthread_internal_slist;

    struct __pthread_internal_slist
    {

        __pthread_internal_slist* __next;
    }

    struct __pthread_cond_s
    {

        __atomic_wide_counter __wseq;

        __atomic_wide_counter __g1_start;

        uint[2] __g_refs;

        uint[2] __g_size;

        uint __g1_orig_size;

        uint __wrefs;

        uint[2] __g_signals;
    }

    alias __tss_t = uint;

    alias __thrd_t = c_ulong;

    struct __once_flag
    {

        int __data;
    }

    alias __u_char = ubyte;

    alias __u_short = ushort;

    alias __u_int = uint;

    alias __u_long = c_ulong;

    alias __int8_t = byte;

    alias __uint8_t = ubyte;

    alias __int16_t = short;

    alias __uint16_t = ushort;

    alias __int32_t = int;

    alias __uint32_t = uint;

    alias __int64_t = c_long;

    alias __uint64_t = c_ulong;

    alias __int_least8_t = byte;

    alias __uint_least8_t = ubyte;

    alias __int_least16_t = short;

    alias __uint_least16_t = ushort;

    alias __int_least32_t = int;

    alias __uint_least32_t = uint;

    alias __int_least64_t = c_long;

    alias __uint_least64_t = c_ulong;

    alias __quad_t = c_long;

    alias __u_quad_t = c_ulong;

    alias __intmax_t = c_long;

    alias __uintmax_t = c_ulong;

    struct max_align_t
    {

        long __clang_max_align_nonce1;

        real __clang_max_align_nonce2;
    }

    alias __dev_t = c_ulong;

    alias __uid_t = uint;

    alias __gid_t = uint;

    alias __ino_t = c_ulong;

    alias __ino64_t = c_ulong;

    alias __mode_t = uint;

    alias __nlink_t = c_ulong;

    alias __off_t = c_long;

    alias __off64_t = c_long;

    alias __pid_t = int;

    struct __fsid_t
    {

        int[2] __val;
    }

    alias __clock_t = c_long;

    alias __rlim_t = c_ulong;

    alias __rlim64_t = c_ulong;

    alias __id_t = uint;

    alias __time_t = c_long;

    alias __useconds_t = uint;

    alias __suseconds_t = c_long;

    alias __suseconds64_t = c_long;

    alias __daddr_t = int;

    alias __key_t = int;

    alias __clockid_t = int;

    alias __timer_t = void*;

    alias __blksize_t = c_long;

    alias __blkcnt_t = c_long;

    alias __blkcnt64_t = c_long;

    alias __fsblkcnt_t = c_ulong;

    alias __fsblkcnt64_t = c_ulong;

    alias __fsfilcnt_t = c_ulong;

    alias __fsfilcnt64_t = c_ulong;

    alias __fsword_t = c_long;

    alias __ssize_t = c_long;

    alias __syscall_slong_t = c_long;

    alias __syscall_ulong_t = c_ulong;

    alias __loff_t = c_long;

    alias __caddr_t = char*;

    alias __intptr_t = c_long;

    alias __socklen_t = uint;

    alias __sig_atomic_t = int;

    alias FILE = _IO_FILE;

    struct _IO_FILE
    {

        int _flags;

        char* _IO_read_ptr;

        char* _IO_read_end;

        char* _IO_read_base;

        char* _IO_write_base;

        char* _IO_write_ptr;

        char* _IO_write_end;

        char* _IO_buf_base;

        char* _IO_buf_end;

        char* _IO_save_base;

        char* _IO_backup_base;

        char* _IO_save_end;

        _IO_marker* _markers;

        _IO_FILE* _chain;

        int _fileno;

        int _flags2;

        c_long _old_offset;

        ushort _cur_column;

        byte _vtable_offset;

        char[1] _shortbuf;

        void* _lock;

        c_long _offset;

        _IO_codecvt* _codecvt;

        _IO_wide_data* _wide_data;

        _IO_FILE* _freeres_list;

        void* _freeres_buf;

        c_ulong __pad5;

        int _mode;

        char[20] _unused2;
    }

    alias __FILE = _IO_FILE;

    int gzvprintf(gzFile_s*, const(char)*, va_list*) @nogc nothrow;

    alias __fpos64_t = _G_fpos64_t;

    struct _G_fpos64_t
    {

        c_long __pos;

        __mbstate_t __state;
    }

    alias __fpos_t = _G_fpos_t;

    struct _G_fpos_t
    {

        c_long __pos;

        __mbstate_t __state;
    }

    struct __locale_struct
    {

        __locale_data*[13] __locales;

        const(ushort)* __ctype_b;

        const(int)* __ctype_tolower;

        const(int)* __ctype_toupper;

        const(char)*[13] __names;
    }

    alias __locale_t = __locale_struct*;

    struct __mbstate_t
    {

        int __count;

        static union _Anonymous_42
        {

            uint __wch;

            char[4] __wchb;
        }

        _Anonymous_42 __value;
    }

    struct __sigset_t
    {

        c_ulong[16] __val;
    }

    int deflateResetKeep(z_stream_s*) @nogc nothrow;

    alias clock_t = c_long;

    alias clockid_t = int;

    alias locale_t = __locale_struct*;

    alias sigset_t = __sigset_t;

    int inflateResetKeep(z_stream_s*) @nogc nothrow;
    struct _IO_marker;
    struct _IO_codecvt;
    struct _IO_wide_data;

    alias _IO_lock_t = void;

    c_ulong inflateCodesUsed(z_stream_s*) @nogc nothrow;

    int inflateValidate(z_stream_s*, int) @nogc nothrow;

    struct itimerspec
    {

        timespec it_interval;

        timespec it_value;
    }

    struct timespec
    {

        c_long tv_sec;

        c_long tv_nsec;
    }

    struct timeval
    {

        c_long tv_sec;

        c_long tv_usec;
    }

    struct tm
    {

        int tm_sec;

        int tm_min;

        int tm_hour;

        int tm_mday;

        int tm_mon;

        int tm_year;

        int tm_wday;

        int tm_yday;

        int tm_isdst;

        c_long tm_gmtoff;

        const(char)* tm_zone;
    }

    int inflateUndermine(z_stream_s*, int) @nogc nothrow;

    alias time_t = c_long;

    alias timer_t = void*;

    const(uint)* get_crc_table() @nogc nothrow;

    int inflateSyncPoint(z_stream_s*) @nogc nothrow;

    const(char)* zError(int) @nogc nothrow;

    c_ulong crc32_combine_gen(c_long) @nogc nothrow;

    c_ulong crc32_combine(c_ulong, c_ulong, c_long) @nogc nothrow;

    c_ulong adler32_combine(c_ulong, c_ulong, c_long) @nogc nothrow;

    c_long gzoffset(gzFile_s*) @nogc nothrow;

    c_long gztell(gzFile_s*) @nogc nothrow;

    c_long gzseek(gzFile_s*, c_long, int) @nogc nothrow;

    gzFile_s* gzopen(const(char)*, const(char)*) @nogc nothrow;

    int gzgetc_(gzFile_s*) @nogc nothrow;

    int inflateBackInit_(z_stream_s*, int, ubyte*, const(char)*, int) @nogc nothrow;

    int inflateInit2_(z_stream_s*, int, const(char)*, int) @nogc nothrow;

    int deflateInit2_(z_stream_s*, int, int, int, int, int, const(char)*, int) @nogc nothrow;

    int inflateInit_(z_stream_s*, const(char)*, int) @nogc nothrow;

    int deflateInit_(z_stream_s*, int, const(char)*, int) @nogc nothrow;

    c_ulong crc32_combine_op(c_ulong, c_ulong, c_ulong) @nogc nothrow;

    c_ulong crc32_z(c_ulong, const(ubyte)*, c_ulong) @nogc nothrow;

    c_ulong crc32(c_ulong, const(ubyte)*, uint) @nogc nothrow;

    c_ulong adler32_z(c_ulong, const(ubyte)*, c_ulong) @nogc nothrow;

    c_ulong adler32(c_ulong, const(ubyte)*, uint) @nogc nothrow;

    enum _Anonymous_43
    {

        _ISupper = 256,

        _ISlower = 512,

        _ISalpha = 1024,

        _ISdigit = 2048,

        _ISxdigit = 4096,

        _ISspace = 8192,

        _ISprint = 16384,

        _ISgraph = 32768,

        _ISblank = 1,

        _IScntrl = 2,

        _ISpunct = 4,

        _ISalnum = 8,
    }
    enum _ISupper = _Anonymous_43._ISupper;
    enum _ISlower = _Anonymous_43._ISlower;
    enum _ISalpha = _Anonymous_43._ISalpha;
    enum _ISdigit = _Anonymous_43._ISdigit;
    enum _ISxdigit = _Anonymous_43._ISxdigit;
    enum _ISspace = _Anonymous_43._ISspace;
    enum _ISprint = _Anonymous_43._ISprint;
    enum _ISgraph = _Anonymous_43._ISgraph;
    enum _ISblank = _Anonymous_43._ISblank;
    enum _IScntrl = _Anonymous_43._IScntrl;
    enum _ISpunct = _Anonymous_43._ISpunct;
    enum _ISalnum = _Anonymous_43._ISalnum;

    const(ushort)** __ctype_b_loc() @nogc nothrow;

    const(int)** __ctype_tolower_loc() @nogc nothrow;

    const(int)** __ctype_toupper_loc() @nogc nothrow;

    void gzclearerr(gzFile_s*) @nogc nothrow;

    int isalnum(int) @nogc nothrow;

    int isalpha(int) @nogc nothrow;

    int iscntrl(int) @nogc nothrow;

    int isdigit(int) @nogc nothrow;

    int islower(int) @nogc nothrow;

    int isgraph(int) @nogc nothrow;

    int isprint(int) @nogc nothrow;

    int ispunct(int) @nogc nothrow;

    int isspace(int) @nogc nothrow;

    int isupper(int) @nogc nothrow;

    int isxdigit(int) @nogc nothrow;

    int tolower(int) @nogc nothrow;

    int toupper(int) @nogc nothrow;

    int isblank(int) @nogc nothrow;

    int isascii(int) @nogc nothrow;

    int toascii(int) @nogc nothrow;

    int _toupper(int) @nogc nothrow;

    int _tolower(int) @nogc nothrow;

    const(char)* gzerror(gzFile_s*, int*) @nogc nothrow;

    int gzclose_w(gzFile_s*) @nogc nothrow;

    int gzclose_r(gzFile_s*) @nogc nothrow;

    int gzclose(gzFile_s*) @nogc nothrow;

    int gzdirect(gzFile_s*) @nogc nothrow;

    int isalnum_l(int, __locale_struct*) @nogc nothrow;

    int isalpha_l(int, __locale_struct*) @nogc nothrow;

    int iscntrl_l(int, __locale_struct*) @nogc nothrow;

    int isdigit_l(int, __locale_struct*) @nogc nothrow;

    int islower_l(int, __locale_struct*) @nogc nothrow;

    int isgraph_l(int, __locale_struct*) @nogc nothrow;

    int isprint_l(int, __locale_struct*) @nogc nothrow;

    int ispunct_l(int, __locale_struct*) @nogc nothrow;

    int isspace_l(int, __locale_struct*) @nogc nothrow;

    int isupper_l(int, __locale_struct*) @nogc nothrow;

    int isxdigit_l(int, __locale_struct*) @nogc nothrow;

    int isblank_l(int, __locale_struct*) @nogc nothrow;

    int __tolower_l(int, __locale_struct*) @nogc nothrow;

    int tolower_l(int, __locale_struct*) @nogc nothrow;

    int __toupper_l(int, __locale_struct*) @nogc nothrow;

    int toupper_l(int, __locale_struct*) @nogc nothrow;

    int gzeof(gzFile_s*) @nogc nothrow;

    int gzrewind(gzFile_s*) @nogc nothrow;

    int gzflush(gzFile_s*, int) @nogc nothrow;

    int gzungetc(int, gzFile_s*) @nogc nothrow;

    int gzgetc(gzFile_s*) @nogc nothrow;

    int gzputc(gzFile_s*, int) @nogc nothrow;

    char* gzgets(gzFile_s*, char*, int) @nogc nothrow;

    int gzputs(gzFile_s*, const(char)*) @nogc nothrow;

    int gzprintf(gzFile_s*, const(char)*, ...) @nogc nothrow;

    c_ulong gzfwrite(const(void)*, c_ulong, c_ulong, gzFile_s*) @nogc nothrow;

    int gzwrite(gzFile_s*, const(void)*, uint) @nogc nothrow;

    c_ulong gzfread(void*, c_ulong, c_ulong, gzFile_s*) @nogc nothrow;

    int* __errno_location() @nogc nothrow;

    int gzread(gzFile_s*, void*, uint) @nogc nothrow;

    int gzsetparams(gzFile_s*, int, int) @nogc nothrow;

    int gzbuffer(gzFile_s*, uint) @nogc nothrow;

    gzFile_s* gzdopen(int, const(char)*) @nogc nothrow;

    struct gzFile_s
    {

        uint have;

        ubyte* next;

        c_long pos;
    }

    alias gzFile = gzFile_s*;

    int uncompress2(ubyte*, c_ulong*, const(ubyte)*, c_ulong*) @nogc nothrow;

    int uncompress(ubyte*, c_ulong*, const(ubyte)*, c_ulong) @nogc nothrow;

    c_ulong compressBound(c_ulong) @nogc nothrow;

    int compress2(ubyte*, c_ulong*, const(ubyte)*, c_ulong, int) @nogc nothrow;

    int compress(ubyte*, c_ulong*, const(ubyte)*, c_ulong) @nogc nothrow;

    c_ulong zlibCompileFlags() @nogc nothrow;

    int inflateBackEnd(z_stream_s*) @nogc nothrow;

    int inflateBack(z_stream_s*, uint function(void*, ubyte**), void*, int function(void*, ubyte*, uint), void*) @nogc nothrow;
    alias out_func = int function(void*, ubyte*, uint);
    alias in_func = uint function(void*, ubyte**);

    int inflateGetHeader(z_stream_s*, gz_header_s*) @nogc nothrow;

    alias int_least8_t = byte;

    alias int_least16_t = short;

    alias int_least32_t = int;

    alias int_least64_t = c_long;

    alias uint_least8_t = ubyte;

    alias uint_least16_t = ushort;

    alias uint_least32_t = uint;

    alias uint_least64_t = c_ulong;

    alias int_fast8_t = byte;

    alias int_fast16_t = c_long;

    alias int_fast32_t = c_long;

    alias int_fast64_t = c_long;

    alias uint_fast8_t = ubyte;

    alias uint_fast16_t = c_ulong;

    alias uint_fast32_t = c_ulong;

    alias uint_fast64_t = c_ulong;

    alias intptr_t = c_long;

    c_long inflateMark(z_stream_s*) @nogc nothrow;

    alias uintptr_t = c_ulong;

    alias intmax_t = c_long;

    alias uintmax_t = c_ulong;

    int inflatePrime(z_stream_s*, int, int) @nogc nothrow;

    int inflateReset2(z_stream_s*, int) @nogc nothrow;

    int inflateReset(z_stream_s*) @nogc nothrow;

    int inflateCopy(z_stream_s*, z_stream_s*) @nogc nothrow;

    int inflateSync(z_stream_s*) @nogc nothrow;

    int inflateGetDictionary(z_stream_s*, ubyte*, uint*) @nogc nothrow;

    int inflateSetDictionary(z_stream_s*, const(ubyte)*, uint) @nogc nothrow;

    int deflateSetHeader(z_stream_s*, gz_header_s*) @nogc nothrow;

    int deflatePrime(z_stream_s*, int, int) @nogc nothrow;

    int deflatePending(z_stream_s*, uint*, int*) @nogc nothrow;

    c_ulong deflateBound(z_stream_s*, c_ulong) @nogc nothrow;

    int deflateTune(z_stream_s*, int, int, int, int) @nogc nothrow;

    int deflateParams(z_stream_s*, int, int) @nogc nothrow;

    int deflateReset(z_stream_s*) @nogc nothrow;

    int deflateCopy(z_stream_s*, z_stream_s*) @nogc nothrow;

    int deflateGetDictionary(z_stream_s*, ubyte*, uint*) @nogc nothrow;

    int deflateSetDictionary(z_stream_s*, const(ubyte)*, uint) @nogc nothrow;

    alias off_t = c_long;

    alias ssize_t = c_long;

    alias fpos_t = _G_fpos_t;

    int inflateEnd(z_stream_s*) @nogc nothrow;

    int inflate(z_stream_s*, int) @nogc nothrow;

    extern export __gshared _IO_FILE* stdin;

    extern export __gshared _IO_FILE* stdout;

    extern export __gshared _IO_FILE* stderr;

    int deflateEnd(z_stream_s*) @nogc nothrow;

    int remove(const(char)*) @nogc nothrow;

    int rename(const(char)*, const(char)*) @nogc nothrow;

    int renameat(int, const(char)*, int, const(char)*) @nogc nothrow;

    int fclose(_IO_FILE*) @nogc nothrow;

    _IO_FILE* tmpfile() @nogc nothrow;

    char* tmpnam(char*) @nogc nothrow;

    char* tmpnam_r(char*) @nogc nothrow;

    char* tempnam(const(char)*, const(char)*) @nogc nothrow;

    int fflush(_IO_FILE*) @nogc nothrow;

    int fflush_unlocked(_IO_FILE*) @nogc nothrow;

    _IO_FILE* fopen(const(char)*, const(char)*) @nogc nothrow;

    _IO_FILE* freopen(const(char)*, const(char)*, _IO_FILE*) @nogc nothrow;

    _IO_FILE* fdopen(int, const(char)*) @nogc nothrow;

    _IO_FILE* fmemopen(void*, c_ulong, const(char)*) @nogc nothrow;

    _IO_FILE* open_memstream(char**, c_ulong*) @nogc nothrow;

    void setbuf(_IO_FILE*, char*) @nogc nothrow;

    int setvbuf(_IO_FILE*, char*, int, c_ulong) @nogc nothrow;

    void setbuffer(_IO_FILE*, char*, c_ulong) @nogc nothrow;

    void setlinebuf(_IO_FILE*) @nogc nothrow;

    int fprintf(_IO_FILE*, const(char)*, ...) @nogc nothrow;

    int printf(const(char)*, ...) @nogc nothrow;

    int sprintf(char*, const(char)*, ...) @nogc nothrow;

    int vfprintf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;

    int vprintf(const(char)*, va_list*) @nogc nothrow;

    int vsprintf(char*, const(char)*, va_list*) @nogc nothrow;

    int snprintf(char*, c_ulong, const(char)*, ...) @nogc nothrow;

    int vsnprintf(char*, c_ulong, const(char)*, va_list*) @nogc nothrow;

    int vdprintf(int, const(char)*, va_list*) @nogc nothrow;

    int dprintf(int, const(char)*, ...) @nogc nothrow;

    int fscanf(_IO_FILE*, const(char)*, ...) @nogc nothrow;

    int scanf(const(char)*, ...) @nogc nothrow;

    int sscanf(const(char)*, const(char)*, ...) @nogc nothrow;

    int vfscanf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;

    int vscanf(const(char)*, va_list*) @nogc nothrow;

    int vsscanf(const(char)*, const(char)*, va_list*) @nogc nothrow;

    int fgetc(_IO_FILE*) @nogc nothrow;

    int getc(_IO_FILE*) @nogc nothrow;

    int getchar() @nogc nothrow;

    int getc_unlocked(_IO_FILE*) @nogc nothrow;

    int getchar_unlocked() @nogc nothrow;

    int fgetc_unlocked(_IO_FILE*) @nogc nothrow;

    int fputc(int, _IO_FILE*) @nogc nothrow;

    int putc(int, _IO_FILE*) @nogc nothrow;

    int putchar(int) @nogc nothrow;

    int fputc_unlocked(int, _IO_FILE*) @nogc nothrow;

    int putc_unlocked(int, _IO_FILE*) @nogc nothrow;

    int putchar_unlocked(int) @nogc nothrow;

    int getw(_IO_FILE*) @nogc nothrow;

    int putw(int, _IO_FILE*) @nogc nothrow;

    char* fgets(char*, int, _IO_FILE*) @nogc nothrow;

    c_long __getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;

    c_long getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;

    c_long getline(char**, c_ulong*, _IO_FILE*) @nogc nothrow;

    int fputs(const(char)*, _IO_FILE*) @nogc nothrow;

    int puts(const(char)*) @nogc nothrow;

    int ungetc(int, _IO_FILE*) @nogc nothrow;

    c_ulong fread(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    c_ulong fwrite(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    c_ulong fread_unlocked(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    c_ulong fwrite_unlocked(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;

    int fseek(_IO_FILE*, c_long, int) @nogc nothrow;

    c_long ftell(_IO_FILE*) @nogc nothrow;

    void rewind(_IO_FILE*) @nogc nothrow;

    int fseeko(_IO_FILE*, c_long, int) @nogc nothrow;

    c_long ftello(_IO_FILE*) @nogc nothrow;

    int fgetpos(_IO_FILE*, _G_fpos_t*) @nogc nothrow;

    int fsetpos(_IO_FILE*, const(_G_fpos_t)*) @nogc nothrow;

    void clearerr(_IO_FILE*) @nogc nothrow;

    int feof(_IO_FILE*) @nogc nothrow;

    int ferror(_IO_FILE*) @nogc nothrow;

    void clearerr_unlocked(_IO_FILE*) @nogc nothrow;

    int feof_unlocked(_IO_FILE*) @nogc nothrow;

    int ferror_unlocked(_IO_FILE*) @nogc nothrow;

    void perror(const(char)*) @nogc nothrow;

    int fileno(_IO_FILE*) @nogc nothrow;

    int fileno_unlocked(_IO_FILE*) @nogc nothrow;

    int pclose(_IO_FILE*) @nogc nothrow;

    _IO_FILE* popen(const(char)*, const(char)*) @nogc nothrow;

    char* ctermid(char*) @nogc nothrow;

    void flockfile(_IO_FILE*) @nogc nothrow;

    int ftrylockfile(_IO_FILE*) @nogc nothrow;

    void funlockfile(_IO_FILE*) @nogc nothrow;

    int __uflow(_IO_FILE*) @nogc nothrow;

    int __overflow(_IO_FILE*, int) @nogc nothrow;

    int deflate(z_stream_s*, int) @nogc nothrow;

    const(char)* zlibVersion() @nogc nothrow;

    alias gz_headerp = gz_header_s*;

    struct gz_header_s
    {

        int text;

        c_ulong time;

        int xflags;

        int os;

        ubyte* extra;

        uint extra_len;

        uint extra_max;

        ubyte* name;

        uint name_max;

        ubyte* comment;

        uint comm_max;

        int hcrc;

        int done;
    }

    alias gz_header = gz_header_s;

    alias z_streamp = z_stream_s*;

    struct div_t
    {

        int quot;

        int rem;
    }

    struct ldiv_t
    {

        c_long quot;

        c_long rem;
    }

    struct lldiv_t
    {

        long quot;

        long rem;
    }

    struct z_stream_s
    {

        ubyte* next_in;

        uint avail_in;

        c_ulong total_in;

        ubyte* next_out;

        uint avail_out;

        c_ulong total_out;

        char* msg;

        internal_state* state;

        void* function(void*, uint, uint) zalloc;

        void function(void*, void*) zfree;

        void* opaque;

        int data_type;

        c_ulong adler;

        c_ulong reserved;
    }

    alias z_stream = z_stream_s;
    struct internal_state;

    c_ulong __ctype_get_mb_cur_max() @nogc nothrow;

    double atof(const(char)*) @nogc nothrow;

    int atoi(const(char)*) @nogc nothrow;

    c_long atol(const(char)*) @nogc nothrow;

    long atoll(const(char)*) @nogc nothrow;

    double strtod(const(char)*, char**) @nogc nothrow;

    float strtof(const(char)*, char**) @nogc nothrow;

    real strtold(const(char)*, char**) @nogc nothrow;

    c_long strtol(const(char)*, char**, int) @nogc nothrow;

    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;

    long strtoq(const(char)*, char**, int) @nogc nothrow;

    ulong strtouq(const(char)*, char**, int) @nogc nothrow;

    long strtoll(const(char)*, char**, int) @nogc nothrow;

    ulong strtoull(const(char)*, char**, int) @nogc nothrow;

    char* l64a(c_long) @nogc nothrow;

    c_long a64l(const(char)*) @nogc nothrow;

    c_long random() @nogc nothrow;

    void srandom(uint) @nogc nothrow;

    char* initstate(uint, char*, c_ulong) @nogc nothrow;

    char* setstate(char*) @nogc nothrow;

    struct random_data
    {

        int* fptr;

        int* rptr;

        int* state;

        int rand_type;

        int rand_deg;

        int rand_sep;

        int* end_ptr;
    }

    int random_r(random_data*, int*) @nogc nothrow;

    int srandom_r(uint, random_data*) @nogc nothrow;

    int initstate_r(uint, char*, c_ulong, random_data*) @nogc nothrow;

    int setstate_r(char*, random_data*) @nogc nothrow;

    int rand() @nogc nothrow;

    void srand(uint) @nogc nothrow;

    int rand_r(uint*) @nogc nothrow;

    double drand48() @nogc nothrow;

    double erand48(ushort*) @nogc nothrow;

    c_long lrand48() @nogc nothrow;

    c_long nrand48(ushort*) @nogc nothrow;

    c_long mrand48() @nogc nothrow;

    c_long jrand48(ushort*) @nogc nothrow;

    void srand48(c_long) @nogc nothrow;

    ushort* seed48(ushort*) @nogc nothrow;

    void lcong48(ushort*) @nogc nothrow;

    struct drand48_data
    {

        ushort[3] __x;

        ushort[3] __old_x;

        ushort __c;

        ushort __init;

        ulong __a;
    }

    int drand48_r(drand48_data*, double*) @nogc nothrow;

    int erand48_r(ushort*, drand48_data*, double*) @nogc nothrow;

    int lrand48_r(drand48_data*, c_long*) @nogc nothrow;

    int nrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;

    int mrand48_r(drand48_data*, c_long*) @nogc nothrow;

    int jrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;

    int srand48_r(c_long, drand48_data*) @nogc nothrow;

    int seed48_r(ushort*, drand48_data*) @nogc nothrow;

    int lcong48_r(ushort*, drand48_data*) @nogc nothrow;

    uint arc4random() @nogc nothrow;

    void arc4random_buf(void*, c_ulong) @nogc nothrow;

    uint arc4random_uniform(uint) @nogc nothrow;

    void* malloc(c_ulong) @nogc nothrow;

    void* calloc(c_ulong, c_ulong) @nogc nothrow;

    void* realloc(void*, c_ulong) @nogc nothrow;

    void free(void*) @nogc nothrow;

    void* reallocarray(void*, c_ulong, c_ulong) @nogc nothrow;

    void* valloc(c_ulong) @nogc nothrow;

    int posix_memalign(void**, c_ulong, c_ulong) @nogc nothrow;

    void* aligned_alloc(c_ulong, c_ulong) @nogc nothrow;

    void abort() @nogc nothrow;

    int atexit(void function()) @nogc nothrow;

    int at_quick_exit(void function()) @nogc nothrow;

    int on_exit(void function(int, void*), void*) @nogc nothrow;

    void exit(int) @nogc nothrow;

    void quick_exit(int) @nogc nothrow;

    void _Exit(int) @nogc nothrow;

    char* getenv(const(char)*) @nogc nothrow;

    int putenv(char*) @nogc nothrow;

    int setenv(const(char)*, const(char)*, int) @nogc nothrow;

    int unsetenv(const(char)*) @nogc nothrow;

    int clearenv() @nogc nothrow;

    char* mktemp(char*) @nogc nothrow;

    int mkstemp(char*) @nogc nothrow;

    int mkstemps(char*, int) @nogc nothrow;

    char* mkdtemp(char*) @nogc nothrow;

    int system(const(char)*) @nogc nothrow;

    char* realpath(const(char)*, char*) @nogc nothrow;
    alias free_func = void function(void*, void*);
    alias __compar_fn_t = int function(const(void)*, const(void)*);

    void* bsearch(const(void)*, const(void)*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;

    void qsort(void*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;

    int abs(int) @nogc nothrow;

    c_long labs(c_long) @nogc nothrow;

    long llabs(long) @nogc nothrow;

    div_t div(int, int) @nogc nothrow;

    ldiv_t ldiv(c_long, c_long) @nogc nothrow;

    lldiv_t lldiv(long, long) @nogc nothrow;

    char* ecvt(double, int, int*, int*) @nogc nothrow;

    char* fcvt(double, int, int*, int*) @nogc nothrow;

    char* gcvt(double, int, char*) @nogc nothrow;

    char* qecvt(real, int, int*, int*) @nogc nothrow;

    char* qfcvt(real, int, int*, int*) @nogc nothrow;

    char* qgcvt(real, int, char*) @nogc nothrow;

    int ecvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;

    int fcvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;

    int qecvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;

    int qfcvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;

    int mblen(const(char)*, c_ulong) @nogc nothrow;

    int mbtowc(int*, const(char)*, c_ulong) @nogc nothrow;

    int wctomb(char*, int) @nogc nothrow;

    c_ulong mbstowcs(int*, const(char)*, c_ulong) @nogc nothrow;

    c_ulong wcstombs(char*, const(int)*, c_ulong) @nogc nothrow;

    int rpmatch(const(char)*) @nogc nothrow;

    int getsubopt(char**, char**, char**) @nogc nothrow;

    int getloadavg(double*, int) @nogc nothrow;
    alias alloc_func = void* function(void*, uint, uint);

    void* memcpy(void*, const(void)*, c_ulong) @nogc nothrow;

    void* memmove(void*, const(void)*, c_ulong) @nogc nothrow;

    void* memccpy(void*, const(void)*, int, c_ulong) @nogc nothrow;

    void* memset(void*, int, c_ulong) @nogc nothrow;

    int memcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;

    int __memcmpeq(const(void)*, const(void)*, c_ulong) @nogc nothrow;

    void* memchr(const(void)*, int, c_ulong) @nogc nothrow;

    char* strcpy(char*, const(char)*) @nogc nothrow;

    char* strncpy(char*, const(char)*, c_ulong) @nogc nothrow;

    char* strcat(char*, const(char)*) @nogc nothrow;

    char* strncat(char*, const(char)*, c_ulong) @nogc nothrow;

    int strcmp(const(char)*, const(char)*) @nogc nothrow;

    int strncmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;

    int strcoll(const(char)*, const(char)*) @nogc nothrow;

    c_ulong strxfrm(char*, const(char)*, c_ulong) @nogc nothrow;

    int strcoll_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;

    c_ulong strxfrm_l(char*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;

    char* strdup(const(char)*) @nogc nothrow;

    char* strndup(const(char)*, c_ulong) @nogc nothrow;

    char* strchr(const(char)*, int) @nogc nothrow;

    char* strrchr(const(char)*, int) @nogc nothrow;

    c_ulong strcspn(const(char)*, const(char)*) @nogc nothrow;

    c_ulong strspn(const(char)*, const(char)*) @nogc nothrow;

    char* strpbrk(const(char)*, const(char)*) @nogc nothrow;

    char* strstr(const(char)*, const(char)*) @nogc nothrow;

    char* strtok(char*, const(char)*) @nogc nothrow;

    char* __strtok_r(char*, const(char)*, char**) @nogc nothrow;

    char* strtok_r(char*, const(char)*, char**) @nogc nothrow;

    c_ulong strlen(const(char)*) @nogc nothrow;

    c_ulong strnlen(const(char)*, c_ulong) @nogc nothrow;

    char* strerror(int) @nogc nothrow;

    int strerror_r(int, char*, c_ulong) @nogc nothrow;

    char* strerror_l(int, __locale_struct*) @nogc nothrow;

    void explicit_bzero(void*, c_ulong) @nogc nothrow;

    char* strsep(char**, const(char)*) @nogc nothrow;

    char* strsignal(int) @nogc nothrow;

    char* __stpcpy(char*, const(char)*) @nogc nothrow;

    char* stpcpy(char*, const(char)*) @nogc nothrow;

    char* __stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;

    char* stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;

    int bcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;

    void bcopy(const(void)*, void*, c_ulong) @nogc nothrow;

    void bzero(void*, c_ulong) @nogc nothrow;

    char* index(const(char)*, int) @nogc nothrow;

    char* rindex(const(char)*, int) @nogc nothrow;

    int ffs(int) @nogc nothrow;

    int ffsl(c_long) @nogc nothrow;

    int ffsll(long) @nogc nothrow;

    int strcasecmp(const(char)*, const(char)*) @nogc nothrow;

    int strncasecmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;

    int strcasecmp_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;

    int strncasecmp_l(const(char)*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;

    alias z_crc_t = uint;

    alias voidp = void*;

    alias voidpf = void*;

    alias voidpc = const(void)*;

    alias uLongf = c_ulong;

    alias uIntf = uint;

    alias intf = int;

    alias charf = char;

    alias Bytef = ubyte;

    alias uLong = c_ulong;

    alias uInt = uint;

    alias Byte = ubyte;

    alias z_size_t = c_ulong;

    int getentropy(void*, c_ulong) @nogc nothrow;

    char* crypt(const(char)*, const(char)*) @nogc nothrow;

    int fdatasync(int) @nogc nothrow;

    int lockf(int, int, c_long) @nogc nothrow;

    c_long syscall(c_long, ...) @nogc nothrow;

    alias suseconds_t = c_long;

    void* sbrk(c_long) @nogc nothrow;

    alias __fd_mask = c_long;

    int brk(void*) @nogc nothrow;

    struct fd_set
    {

        c_long[16] __fds_bits;
    }

    alias fd_mask = c_long;

    int ftruncate(int, c_long) @nogc nothrow;

    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;

    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;

    alias u_char = ubyte;

    alias u_short = ushort;

    alias u_int = uint;

    alias u_long = c_ulong;

    alias quad_t = c_long;

    alias u_quad_t = c_ulong;

    alias fsid_t = __fsid_t;

    alias loff_t = c_long;

    alias ino_t = c_ulong;

    alias dev_t = c_ulong;

    int truncate(const(char)*, c_long) @nogc nothrow;

    alias gid_t = uint;

    alias mode_t = uint;

    alias nlink_t = c_ulong;

    int getdtablesize() @nogc nothrow;

    alias uid_t = uint;

    alias pid_t = int;

    int getpagesize() @nogc nothrow;

    alias id_t = uint;

    alias daddr_t = int;

    alias caddr_t = char*;

    alias key_t = int;

    void sync() @nogc nothrow;

    alias u_int8_t = ubyte;

    alias u_int16_t = ushort;

    alias u_int32_t = uint;

    alias u_int64_t = c_ulong;

    alias register_t = c_long;

    c_long gethostid() @nogc nothrow;

    alias blksize_t = c_long;

    alias blkcnt_t = c_long;

    int fsync(int) @nogc nothrow;

    alias fsblkcnt_t = c_ulong;

    alias fsfilcnt_t = c_ulong;

    char* getpass(const(char)*) @nogc nothrow;
    struct sigevent;

    int chroot(const(char)*) @nogc nothrow;

    c_long clock() @nogc nothrow;

    c_long time(c_long*) @nogc nothrow;

    double difftime(c_long, c_long) @nogc nothrow;

    c_long mktime(tm*) @nogc nothrow;

    c_ulong strftime(char*, c_ulong, const(char)*, const(tm)*) @nogc nothrow;

    c_ulong strftime_l(char*, c_ulong, const(char)*, const(tm)*, __locale_struct*) @nogc nothrow;

    tm* gmtime(const(c_long)*) @nogc nothrow;

    tm* localtime(const(c_long)*) @nogc nothrow;

    tm* gmtime_r(const(c_long)*, tm*) @nogc nothrow;

    tm* localtime_r(const(c_long)*, tm*) @nogc nothrow;

    char* asctime(const(tm)*) @nogc nothrow;

    char* ctime(const(c_long)*) @nogc nothrow;

    char* asctime_r(const(tm)*, char*) @nogc nothrow;

    char* ctime_r(const(c_long)*, char*) @nogc nothrow;

    extern export __gshared char*[2] __tzname;

    extern export __gshared int __daylight;

    extern export __gshared c_long __timezone;

    extern export __gshared char*[2] tzname;

    void tzset() @nogc nothrow;

    extern export __gshared int daylight;

    extern export __gshared c_long timezone;

    c_long timegm(tm*) @nogc nothrow;

    c_long timelocal(tm*) @nogc nothrow;

    int dysize(int) @nogc nothrow;

    int nanosleep(const(timespec)*, timespec*) @nogc nothrow;

    int clock_getres(int, timespec*) @nogc nothrow;

    int clock_gettime(int, timespec*) @nogc nothrow;

    int clock_settime(int, const(timespec)*) @nogc nothrow;

    int clock_nanosleep(int, int, const(timespec)*, timespec*) @nogc nothrow;

    int clock_getcpuclockid(int, int*) @nogc nothrow;

    int timer_create(int, sigevent*, void**) @nogc nothrow;

    int timer_delete(void*) @nogc nothrow;

    int timer_settime(void*, int, const(itimerspec)*, itimerspec*) @nogc nothrow;

    int timer_gettime(void*, itimerspec*) @nogc nothrow;

    int timer_getoverrun(void*) @nogc nothrow;

    int timespec_get(timespec*, int) @nogc nothrow;

    int daemon(int, int) @nogc nothrow;

    void setusershell() @nogc nothrow;

    void endusershell() @nogc nothrow;

    char* getusershell() @nogc nothrow;

    int acct(const(char)*) @nogc nothrow;

    int profil(ushort*, c_ulong, c_ulong, uint) @nogc nothrow;

    int revoke(const(char)*) @nogc nothrow;

    int vhangup() @nogc nothrow;

    alias useconds_t = uint;

    alias socklen_t = uint;

    int setdomainname(const(char)*, c_ulong) @nogc nothrow;

    int access(const(char)*, int) @nogc nothrow;

    int faccessat(int, const(char)*, int, int) @nogc nothrow;

    int getdomainname(char*, c_ulong) @nogc nothrow;

    c_long lseek(int, c_long, int) @nogc nothrow;

    int close(int) @nogc nothrow;

    void closefrom(int) @nogc nothrow;

    c_long read(int, void*, c_ulong) @nogc nothrow;

    c_long write(int, const(void)*, c_ulong) @nogc nothrow;

    c_long pread(int, void*, c_ulong, c_long) @nogc nothrow;

    c_long pwrite(int, const(void)*, c_ulong, c_long) @nogc nothrow;

    int pipe(int*) @nogc nothrow;

    uint alarm(uint) @nogc nothrow;

    uint sleep(uint) @nogc nothrow;

    uint ualarm(uint, uint) @nogc nothrow;

    int usleep(uint) @nogc nothrow;

    int pause() @nogc nothrow;

    int chown(const(char)*, uint, uint) @nogc nothrow;

    int fchown(int, uint, uint) @nogc nothrow;

    int lchown(const(char)*, uint, uint) @nogc nothrow;

    int fchownat(int, const(char)*, uint, uint, int) @nogc nothrow;

    int chdir(const(char)*) @nogc nothrow;

    int fchdir(int) @nogc nothrow;

    char* getcwd(char*, c_ulong) @nogc nothrow;

    char* getwd(char*) @nogc nothrow;

    int dup(int) @nogc nothrow;

    int dup2(int, int) @nogc nothrow;

    extern export __gshared char** __environ;

    int execve(const(char)*, char**, char**) @nogc nothrow;

    int fexecve(int, char**, char**) @nogc nothrow;

    int execv(const(char)*, char**) @nogc nothrow;

    int execle(const(char)*, const(char)*, ...) @nogc nothrow;

    int execl(const(char)*, const(char)*, ...) @nogc nothrow;

    int execvp(const(char)*, char**) @nogc nothrow;

    int execlp(const(char)*, const(char)*, ...) @nogc nothrow;

    int nice(int) @nogc nothrow;

    void _exit(int) @nogc nothrow;

    c_long pathconf(const(char)*, int) @nogc nothrow;

    c_long fpathconf(int, int) @nogc nothrow;

    c_long sysconf(int) @nogc nothrow;

    c_ulong confstr(int, char*, c_ulong) @nogc nothrow;

    int getpid() @nogc nothrow;

    int getppid() @nogc nothrow;

    int getpgrp() @nogc nothrow;

    int __getpgid(int) @nogc nothrow;

    int getpgid(int) @nogc nothrow;

    int setpgid(int, int) @nogc nothrow;

    int setpgrp() @nogc nothrow;

    int setsid() @nogc nothrow;

    int getsid(int) @nogc nothrow;

    uint getuid() @nogc nothrow;

    uint geteuid() @nogc nothrow;

    uint getgid() @nogc nothrow;

    uint getegid() @nogc nothrow;

    int getgroups(int, uint*) @nogc nothrow;

    int setuid(uint) @nogc nothrow;

    int setreuid(uint, uint) @nogc nothrow;

    int seteuid(uint) @nogc nothrow;

    int setgid(uint) @nogc nothrow;

    int setregid(uint, uint) @nogc nothrow;

    int setegid(uint) @nogc nothrow;

    int fork() @nogc nothrow;

    int vfork() @nogc nothrow;

    char* ttyname(int) @nogc nothrow;

    int ttyname_r(int, char*, c_ulong) @nogc nothrow;

    int isatty(int) @nogc nothrow;

    int ttyslot() @nogc nothrow;

    int link(const(char)*, const(char)*) @nogc nothrow;

    int linkat(int, const(char)*, int, const(char)*, int) @nogc nothrow;

    int symlink(const(char)*, const(char)*) @nogc nothrow;

    c_long readlink(const(char)*, char*, c_ulong) @nogc nothrow;

    int symlinkat(const(char)*, int, const(char)*) @nogc nothrow;

    c_long readlinkat(int, const(char)*, char*, c_ulong) @nogc nothrow;

    int unlink(const(char)*) @nogc nothrow;

    int unlinkat(int, const(char)*, int) @nogc nothrow;

    int rmdir(const(char)*) @nogc nothrow;

    int tcgetpgrp(int) @nogc nothrow;

    int tcsetpgrp(int, int) @nogc nothrow;

    char* getlogin() @nogc nothrow;

    int getlogin_r(char*, c_ulong) @nogc nothrow;

    int setlogin(const(char)*) @nogc nothrow;

    int gethostname(char*, c_ulong) @nogc nothrow;

    int sethostname(const(char)*, c_ulong) @nogc nothrow;

    int sethostid(c_long) @nogc nothrow;



    static if(!is(typeof(L_XTND))) {
        private enum enumMixinStr_L_XTND = `enum L_XTND = SEEK_END;`;
        static if(is(typeof({ mixin(enumMixinStr_L_XTND); }))) {
            mixin(enumMixinStr_L_XTND);
        }
    }




    static if(!is(typeof(L_INCR))) {
        private enum enumMixinStr_L_INCR = `enum L_INCR = SEEK_CUR;`;
        static if(is(typeof({ mixin(enumMixinStr_L_INCR); }))) {
            mixin(enumMixinStr_L_INCR);
        }
    }




    static if(!is(typeof(L_SET))) {
        private enum enumMixinStr_L_SET = `enum L_SET = SEEK_SET;`;
        static if(is(typeof({ mixin(enumMixinStr_L_SET); }))) {
            mixin(enumMixinStr_L_SET);
        }
    }




    static if(!is(typeof(F_OK))) {
        enum F_OK = 0;
    }




    static if(!is(typeof(X_OK))) {
        enum X_OK = 1;
    }




    static if(!is(typeof(W_OK))) {
        enum W_OK = 2;
    }




    static if(!is(typeof(R_OK))) {
        enum R_OK = 4;
    }
    static if(!is(typeof(STDERR_FILENO))) {
        enum STDERR_FILENO = 2;
    }




    static if(!is(typeof(STDOUT_FILENO))) {
        enum STDOUT_FILENO = 1;
    }




    static if(!is(typeof(STDIN_FILENO))) {
        enum STDIN_FILENO = 0;
    }




    static if(!is(typeof(_XOPEN_LEGACY))) {
        enum _XOPEN_LEGACY = 1;
    }




    static if(!is(typeof(_XOPEN_ENH_I18N))) {
        enum _XOPEN_ENH_I18N = 1;
    }




    static if(!is(typeof(_XOPEN_UNIX))) {
        enum _XOPEN_UNIX = 1;
    }




    static if(!is(typeof(_XOPEN_XPG4))) {
        enum _XOPEN_XPG4 = 1;
    }




    static if(!is(typeof(_XOPEN_XPG3))) {
        enum _XOPEN_XPG3 = 1;
    }




    static if(!is(typeof(_XOPEN_XPG2))) {
        enum _XOPEN_XPG2 = 1;
    }




    static if(!is(typeof(_XOPEN_XCU_VERSION))) {
        enum _XOPEN_XCU_VERSION = 4;
    }




    static if(!is(typeof(_XOPEN_VERSION))) {
        enum _XOPEN_VERSION = 700;
    }




    static if(!is(typeof(_POSIX2_LOCALEDEF))) {
        private enum enumMixinStr__POSIX2_LOCALEDEF = `enum _POSIX2_LOCALEDEF = __POSIX2_THIS_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_LOCALEDEF); }))) {
            mixin(enumMixinStr__POSIX2_LOCALEDEF);
        }
    }




    static if(!is(typeof(_POSIX2_SW_DEV))) {
        private enum enumMixinStr__POSIX2_SW_DEV = `enum _POSIX2_SW_DEV = __POSIX2_THIS_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_SW_DEV); }))) {
            mixin(enumMixinStr__POSIX2_SW_DEV);
        }
    }




    static if(!is(typeof(_POSIX2_C_DEV))) {
        private enum enumMixinStr__POSIX2_C_DEV = `enum _POSIX2_C_DEV = __POSIX2_THIS_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_C_DEV); }))) {
            mixin(enumMixinStr__POSIX2_C_DEV);
        }
    }




    static if(!is(typeof(_POSIX2_C_BIND))) {
        private enum enumMixinStr__POSIX2_C_BIND = `enum _POSIX2_C_BIND = __POSIX2_THIS_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_C_BIND); }))) {
            mixin(enumMixinStr__POSIX2_C_BIND);
        }
    }




    static if(!is(typeof(_POSIX2_C_VERSION))) {
        private enum enumMixinStr__POSIX2_C_VERSION = `enum _POSIX2_C_VERSION = __POSIX2_THIS_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_C_VERSION); }))) {
            mixin(enumMixinStr__POSIX2_C_VERSION);
        }
    }




    static if(!is(typeof(_POSIX2_VERSION))) {
        private enum enumMixinStr__POSIX2_VERSION = `enum _POSIX2_VERSION = __POSIX2_THIS_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX2_VERSION); }))) {
            mixin(enumMixinStr__POSIX2_VERSION);
        }
    }




    static if(!is(typeof(__POSIX2_THIS_VERSION))) {
        enum __POSIX2_THIS_VERSION = 200809L;
    }




    static if(!is(typeof(_POSIX_VERSION))) {
        enum _POSIX_VERSION = 200809L;
    }




    static if(!is(typeof(_UNISTD_H))) {
        enum _UNISTD_H = 1;
    }







    static if(!is(typeof(TIME_UTC))) {
        enum TIME_UTC = 1;
    }




    static if(!is(typeof(_TIME_H))) {
        enum _TIME_H = 1;
    }
    static if(!is(typeof(__BIT_TYPES_DEFINED__))) {
        enum __BIT_TYPES_DEFINED__ = 1;
    }
    static if(!is(typeof(_SYS_TYPES_H))) {
        enum _SYS_TYPES_H = 1;
    }
    static if(!is(typeof(NFDBITS))) {
        private enum enumMixinStr_NFDBITS = `enum NFDBITS = __NFDBITS;`;
        static if(is(typeof({ mixin(enumMixinStr_NFDBITS); }))) {
            mixin(enumMixinStr_NFDBITS);
        }
    }




    static if(!is(typeof(FD_SETSIZE))) {
        private enum enumMixinStr_FD_SETSIZE = `enum FD_SETSIZE = __FD_SETSIZE;`;
        static if(is(typeof({ mixin(enumMixinStr_FD_SETSIZE); }))) {
            mixin(enumMixinStr_FD_SETSIZE);
        }
    }
    static if(!is(typeof(__NFDBITS))) {
        private enum enumMixinStr___NFDBITS = `enum __NFDBITS = ( 8 * cast( int ) ( __fd_mask ) .sizeof );`;
        static if(is(typeof({ mixin(enumMixinStr___NFDBITS); }))) {
            mixin(enumMixinStr___NFDBITS);
        }
    }







    static if(!is(typeof(_SYS_SELECT_H))) {
        enum _SYS_SELECT_H = 1;
    }




    static if(!is(typeof(__attribute_returns_twice__))) {
        private enum enumMixinStr___attribute_returns_twice__ = `enum __attribute_returns_twice__ = __attribute__ ( ( __returns_twice__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_returns_twice__); }))) {
            mixin(enumMixinStr___attribute_returns_twice__);
        }
    }
    static if(!is(typeof(F_ULOCK))) {
        enum F_ULOCK = 0;
    }




    static if(!is(typeof(F_LOCK))) {
        enum F_LOCK = 1;
    }




    static if(!is(typeof(F_TLOCK))) {
        enum F_TLOCK = 2;
    }




    static if(!is(typeof(F_TEST))) {
        enum F_TEST = 3;
    }
    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        enum __HAVE_GENERIC_SELECTION = 1;
    }
    static if(!is(typeof(__restrict_arr))) {
        private enum enumMixinStr___restrict_arr = `enum __restrict_arr = __restrict;`;
        static if(is(typeof({ mixin(enumMixinStr___restrict_arr); }))) {
            mixin(enumMixinStr___restrict_arr);
        }
    }







    static if(!is(typeof(__fortify_function))) {
        private enum enumMixinStr___fortify_function = `enum __fortify_function = __extern_always_inline __attribute_artificial__;`;
        static if(is(typeof({ mixin(enumMixinStr___fortify_function); }))) {
            mixin(enumMixinStr___fortify_function);
        }
    }







    static if(!is(typeof(__extern_always_inline))) {
        private enum enumMixinStr___extern_always_inline = `enum __extern_always_inline = extern __always_inline __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_always_inline); }))) {
            mixin(enumMixinStr___extern_always_inline);
        }
    }







    static if(!is(typeof(__extern_inline))) {
        private enum enumMixinStr___extern_inline = `enum __extern_inline = extern __inline __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_inline); }))) {
            mixin(enumMixinStr___extern_inline);
        }
    }




    static if(!is(typeof(__attribute_artificial__))) {
        private enum enumMixinStr___attribute_artificial__ = `enum __attribute_artificial__ = __attribute__ ( ( __artificial__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_artificial__); }))) {
            mixin(enumMixinStr___attribute_artificial__);
        }
    }




    static if(!is(typeof(__always_inline))) {
        private enum enumMixinStr___always_inline = `enum __always_inline = __inline __attribute__ ( ( __always_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___always_inline); }))) {
            mixin(enumMixinStr___always_inline);
        }
    }







    static if(!is(typeof(__attribute_warn_unused_result__))) {
        private enum enumMixinStr___attribute_warn_unused_result__ = `enum __attribute_warn_unused_result__ = __attribute__ ( ( __warn_unused_result__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_warn_unused_result__); }))) {
            mixin(enumMixinStr___attribute_warn_unused_result__);
        }
    }




    static if(!is(typeof(__returns_nonnull))) {
        private enum enumMixinStr___returns_nonnull = `enum __returns_nonnull = __attribute__ ( ( __returns_nonnull__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___returns_nonnull); }))) {
            mixin(enumMixinStr___returns_nonnull);
        }
    }
    static if(!is(typeof(z_longlong))) {
        private enum enumMixinStr_z_longlong = `enum z_longlong = long long;`;
        static if(is(typeof({ mixin(enumMixinStr_z_longlong); }))) {
            mixin(enumMixinStr_z_longlong);
        }
    }
    static if(!is(typeof(MAX_MEM_LEVEL))) {
        enum MAX_MEM_LEVEL = 9;
    }




    static if(!is(typeof(MAX_WBITS))) {
        enum MAX_WBITS = 15;
    }




    static if(!is(typeof(__attribute_deprecated__))) {
        private enum enumMixinStr___attribute_deprecated__ = `enum __attribute_deprecated__ = __attribute__ ( ( __deprecated__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_deprecated__); }))) {
            mixin(enumMixinStr___attribute_deprecated__);
        }
    }







    static if(!is(typeof(__attribute_noinline__))) {
        private enum enumMixinStr___attribute_noinline__ = `enum __attribute_noinline__ = __attribute__ ( ( __noinline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_noinline__); }))) {
            mixin(enumMixinStr___attribute_noinline__);
        }
    }







    static if(!is(typeof(ZEXTERN))) {
        private enum enumMixinStr_ZEXTERN = `enum ZEXTERN = extern;`;
        static if(is(typeof({ mixin(enumMixinStr_ZEXTERN); }))) {
            mixin(enumMixinStr_ZEXTERN);
        }
    }
    static if(!is(typeof(__attribute_used__))) {
        private enum enumMixinStr___attribute_used__ = `enum __attribute_used__ = __attribute__ ( ( __used__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_used__); }))) {
            mixin(enumMixinStr___attribute_used__);
        }
    }




    static if(!is(typeof(__attribute_maybe_unused__))) {
        private enum enumMixinStr___attribute_maybe_unused__ = `enum __attribute_maybe_unused__ = __attribute__ ( ( __unused__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_maybe_unused__); }))) {
            mixin(enumMixinStr___attribute_maybe_unused__);
        }
    }




    static if(!is(typeof(__attribute_const__))) {
        private enum enumMixinStr___attribute_const__ = `enum __attribute_const__ = __attribute__ ( cast( __const__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_const__); }))) {
            mixin(enumMixinStr___attribute_const__);
        }
    }




    static if(!is(typeof(__attribute_pure__))) {
        private enum enumMixinStr___attribute_pure__ = `enum __attribute_pure__ = __attribute__ ( ( __pure__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_pure__); }))) {
            mixin(enumMixinStr___attribute_pure__);
        }
    }
    static if(!is(typeof(__attribute_malloc__))) {
        private enum enumMixinStr___attribute_malloc__ = `enum __attribute_malloc__ = __attribute__ ( ( __malloc__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_malloc__); }))) {
            mixin(enumMixinStr___attribute_malloc__);
        }
    }
    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        enum __glibc_c99_flexarr_available = 1;
    }




    static if(!is(typeof(__flexarr))) {
        private enum enumMixinStr___flexarr = `enum __flexarr = [ ];`;
        static if(is(typeof({ mixin(enumMixinStr___flexarr); }))) {
            mixin(enumMixinStr___flexarr);
        }
    }
    static if(!is(typeof(Z_U4))) {
        private enum enumMixinStr_Z_U4 = `enum Z_U4 = unsigned;`;
        static if(is(typeof({ mixin(enumMixinStr_Z_U4); }))) {
            mixin(enumMixinStr_Z_U4);
        }
    }







    static if(!is(typeof(__ptr_t))) {
        private enum enumMixinStr___ptr_t = `enum __ptr_t = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___ptr_t); }))) {
            mixin(enumMixinStr___ptr_t);
        }
    }
    static if(!is(typeof(__THROWNL))) {
        private enum enumMixinStr___THROWNL = `enum __THROWNL = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROWNL); }))) {
            mixin(enumMixinStr___THROWNL);
        }
    }




    static if(!is(typeof(__THROW))) {
        private enum enumMixinStr___THROW = `enum __THROW = __attribute__ ( ( __nothrow__ __LEAF ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROW); }))) {
            mixin(enumMixinStr___THROW);
        }
    }
    static if(!is(typeof(z_off_t))) {
        private enum enumMixinStr_z_off_t = `enum z_off_t = off_t;`;
        static if(is(typeof({ mixin(enumMixinStr_z_off_t); }))) {
            mixin(enumMixinStr_z_off_t);
        }
    }
    static if(!is(typeof(_SYS_CDEFS_H))) {
        enum _SYS_CDEFS_H = 1;
    }




    static if(!is(typeof(_STRINGS_H))) {
        enum _STRINGS_H = 1;
    }




    static if(!is(typeof(z_off64_t))) {
        private enum enumMixinStr_z_off64_t = `enum z_off64_t = off_t;`;
        static if(is(typeof({ mixin(enumMixinStr_z_off64_t); }))) {
            mixin(enumMixinStr_z_off64_t);
        }
    }







    static if(!is(typeof(ZLIB_VERSION))) {
        enum ZLIB_VERSION = "1.2.13";
    }




    static if(!is(typeof(ZLIB_VERNUM))) {
        enum ZLIB_VERNUM = 0x12d0;
    }




    static if(!is(typeof(ZLIB_VER_MAJOR))) {
        enum ZLIB_VER_MAJOR = 1;
    }




    static if(!is(typeof(ZLIB_VER_MINOR))) {
        enum ZLIB_VER_MINOR = 2;
    }




    static if(!is(typeof(ZLIB_VER_REVISION))) {
        enum ZLIB_VER_REVISION = 13;
    }




    static if(!is(typeof(ZLIB_VER_SUBREVISION))) {
        enum ZLIB_VER_SUBREVISION = 0;
    }







    static if(!is(typeof(_STRING_H))) {
        enum _STRING_H = 1;
    }







    static if(!is(typeof(MB_CUR_MAX))) {
        private enum enumMixinStr_MB_CUR_MAX = `enum MB_CUR_MAX = ( __ctype_get_mb_cur_max ( ) );`;
        static if(is(typeof({ mixin(enumMixinStr_MB_CUR_MAX); }))) {
            mixin(enumMixinStr_MB_CUR_MAX);
        }
    }




    static if(!is(typeof(EXIT_SUCCESS))) {
        enum EXIT_SUCCESS = 0;
    }




    static if(!is(typeof(EXIT_FAILURE))) {
        enum EXIT_FAILURE = 1;
    }




    static if(!is(typeof(RAND_MAX))) {
        enum RAND_MAX = 2147483647;
    }




    static if(!is(typeof(__lldiv_t_defined))) {
        enum __lldiv_t_defined = 1;
    }




    static if(!is(typeof(__ldiv_t_defined))) {
        enum __ldiv_t_defined = 1;
    }
    static if(!is(typeof(Z_NO_FLUSH))) {
        enum Z_NO_FLUSH = 0;
    }




    static if(!is(typeof(Z_PARTIAL_FLUSH))) {
        enum Z_PARTIAL_FLUSH = 1;
    }




    static if(!is(typeof(Z_SYNC_FLUSH))) {
        enum Z_SYNC_FLUSH = 2;
    }




    static if(!is(typeof(Z_FULL_FLUSH))) {
        enum Z_FULL_FLUSH = 3;
    }




    static if(!is(typeof(Z_FINISH))) {
        enum Z_FINISH = 4;
    }




    static if(!is(typeof(Z_BLOCK))) {
        enum Z_BLOCK = 5;
    }




    static if(!is(typeof(Z_TREES))) {
        enum Z_TREES = 6;
    }




    static if(!is(typeof(Z_OK))) {
        enum Z_OK = 0;
    }




    static if(!is(typeof(Z_STREAM_END))) {
        enum Z_STREAM_END = 1;
    }




    static if(!is(typeof(Z_NEED_DICT))) {
        enum Z_NEED_DICT = 2;
    }




    static if(!is(typeof(Z_ERRNO))) {
        private enum enumMixinStr_Z_ERRNO = `enum Z_ERRNO = ( - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_Z_ERRNO); }))) {
            mixin(enumMixinStr_Z_ERRNO);
        }
    }




    static if(!is(typeof(Z_STREAM_ERROR))) {
        private enum enumMixinStr_Z_STREAM_ERROR = `enum Z_STREAM_ERROR = ( - 2 );`;
        static if(is(typeof({ mixin(enumMixinStr_Z_STREAM_ERROR); }))) {
            mixin(enumMixinStr_Z_STREAM_ERROR);
        }
    }




    static if(!is(typeof(Z_DATA_ERROR))) {
        private enum enumMixinStr_Z_DATA_ERROR = `enum Z_DATA_ERROR = ( - 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_Z_DATA_ERROR); }))) {
            mixin(enumMixinStr_Z_DATA_ERROR);
        }
    }




    static if(!is(typeof(Z_MEM_ERROR))) {
        private enum enumMixinStr_Z_MEM_ERROR = `enum Z_MEM_ERROR = ( - 4 );`;
        static if(is(typeof({ mixin(enumMixinStr_Z_MEM_ERROR); }))) {
            mixin(enumMixinStr_Z_MEM_ERROR);
        }
    }




    static if(!is(typeof(Z_BUF_ERROR))) {
        private enum enumMixinStr_Z_BUF_ERROR = `enum Z_BUF_ERROR = ( - 5 );`;
        static if(is(typeof({ mixin(enumMixinStr_Z_BUF_ERROR); }))) {
            mixin(enumMixinStr_Z_BUF_ERROR);
        }
    }




    static if(!is(typeof(Z_VERSION_ERROR))) {
        private enum enumMixinStr_Z_VERSION_ERROR = `enum Z_VERSION_ERROR = ( - 6 );`;
        static if(is(typeof({ mixin(enumMixinStr_Z_VERSION_ERROR); }))) {
            mixin(enumMixinStr_Z_VERSION_ERROR);
        }
    }




    static if(!is(typeof(Z_NO_COMPRESSION))) {
        enum Z_NO_COMPRESSION = 0;
    }




    static if(!is(typeof(Z_BEST_SPEED))) {
        enum Z_BEST_SPEED = 1;
    }




    static if(!is(typeof(Z_BEST_COMPRESSION))) {
        enum Z_BEST_COMPRESSION = 9;
    }




    static if(!is(typeof(Z_DEFAULT_COMPRESSION))) {
        private enum enumMixinStr_Z_DEFAULT_COMPRESSION = `enum Z_DEFAULT_COMPRESSION = ( - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_Z_DEFAULT_COMPRESSION); }))) {
            mixin(enumMixinStr_Z_DEFAULT_COMPRESSION);
        }
    }




    static if(!is(typeof(Z_FILTERED))) {
        enum Z_FILTERED = 1;
    }




    static if(!is(typeof(Z_HUFFMAN_ONLY))) {
        enum Z_HUFFMAN_ONLY = 2;
    }




    static if(!is(typeof(Z_RLE))) {
        enum Z_RLE = 3;
    }




    static if(!is(typeof(Z_FIXED))) {
        enum Z_FIXED = 4;
    }




    static if(!is(typeof(Z_DEFAULT_STRATEGY))) {
        enum Z_DEFAULT_STRATEGY = 0;
    }




    static if(!is(typeof(Z_BINARY))) {
        enum Z_BINARY = 0;
    }




    static if(!is(typeof(Z_TEXT))) {
        enum Z_TEXT = 1;
    }




    static if(!is(typeof(Z_ASCII))) {
        private enum enumMixinStr_Z_ASCII = `enum Z_ASCII = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_Z_ASCII); }))) {
            mixin(enumMixinStr_Z_ASCII);
        }
    }




    static if(!is(typeof(Z_UNKNOWN))) {
        enum Z_UNKNOWN = 2;
    }




    static if(!is(typeof(Z_DEFLATED))) {
        enum Z_DEFLATED = 8;
    }




    static if(!is(typeof(Z_NULL))) {
        enum Z_NULL = 0;
    }




    static if(!is(typeof(zlib_version))) {
        private enum enumMixinStr_zlib_version = `enum zlib_version = zlibVersion ( );`;
        static if(is(typeof({ mixin(enumMixinStr_zlib_version); }))) {
            mixin(enumMixinStr_zlib_version);
        }
    }




    static if(!is(typeof(_STDLIB_H))) {
        enum _STDLIB_H = 1;
    }







    static if(!is(typeof(__attr_dealloc_fclose))) {
        private enum enumMixinStr___attr_dealloc_fclose = `enum __attr_dealloc_fclose = ;`;
        static if(is(typeof({ mixin(enumMixinStr___attr_dealloc_fclose); }))) {
            mixin(enumMixinStr___attr_dealloc_fclose);
        }
    }




    static if(!is(typeof(stderr))) {
        private enum enumMixinStr_stderr = `enum stderr = stderr;`;
        static if(is(typeof({ mixin(enumMixinStr_stderr); }))) {
            mixin(enumMixinStr_stderr);
        }
    }




    static if(!is(typeof(stdout))) {
        private enum enumMixinStr_stdout = `enum stdout = stdout;`;
        static if(is(typeof({ mixin(enumMixinStr_stdout); }))) {
            mixin(enumMixinStr_stdout);
        }
    }




    static if(!is(typeof(stdin))) {
        private enum enumMixinStr_stdin = `enum stdin = stdin;`;
        static if(is(typeof({ mixin(enumMixinStr_stdin); }))) {
            mixin(enumMixinStr_stdin);
        }
    }




    static if(!is(typeof(P_tmpdir))) {
        enum P_tmpdir = "/tmp";
    }




    static if(!is(typeof(SEEK_END))) {
        enum SEEK_END = 2;
    }




    static if(!is(typeof(SEEK_CUR))) {
        enum SEEK_CUR = 1;
    }




    static if(!is(typeof(SEEK_SET))) {
        enum SEEK_SET = 0;
    }




    static if(!is(typeof(EOF))) {
        private enum enumMixinStr_EOF = `enum EOF = ( - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_EOF); }))) {
            mixin(enumMixinStr_EOF);
        }
    }




    static if(!is(typeof(BUFSIZ))) {
        enum BUFSIZ = 8192;
    }




    static if(!is(typeof(_IONBF))) {
        enum _IONBF = 2;
    }




    static if(!is(typeof(_IOLBF))) {
        enum _IOLBF = 1;
    }




    static if(!is(typeof(_IOFBF))) {
        enum _IOFBF = 0;
    }
    static if(!is(typeof(_STDIO_H))) {
        enum _STDIO_H = 1;
    }
    static if(!is(typeof(WINT_MAX))) {
        private enum enumMixinStr_WINT_MAX = `enum WINT_MAX = ( 4294967295u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MAX); }))) {
            mixin(enumMixinStr_WINT_MAX);
        }
    }




    static if(!is(typeof(WINT_MIN))) {
        private enum enumMixinStr_WINT_MIN = `enum WINT_MIN = ( 0u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MIN); }))) {
            mixin(enumMixinStr_WINT_MIN);
        }
    }




    static if(!is(typeof(WCHAR_MAX))) {
        private enum enumMixinStr_WCHAR_MAX = `enum WCHAR_MAX = __WCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MAX); }))) {
            mixin(enumMixinStr_WCHAR_MAX);
        }
    }




    static if(!is(typeof(WCHAR_MIN))) {
        private enum enumMixinStr_WCHAR_MIN = `enum WCHAR_MIN = __WCHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MIN); }))) {
            mixin(enumMixinStr_WCHAR_MIN);
        }
    }




    static if(!is(typeof(SIZE_MAX))) {
        private enum enumMixinStr_SIZE_MAX = `enum SIZE_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_SIZE_MAX); }))) {
            mixin(enumMixinStr_SIZE_MAX);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MAX))) {
        private enum enumMixinStr_SIG_ATOMIC_MAX = `enum SIG_ATOMIC_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MAX); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MAX);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MIN))) {
        private enum enumMixinStr_SIG_ATOMIC_MIN = `enum SIG_ATOMIC_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MIN); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MIN);
        }
    }




    static if(!is(typeof(PTRDIFF_MAX))) {
        private enum enumMixinStr_PTRDIFF_MAX = `enum PTRDIFF_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MAX); }))) {
            mixin(enumMixinStr_PTRDIFF_MAX);
        }
    }




    static if(!is(typeof(PTRDIFF_MIN))) {
        private enum enumMixinStr_PTRDIFF_MIN = `enum PTRDIFF_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MIN); }))) {
            mixin(enumMixinStr_PTRDIFF_MIN);
        }
    }




    static if(!is(typeof(UINTMAX_MAX))) {
        private enum enumMixinStr_UINTMAX_MAX = `enum UINTMAX_MAX = ( __UINT64_C ( 18446744073709551615 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTMAX_MAX); }))) {
            mixin(enumMixinStr_UINTMAX_MAX);
        }
    }




    static if(!is(typeof(INTMAX_MAX))) {
        private enum enumMixinStr_INTMAX_MAX = `enum INTMAX_MAX = ( __INT64_C ( 9223372036854775807 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MAX); }))) {
            mixin(enumMixinStr_INTMAX_MAX);
        }
    }




    static if(!is(typeof(INTMAX_MIN))) {
        private enum enumMixinStr_INTMAX_MIN = `enum INTMAX_MIN = ( - __INT64_C ( 9223372036854775807 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MIN); }))) {
            mixin(enumMixinStr_INTMAX_MIN);
        }
    }




    static if(!is(typeof(UINTPTR_MAX))) {
        private enum enumMixinStr_UINTPTR_MAX = `enum UINTPTR_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTPTR_MAX); }))) {
            mixin(enumMixinStr_UINTPTR_MAX);
        }
    }




    static if(!is(typeof(INTPTR_MAX))) {
        private enum enumMixinStr_INTPTR_MAX = `enum INTPTR_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MAX); }))) {
            mixin(enumMixinStr_INTPTR_MAX);
        }
    }




    static if(!is(typeof(INTPTR_MIN))) {
        private enum enumMixinStr_INTPTR_MIN = `enum INTPTR_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MIN); }))) {
            mixin(enumMixinStr_INTPTR_MIN);
        }
    }




    static if(!is(typeof(UINT_FAST64_MAX))) {
        private enum enumMixinStr_UINT_FAST64_MAX = `enum UINT_FAST64_MAX = ( __UINT64_C ( 18446744073709551615 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST32_MAX))) {
        private enum enumMixinStr_UINT_FAST32_MAX = `enum UINT_FAST32_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST16_MAX))) {
        private enum enumMixinStr_UINT_FAST16_MAX = `enum UINT_FAST16_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST8_MAX))) {
        private enum enumMixinStr_UINT_FAST8_MAX = `enum UINT_FAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST8_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MAX))) {
        private enum enumMixinStr_INT_FAST64_MAX = `enum INT_FAST64_MAX = ( __INT64_C ( 9223372036854775807 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MAX); }))) {
            mixin(enumMixinStr_INT_FAST64_MAX);
        }
    }




    static if(!is(typeof(INT_FAST32_MAX))) {
        private enum enumMixinStr_INT_FAST32_MAX = `enum INT_FAST32_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MAX); }))) {
            mixin(enumMixinStr_INT_FAST32_MAX);
        }
    }




    static if(!is(typeof(INT_FAST16_MAX))) {
        private enum enumMixinStr_INT_FAST16_MAX = `enum INT_FAST16_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MAX); }))) {
            mixin(enumMixinStr_INT_FAST16_MAX);
        }
    }




    static if(!is(typeof(INT_FAST8_MAX))) {
        private enum enumMixinStr_INT_FAST8_MAX = `enum INT_FAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MAX); }))) {
            mixin(enumMixinStr_INT_FAST8_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MIN))) {
        private enum enumMixinStr_INT_FAST64_MIN = `enum INT_FAST64_MIN = ( - __INT64_C ( 9223372036854775807 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MIN); }))) {
            mixin(enumMixinStr_INT_FAST64_MIN);
        }
    }




    static if(!is(typeof(INT_FAST32_MIN))) {
        private enum enumMixinStr_INT_FAST32_MIN = `enum INT_FAST32_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MIN); }))) {
            mixin(enumMixinStr_INT_FAST32_MIN);
        }
    }




    static if(!is(typeof(INT_FAST16_MIN))) {
        private enum enumMixinStr_INT_FAST16_MIN = `enum INT_FAST16_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MIN); }))) {
            mixin(enumMixinStr_INT_FAST16_MIN);
        }
    }




    static if(!is(typeof(INT_FAST8_MIN))) {
        private enum enumMixinStr_INT_FAST8_MIN = `enum INT_FAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MIN); }))) {
            mixin(enumMixinStr_INT_FAST8_MIN);
        }
    }




    static if(!is(typeof(UINT_LEAST64_MAX))) {
        private enum enumMixinStr_UINT_LEAST64_MAX = `enum UINT_LEAST64_MAX = ( __UINT64_C ( 18446744073709551615 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST32_MAX))) {
        private enum enumMixinStr_UINT_LEAST32_MAX = `enum UINT_LEAST32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST16_MAX))) {
        private enum enumMixinStr_UINT_LEAST16_MAX = `enum UINT_LEAST16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST8_MAX))) {
        private enum enumMixinStr_UINT_LEAST8_MAX = `enum UINT_LEAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MAX))) {
        private enum enumMixinStr_INT_LEAST64_MAX = `enum INT_LEAST64_MAX = ( __INT64_C ( 9223372036854775807 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST32_MAX))) {
        private enum enumMixinStr_INT_LEAST32_MAX = `enum INT_LEAST32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST16_MAX))) {
        private enum enumMixinStr_INT_LEAST16_MAX = `enum INT_LEAST16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST8_MAX))) {
        private enum enumMixinStr_INT_LEAST8_MAX = `enum INT_LEAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MIN))) {
        private enum enumMixinStr_INT_LEAST64_MIN = `enum INT_LEAST64_MIN = ( - __INT64_C ( 9223372036854775807 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST64_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST32_MIN))) {
        private enum enumMixinStr_INT_LEAST32_MIN = `enum INT_LEAST32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST32_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST16_MIN))) {
        private enum enumMixinStr_INT_LEAST16_MIN = `enum INT_LEAST16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST16_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST8_MIN))) {
        private enum enumMixinStr_INT_LEAST8_MIN = `enum INT_LEAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST8_MIN);
        }
    }




    static if(!is(typeof(UINT64_MAX))) {
        private enum enumMixinStr_UINT64_MAX = `enum UINT64_MAX = ( __UINT64_C ( 18446744073709551615 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT64_MAX); }))) {
            mixin(enumMixinStr_UINT64_MAX);
        }
    }




    static if(!is(typeof(UINT32_MAX))) {
        private enum enumMixinStr_UINT32_MAX = `enum UINT32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT32_MAX); }))) {
            mixin(enumMixinStr_UINT32_MAX);
        }
    }




    static if(!is(typeof(UINT16_MAX))) {
        private enum enumMixinStr_UINT16_MAX = `enum UINT16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT16_MAX); }))) {
            mixin(enumMixinStr_UINT16_MAX);
        }
    }




    static if(!is(typeof(UINT8_MAX))) {
        private enum enumMixinStr_UINT8_MAX = `enum UINT8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT8_MAX); }))) {
            mixin(enumMixinStr_UINT8_MAX);
        }
    }




    static if(!is(typeof(INT64_MAX))) {
        private enum enumMixinStr_INT64_MAX = `enum INT64_MAX = ( __INT64_C ( 9223372036854775807 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MAX); }))) {
            mixin(enumMixinStr_INT64_MAX);
        }
    }




    static if(!is(typeof(INT32_MAX))) {
        private enum enumMixinStr_INT32_MAX = `enum INT32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MAX); }))) {
            mixin(enumMixinStr_INT32_MAX);
        }
    }




    static if(!is(typeof(INT16_MAX))) {
        private enum enumMixinStr_INT16_MAX = `enum INT16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MAX); }))) {
            mixin(enumMixinStr_INT16_MAX);
        }
    }




    static if(!is(typeof(INT8_MAX))) {
        private enum enumMixinStr_INT8_MAX = `enum INT8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MAX); }))) {
            mixin(enumMixinStr_INT8_MAX);
        }
    }




    static if(!is(typeof(INT64_MIN))) {
        private enum enumMixinStr_INT64_MIN = `enum INT64_MIN = ( - __INT64_C ( 9223372036854775807 ) - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MIN); }))) {
            mixin(enumMixinStr_INT64_MIN);
        }
    }




    static if(!is(typeof(INT32_MIN))) {
        private enum enumMixinStr_INT32_MIN = `enum INT32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MIN); }))) {
            mixin(enumMixinStr_INT32_MIN);
        }
    }




    static if(!is(typeof(INT16_MIN))) {
        private enum enumMixinStr_INT16_MIN = `enum INT16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MIN); }))) {
            mixin(enumMixinStr_INT16_MIN);
        }
    }




    static if(!is(typeof(INT8_MIN))) {
        private enum enumMixinStr_INT8_MIN = `enum INT8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MIN); }))) {
            mixin(enumMixinStr_INT8_MIN);
        }
    }
    static if(!is(typeof(_STDINT_H))) {
        enum _STDINT_H = 1;
    }




    static if(!is(typeof(_STDC_PREDEF_H))) {
        enum _STDC_PREDEF_H = 1;
    }




    static if(!is(typeof(RTSIG_MAX))) {
        enum RTSIG_MAX = 32;
    }




    static if(!is(typeof(XATTR_LIST_MAX))) {
        enum XATTR_LIST_MAX = 65536;
    }




    static if(!is(typeof(XATTR_SIZE_MAX))) {
        enum XATTR_SIZE_MAX = 65536;
    }




    static if(!is(typeof(XATTR_NAME_MAX))) {
        enum XATTR_NAME_MAX = 255;
    }




    static if(!is(typeof(PIPE_BUF))) {
        enum PIPE_BUF = 4096;
    }




    static if(!is(typeof(PATH_MAX))) {
        enum PATH_MAX = 4096;
    }




    static if(!is(typeof(NAME_MAX))) {
        enum NAME_MAX = 255;
    }




    static if(!is(typeof(MAX_INPUT))) {
        enum MAX_INPUT = 255;
    }




    static if(!is(typeof(MAX_CANON))) {
        enum MAX_CANON = 255;
    }




    static if(!is(typeof(LINK_MAX))) {
        enum LINK_MAX = 127;
    }




    static if(!is(typeof(ARG_MAX))) {
        enum ARG_MAX = 131072;
    }




    static if(!is(typeof(NGROUPS_MAX))) {
        enum NGROUPS_MAX = 65536;
    }




    static if(!is(typeof(NR_OPEN))) {
        enum NR_OPEN = 1024;
    }







    static if(!is(typeof(ULLONG_MAX))) {
        private enum enumMixinStr_ULLONG_MAX = `enum ULLONG_MAX = ( LLONG_MAX * 2LU + 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_ULLONG_MAX); }))) {
            mixin(enumMixinStr_ULLONG_MAX);
        }
    }




    static if(!is(typeof(LLONG_MAX))) {
        private enum enumMixinStr_LLONG_MAX = `enum LLONG_MAX = 9223372036854775807LL;`;
        static if(is(typeof({ mixin(enumMixinStr_LLONG_MAX); }))) {
            mixin(enumMixinStr_LLONG_MAX);
        }
    }




    static if(!is(typeof(LLONG_MIN))) {
        private enum enumMixinStr_LLONG_MIN = `enum LLONG_MIN = ( - 9223372036854775807LL - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_LLONG_MIN); }))) {
            mixin(enumMixinStr_LLONG_MIN);
        }
    }




    static if(!is(typeof(MB_LEN_MAX))) {
        enum MB_LEN_MAX = 16;
    }




    static if(!is(typeof(_LIBC_LIMITS_H_))) {
        enum _LIBC_LIMITS_H_ = 1;
    }
    static if(!is(typeof(__GLIBC_MINOR__))) {
        enum __GLIBC_MINOR__ = 37;
    }




    static if(!is(typeof(__GLIBC__))) {
        enum __GLIBC__ = 2;
    }




    static if(!is(typeof(__GNU_LIBRARY__))) {
        enum __GNU_LIBRARY__ = 6;
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_SCANF))) {
        enum __GLIBC_USE_DEPRECATED_SCANF = 0;
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_GETS))) {
        enum __GLIBC_USE_DEPRECATED_GETS = 0;
    }




    static if(!is(typeof(__USE_FORTIFY_LEVEL))) {
        enum __USE_FORTIFY_LEVEL = 0;
    }




    static if(!is(typeof(__USE_ATFILE))) {
        enum __USE_ATFILE = 1;
    }




    static if(!is(typeof(__USE_MISC))) {
        enum __USE_MISC = 1;
    }




    static if(!is(typeof(_ATFILE_SOURCE))) {
        enum _ATFILE_SOURCE = 1;
    }




    static if(!is(typeof(__USE_XOPEN2K8))) {
        enum __USE_XOPEN2K8 = 1;
    }




    static if(!is(typeof(__USE_ISOC99))) {
        enum __USE_ISOC99 = 1;
    }




    static if(!is(typeof(__USE_ISOC95))) {
        enum __USE_ISOC95 = 1;
    }




    static if(!is(typeof(__USE_XOPEN2K))) {
        enum __USE_XOPEN2K = 1;
    }




    static if(!is(typeof(__USE_POSIX199506))) {
        enum __USE_POSIX199506 = 1;
    }




    static if(!is(typeof(__USE_POSIX199309))) {
        enum __USE_POSIX199309 = 1;
    }




    static if(!is(typeof(__USE_POSIX2))) {
        enum __USE_POSIX2 = 1;
    }




    static if(!is(typeof(__USE_POSIX))) {
        enum __USE_POSIX = 1;
    }




    static if(!is(typeof(_POSIX_C_SOURCE))) {
        enum _POSIX_C_SOURCE = 200809L;
    }




    static if(!is(typeof(_POSIX_SOURCE))) {
        enum _POSIX_SOURCE = 1;
    }




    static if(!is(typeof(__USE_POSIX_IMPLICITLY))) {
        enum __USE_POSIX_IMPLICITLY = 1;
    }




    static if(!is(typeof(__USE_ISOC11))) {
        enum __USE_ISOC11 = 1;
    }




    static if(!is(typeof(__GLIBC_USE_ISOC2X))) {
        enum __GLIBC_USE_ISOC2X = 0;
    }




    static if(!is(typeof(_DEFAULT_SOURCE))) {
        enum _DEFAULT_SOURCE = 1;
    }
    static if(!is(typeof(_FEATURES_H))) {
        enum _FEATURES_H = 1;
    }




    static if(!is(typeof(errno))) {
        private enum enumMixinStr_errno = `enum errno = ( * __errno_location ( ) );`;
        static if(is(typeof({ mixin(enumMixinStr_errno); }))) {
            mixin(enumMixinStr_errno);
        }
    }




    static if(!is(typeof(_ERRNO_H))) {
        enum _ERRNO_H = 1;
    }
    static if(!is(typeof(BYTE_ORDER))) {
        private enum enumMixinStr_BYTE_ORDER = `enum BYTE_ORDER = __BYTE_ORDER;`;
        static if(is(typeof({ mixin(enumMixinStr_BYTE_ORDER); }))) {
            mixin(enumMixinStr_BYTE_ORDER);
        }
    }




    static if(!is(typeof(PDP_ENDIAN))) {
        private enum enumMixinStr_PDP_ENDIAN = `enum PDP_ENDIAN = __PDP_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_PDP_ENDIAN); }))) {
            mixin(enumMixinStr_PDP_ENDIAN);
        }
    }




    static if(!is(typeof(BIG_ENDIAN))) {
        private enum enumMixinStr_BIG_ENDIAN = `enum BIG_ENDIAN = __BIG_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_BIG_ENDIAN); }))) {
            mixin(enumMixinStr_BIG_ENDIAN);
        }
    }




    static if(!is(typeof(LITTLE_ENDIAN))) {
        private enum enumMixinStr_LITTLE_ENDIAN = `enum LITTLE_ENDIAN = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr_LITTLE_ENDIAN); }))) {
            mixin(enumMixinStr_LITTLE_ENDIAN);
        }
    }




    static if(!is(typeof(_ENDIAN_H))) {
        enum _ENDIAN_H = 1;
    }
    static if(!is(typeof(_CTYPE_H))) {
        enum _CTYPE_H = 1;
    }




    static if(!is(typeof(__SYSCALL_WORDSIZE))) {
        enum __SYSCALL_WORDSIZE = 64;
    }




    static if(!is(typeof(__WORDSIZE_TIME64_COMPAT32))) {
        enum __WORDSIZE_TIME64_COMPAT32 = 1;
    }




    static if(!is(typeof(__WORDSIZE))) {
        enum __WORDSIZE = 64;
    }




    static if(!is(typeof(__WCHAR_MIN))) {
        private enum enumMixinStr___WCHAR_MIN = `enum __WCHAR_MIN = ( - __WCHAR_MAX - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MIN); }))) {
            mixin(enumMixinStr___WCHAR_MIN);
        }
    }




    static if(!is(typeof(__WCHAR_MAX))) {
        private enum enumMixinStr___WCHAR_MAX = `enum __WCHAR_MAX = 2147483647;`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MAX); }))) {
            mixin(enumMixinStr___WCHAR_MAX);
        }
    }




    static if(!is(typeof(_BITS_WCHAR_H))) {
        enum _BITS_WCHAR_H = 1;
    }




    static if(!is(typeof(__WCOREFLAG))) {
        enum __WCOREFLAG = 0x80;
    }




    static if(!is(typeof(__W_CONTINUED))) {
        enum __W_CONTINUED = 0xffff;
    }
    static if(!is(typeof(__WCLONE))) {
        enum __WCLONE = 0x80000000;
    }




    static if(!is(typeof(__WALL))) {
        enum __WALL = 0x40000000;
    }




    static if(!is(typeof(__WNOTHREAD))) {
        enum __WNOTHREAD = 0x20000000;
    }




    static if(!is(typeof(WNOWAIT))) {
        enum WNOWAIT = 0x01000000;
    }




    static if(!is(typeof(WCONTINUED))) {
        enum WCONTINUED = 8;
    }







    static if(!is(typeof(WEXITED))) {
        enum WEXITED = 4;
    }




    static if(!is(typeof(WSTOPPED))) {
        enum WSTOPPED = 2;
    }




    static if(!is(typeof(WUNTRACED))) {
        enum WUNTRACED = 2;
    }




    static if(!is(typeof(WNOHANG))) {
        enum WNOHANG = 1;
    }




    static if(!is(typeof(_BITS_UINTN_IDENTITY_H))) {
        enum _BITS_UINTN_IDENTITY_H = 1;
    }




    static if(!is(typeof(__FD_SETSIZE))) {
        enum __FD_SETSIZE = 1024;
    }




    static if(!is(typeof(__KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64))) {
        enum __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = 1;
    }




    static if(!is(typeof(__STATFS_MATCHES_STATFS64))) {
        enum __STATFS_MATCHES_STATFS64 = 1;
    }




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        enum __RLIM_T_MATCHES_RLIM64_T = 1;
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        enum __INO_T_MATCHES_INO64_T = 1;
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        enum __OFF_T_MATCHES_OFF64_T = 1;
    }




    static if(!is(typeof(__CPU_MASK_TYPE))) {
        private enum enumMixinStr___CPU_MASK_TYPE = `enum __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___CPU_MASK_TYPE); }))) {
            mixin(enumMixinStr___CPU_MASK_TYPE);
        }
    }




    static if(!is(typeof(__SSIZE_T_TYPE))) {
        private enum enumMixinStr___SSIZE_T_TYPE = `enum __SSIZE_T_TYPE = __SWORD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___SSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___SSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__FSID_T_TYPE))) {
        private enum enumMixinStr___FSID_T_TYPE = `enum __FSID_T_TYPE = { int __val [ 2 ] ; };`;
        static if(is(typeof({ mixin(enumMixinStr___FSID_T_TYPE); }))) {
            mixin(enumMixinStr___FSID_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKSIZE_T_TYPE))) {
        private enum enumMixinStr___BLKSIZE_T_TYPE = `enum __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___BLKSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__TIMER_T_TYPE))) {
        private enum enumMixinStr___TIMER_T_TYPE = `enum __TIMER_T_TYPE = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMER_T_TYPE); }))) {
            mixin(enumMixinStr___TIMER_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCKID_T_TYPE))) {
        private enum enumMixinStr___CLOCKID_T_TYPE = `enum __CLOCKID_T_TYPE = __S32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCKID_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCKID_T_TYPE);
        }
    }




    static if(!is(typeof(__KEY_T_TYPE))) {
        private enum enumMixinStr___KEY_T_TYPE = `enum __KEY_T_TYPE = __S32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___KEY_T_TYPE); }))) {
            mixin(enumMixinStr___KEY_T_TYPE);
        }
    }




    static if(!is(typeof(__DADDR_T_TYPE))) {
        private enum enumMixinStr___DADDR_T_TYPE = `enum __DADDR_T_TYPE = __S32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___DADDR_T_TYPE); }))) {
            mixin(enumMixinStr___DADDR_T_TYPE);
        }
    }




    static if(!is(typeof(__SUSECONDS64_T_TYPE))) {
        private enum enumMixinStr___SUSECONDS64_T_TYPE = `enum __SUSECONDS64_T_TYPE = __SQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___SUSECONDS64_T_TYPE); }))) {
            mixin(enumMixinStr___SUSECONDS64_T_TYPE);
        }
    }




    static if(!is(typeof(__SUSECONDS_T_TYPE))) {
        private enum enumMixinStr___SUSECONDS_T_TYPE = `enum __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___SUSECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___SUSECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__USECONDS_T_TYPE))) {
        private enum enumMixinStr___USECONDS_T_TYPE = `enum __USECONDS_T_TYPE = __U32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___USECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___USECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__TIME_T_TYPE))) {
        private enum enumMixinStr___TIME_T_TYPE = `enum __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME_T_TYPE); }))) {
            mixin(enumMixinStr___TIME_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCK_T_TYPE))) {
        private enum enumMixinStr___CLOCK_T_TYPE = `enum __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCK_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCK_T_TYPE);
        }
    }




    static if(!is(typeof(__ID_T_TYPE))) {
        private enum enumMixinStr___ID_T_TYPE = `enum __ID_T_TYPE = __U32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___ID_T_TYPE); }))) {
            mixin(enumMixinStr___ID_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT64_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT64_T_TYPE = `enum __FSFILCNT64_T_TYPE = __UQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT_T_TYPE = `enum __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT64_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT64_T_TYPE = `enum __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT_T_TYPE = `enum __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT64_T_TYPE))) {
        private enum enumMixinStr___BLKCNT64_T_TYPE = `enum __BLKCNT64_T_TYPE = __SQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT_T_TYPE))) {
        private enum enumMixinStr___BLKCNT_T_TYPE = `enum __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM64_T_TYPE))) {
        private enum enumMixinStr___RLIM64_T_TYPE = `enum __RLIM64_T_TYPE = __UQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM64_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM64_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM_T_TYPE))) {
        private enum enumMixinStr___RLIM_T_TYPE = `enum __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM_T_TYPE);
        }
    }




    static if(!is(typeof(__PID_T_TYPE))) {
        private enum enumMixinStr___PID_T_TYPE = `enum __PID_T_TYPE = __S32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___PID_T_TYPE); }))) {
            mixin(enumMixinStr___PID_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF64_T_TYPE))) {
        private enum enumMixinStr___OFF64_T_TYPE = `enum __OFF64_T_TYPE = __SQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF64_T_TYPE); }))) {
            mixin(enumMixinStr___OFF64_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_TYPE))) {
        private enum enumMixinStr___OFF_T_TYPE = `enum __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_TYPE); }))) {
            mixin(enumMixinStr___OFF_T_TYPE);
        }
    }




    static if(!is(typeof(__FSWORD_T_TYPE))) {
        private enum enumMixinStr___FSWORD_T_TYPE = `enum __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___FSWORD_T_TYPE); }))) {
            mixin(enumMixinStr___FSWORD_T_TYPE);
        }
    }




    static if(!is(typeof(__NLINK_T_TYPE))) {
        private enum enumMixinStr___NLINK_T_TYPE = `enum __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___NLINK_T_TYPE); }))) {
            mixin(enumMixinStr___NLINK_T_TYPE);
        }
    }




    static if(!is(typeof(__MODE_T_TYPE))) {
        private enum enumMixinStr___MODE_T_TYPE = `enum __MODE_T_TYPE = __U32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___MODE_T_TYPE); }))) {
            mixin(enumMixinStr___MODE_T_TYPE);
        }
    }




    static if(!is(typeof(__INO64_T_TYPE))) {
        private enum enumMixinStr___INO64_T_TYPE = `enum __INO64_T_TYPE = __UQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___INO64_T_TYPE); }))) {
            mixin(enumMixinStr___INO64_T_TYPE);
        }
    }




    static if(!is(typeof(__INO_T_TYPE))) {
        private enum enumMixinStr___INO_T_TYPE = `enum __INO_T_TYPE = __SYSCALL_ULONG_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_TYPE); }))) {
            mixin(enumMixinStr___INO_T_TYPE);
        }
    }




    static if(!is(typeof(__GID_T_TYPE))) {
        private enum enumMixinStr___GID_T_TYPE = `enum __GID_T_TYPE = __U32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___GID_T_TYPE); }))) {
            mixin(enumMixinStr___GID_T_TYPE);
        }
    }




    static if(!is(typeof(__UID_T_TYPE))) {
        private enum enumMixinStr___UID_T_TYPE = `enum __UID_T_TYPE = __U32_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___UID_T_TYPE); }))) {
            mixin(enumMixinStr___UID_T_TYPE);
        }
    }




    static if(!is(typeof(__DEV_T_TYPE))) {
        private enum enumMixinStr___DEV_T_TYPE = `enum __DEV_T_TYPE = __UQUAD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___DEV_T_TYPE); }))) {
            mixin(enumMixinStr___DEV_T_TYPE);
        }
    }




    static if(!is(typeof(__SYSCALL_ULONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_ULONG_TYPE = `enum __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_ULONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_ULONG_TYPE);
        }
    }




    static if(!is(typeof(__SYSCALL_SLONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_SLONG_TYPE = `enum __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_SLONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_SLONG_TYPE);
        }
    }




    static if(!is(typeof(_BITS_TYPESIZES_H))) {
        enum _BITS_TYPESIZES_H = 1;
    }




    static if(!is(typeof(__timer_t_defined))) {
        enum __timer_t_defined = 1;
    }




    static if(!is(typeof(__time_t_defined))) {
        enum __time_t_defined = 1;
    }




    static if(!is(typeof(__struct_tm_defined))) {
        enum __struct_tm_defined = 1;
    }




    static if(!is(typeof(__timeval_defined))) {
        enum __timeval_defined = 1;
    }




    static if(!is(typeof(_STRUCT_TIMESPEC))) {
        enum _STRUCT_TIMESPEC = 1;
    }




    static if(!is(typeof(__itimerspec_defined))) {
        enum __itimerspec_defined = 1;
    }




    static if(!is(typeof(_IO_USER_LOCK))) {
        enum _IO_USER_LOCK = 0x8000;
    }







    static if(!is(typeof(_IO_ERR_SEEN))) {
        enum _IO_ERR_SEEN = 0x0020;
    }







    static if(!is(typeof(_IO_EOF_SEEN))) {
        enum _IO_EOF_SEEN = 0x0010;
    }
    static if(!is(typeof(__struct_FILE_defined))) {
        enum __struct_FILE_defined = 1;
    }




    static if(!is(typeof(__sigset_t_defined))) {
        enum __sigset_t_defined = 1;
    }




    static if(!is(typeof(_BITS_TYPES_LOCALE_T_H))) {
        enum _BITS_TYPES_LOCALE_T_H = 1;
    }




    static if(!is(typeof(__clockid_t_defined))) {
        enum __clockid_t_defined = 1;
    }




    static if(!is(typeof(__clock_t_defined))) {
        enum __clock_t_defined = 1;
    }




    static if(!is(typeof(_SIGSET_NWORDS))) {
        private enum enumMixinStr__SIGSET_NWORDS = `enum _SIGSET_NWORDS = ( 1024 / ( 8 * ( unsigned long int ) .sizeof ) );`;
        static if(is(typeof({ mixin(enumMixinStr__SIGSET_NWORDS); }))) {
            mixin(enumMixinStr__SIGSET_NWORDS);
        }
    }







    static if(!is(typeof(____mbstate_t_defined))) {
        enum ____mbstate_t_defined = 1;
    }




    static if(!is(typeof(_BITS_TYPES___LOCALE_T_H))) {
        enum _BITS_TYPES___LOCALE_T_H = 1;
    }




    static if(!is(typeof(_____fpos_t_defined))) {
        enum _____fpos_t_defined = 1;
    }




    static if(!is(typeof(_____fpos64_t_defined))) {
        enum _____fpos64_t_defined = 1;
    }




    static if(!is(typeof(____FILE_defined))) {
        enum ____FILE_defined = 1;
    }




    static if(!is(typeof(__FILE_defined))) {
        enum __FILE_defined = 1;
    }




    static if(!is(typeof(__STD_TYPE))) {
        private enum enumMixinStr___STD_TYPE = `enum __STD_TYPE = typedef;`;
        static if(is(typeof({ mixin(enumMixinStr___STD_TYPE); }))) {
            mixin(enumMixinStr___STD_TYPE);
        }
    }







    static if(!is(typeof(__U64_TYPE))) {
        private enum enumMixinStr___U64_TYPE = `enum __U64_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___U64_TYPE); }))) {
            mixin(enumMixinStr___U64_TYPE);
        }
    }




    static if(!is(typeof(__S64_TYPE))) {
        private enum enumMixinStr___S64_TYPE = `enum __S64_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___S64_TYPE); }))) {
            mixin(enumMixinStr___S64_TYPE);
        }
    }







    static if(!is(typeof(__ULONG32_TYPE))) {
        private enum enumMixinStr___ULONG32_TYPE = `enum __ULONG32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONG32_TYPE); }))) {
            mixin(enumMixinStr___ULONG32_TYPE);
        }
    }







    static if(!is(typeof(__SLONG32_TYPE))) {
        private enum enumMixinStr___SLONG32_TYPE = `enum __SLONG32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONG32_TYPE); }))) {
            mixin(enumMixinStr___SLONG32_TYPE);
        }
    }




    static if(!is(typeof(__UWORD_TYPE))) {
        private enum enumMixinStr___UWORD_TYPE = `enum __UWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UWORD_TYPE); }))) {
            mixin(enumMixinStr___UWORD_TYPE);
        }
    }




    static if(!is(typeof(__SWORD_TYPE))) {
        private enum enumMixinStr___SWORD_TYPE = `enum __SWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SWORD_TYPE); }))) {
            mixin(enumMixinStr___SWORD_TYPE);
        }
    }




    static if(!is(typeof(SCHAR_MAX))) {
        private enum enumMixinStr_SCHAR_MAX = `enum SCHAR_MAX = 127;`;
        static if(is(typeof({ mixin(enumMixinStr_SCHAR_MAX); }))) {
            mixin(enumMixinStr_SCHAR_MAX);
        }
    }




    static if(!is(typeof(SHRT_MAX))) {
        private enum enumMixinStr_SHRT_MAX = `enum SHRT_MAX = 32767;`;
        static if(is(typeof({ mixin(enumMixinStr_SHRT_MAX); }))) {
            mixin(enumMixinStr_SHRT_MAX);
        }
    }




    static if(!is(typeof(INT_MAX))) {
        private enum enumMixinStr_INT_MAX = `enum INT_MAX = 2147483647;`;
        static if(is(typeof({ mixin(enumMixinStr_INT_MAX); }))) {
            mixin(enumMixinStr_INT_MAX);
        }
    }




    static if(!is(typeof(LONG_MAX))) {
        private enum enumMixinStr_LONG_MAX = `enum LONG_MAX = 9223372036854775807L;`;
        static if(is(typeof({ mixin(enumMixinStr_LONG_MAX); }))) {
            mixin(enumMixinStr_LONG_MAX);
        }
    }




    static if(!is(typeof(SCHAR_MIN))) {
        private enum enumMixinStr_SCHAR_MIN = `enum SCHAR_MIN = ( - 127 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_SCHAR_MIN); }))) {
            mixin(enumMixinStr_SCHAR_MIN);
        }
    }




    static if(!is(typeof(SHRT_MIN))) {
        private enum enumMixinStr_SHRT_MIN = `enum SHRT_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_SHRT_MIN); }))) {
            mixin(enumMixinStr_SHRT_MIN);
        }
    }




    static if(!is(typeof(INT_MIN))) {
        private enum enumMixinStr_INT_MIN = `enum INT_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_MIN); }))) {
            mixin(enumMixinStr_INT_MIN);
        }
    }




    static if(!is(typeof(LONG_MIN))) {
        private enum enumMixinStr_LONG_MIN = `enum LONG_MIN = ( - 9223372036854775807L - 1L );`;
        static if(is(typeof({ mixin(enumMixinStr_LONG_MIN); }))) {
            mixin(enumMixinStr_LONG_MIN);
        }
    }




    static if(!is(typeof(UCHAR_MAX))) {
        private enum enumMixinStr_UCHAR_MAX = `enum UCHAR_MAX = ( 127 * 2 + 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_UCHAR_MAX); }))) {
            mixin(enumMixinStr_UCHAR_MAX);
        }
    }




    static if(!is(typeof(USHRT_MAX))) {
        private enum enumMixinStr_USHRT_MAX = `enum USHRT_MAX = ( 32767 * 2 + 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_USHRT_MAX); }))) {
            mixin(enumMixinStr_USHRT_MAX);
        }
    }




    static if(!is(typeof(UINT_MAX))) {
        private enum enumMixinStr_UINT_MAX = `enum UINT_MAX = ( 2147483647 * 2U + 1U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_MAX); }))) {
            mixin(enumMixinStr_UINT_MAX);
        }
    }




    static if(!is(typeof(ULONG_MAX))) {
        private enum enumMixinStr_ULONG_MAX = `enum ULONG_MAX = ( 9223372036854775807L * 2UL + 1UL );`;
        static if(is(typeof({ mixin(enumMixinStr_ULONG_MAX); }))) {
            mixin(enumMixinStr_ULONG_MAX);
        }
    }




    static if(!is(typeof(__UQUAD_TYPE))) {
        private enum enumMixinStr___UQUAD_TYPE = `enum __UQUAD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UQUAD_TYPE); }))) {
            mixin(enumMixinStr___UQUAD_TYPE);
        }
    }




    static if(!is(typeof(CHAR_BIT))) {
        private enum enumMixinStr_CHAR_BIT = `enum CHAR_BIT = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_CHAR_BIT); }))) {
            mixin(enumMixinStr_CHAR_BIT);
        }
    }




    static if(!is(typeof(__SQUAD_TYPE))) {
        private enum enumMixinStr___SQUAD_TYPE = `enum __SQUAD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SQUAD_TYPE); }))) {
            mixin(enumMixinStr___SQUAD_TYPE);
        }
    }




    static if(!is(typeof(CHAR_MIN))) {
        private enum enumMixinStr_CHAR_MIN = `enum CHAR_MIN = ( - 127 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_CHAR_MIN); }))) {
            mixin(enumMixinStr_CHAR_MIN);
        }
    }




    static if(!is(typeof(CHAR_MAX))) {
        private enum enumMixinStr_CHAR_MAX = `enum CHAR_MAX = 127;`;
        static if(is(typeof({ mixin(enumMixinStr_CHAR_MAX); }))) {
            mixin(enumMixinStr_CHAR_MAX);
        }
    }




    static if(!is(typeof(__ULONGWORD_TYPE))) {
        private enum enumMixinStr___ULONGWORD_TYPE = `enum __ULONGWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONGWORD_TYPE); }))) {
            mixin(enumMixinStr___ULONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__SLONGWORD_TYPE))) {
        private enum enumMixinStr___SLONGWORD_TYPE = `enum __SLONGWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONGWORD_TYPE); }))) {
            mixin(enumMixinStr___SLONGWORD_TYPE);
        }
    }







    static if(!is(typeof(__U32_TYPE))) {
        private enum enumMixinStr___U32_TYPE = `enum __U32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___U32_TYPE); }))) {
            mixin(enumMixinStr___U32_TYPE);
        }
    }
    static if(!is(typeof(__S32_TYPE))) {
        private enum enumMixinStr___S32_TYPE = `enum __S32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___S32_TYPE); }))) {
            mixin(enumMixinStr___S32_TYPE);
        }
    }







    static if(!is(typeof(__GNUC_VA_LIST))) {
        enum __GNUC_VA_LIST = 1;
    }




    static if(!is(typeof(__U16_TYPE))) {
        private enum enumMixinStr___U16_TYPE = `enum __U16_TYPE = unsigned short int;`;
        static if(is(typeof({ mixin(enumMixinStr___U16_TYPE); }))) {
            mixin(enumMixinStr___U16_TYPE);
        }
    }




    static if(!is(typeof(__S16_TYPE))) {
        private enum enumMixinStr___S16_TYPE = `enum __S16_TYPE = short int;`;
        static if(is(typeof({ mixin(enumMixinStr___S16_TYPE); }))) {
            mixin(enumMixinStr___S16_TYPE);
        }
    }




    static if(!is(typeof(_BITS_TYPES_H))) {
        enum _BITS_TYPES_H = 1;
    }




    static if(!is(typeof(__TIMESIZE))) {
        private enum enumMixinStr___TIMESIZE = `enum __TIMESIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMESIZE); }))) {
            mixin(enumMixinStr___TIMESIZE);
        }
    }




    static if(!is(typeof(__TIME64_T_TYPE))) {
        private enum enumMixinStr___TIME64_T_TYPE = `enum __TIME64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME64_T_TYPE); }))) {
            mixin(enumMixinStr___TIME64_T_TYPE);
        }
    }




    static if(!is(typeof(_BITS_TIME64_H))) {
        enum _BITS_TIME64_H = 1;
    }




    static if(!is(typeof(TIMER_ABSTIME))) {
        enum TIMER_ABSTIME = 1;
    }




    static if(!is(typeof(CLOCK_TAI))) {
        enum CLOCK_TAI = 11;
    }




    static if(!is(typeof(CLOCK_BOOTTIME_ALARM))) {
        enum CLOCK_BOOTTIME_ALARM = 9;
    }




    static if(!is(typeof(CLOCK_REALTIME_ALARM))) {
        enum CLOCK_REALTIME_ALARM = 8;
    }




    static if(!is(typeof(CLOCK_BOOTTIME))) {
        enum CLOCK_BOOTTIME = 7;
    }




    static if(!is(typeof(CLOCK_MONOTONIC_COARSE))) {
        enum CLOCK_MONOTONIC_COARSE = 6;
    }




    static if(!is(typeof(CLOCK_REALTIME_COARSE))) {
        enum CLOCK_REALTIME_COARSE = 5;
    }




    static if(!is(typeof(CLOCK_MONOTONIC_RAW))) {
        enum CLOCK_MONOTONIC_RAW = 4;
    }




    static if(!is(typeof(CLOCK_THREAD_CPUTIME_ID))) {
        enum CLOCK_THREAD_CPUTIME_ID = 3;
    }




    static if(!is(typeof(CLOCK_PROCESS_CPUTIME_ID))) {
        enum CLOCK_PROCESS_CPUTIME_ID = 2;
    }




    static if(!is(typeof(CLOCK_MONOTONIC))) {
        enum CLOCK_MONOTONIC = 1;
    }




    static if(!is(typeof(CLOCK_REALTIME))) {
        enum CLOCK_REALTIME = 0;
    }




    static if(!is(typeof(CLOCKS_PER_SEC))) {
        private enum enumMixinStr_CLOCKS_PER_SEC = `enum CLOCKS_PER_SEC = ( cast( __clock_t ) 1000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCKS_PER_SEC); }))) {
            mixin(enumMixinStr_CLOCKS_PER_SEC);
        }
    }




    static if(!is(typeof(_BITS_TIME_H))) {
        enum _BITS_TIME_H = 1;
    }




    static if(!is(typeof(__ONCE_FLAG_INIT))) {
        private enum enumMixinStr___ONCE_FLAG_INIT = `enum __ONCE_FLAG_INIT = { 0 };`;
        static if(is(typeof({ mixin(enumMixinStr___ONCE_FLAG_INIT); }))) {
            mixin(enumMixinStr___ONCE_FLAG_INIT);
        }
    }




    static if(!is(typeof(_THREAD_SHARED_TYPES_H))) {
        enum _THREAD_SHARED_TYPES_H = 1;
    }







    static if(!is(typeof(__PTHREAD_RWLOCK_ELISION_EXTRA))) {
        private enum enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA = `enum __PTHREAD_RWLOCK_ELISION_EXTRA = 0 , { 0 , 0 , 0 , 0 , 0 , 0 , 0 };`;
        static if(is(typeof({ mixin(enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA); }))) {
            mixin(enumMixinStr___PTHREAD_RWLOCK_ELISION_EXTRA);
        }
    }
    static if(!is(typeof(__PTHREAD_MUTEX_HAVE_PREV))) {
        enum __PTHREAD_MUTEX_HAVE_PREV = 1;
    }




    static if(!is(typeof(_THREAD_MUTEX_INTERNAL_H))) {
        enum _THREAD_MUTEX_INTERNAL_H = 1;
    }




    static if(!is(typeof(FOPEN_MAX))) {
        enum FOPEN_MAX = 16;
    }




    static if(!is(typeof(L_ctermid))) {
        enum L_ctermid = 9;
    }
    static if(!is(typeof(FILENAME_MAX))) {
        enum FILENAME_MAX = 4096;
    }




    static if(!is(typeof(TMP_MAX))) {
        enum TMP_MAX = 238328;
    }




    static if(!is(typeof(L_tmpnam))) {
        enum L_tmpnam = 20;
    }







    static if(!is(typeof(_BITS_STDIO_LIM_H))) {
        enum _BITS_STDIO_LIM_H = 1;
    }




    static if(!is(typeof(_BITS_STDINT_UINTN_H))) {
        enum _BITS_STDINT_UINTN_H = 1;
    }




    static if(!is(typeof(_BITS_STDINT_INTN_H))) {
        enum _BITS_STDINT_INTN_H = 1;
    }
    static if(!is(typeof(__have_pthread_attr_t))) {
        enum __have_pthread_attr_t = 1;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_COMMON_H))) {
        enum _BITS_PTHREADTYPES_COMMON_H = 1;
    }
    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIERATTR_T))) {
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCKATTR_T))) {
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_CONDATTR_T))) {
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_COND_T))) {
        enum __SIZEOF_PTHREAD_COND_T = 48;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEXATTR_T))) {
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIER_T))) {
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCK_T))) {
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_ATTR_T))) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEX_T))) {
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_ARCH_H))) {
        enum _BITS_PTHREADTYPES_ARCH_H = 1;
    }




    static if(!is(typeof(PTHREAD_STACK_MIN))) {
        enum PTHREAD_STACK_MIN = 16384;
    }




    static if(!is(typeof(_POSIX_TYPED_MEMORY_OBJECTS))) {
        private enum enumMixinStr__POSIX_TYPED_MEMORY_OBJECTS = `enum _POSIX_TYPED_MEMORY_OBJECTS = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TYPED_MEMORY_OBJECTS); }))) {
            mixin(enumMixinStr__POSIX_TYPED_MEMORY_OBJECTS);
        }
    }




    static if(!is(typeof(_POSIX_TRACE_LOG))) {
        private enum enumMixinStr__POSIX_TRACE_LOG = `enum _POSIX_TRACE_LOG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE_LOG); }))) {
            mixin(enumMixinStr__POSIX_TRACE_LOG);
        }
    }




    static if(!is(typeof(_POSIX_TRACE_INHERIT))) {
        private enum enumMixinStr__POSIX_TRACE_INHERIT = `enum _POSIX_TRACE_INHERIT = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE_INHERIT); }))) {
            mixin(enumMixinStr__POSIX_TRACE_INHERIT);
        }
    }




    static if(!is(typeof(_POSIX_TRACE_EVENT_FILTER))) {
        private enum enumMixinStr__POSIX_TRACE_EVENT_FILTER = `enum _POSIX_TRACE_EVENT_FILTER = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE_EVENT_FILTER); }))) {
            mixin(enumMixinStr__POSIX_TRACE_EVENT_FILTER);
        }
    }




    static if(!is(typeof(_POSIX_TRACE))) {
        private enum enumMixinStr__POSIX_TRACE = `enum _POSIX_TRACE = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_TRACE); }))) {
            mixin(enumMixinStr__POSIX_TRACE);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_SPORADIC_SERVER))) {
        private enum enumMixinStr__POSIX_THREAD_SPORADIC_SERVER = `enum _POSIX_THREAD_SPORADIC_SERVER = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__POSIX_THREAD_SPORADIC_SERVER);
        }
    }




    static if(!is(typeof(_POSIX_SPORADIC_SERVER))) {
        private enum enumMixinStr__POSIX_SPORADIC_SERVER = `enum _POSIX_SPORADIC_SERVER = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__POSIX_SPORADIC_SERVER);
        }
    }







    static if(!is(typeof(_POSIX2_CHAR_TERM))) {
        enum _POSIX2_CHAR_TERM = 200809L;
    }




    static if(!is(typeof(_POSIX_RAW_SOCKETS))) {
        enum _POSIX_RAW_SOCKETS = 200809L;
    }




    static if(!is(typeof(_POSIX_IPV6))) {
        enum _POSIX_IPV6 = 200809L;
    }




    static if(!is(typeof(_POSIX_ADVISORY_INFO))) {
        enum _POSIX_ADVISORY_INFO = 200809L;
    }




    static if(!is(typeof(_POSIX_CLOCK_SELECTION))) {
        enum _POSIX_CLOCK_SELECTION = 200809L;
    }




    static if(!is(typeof(_POSIX_MONOTONIC_CLOCK))) {
        enum _POSIX_MONOTONIC_CLOCK = 0;
    }




    static if(!is(typeof(_POSIX_THREAD_PROCESS_SHARED))) {
        enum _POSIX_THREAD_PROCESS_SHARED = 200809L;
    }




    static if(!is(typeof(_POSIX_MESSAGE_PASSING))) {
        enum _POSIX_MESSAGE_PASSING = 200809L;
    }




    static if(!is(typeof(_POSIX_BARRIERS))) {
        enum _POSIX_BARRIERS = 200809L;
    }




    static if(!is(typeof(_POSIX_TIMERS))) {
        enum _POSIX_TIMERS = 200809L;
    }







    static if(!is(typeof(_POSIX_SPAWN))) {
        enum _POSIX_SPAWN = 200809L;
    }




    static if(!is(typeof(_POSIX_SPIN_LOCKS))) {
        enum _POSIX_SPIN_LOCKS = 200809L;
    }




    static if(!is(typeof(_POSIX_TIMEOUTS))) {
        enum _POSIX_TIMEOUTS = 200809L;
    }




    static if(!is(typeof(_POSIX_SHELL))) {
        enum _POSIX_SHELL = 1;
    }




    static if(!is(typeof(_POSIX_READER_WRITER_LOCKS))) {
        enum _POSIX_READER_WRITER_LOCKS = 200809L;
    }




    static if(!is(typeof(_POSIX_REGEXP))) {
        enum _POSIX_REGEXP = 1;
    }




    static if(!is(typeof(_POSIX_THREAD_CPUTIME))) {
        enum _POSIX_THREAD_CPUTIME = 0;
    }




    static if(!is(typeof(_POSIX_CPUTIME))) {
        enum _POSIX_CPUTIME = 0;
    }




    static if(!is(typeof(NULL))) {
        private enum enumMixinStr_NULL = `enum NULL = ( cast( void * ) 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_NULL); }))) {
            mixin(enumMixinStr_NULL);
        }
    }




    static if(!is(typeof(_POSIX_SHARED_MEMORY_OBJECTS))) {
        enum _POSIX_SHARED_MEMORY_OBJECTS = 200809L;
    }




    static if(!is(typeof(_LFS64_STDIO))) {
        enum _LFS64_STDIO = 1;
    }




    static if(!is(typeof(_LFS64_LARGEFILE))) {
        enum _LFS64_LARGEFILE = 1;
    }







    static if(!is(typeof(_LFS_LARGEFILE))) {
        enum _LFS_LARGEFILE = 1;
    }







    static if(!is(typeof(_LFS64_ASYNCHRONOUS_IO))) {
        enum _LFS64_ASYNCHRONOUS_IO = 1;
    }




    static if(!is(typeof(_POSIX_PRIORITIZED_IO))) {
        enum _POSIX_PRIORITIZED_IO = 200809L;
    }




    static if(!is(typeof(_LFS_ASYNCHRONOUS_IO))) {
        enum _LFS_ASYNCHRONOUS_IO = 1;
    }







    static if(!is(typeof(_POSIX_ASYNC_IO))) {
        enum _POSIX_ASYNC_IO = 1;
    }




    static if(!is(typeof(_POSIX_ASYNCHRONOUS_IO))) {
        enum _POSIX_ASYNCHRONOUS_IO = 200809L;
    }




    static if(!is(typeof(_POSIX_REALTIME_SIGNALS))) {
        enum _POSIX_REALTIME_SIGNALS = 200809L;
    }




    static if(!is(typeof(_POSIX_SEMAPHORES))) {
        enum _POSIX_SEMAPHORES = 200809L;
    }




    static if(!is(typeof(_POSIX_THREAD_ROBUST_PRIO_PROTECT))) {
        private enum enumMixinStr__POSIX_THREAD_ROBUST_PRIO_PROTECT = `enum _POSIX_THREAD_ROBUST_PRIO_PROTECT = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_THREAD_ROBUST_PRIO_PROTECT); }))) {
            mixin(enumMixinStr__POSIX_THREAD_ROBUST_PRIO_PROTECT);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_ROBUST_PRIO_INHERIT))) {
        enum _POSIX_THREAD_ROBUST_PRIO_INHERIT = 200809L;
    }




    static if(!is(typeof(_POSIX_THREAD_PRIO_PROTECT))) {
        enum _POSIX_THREAD_PRIO_PROTECT = 200809L;
    }




    static if(!is(typeof(_POSIX_THREAD_PRIO_INHERIT))) {
        enum _POSIX_THREAD_PRIO_INHERIT = 200809L;
    }




    static if(!is(typeof(_POSIX_THREAD_ATTR_STACKADDR))) {
        enum _POSIX_THREAD_ATTR_STACKADDR = 200809L;
    }




    static if(!is(typeof(_POSIX_THREAD_ATTR_STACKSIZE))) {
        enum _POSIX_THREAD_ATTR_STACKSIZE = 200809L;
    }




    static if(!is(typeof(_POSIX_THREAD_PRIORITY_SCHEDULING))) {
        enum _POSIX_THREAD_PRIORITY_SCHEDULING = 200809L;
    }




    static if(!is(typeof(_POSIX_THREAD_SAFE_FUNCTIONS))) {
        enum _POSIX_THREAD_SAFE_FUNCTIONS = 200809L;
    }




    static if(!is(typeof(_POSIX_REENTRANT_FUNCTIONS))) {
        enum _POSIX_REENTRANT_FUNCTIONS = 1;
    }




    static if(!is(typeof(_POSIX_THREADS))) {
        enum _POSIX_THREADS = 200809L;
    }




    static if(!is(typeof(_XOPEN_SHM))) {
        enum _XOPEN_SHM = 1;
    }




    static if(!is(typeof(_XOPEN_REALTIME_THREADS))) {
        enum _XOPEN_REALTIME_THREADS = 1;
    }




    static if(!is(typeof(_XOPEN_REALTIME))) {
        enum _XOPEN_REALTIME = 1;
    }




    static if(!is(typeof(_POSIX_NO_TRUNC))) {
        enum _POSIX_NO_TRUNC = 1;
    }




    static if(!is(typeof(_POSIX_VDISABLE))) {
        enum _POSIX_VDISABLE = '\0';
    }




    static if(!is(typeof(_POSIX_CHOWN_RESTRICTED))) {
        enum _POSIX_CHOWN_RESTRICTED = 0;
    }




    static if(!is(typeof(_POSIX_MEMORY_PROTECTION))) {
        enum _POSIX_MEMORY_PROTECTION = 200809L;
    }







    static if(!is(typeof(_POSIX_MEMLOCK_RANGE))) {
        enum _POSIX_MEMLOCK_RANGE = 200809L;
    }




    static if(!is(typeof(_POSIX_MEMLOCK))) {
        enum _POSIX_MEMLOCK = 200809L;
    }




    static if(!is(typeof(_POSIX_MAPPED_FILES))) {
        enum _POSIX_MAPPED_FILES = 200809L;
    }




    static if(!is(typeof(_POSIX_FSYNC))) {
        enum _POSIX_FSYNC = 200809L;
    }




    static if(!is(typeof(_POSIX_SYNCHRONIZED_IO))) {
        enum _POSIX_SYNCHRONIZED_IO = 200809L;
    }




    static if(!is(typeof(_POSIX_PRIORITY_SCHEDULING))) {
        enum _POSIX_PRIORITY_SCHEDULING = 200809L;
    }




    static if(!is(typeof(_POSIX_SAVED_IDS))) {
        enum _POSIX_SAVED_IDS = 1;
    }




    static if(!is(typeof(_POSIX_JOB_CONTROL))) {
        enum _POSIX_JOB_CONTROL = 1;
    }




    static if(!is(typeof(_BITS_POSIX_OPT_H))) {
        enum _BITS_POSIX_OPT_H = 1;
    }




    static if(!is(typeof(RE_DUP_MAX))) {
        private enum enumMixinStr_RE_DUP_MAX = `enum RE_DUP_MAX = ( 0x7fff );`;
        static if(is(typeof({ mixin(enumMixinStr_RE_DUP_MAX); }))) {
            mixin(enumMixinStr_RE_DUP_MAX);
        }
    }




    static if(!is(typeof(LXW_CHART_NUM_FORMAT_LEN))) {
        enum LXW_CHART_NUM_FORMAT_LEN = 128;
    }




    static if(!is(typeof(LXW_CHART_DEFAULT_GAP))) {
        enum LXW_CHART_DEFAULT_GAP = 501;
    }




    static if(!is(typeof(CHARCLASS_NAME_MAX))) {
        enum CHARCLASS_NAME_MAX = 2048;
    }




    static if(!is(typeof(LINE_MAX))) {
        private enum enumMixinStr_LINE_MAX = `enum LINE_MAX = _POSIX2_LINE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_LINE_MAX); }))) {
            mixin(enumMixinStr_LINE_MAX);
        }
    }




    static if(!is(typeof(EXPR_NEST_MAX))) {
        private enum enumMixinStr_EXPR_NEST_MAX = `enum EXPR_NEST_MAX = _POSIX2_EXPR_NEST_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_EXPR_NEST_MAX); }))) {
            mixin(enumMixinStr_EXPR_NEST_MAX);
        }
    }




    static if(!is(typeof(COLL_WEIGHTS_MAX))) {
        enum COLL_WEIGHTS_MAX = 255;
    }




    static if(!is(typeof(BC_STRING_MAX))) {
        private enum enumMixinStr_BC_STRING_MAX = `enum BC_STRING_MAX = _POSIX2_BC_STRING_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_BC_STRING_MAX); }))) {
            mixin(enumMixinStr_BC_STRING_MAX);
        }
    }




    static if(!is(typeof(BC_SCALE_MAX))) {
        private enum enumMixinStr_BC_SCALE_MAX = `enum BC_SCALE_MAX = _POSIX2_BC_SCALE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_BC_SCALE_MAX); }))) {
            mixin(enumMixinStr_BC_SCALE_MAX);
        }
    }




    static if(!is(typeof(BC_DIM_MAX))) {
        private enum enumMixinStr_BC_DIM_MAX = `enum BC_DIM_MAX = _POSIX2_BC_DIM_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_BC_DIM_MAX); }))) {
            mixin(enumMixinStr_BC_DIM_MAX);
        }
    }




    static if(!is(typeof(BC_BASE_MAX))) {
        private enum enumMixinStr_BC_BASE_MAX = `enum BC_BASE_MAX = _POSIX2_BC_BASE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_BC_BASE_MAX); }))) {
            mixin(enumMixinStr_BC_BASE_MAX);
        }
    }




    static if(!is(typeof(_POSIX2_CHARCLASS_NAME_MAX))) {
        enum _POSIX2_CHARCLASS_NAME_MAX = 14;
    }




    static if(!is(typeof(_POSIX2_RE_DUP_MAX))) {
        enum _POSIX2_RE_DUP_MAX = 255;
    }




    static if(!is(typeof(_POSIX2_LINE_MAX))) {
        enum _POSIX2_LINE_MAX = 2048;
    }




    static if(!is(typeof(_POSIX2_EXPR_NEST_MAX))) {
        enum _POSIX2_EXPR_NEST_MAX = 32;
    }




    static if(!is(typeof(_POSIX2_COLL_WEIGHTS_MAX))) {
        enum _POSIX2_COLL_WEIGHTS_MAX = 2;
    }




    static if(!is(typeof(_POSIX2_BC_STRING_MAX))) {
        enum _POSIX2_BC_STRING_MAX = 1000;
    }




    static if(!is(typeof(_POSIX2_BC_SCALE_MAX))) {
        enum _POSIX2_BC_SCALE_MAX = 99;
    }




    static if(!is(typeof(_POSIX2_BC_DIM_MAX))) {
        enum _POSIX2_BC_DIM_MAX = 2048;
    }




    static if(!is(typeof(_POSIX2_BC_BASE_MAX))) {
        enum _POSIX2_BC_BASE_MAX = 99;
    }




    static if(!is(typeof(_BITS_POSIX2_LIM_H))) {
        enum _BITS_POSIX2_LIM_H = 1;
    }




    static if(!is(typeof(SSIZE_MAX))) {
        private enum enumMixinStr_SSIZE_MAX = `enum SSIZE_MAX = 9223372036854775807L;`;
        static if(is(typeof({ mixin(enumMixinStr_SSIZE_MAX); }))) {
            mixin(enumMixinStr_SSIZE_MAX);
        }
    }




    static if(!is(typeof(_POSIX_CLOCKRES_MIN))) {
        enum _POSIX_CLOCKRES_MIN = 20000000;
    }




    static if(!is(typeof(_POSIX_TZNAME_MAX))) {
        enum _POSIX_TZNAME_MAX = 6;
    }




    static if(!is(typeof(_POSIX_TTY_NAME_MAX))) {
        enum _POSIX_TTY_NAME_MAX = 9;
    }




    static if(!is(typeof(_POSIX_TIMER_MAX))) {
        enum _POSIX_TIMER_MAX = 32;
    }




    static if(!is(typeof(_POSIX_SYMLOOP_MAX))) {
        enum _POSIX_SYMLOOP_MAX = 8;
    }




    static if(!is(typeof(_POSIX_SYMLINK_MAX))) {
        enum _POSIX_SYMLINK_MAX = 255;
    }




    static if(!is(typeof(_POSIX_STREAM_MAX))) {
        enum _POSIX_STREAM_MAX = 8;
    }




    static if(!is(typeof(_POSIX_SSIZE_MAX))) {
        enum _POSIX_SSIZE_MAX = 32767;
    }




    static if(!is(typeof(_POSIX_SIGQUEUE_MAX))) {
        enum _POSIX_SIGQUEUE_MAX = 32;
    }




    static if(!is(typeof(_POSIX_SEM_VALUE_MAX))) {
        enum _POSIX_SEM_VALUE_MAX = 32767;
    }




    static if(!is(typeof(_POSIX_SEM_NSEMS_MAX))) {
        enum _POSIX_SEM_NSEMS_MAX = 256;
    }




    static if(!is(typeof(_POSIX_RTSIG_MAX))) {
        enum _POSIX_RTSIG_MAX = 8;
    }




    static if(!is(typeof(_POSIX_RE_DUP_MAX))) {
        enum _POSIX_RE_DUP_MAX = 255;
    }




    static if(!is(typeof(_POSIX_PIPE_BUF))) {
        enum _POSIX_PIPE_BUF = 512;
    }




    static if(!is(typeof(_POSIX_PATH_MAX))) {
        enum _POSIX_PATH_MAX = 256;
    }




    static if(!is(typeof(_POSIX_OPEN_MAX))) {
        enum _POSIX_OPEN_MAX = 20;
    }




    static if(!is(typeof(_POSIX_NGROUPS_MAX))) {
        enum _POSIX_NGROUPS_MAX = 8;
    }




    static if(!is(typeof(_POSIX_NAME_MAX))) {
        enum _POSIX_NAME_MAX = 14;
    }




    static if(!is(typeof(_POSIX_MQ_PRIO_MAX))) {
        enum _POSIX_MQ_PRIO_MAX = 32;
    }




    static if(!is(typeof(_POSIX_MQ_OPEN_MAX))) {
        enum _POSIX_MQ_OPEN_MAX = 8;
    }




    static if(!is(typeof(_POSIX_MAX_INPUT))) {
        enum _POSIX_MAX_INPUT = 255;
    }




    static if(!is(typeof(_POSIX_MAX_CANON))) {
        enum _POSIX_MAX_CANON = 255;
    }




    static if(!is(typeof(_POSIX_LOGIN_NAME_MAX))) {
        enum _POSIX_LOGIN_NAME_MAX = 9;
    }




    static if(!is(typeof(_POSIX_LINK_MAX))) {
        enum _POSIX_LINK_MAX = 8;
    }




    static if(!is(typeof(_POSIX_HOST_NAME_MAX))) {
        enum _POSIX_HOST_NAME_MAX = 255;
    }




    static if(!is(typeof(_POSIX_DELAYTIMER_MAX))) {
        enum _POSIX_DELAYTIMER_MAX = 32;
    }




    static if(!is(typeof(_POSIX_CHILD_MAX))) {
        enum _POSIX_CHILD_MAX = 25;
    }




    static if(!is(typeof(_POSIX_ARG_MAX))) {
        enum _POSIX_ARG_MAX = 4096;
    }




    static if(!is(typeof(_POSIX_AIO_MAX))) {
        enum _POSIX_AIO_MAX = 1;
    }




    static if(!is(typeof(_POSIX_AIO_LISTIO_MAX))) {
        enum _POSIX_AIO_LISTIO_MAX = 2;
    }




    static if(!is(typeof(_BITS_POSIX1_LIM_H))) {
        enum _BITS_POSIX1_LIM_H = 1;
    }




    static if(!is(typeof(__LDOUBLE_REDIRECTS_TO_FLOAT128_ABI))) {
        enum __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = 0;
    }




    static if(!is(typeof(SEM_VALUE_MAX))) {
        private enum enumMixinStr_SEM_VALUE_MAX = `enum SEM_VALUE_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_SEM_VALUE_MAX); }))) {
            mixin(enumMixinStr_SEM_VALUE_MAX);
        }
    }




    static if(!is(typeof(MQ_PRIO_MAX))) {
        enum MQ_PRIO_MAX = 32768;
    }




    static if(!is(typeof(HOST_NAME_MAX))) {
        enum HOST_NAME_MAX = 64;
    }




    static if(!is(typeof(LOGIN_NAME_MAX))) {
        enum LOGIN_NAME_MAX = 256;
    }




    static if(!is(typeof(TTY_NAME_MAX))) {
        enum TTY_NAME_MAX = 32;
    }




    static if(!is(typeof(DELAYTIMER_MAX))) {
        enum DELAYTIMER_MAX = 2147483647;
    }




    static if(!is(typeof(AIO_PRIO_DELTA_MAX))) {
        enum AIO_PRIO_DELTA_MAX = 20;
    }




    static if(!is(typeof(_POSIX_THREAD_THREADS_MAX))) {
        enum _POSIX_THREAD_THREADS_MAX = 64;
    }




    static if(!is(typeof(PTHREAD_DESTRUCTOR_ITERATIONS))) {
        private enum enumMixinStr_PTHREAD_DESTRUCTOR_ITERATIONS = `enum PTHREAD_DESTRUCTOR_ITERATIONS = _POSIX_THREAD_DESTRUCTOR_ITERATIONS;`;
        static if(is(typeof({ mixin(enumMixinStr_PTHREAD_DESTRUCTOR_ITERATIONS); }))) {
            mixin(enumMixinStr_PTHREAD_DESTRUCTOR_ITERATIONS);
        }
    }




    static if(!is(typeof(_POSIX_THREAD_DESTRUCTOR_ITERATIONS))) {
        enum _POSIX_THREAD_DESTRUCTOR_ITERATIONS = 4;
    }




    static if(!is(typeof(PTHREAD_KEYS_MAX))) {
        enum PTHREAD_KEYS_MAX = 1024;
    }




    static if(!is(typeof(_POSIX_THREAD_KEYS_MAX))) {
        enum _POSIX_THREAD_KEYS_MAX = 128;
    }
    static if(!is(typeof(__GLIBC_USE_IEC_60559_TYPES_EXT))) {
        enum __GLIBC_USE_IEC_60559_TYPES_EXT = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT_C2X))) {
        enum __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_EXT))) {
        enum __GLIBC_USE_IEC_60559_EXT = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT_C2X))) {
        enum __GLIBC_USE_IEC_60559_BFP_EXT_C2X = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT))) {
        enum __GLIBC_USE_IEC_60559_BFP_EXT = 0;
    }




    static if(!is(typeof(__GLIBC_USE_LIB_EXT2))) {
        enum __GLIBC_USE_LIB_EXT2 = 0;
    }




    static if(!is(typeof(_GETOPT_POSIX_H))) {
        enum _GETOPT_POSIX_H = 1;
    }




    static if(!is(typeof(_GETOPT_CORE_H))) {
        enum _GETOPT_CORE_H = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT64X_LONG_DOUBLE))) {
        enum __HAVE_FLOAT64X_LONG_DOUBLE = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT64X))) {
        enum __HAVE_FLOAT64X = 1;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT128))) {
        enum __HAVE_DISTINCT_FLOAT128 = 0;
    }




    static if(!is(typeof(__HAVE_FLOAT128))) {
        enum __HAVE_FLOAT128 = 0;
    }
    static if(!is(typeof(__CFLOAT64X))) {
        private enum enumMixinStr___CFLOAT64X = `enum __CFLOAT64X = _Complex long double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT64X); }))) {
            mixin(enumMixinStr___CFLOAT64X);
        }
    }




    static if(!is(typeof(__CFLOAT32X))) {
        private enum enumMixinStr___CFLOAT32X = `enum __CFLOAT32X = _Complex double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT32X); }))) {
            mixin(enumMixinStr___CFLOAT32X);
        }
    }




    static if(!is(typeof(__CFLOAT64))) {
        private enum enumMixinStr___CFLOAT64 = `enum __CFLOAT64 = _Complex double;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT64); }))) {
            mixin(enumMixinStr___CFLOAT64);
        }
    }




    static if(!is(typeof(__CFLOAT32))) {
        private enum enumMixinStr___CFLOAT32 = `enum __CFLOAT32 = _Complex float;`;
        static if(is(typeof({ mixin(enumMixinStr___CFLOAT32); }))) {
            mixin(enumMixinStr___CFLOAT32);
        }
    }
    static if(!is(typeof(__HAVE_FLOATN_NOT_TYPEDEF))) {
        enum __HAVE_FLOATN_NOT_TYPEDEF = 0;
    }




    static if(!is(typeof(__HAVE_FLOAT128_UNLIKE_LDBL))) {
        private enum enumMixinStr___HAVE_FLOAT128_UNLIKE_LDBL = `enum __HAVE_FLOAT128_UNLIKE_LDBL = ( 0 && 64 != 113 );`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_FLOAT128_UNLIKE_LDBL); }))) {
            mixin(enumMixinStr___HAVE_FLOAT128_UNLIKE_LDBL);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT128X))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT128X = `enum __HAVE_DISTINCT_FLOAT128X = __HAVE_FLOAT128X;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128X); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT128X);
        }
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64X))) {
        enum __HAVE_DISTINCT_FLOAT64X = 0;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32X))) {
        enum __HAVE_DISTINCT_FLOAT32X = 0;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64))) {
        enum __HAVE_DISTINCT_FLOAT64 = 0;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32))) {
        enum __HAVE_DISTINCT_FLOAT32 = 0;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT16))) {
        private enum enumMixinStr___HAVE_DISTINCT_FLOAT16 = `enum __HAVE_DISTINCT_FLOAT16 = __HAVE_FLOAT16;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_DISTINCT_FLOAT16); }))) {
            mixin(enumMixinStr___HAVE_DISTINCT_FLOAT16);
        }
    }




    static if(!is(typeof(__HAVE_FLOAT128X))) {
        enum __HAVE_FLOAT128X = 0;
    }




    static if(!is(typeof(__HAVE_FLOAT32X))) {
        enum __HAVE_FLOAT32X = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT64))) {
        enum __HAVE_FLOAT64 = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT32))) {
        enum __HAVE_FLOAT32 = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT16))) {
        enum __HAVE_FLOAT16 = 0;
    }







    static if(!is(typeof(ENOTSUP))) {
        private enum enumMixinStr_ENOTSUP = `enum ENOTSUP = EOPNOTSUPP;`;
        static if(is(typeof({ mixin(enumMixinStr_ENOTSUP); }))) {
            mixin(enumMixinStr_ENOTSUP);
        }
    }




    static if(!is(typeof(_BITS_ERRNO_H))) {
        enum _BITS_ERRNO_H = 1;
    }




    static if(!is(typeof(__LP64_OFF64_LDFLAGS))) {
        enum __LP64_OFF64_LDFLAGS = "-m64";
    }




    static if(!is(typeof(__LP64_OFF64_CFLAGS))) {
        enum __LP64_OFF64_CFLAGS = "-m64";
    }




    static if(!is(typeof(__ILP32_OFFBIG_LDFLAGS))) {
        enum __ILP32_OFFBIG_LDFLAGS = "-m32";
    }




    static if(!is(typeof(__ILP32_OFFBIG_CFLAGS))) {
        enum __ILP32_OFFBIG_CFLAGS = "-m32 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64";
    }




    static if(!is(typeof(__ILP32_OFF32_LDFLAGS))) {
        enum __ILP32_OFF32_LDFLAGS = "-m32";
    }




    static if(!is(typeof(__ILP32_OFF32_CFLAGS))) {
        enum __ILP32_OFF32_CFLAGS = "-m32";
    }




    static if(!is(typeof(_XBS5_LP64_OFF64))) {
        enum _XBS5_LP64_OFF64 = 1;
    }




    static if(!is(typeof(_POSIX_V6_LP64_OFF64))) {
        enum _POSIX_V6_LP64_OFF64 = 1;
    }




    static if(!is(typeof(_POSIX_V7_LP64_OFF64))) {
        enum _POSIX_V7_LP64_OFF64 = 1;
    }




    static if(!is(typeof(_XBS5_LPBIG_OFFBIG))) {
        private enum enumMixinStr__XBS5_LPBIG_OFFBIG = `enum _XBS5_LPBIG_OFFBIG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__XBS5_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__XBS5_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_POSIX_V6_LPBIG_OFFBIG))) {
        private enum enumMixinStr__POSIX_V6_LPBIG_OFFBIG = `enum _POSIX_V6_LPBIG_OFFBIG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_V6_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__POSIX_V6_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_POSIX_V7_LPBIG_OFFBIG))) {
        private enum enumMixinStr__POSIX_V7_LPBIG_OFFBIG = `enum _POSIX_V7_LPBIG_OFFBIG = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_V7_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__POSIX_V7_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(__BYTE_ORDER))) {
        private enum enumMixinStr___BYTE_ORDER = `enum __BYTE_ORDER = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr___BYTE_ORDER); }))) {
            mixin(enumMixinStr___BYTE_ORDER);
        }
    }




    static if(!is(typeof(_BITS_ENDIANNESS_H))) {
        enum _BITS_ENDIANNESS_H = 1;
    }







    static if(!is(typeof(__FLOAT_WORD_ORDER))) {
        private enum enumMixinStr___FLOAT_WORD_ORDER = `enum __FLOAT_WORD_ORDER = __LITTLE_ENDIAN;`;
        static if(is(typeof({ mixin(enumMixinStr___FLOAT_WORD_ORDER); }))) {
            mixin(enumMixinStr___FLOAT_WORD_ORDER);
        }
    }




    static if(!is(typeof(__PDP_ENDIAN))) {
        enum __PDP_ENDIAN = 3412;
    }




    static if(!is(typeof(__BIG_ENDIAN))) {
        enum __BIG_ENDIAN = 4321;
    }




    static if(!is(typeof(__LITTLE_ENDIAN))) {
        enum __LITTLE_ENDIAN = 1234;
    }




    static if(!is(typeof(_BITS_ENDIAN_H))) {
        enum _BITS_ENDIAN_H = 1;
    }




    static if(!is(typeof(_CS_V7_ENV))) {
        private enum enumMixinStr__CS_V7_ENV = `enum _CS_V7_ENV = _CS_V7_ENV;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V7_ENV); }))) {
            mixin(enumMixinStr__CS_V7_ENV);
        }
    }




    static if(!is(typeof(_CS_V6_ENV))) {
        private enum enumMixinStr__CS_V6_ENV = `enum _CS_V6_ENV = _CS_V6_ENV;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V6_ENV); }))) {
            mixin(enumMixinStr__CS_V6_ENV);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LIBS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = _CS_POSIX_V7_LPBIG_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = `enum _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_LINTFLAGS = `enum _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = _CS_POSIX_V7_LP64_OFF64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_LIBS = `enum _CS_POSIX_V7_LP64_OFF64_LIBS = _CS_POSIX_V7_LP64_OFF64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_LDFLAGS = `enum _CS_POSIX_V7_LP64_OFF64_LDFLAGS = _CS_POSIX_V7_LP64_OFF64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_LP64_OFF64_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_LP64_OFF64_CFLAGS = `enum _CS_POSIX_V7_LP64_OFF64_CFLAGS = _CS_POSIX_V7_LP64_OFF64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_LP64_OFF64_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS);
        }
    }







    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LIBS = `enum _CS_POSIX_V7_ILP32_OFFBIG_LIBS = _CS_POSIX_V7_ILP32_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = `enum _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = `enum _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = `enum _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LIBS = `enum _CS_POSIX_V7_ILP32_OFF32_LIBS = _CS_POSIX_V7_ILP32_OFF32_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LDFLAGS = `enum _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = _CS_POSIX_V7_ILP32_OFF32_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_ILP32_OFF32_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V7_ILP32_OFF32_CFLAGS = `enum _CS_POSIX_V7_ILP32_OFF32_CFLAGS = _CS_POSIX_V7_ILP32_OFF32_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_ILP32_OFF32_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LIBS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _CS_POSIX_V6_LPBIG_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = `enum _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_LINTFLAGS = `enum _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = _CS_POSIX_V6_LP64_OFF64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_LIBS = `enum _CS_POSIX_V6_LP64_OFF64_LIBS = _CS_POSIX_V6_LP64_OFF64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_LDFLAGS = `enum _CS_POSIX_V6_LP64_OFF64_LDFLAGS = _CS_POSIX_V6_LP64_OFF64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_LP64_OFF64_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_LP64_OFF64_CFLAGS = `enum _CS_POSIX_V6_LP64_OFF64_CFLAGS = _CS_POSIX_V6_LP64_OFF64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_LP64_OFF64_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = `enum _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LIBS = `enum _CS_POSIX_V6_ILP32_OFFBIG_LIBS = _CS_POSIX_V6_ILP32_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = `enum _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = `enum _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_LINTFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = `enum _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_LIBS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LIBS = `enum _CS_POSIX_V6_ILP32_OFF32_LIBS = _CS_POSIX_V6_ILP32_OFF32_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LIBS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LIBS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_LDFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LDFLAGS = `enum _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _CS_POSIX_V6_ILP32_OFF32_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V6_ILP32_OFF32_CFLAGS))) {
        private enum enumMixinStr__CS_POSIX_V6_ILP32_OFF32_CFLAGS = `enum _CS_POSIX_V6_ILP32_OFF32_CFLAGS = _CS_POSIX_V6_ILP32_OFF32_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_CFLAGS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_ILP32_OFF32_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = `enum _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LIBS = `enum _CS_XBS5_LPBIG_OFFBIG_LIBS = _CS_XBS5_LPBIG_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LDFLAGS = `enum _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _CS_XBS5_LPBIG_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LPBIG_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LPBIG_OFFBIG_CFLAGS = `enum _CS_XBS5_LPBIG_OFFBIG_CFLAGS = _CS_XBS5_LPBIG_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LPBIG_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LP64_OFF64_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_LINTFLAGS = `enum _CS_XBS5_LP64_OFF64_LINTFLAGS = _CS_XBS5_LP64_OFF64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LINTFLAGS);
        }
    }







    static if(!is(typeof(_CS_XBS5_LP64_OFF64_LIBS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_LIBS = `enum _CS_XBS5_LP64_OFF64_LIBS = _CS_XBS5_LP64_OFF64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LIBS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LP64_OFF64_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_LDFLAGS = `enum _CS_XBS5_LP64_OFF64_LDFLAGS = _CS_XBS5_LP64_OFF64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_LP64_OFF64_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_LP64_OFF64_CFLAGS = `enum _CS_XBS5_LP64_OFF64_CFLAGS = _CS_XBS5_LP64_OFF64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_LP64_OFF64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_LP64_OFF64_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_LINTFLAGS = `enum _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = _CS_XBS5_ILP32_OFFBIG_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_LIBS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_LIBS = `enum _CS_XBS5_ILP32_OFFBIG_LIBS = _CS_XBS5_ILP32_OFFBIG_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LIBS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_LDFLAGS = `enum _CS_XBS5_ILP32_OFFBIG_LDFLAGS = _CS_XBS5_ILP32_OFFBIG_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFFBIG_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFFBIG_CFLAGS = `enum _CS_XBS5_ILP32_OFFBIG_CFLAGS = _CS_XBS5_ILP32_OFFBIG_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFFBIG_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_LINTFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_LINTFLAGS = `enum _CS_XBS5_ILP32_OFF32_LINTFLAGS = _CS_XBS5_ILP32_OFF32_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_LIBS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_LIBS = `enum _CS_XBS5_ILP32_OFF32_LIBS = _CS_XBS5_ILP32_OFF32_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LIBS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LIBS);
        }
    }




    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_LDFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_LDFLAGS = `enum _CS_XBS5_ILP32_OFF32_LDFLAGS = _CS_XBS5_ILP32_OFF32_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_LDFLAGS);
        }
    }







    static if(!is(typeof(_CS_XBS5_ILP32_OFF32_CFLAGS))) {
        private enum enumMixinStr__CS_XBS5_ILP32_OFF32_CFLAGS = `enum _CS_XBS5_ILP32_OFF32_CFLAGS = _CS_XBS5_ILP32_OFF32_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_CFLAGS); }))) {
            mixin(enumMixinStr__CS_XBS5_ILP32_OFF32_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS64_LINTFLAGS))) {
        private enum enumMixinStr__CS_LFS64_LINTFLAGS = `enum _CS_LFS64_LINTFLAGS = _CS_LFS64_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS64_LINTFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS64_LIBS))) {
        private enum enumMixinStr__CS_LFS64_LIBS = `enum _CS_LFS64_LIBS = _CS_LFS64_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_LIBS); }))) {
            mixin(enumMixinStr__CS_LFS64_LIBS);
        }
    }







    static if(!is(typeof(_CS_LFS64_LDFLAGS))) {
        private enum enumMixinStr__CS_LFS64_LDFLAGS = `enum _CS_LFS64_LDFLAGS = _CS_LFS64_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS64_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS64_CFLAGS))) {
        private enum enumMixinStr__CS_LFS64_CFLAGS = `enum _CS_LFS64_CFLAGS = _CS_LFS64_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS64_CFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS64_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS_LINTFLAGS))) {
        private enum enumMixinStr__CS_LFS_LINTFLAGS = `enum _CS_LFS_LINTFLAGS = _CS_LFS_LINTFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_LINTFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS_LINTFLAGS);
        }
    }




    static if(!is(typeof(STATIC))) {
        private enum enumMixinStr_STATIC = `enum STATIC = static;`;
        static if(is(typeof({ mixin(enumMixinStr_STATIC); }))) {
            mixin(enumMixinStr_STATIC);
        }
    }




    static if(!is(typeof(_CS_LFS_LIBS))) {
        private enum enumMixinStr__CS_LFS_LIBS = `enum _CS_LFS_LIBS = _CS_LFS_LIBS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_LIBS); }))) {
            mixin(enumMixinStr__CS_LFS_LIBS);
        }
    }







    static if(!is(typeof(_CS_LFS_LDFLAGS))) {
        private enum enumMixinStr__CS_LFS_LDFLAGS = `enum _CS_LFS_LDFLAGS = _CS_LFS_LDFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_LDFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS_LDFLAGS);
        }
    }




    static if(!is(typeof(_CS_LFS_CFLAGS))) {
        private enum enumMixinStr__CS_LFS_CFLAGS = `enum _CS_LFS_CFLAGS = _CS_LFS_CFLAGS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_LFS_CFLAGS); }))) {
            mixin(enumMixinStr__CS_LFS_CFLAGS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_POSIX_V7_WIDTH_RESTRICTED_ENVS = `enum _CS_POSIX_V7_WIDTH_RESTRICTED_ENVS = _CS_V7_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V7_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_POSIX_V7_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_V7_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_V7_WIDTH_RESTRICTED_ENVS = `enum _CS_V7_WIDTH_RESTRICTED_ENVS = _CS_V7_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V7_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_V7_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_POSIX_V5_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_POSIX_V5_WIDTH_RESTRICTED_ENVS = `enum _CS_POSIX_V5_WIDTH_RESTRICTED_ENVS = _CS_V5_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V5_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_POSIX_V5_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_V5_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_V5_WIDTH_RESTRICTED_ENVS = `enum _CS_V5_WIDTH_RESTRICTED_ENVS = _CS_V5_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V5_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_V5_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_GNU_LIBPTHREAD_VERSION))) {
        private enum enumMixinStr__CS_GNU_LIBPTHREAD_VERSION = `enum _CS_GNU_LIBPTHREAD_VERSION = _CS_GNU_LIBPTHREAD_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_GNU_LIBPTHREAD_VERSION); }))) {
            mixin(enumMixinStr__CS_GNU_LIBPTHREAD_VERSION);
        }
    }




    static if(!is(typeof(_CS_GNU_LIBC_VERSION))) {
        private enum enumMixinStr__CS_GNU_LIBC_VERSION = `enum _CS_GNU_LIBC_VERSION = _CS_GNU_LIBC_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_GNU_LIBC_VERSION); }))) {
            mixin(enumMixinStr__CS_GNU_LIBC_VERSION);
        }
    }




    static if(!is(typeof(LXW_MD5_SIZE))) {
        enum LXW_MD5_SIZE = 16;
    }




    static if(!is(typeof(LXW_SHEETNAME_MAX))) {
        enum LXW_SHEETNAME_MAX = 31;
    }




    static if(!is(typeof(LXW_MAX_SHEETNAME_LENGTH))) {
        private enum enumMixinStr_LXW_MAX_SHEETNAME_LENGTH = `enum LXW_MAX_SHEETNAME_LENGTH = ( ( 31 * 4 ) + 2 + 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_MAX_SHEETNAME_LENGTH); }))) {
            mixin(enumMixinStr_LXW_MAX_SHEETNAME_LENGTH);
        }
    }




    static if(!is(typeof(LXW_MAX_COL_NAME_LENGTH))) {
        private enum enumMixinStr_LXW_MAX_COL_NAME_LENGTH = `enum LXW_MAX_COL_NAME_LENGTH = ( "$XFD" ) .sizeof;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_MAX_COL_NAME_LENGTH); }))) {
            mixin(enumMixinStr_LXW_MAX_COL_NAME_LENGTH);
        }
    }




    static if(!is(typeof(LXW_MAX_ROW_NAME_LENGTH))) {
        private enum enumMixinStr_LXW_MAX_ROW_NAME_LENGTH = `enum LXW_MAX_ROW_NAME_LENGTH = ( "$1048576" ) .sizeof;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_MAX_ROW_NAME_LENGTH); }))) {
            mixin(enumMixinStr_LXW_MAX_ROW_NAME_LENGTH);
        }
    }




    static if(!is(typeof(LXW_MAX_CELL_NAME_LENGTH))) {
        private enum enumMixinStr_LXW_MAX_CELL_NAME_LENGTH = `enum LXW_MAX_CELL_NAME_LENGTH = ( "$XFWD$1048576" ) .sizeof;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_MAX_CELL_NAME_LENGTH); }))) {
            mixin(enumMixinStr_LXW_MAX_CELL_NAME_LENGTH);
        }
    }




    static if(!is(typeof(LXW_MAX_CELL_RANGE_LENGTH))) {
        private enum enumMixinStr_LXW_MAX_CELL_RANGE_LENGTH = `enum LXW_MAX_CELL_RANGE_LENGTH = ( ( "$XFWD$1048576" ) .sizeof * 2 );`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_MAX_CELL_RANGE_LENGTH); }))) {
            mixin(enumMixinStr_LXW_MAX_CELL_RANGE_LENGTH);
        }
    }




    static if(!is(typeof(LXW_MAX_FORMULA_RANGE_LENGTH))) {
        private enum enumMixinStr_LXW_MAX_FORMULA_RANGE_LENGTH = `enum LXW_MAX_FORMULA_RANGE_LENGTH = ( ( ( 31 * 4 ) + 2 + 1 ) + ( ( "$XFWD$1048576" ) .sizeof * 2 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_MAX_FORMULA_RANGE_LENGTH); }))) {
            mixin(enumMixinStr_LXW_MAX_FORMULA_RANGE_LENGTH);
        }
    }




    static if(!is(typeof(LXW_DATETIME_LENGTH))) {
        private enum enumMixinStr_LXW_DATETIME_LENGTH = `enum LXW_DATETIME_LENGTH = ( "2016-12-12T23:00:00Z" ) .sizeof;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_DATETIME_LENGTH); }))) {
            mixin(enumMixinStr_LXW_DATETIME_LENGTH);
        }
    }




    static if(!is(typeof(LXW_GUID_LENGTH))) {
        private enum enumMixinStr_LXW_GUID_LENGTH = `enum LXW_GUID_LENGTH = ( "{12345678-1234-1234-1234-1234567890AB}\0" ) .sizeof;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_GUID_LENGTH); }))) {
            mixin(enumMixinStr_LXW_GUID_LENGTH);
        }
    }




    static if(!is(typeof(LXW_EPOCH_1900))) {
        enum LXW_EPOCH_1900 = 0;
    }




    static if(!is(typeof(LXW_EPOCH_1904))) {
        enum LXW_EPOCH_1904 = 1;
    }




    static if(!is(typeof(LXW_UINT32_T_LENGTH))) {
        private enum enumMixinStr_LXW_UINT32_T_LENGTH = `enum LXW_UINT32_T_LENGTH = ( "4294967296" ) .sizeof;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_UINT32_T_LENGTH); }))) {
            mixin(enumMixinStr_LXW_UINT32_T_LENGTH);
        }
    }




    static if(!is(typeof(LXW_FILENAME_LENGTH))) {
        enum LXW_FILENAME_LENGTH = 128;
    }




    static if(!is(typeof(LXW_IGNORE))) {
        enum LXW_IGNORE = 1;
    }




    static if(!is(typeof(LXW_PORTRAIT))) {
        enum LXW_PORTRAIT = 1;
    }




    static if(!is(typeof(LXW_LANDSCAPE))) {
        enum LXW_LANDSCAPE = 0;
    }




    static if(!is(typeof(LXW_SCHEMA_MS))) {
        enum LXW_SCHEMA_MS = "http://schemas.microsoft.com/office/2006/relationships";
    }




    static if(!is(typeof(LXW_SCHEMA_ROOT))) {
        enum LXW_SCHEMA_ROOT = "http://schemas.openxmlformats.org";
    }




    static if(!is(typeof(LXW_SCHEMA_DRAWING))) {
        private enum enumMixinStr_LXW_SCHEMA_DRAWING = `enum LXW_SCHEMA_DRAWING = "http://schemas.openxmlformats.org" "/drawingml/2006";`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_SCHEMA_DRAWING); }))) {
            mixin(enumMixinStr_LXW_SCHEMA_DRAWING);
        }
    }




    static if(!is(typeof(LXW_SCHEMA_OFFICEDOC))) {
        private enum enumMixinStr_LXW_SCHEMA_OFFICEDOC = `enum LXW_SCHEMA_OFFICEDOC = "http://schemas.openxmlformats.org" "/officeDocument/2006";`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_SCHEMA_OFFICEDOC); }))) {
            mixin(enumMixinStr_LXW_SCHEMA_OFFICEDOC);
        }
    }




    static if(!is(typeof(LXW_SCHEMA_PACKAGE))) {
        private enum enumMixinStr_LXW_SCHEMA_PACKAGE = `enum LXW_SCHEMA_PACKAGE = "http://schemas.openxmlformats.org" "/package/2006/relationships";`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_SCHEMA_PACKAGE); }))) {
            mixin(enumMixinStr_LXW_SCHEMA_PACKAGE);
        }
    }




    static if(!is(typeof(LXW_SCHEMA_DOCUMENT))) {
        private enum enumMixinStr_LXW_SCHEMA_DOCUMENT = `enum LXW_SCHEMA_DOCUMENT = "http://schemas.openxmlformats.org" "/officeDocument/2006/relationships";`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_SCHEMA_DOCUMENT); }))) {
            mixin(enumMixinStr_LXW_SCHEMA_DOCUMENT);
        }
    }




    static if(!is(typeof(LXW_SCHEMA_CONTENT))) {
        private enum enumMixinStr_LXW_SCHEMA_CONTENT = `enum LXW_SCHEMA_CONTENT = "http://schemas.openxmlformats.org" "/package/2006/content-types";`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_SCHEMA_CONTENT); }))) {
            mixin(enumMixinStr_LXW_SCHEMA_CONTENT);
        }
    }




    static if(!is(typeof(LXW_PRINTF))) {
        private enum enumMixinStr_LXW_PRINTF = `enum LXW_PRINTF = fprintf;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_PRINTF); }))) {
            mixin(enumMixinStr_LXW_PRINTF);
        }
    }




    static if(!is(typeof(LXW_STDERR))) {
        private enum enumMixinStr_LXW_STDERR = `enum LXW_STDERR = stderr ,;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_STDERR); }))) {
            mixin(enumMixinStr_LXW_STDERR);
        }
    }
    static if(!is(typeof(lxw_snprintf))) {
        private enum enumMixinStr_lxw_snprintf = `enum lxw_snprintf = __builtin_snprintf;`;
        static if(is(typeof({ mixin(enumMixinStr_lxw_snprintf); }))) {
            mixin(enumMixinStr_lxw_snprintf);
        }
    }







    static if(!is(typeof(_CS_POSIX_V6_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_POSIX_V6_WIDTH_RESTRICTED_ENVS = `enum _CS_POSIX_V6_WIDTH_RESTRICTED_ENVS = _CS_V6_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_POSIX_V6_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_POSIX_V6_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_V6_WIDTH_RESTRICTED_ENVS))) {
        private enum enumMixinStr__CS_V6_WIDTH_RESTRICTED_ENVS = `enum _CS_V6_WIDTH_RESTRICTED_ENVS = _CS_V6_WIDTH_RESTRICTED_ENVS;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_V6_WIDTH_RESTRICTED_ENVS); }))) {
            mixin(enumMixinStr__CS_V6_WIDTH_RESTRICTED_ENVS);
        }
    }




    static if(!is(typeof(_CS_PATH))) {
        private enum enumMixinStr__CS_PATH = `enum _CS_PATH = _CS_PATH;`;
        static if(is(typeof({ mixin(enumMixinStr__CS_PATH); }))) {
            mixin(enumMixinStr__CS_PATH);
        }
    }




    static if(!is(typeof(_SC_SIGSTKSZ))) {
        private enum enumMixinStr__SC_SIGSTKSZ = `enum _SC_SIGSTKSZ = _SC_SIGSTKSZ;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SIGSTKSZ); }))) {
            mixin(enumMixinStr__SC_SIGSTKSZ);
        }
    }




    static if(!is(typeof(_SC_MINSIGSTKSZ))) {
        private enum enumMixinStr__SC_MINSIGSTKSZ = `enum _SC_MINSIGSTKSZ = _SC_MINSIGSTKSZ;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MINSIGSTKSZ); }))) {
            mixin(enumMixinStr__SC_MINSIGSTKSZ);
        }
    }




    static if(!is(typeof(_SC_THREAD_ROBUST_PRIO_PROTECT))) {
        private enum enumMixinStr__SC_THREAD_ROBUST_PRIO_PROTECT = `enum _SC_THREAD_ROBUST_PRIO_PROTECT = _SC_THREAD_ROBUST_PRIO_PROTECT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_PROTECT); }))) {
            mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_PROTECT);
        }
    }




    static if(!is(typeof(_SC_THREAD_ROBUST_PRIO_INHERIT))) {
        private enum enumMixinStr__SC_THREAD_ROBUST_PRIO_INHERIT = `enum _SC_THREAD_ROBUST_PRIO_INHERIT = _SC_THREAD_ROBUST_PRIO_INHERIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_INHERIT); }))) {
            mixin(enumMixinStr__SC_THREAD_ROBUST_PRIO_INHERIT);
        }
    }




    static if(!is(typeof(_SC_XOPEN_STREAMS))) {
        private enum enumMixinStr__SC_XOPEN_STREAMS = `enum _SC_XOPEN_STREAMS = _SC_XOPEN_STREAMS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_STREAMS); }))) {
            mixin(enumMixinStr__SC_XOPEN_STREAMS);
        }
    }




    static if(!is(typeof(_SC_TRACE_USER_EVENT_MAX))) {
        private enum enumMixinStr__SC_TRACE_USER_EVENT_MAX = `enum _SC_TRACE_USER_EVENT_MAX = _SC_TRACE_USER_EVENT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_USER_EVENT_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_USER_EVENT_MAX);
        }
    }




    static if(!is(typeof(_SC_TRACE_SYS_MAX))) {
        private enum enumMixinStr__SC_TRACE_SYS_MAX = `enum _SC_TRACE_SYS_MAX = _SC_TRACE_SYS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_SYS_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_SYS_MAX);
        }
    }




    static if(!is(typeof(_SC_TRACE_NAME_MAX))) {
        private enum enumMixinStr__SC_TRACE_NAME_MAX = `enum _SC_TRACE_NAME_MAX = _SC_TRACE_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_TRACE_EVENT_NAME_MAX))) {
        private enum enumMixinStr__SC_TRACE_EVENT_NAME_MAX = `enum _SC_TRACE_EVENT_NAME_MAX = _SC_TRACE_EVENT_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_EVENT_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_TRACE_EVENT_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_SS_REPL_MAX))) {
        private enum enumMixinStr__SC_SS_REPL_MAX = `enum _SC_SS_REPL_MAX = _SC_SS_REPL_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SS_REPL_MAX); }))) {
            mixin(enumMixinStr__SC_SS_REPL_MAX);
        }
    }







    static if(!is(typeof(_SC_V7_LPBIG_OFFBIG))) {
        private enum enumMixinStr__SC_V7_LPBIG_OFFBIG = `enum _SC_V7_LPBIG_OFFBIG = _SC_V7_LPBIG_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V7_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_V7_LP64_OFF64))) {
        private enum enumMixinStr__SC_V7_LP64_OFF64 = `enum _SC_V7_LP64_OFF64 = _SC_V7_LP64_OFF64;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_LP64_OFF64); }))) {
            mixin(enumMixinStr__SC_V7_LP64_OFF64);
        }
    }




    static if(!is(typeof(_SC_V7_ILP32_OFFBIG))) {
        private enum enumMixinStr__SC_V7_ILP32_OFFBIG = `enum _SC_V7_ILP32_OFFBIG = _SC_V7_ILP32_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_ILP32_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V7_ILP32_OFFBIG);
        }
    }




    static if(!is(typeof(LXW_APP_PACKAGE))) {
        enum LXW_APP_PACKAGE = "application/vnd.openxmlformats-package.";
    }




    static if(!is(typeof(LXW_APP_DOCUMENT))) {
        enum LXW_APP_DOCUMENT = "application/vnd.openxmlformats-officedocument.";
    }




    static if(!is(typeof(LXW_APP_MSEXCEL))) {
        enum LXW_APP_MSEXCEL = "application/vnd.ms-excel.";
    }




    static if(!is(typeof(_SC_V7_ILP32_OFF32))) {
        private enum enumMixinStr__SC_V7_ILP32_OFF32 = `enum _SC_V7_ILP32_OFF32 = _SC_V7_ILP32_OFF32;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V7_ILP32_OFF32); }))) {
            mixin(enumMixinStr__SC_V7_ILP32_OFF32);
        }
    }




    static if(!is(typeof(_SC_RAW_SOCKETS))) {
        private enum enumMixinStr__SC_RAW_SOCKETS = `enum _SC_RAW_SOCKETS = _SC_RAW_SOCKETS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_RAW_SOCKETS); }))) {
            mixin(enumMixinStr__SC_RAW_SOCKETS);
        }
    }




    static if(!is(typeof(_SC_IPV6))) {
        private enum enumMixinStr__SC_IPV6 = `enum _SC_IPV6 = _SC_IPV6;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_IPV6); }))) {
            mixin(enumMixinStr__SC_IPV6);
        }
    }




    static if(!is(typeof(_SC_LEVEL4_CACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL4_CACHE_LINESIZE = `enum _SC_LEVEL4_CACHE_LINESIZE = _SC_LEVEL4_CACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL4_CACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL4_CACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL4_CACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL4_CACHE_ASSOC = `enum _SC_LEVEL4_CACHE_ASSOC = _SC_LEVEL4_CACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL4_CACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL4_CACHE_ASSOC);
        }
    }




    static if(!is(typeof(_SC_LEVEL4_CACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL4_CACHE_SIZE = `enum _SC_LEVEL4_CACHE_SIZE = _SC_LEVEL4_CACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL4_CACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL4_CACHE_SIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL3_CACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL3_CACHE_LINESIZE = `enum _SC_LEVEL3_CACHE_LINESIZE = _SC_LEVEL3_CACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL3_CACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL3_CACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL3_CACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL3_CACHE_ASSOC = `enum _SC_LEVEL3_CACHE_ASSOC = _SC_LEVEL3_CACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL3_CACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL3_CACHE_ASSOC);
        }
    }




    static if(!is(typeof(_SC_LEVEL3_CACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL3_CACHE_SIZE = `enum _SC_LEVEL3_CACHE_SIZE = _SC_LEVEL3_CACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL3_CACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL3_CACHE_SIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL2_CACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL2_CACHE_LINESIZE = `enum _SC_LEVEL2_CACHE_LINESIZE = _SC_LEVEL2_CACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL2_CACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL2_CACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL2_CACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL2_CACHE_ASSOC = `enum _SC_LEVEL2_CACHE_ASSOC = _SC_LEVEL2_CACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL2_CACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL2_CACHE_ASSOC);
        }
    }




    static if(!is(typeof(_SC_LEVEL2_CACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL2_CACHE_SIZE = `enum _SC_LEVEL2_CACHE_SIZE = _SC_LEVEL2_CACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL2_CACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL2_CACHE_SIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_DCACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL1_DCACHE_LINESIZE = `enum _SC_LEVEL1_DCACHE_LINESIZE = _SC_LEVEL1_DCACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_DCACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_DCACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_DCACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL1_DCACHE_ASSOC = `enum _SC_LEVEL1_DCACHE_ASSOC = _SC_LEVEL1_DCACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_DCACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL1_DCACHE_ASSOC);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_DCACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL1_DCACHE_SIZE = `enum _SC_LEVEL1_DCACHE_SIZE = _SC_LEVEL1_DCACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_DCACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_DCACHE_SIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_ICACHE_LINESIZE))) {
        private enum enumMixinStr__SC_LEVEL1_ICACHE_LINESIZE = `enum _SC_LEVEL1_ICACHE_LINESIZE = _SC_LEVEL1_ICACHE_LINESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_ICACHE_LINESIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_ICACHE_LINESIZE);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_ICACHE_ASSOC))) {
        private enum enumMixinStr__SC_LEVEL1_ICACHE_ASSOC = `enum _SC_LEVEL1_ICACHE_ASSOC = _SC_LEVEL1_ICACHE_ASSOC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_ICACHE_ASSOC); }))) {
            mixin(enumMixinStr__SC_LEVEL1_ICACHE_ASSOC);
        }
    }




    static if(!is(typeof(_SC_LEVEL1_ICACHE_SIZE))) {
        private enum enumMixinStr__SC_LEVEL1_ICACHE_SIZE = `enum _SC_LEVEL1_ICACHE_SIZE = _SC_LEVEL1_ICACHE_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LEVEL1_ICACHE_SIZE); }))) {
            mixin(enumMixinStr__SC_LEVEL1_ICACHE_SIZE);
        }
    }







    static if(!is(typeof(_SC_TRACE_LOG))) {
        private enum enumMixinStr__SC_TRACE_LOG = `enum _SC_TRACE_LOG = _SC_TRACE_LOG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_LOG); }))) {
            mixin(enumMixinStr__SC_TRACE_LOG);
        }
    }




    static if(!is(typeof(_SC_TRACE_INHERIT))) {
        private enum enumMixinStr__SC_TRACE_INHERIT = `enum _SC_TRACE_INHERIT = _SC_TRACE_INHERIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_INHERIT); }))) {
            mixin(enumMixinStr__SC_TRACE_INHERIT);
        }
    }




    static if(!is(typeof(_SC_TRACE_EVENT_FILTER))) {
        private enum enumMixinStr__SC_TRACE_EVENT_FILTER = `enum _SC_TRACE_EVENT_FILTER = _SC_TRACE_EVENT_FILTER;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE_EVENT_FILTER); }))) {
            mixin(enumMixinStr__SC_TRACE_EVENT_FILTER);
        }
    }




    static if(!is(typeof(_SC_TRACE))) {
        private enum enumMixinStr__SC_TRACE = `enum _SC_TRACE = _SC_TRACE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TRACE); }))) {
            mixin(enumMixinStr__SC_TRACE);
        }
    }




    static if(!is(typeof(_SC_HOST_NAME_MAX))) {
        private enum enumMixinStr__SC_HOST_NAME_MAX = `enum _SC_HOST_NAME_MAX = _SC_HOST_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_HOST_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_HOST_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_V6_LPBIG_OFFBIG))) {
        private enum enumMixinStr__SC_V6_LPBIG_OFFBIG = `enum _SC_V6_LPBIG_OFFBIG = _SC_V6_LPBIG_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V6_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_V6_LP64_OFF64))) {
        private enum enumMixinStr__SC_V6_LP64_OFF64 = `enum _SC_V6_LP64_OFF64 = _SC_V6_LP64_OFF64;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_LP64_OFF64); }))) {
            mixin(enumMixinStr__SC_V6_LP64_OFF64);
        }
    }




    static if(!is(typeof(_SC_V6_ILP32_OFFBIG))) {
        private enum enumMixinStr__SC_V6_ILP32_OFFBIG = `enum _SC_V6_ILP32_OFFBIG = _SC_V6_ILP32_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_ILP32_OFFBIG); }))) {
            mixin(enumMixinStr__SC_V6_ILP32_OFFBIG);
        }
    }







    static if(!is(typeof(_SC_V6_ILP32_OFF32))) {
        private enum enumMixinStr__SC_V6_ILP32_OFF32 = `enum _SC_V6_ILP32_OFF32 = _SC_V6_ILP32_OFF32;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_V6_ILP32_OFF32); }))) {
            mixin(enumMixinStr__SC_V6_ILP32_OFF32);
        }
    }




    static if(!is(typeof(_SC_2_PBS_CHECKPOINT))) {
        private enum enumMixinStr__SC_2_PBS_CHECKPOINT = `enum _SC_2_PBS_CHECKPOINT = _SC_2_PBS_CHECKPOINT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_CHECKPOINT); }))) {
            mixin(enumMixinStr__SC_2_PBS_CHECKPOINT);
        }
    }




    static if(!is(typeof(_SC_STREAMS))) {
        private enum enumMixinStr__SC_STREAMS = `enum _SC_STREAMS = _SC_STREAMS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_STREAMS); }))) {
            mixin(enumMixinStr__SC_STREAMS);
        }
    }




    static if(!is(typeof(_SC_SYMLOOP_MAX))) {
        private enum enumMixinStr__SC_SYMLOOP_MAX = `enum _SC_SYMLOOP_MAX = _SC_SYMLOOP_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYMLOOP_MAX); }))) {
            mixin(enumMixinStr__SC_SYMLOOP_MAX);
        }
    }




    static if(!is(typeof(_SC_2_PBS_TRACK))) {
        private enum enumMixinStr__SC_2_PBS_TRACK = `enum _SC_2_PBS_TRACK = _SC_2_PBS_TRACK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_TRACK); }))) {
            mixin(enumMixinStr__SC_2_PBS_TRACK);
        }
    }




    static if(!is(typeof(_SC_2_PBS_MESSAGE))) {
        private enum enumMixinStr__SC_2_PBS_MESSAGE = `enum _SC_2_PBS_MESSAGE = _SC_2_PBS_MESSAGE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_MESSAGE); }))) {
            mixin(enumMixinStr__SC_2_PBS_MESSAGE);
        }
    }




    static if(!is(typeof(_SC_2_PBS_LOCATE))) {
        private enum enumMixinStr__SC_2_PBS_LOCATE = `enum _SC_2_PBS_LOCATE = _SC_2_PBS_LOCATE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_LOCATE); }))) {
            mixin(enumMixinStr__SC_2_PBS_LOCATE);
        }
    }







    static if(!is(typeof(_SC_2_PBS_ACCOUNTING))) {
        private enum enumMixinStr__SC_2_PBS_ACCOUNTING = `enum _SC_2_PBS_ACCOUNTING = _SC_2_PBS_ACCOUNTING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS_ACCOUNTING); }))) {
            mixin(enumMixinStr__SC_2_PBS_ACCOUNTING);
        }
    }




    static if(!is(typeof(_SC_2_PBS))) {
        private enum enumMixinStr__SC_2_PBS = `enum _SC_2_PBS = _SC_2_PBS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_PBS); }))) {
            mixin(enumMixinStr__SC_2_PBS);
        }
    }




    static if(!is(typeof(_SC_USER_GROUPS_R))) {
        private enum enumMixinStr__SC_USER_GROUPS_R = `enum _SC_USER_GROUPS_R = _SC_USER_GROUPS_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_USER_GROUPS_R); }))) {
            mixin(enumMixinStr__SC_USER_GROUPS_R);
        }
    }




    static if(!is(typeof(_SC_USER_GROUPS))) {
        private enum enumMixinStr__SC_USER_GROUPS = `enum _SC_USER_GROUPS = _SC_USER_GROUPS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_USER_GROUPS); }))) {
            mixin(enumMixinStr__SC_USER_GROUPS);
        }
    }




    static if(!is(typeof(_SC_TYPED_MEMORY_OBJECTS))) {
        private enum enumMixinStr__SC_TYPED_MEMORY_OBJECTS = `enum _SC_TYPED_MEMORY_OBJECTS = _SC_TYPED_MEMORY_OBJECTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TYPED_MEMORY_OBJECTS); }))) {
            mixin(enumMixinStr__SC_TYPED_MEMORY_OBJECTS);
        }
    }




    static if(!is(typeof(_SC_TIMEOUTS))) {
        private enum enumMixinStr__SC_TIMEOUTS = `enum _SC_TIMEOUTS = _SC_TIMEOUTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TIMEOUTS); }))) {
            mixin(enumMixinStr__SC_TIMEOUTS);
        }
    }




    static if(!is(typeof(_SC_SYSTEM_DATABASE_R))) {
        private enum enumMixinStr__SC_SYSTEM_DATABASE_R = `enum _SC_SYSTEM_DATABASE_R = _SC_SYSTEM_DATABASE_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYSTEM_DATABASE_R); }))) {
            mixin(enumMixinStr__SC_SYSTEM_DATABASE_R);
        }
    }




    static if(!is(typeof(_SC_SYSTEM_DATABASE))) {
        private enum enumMixinStr__SC_SYSTEM_DATABASE = `enum _SC_SYSTEM_DATABASE = _SC_SYSTEM_DATABASE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYSTEM_DATABASE); }))) {
            mixin(enumMixinStr__SC_SYSTEM_DATABASE);
        }
    }




    static if(!is(typeof(_SC_THREAD_SPORADIC_SERVER))) {
        private enum enumMixinStr__SC_THREAD_SPORADIC_SERVER = `enum _SC_THREAD_SPORADIC_SERVER = _SC_THREAD_SPORADIC_SERVER;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__SC_THREAD_SPORADIC_SERVER);
        }
    }




    static if(!is(typeof(_SC_SPORADIC_SERVER))) {
        private enum enumMixinStr__SC_SPORADIC_SERVER = `enum _SC_SPORADIC_SERVER = _SC_SPORADIC_SERVER;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SPORADIC_SERVER); }))) {
            mixin(enumMixinStr__SC_SPORADIC_SERVER);
        }
    }




    static if(!is(typeof(_SC_SPAWN))) {
        private enum enumMixinStr__SC_SPAWN = `enum _SC_SPAWN = _SC_SPAWN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SPAWN); }))) {
            mixin(enumMixinStr__SC_SPAWN);
        }
    }




    static if(!is(typeof(_SC_SIGNALS))) {
        private enum enumMixinStr__SC_SIGNALS = `enum _SC_SIGNALS = _SC_SIGNALS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SIGNALS); }))) {
            mixin(enumMixinStr__SC_SIGNALS);
        }
    }




    static if(!is(typeof(_SC_SHELL))) {
        private enum enumMixinStr__SC_SHELL = `enum _SC_SHELL = _SC_SHELL;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHELL); }))) {
            mixin(enumMixinStr__SC_SHELL);
        }
    }




    static if(!is(typeof(_SC_REGEX_VERSION))) {
        private enum enumMixinStr__SC_REGEX_VERSION = `enum _SC_REGEX_VERSION = _SC_REGEX_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_REGEX_VERSION); }))) {
            mixin(enumMixinStr__SC_REGEX_VERSION);
        }
    }




    static if(!is(typeof(_SC_REGEXP))) {
        private enum enumMixinStr__SC_REGEXP = `enum _SC_REGEXP = _SC_REGEXP;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_REGEXP); }))) {
            mixin(enumMixinStr__SC_REGEXP);
        }
    }




    static if(!is(typeof(_SC_SPIN_LOCKS))) {
        private enum enumMixinStr__SC_SPIN_LOCKS = `enum _SC_SPIN_LOCKS = _SC_SPIN_LOCKS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SPIN_LOCKS); }))) {
            mixin(enumMixinStr__SC_SPIN_LOCKS);
        }
    }




    static if(!is(typeof(_SC_READER_WRITER_LOCKS))) {
        private enum enumMixinStr__SC_READER_WRITER_LOCKS = `enum _SC_READER_WRITER_LOCKS = _SC_READER_WRITER_LOCKS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_READER_WRITER_LOCKS); }))) {
            mixin(enumMixinStr__SC_READER_WRITER_LOCKS);
        }
    }




    static if(!is(typeof(_SC_NETWORKING))) {
        private enum enumMixinStr__SC_NETWORKING = `enum _SC_NETWORKING = _SC_NETWORKING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NETWORKING); }))) {
            mixin(enumMixinStr__SC_NETWORKING);
        }
    }




    static if(!is(typeof(_SC_SINGLE_PROCESS))) {
        private enum enumMixinStr__SC_SINGLE_PROCESS = `enum _SC_SINGLE_PROCESS = _SC_SINGLE_PROCESS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SINGLE_PROCESS); }))) {
            mixin(enumMixinStr__SC_SINGLE_PROCESS);
        }
    }







    static if(!is(typeof(_SC_MULTI_PROCESS))) {
        private enum enumMixinStr__SC_MULTI_PROCESS = `enum _SC_MULTI_PROCESS = _SC_MULTI_PROCESS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MULTI_PROCESS); }))) {
            mixin(enumMixinStr__SC_MULTI_PROCESS);
        }
    }




    static if(!is(typeof(_SC_MONOTONIC_CLOCK))) {
        private enum enumMixinStr__SC_MONOTONIC_CLOCK = `enum _SC_MONOTONIC_CLOCK = _SC_MONOTONIC_CLOCK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MONOTONIC_CLOCK); }))) {
            mixin(enumMixinStr__SC_MONOTONIC_CLOCK);
        }
    }




    static if(!is(typeof(_SC_FILE_SYSTEM))) {
        private enum enumMixinStr__SC_FILE_SYSTEM = `enum _SC_FILE_SYSTEM = _SC_FILE_SYSTEM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FILE_SYSTEM); }))) {
            mixin(enumMixinStr__SC_FILE_SYSTEM);
        }
    }




    static if(!is(typeof(_SC_FILE_LOCKING))) {
        private enum enumMixinStr__SC_FILE_LOCKING = `enum _SC_FILE_LOCKING = _SC_FILE_LOCKING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FILE_LOCKING); }))) {
            mixin(enumMixinStr__SC_FILE_LOCKING);
        }
    }




    static if(!is(typeof(_SC_FILE_ATTRIBUTES))) {
        private enum enumMixinStr__SC_FILE_ATTRIBUTES = `enum _SC_FILE_ATTRIBUTES = _SC_FILE_ATTRIBUTES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FILE_ATTRIBUTES); }))) {
            mixin(enumMixinStr__SC_FILE_ATTRIBUTES);
        }
    }




    static if(!is(typeof(LXW_FORMAT_FIELD_LEN))) {
        enum LXW_FORMAT_FIELD_LEN = 128;
    }




    static if(!is(typeof(LXW_DEFAULT_FONT_NAME))) {
        enum LXW_DEFAULT_FONT_NAME = "Calibri";
    }




    static if(!is(typeof(LXW_DEFAULT_FONT_FAMILY))) {
        enum LXW_DEFAULT_FONT_FAMILY = 2;
    }




    static if(!is(typeof(LXW_DEFAULT_FONT_THEME))) {
        enum LXW_DEFAULT_FONT_THEME = 1;
    }




    static if(!is(typeof(LXW_PROPERTY_UNSET))) {
        private enum enumMixinStr_LXW_PROPERTY_UNSET = `enum LXW_PROPERTY_UNSET = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_PROPERTY_UNSET); }))) {
            mixin(enumMixinStr_LXW_PROPERTY_UNSET);
        }
    }




    static if(!is(typeof(LXW_COLOR_UNSET))) {
        enum LXW_COLOR_UNSET = 0x000000;
    }




    static if(!is(typeof(LXW_COLOR_MASK))) {
        enum LXW_COLOR_MASK = 0xFFFFFF;
    }




    static if(!is(typeof(LXW_MIN_FONT_SIZE))) {
        enum LXW_MIN_FONT_SIZE = 1.0;
    }




    static if(!is(typeof(LXW_MAX_FONT_SIZE))) {
        enum LXW_MAX_FONT_SIZE = 409.0;
    }







    static if(!is(typeof(_SC_PIPE))) {
        private enum enumMixinStr__SC_PIPE = `enum _SC_PIPE = _SC_PIPE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PIPE); }))) {
            mixin(enumMixinStr__SC_PIPE);
        }
    }




    static if(!is(typeof(_SC_FIFO))) {
        private enum enumMixinStr__SC_FIFO = `enum _SC_FIFO = _SC_FIFO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FIFO); }))) {
            mixin(enumMixinStr__SC_FIFO);
        }
    }




    static if(!is(typeof(_SC_FD_MGMT))) {
        private enum enumMixinStr__SC_FD_MGMT = `enum _SC_FD_MGMT = _SC_FD_MGMT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FD_MGMT); }))) {
            mixin(enumMixinStr__SC_FD_MGMT);
        }
    }




    static if(!is(typeof(_SC_DEVICE_SPECIFIC_R))) {
        private enum enumMixinStr__SC_DEVICE_SPECIFIC_R = `enum _SC_DEVICE_SPECIFIC_R = _SC_DEVICE_SPECIFIC_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DEVICE_SPECIFIC_R); }))) {
            mixin(enumMixinStr__SC_DEVICE_SPECIFIC_R);
        }
    }




    static if(!is(typeof(_SC_DEVICE_SPECIFIC))) {
        private enum enumMixinStr__SC_DEVICE_SPECIFIC = `enum _SC_DEVICE_SPECIFIC = _SC_DEVICE_SPECIFIC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DEVICE_SPECIFIC); }))) {
            mixin(enumMixinStr__SC_DEVICE_SPECIFIC);
        }
    }




    static if(!is(typeof(_SC_DEVICE_IO))) {
        private enum enumMixinStr__SC_DEVICE_IO = `enum _SC_DEVICE_IO = _SC_DEVICE_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DEVICE_IO); }))) {
            mixin(enumMixinStr__SC_DEVICE_IO);
        }
    }




    static if(!is(typeof(_SC_THREAD_CPUTIME))) {
        private enum enumMixinStr__SC_THREAD_CPUTIME = `enum _SC_THREAD_CPUTIME = _SC_THREAD_CPUTIME;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_CPUTIME); }))) {
            mixin(enumMixinStr__SC_THREAD_CPUTIME);
        }
    }




    static if(!is(typeof(_SC_CPUTIME))) {
        private enum enumMixinStr__SC_CPUTIME = `enum _SC_CPUTIME = _SC_CPUTIME;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CPUTIME); }))) {
            mixin(enumMixinStr__SC_CPUTIME);
        }
    }




    static if(!is(typeof(_SC_CLOCK_SELECTION))) {
        private enum enumMixinStr__SC_CLOCK_SELECTION = `enum _SC_CLOCK_SELECTION = _SC_CLOCK_SELECTION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CLOCK_SELECTION); }))) {
            mixin(enumMixinStr__SC_CLOCK_SELECTION);
        }
    }




    static if(!is(typeof(_SC_C_LANG_SUPPORT_R))) {
        private enum enumMixinStr__SC_C_LANG_SUPPORT_R = `enum _SC_C_LANG_SUPPORT_R = _SC_C_LANG_SUPPORT_R;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_C_LANG_SUPPORT_R); }))) {
            mixin(enumMixinStr__SC_C_LANG_SUPPORT_R);
        }
    }




    static if(!is(typeof(_SC_C_LANG_SUPPORT))) {
        private enum enumMixinStr__SC_C_LANG_SUPPORT = `enum _SC_C_LANG_SUPPORT = _SC_C_LANG_SUPPORT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_C_LANG_SUPPORT); }))) {
            mixin(enumMixinStr__SC_C_LANG_SUPPORT);
        }
    }




    static if(!is(typeof(_SC_BASE))) {
        private enum enumMixinStr__SC_BASE = `enum _SC_BASE = _SC_BASE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BASE); }))) {
            mixin(enumMixinStr__SC_BASE);
        }
    }




    static if(!is(typeof(_SC_BARRIERS))) {
        private enum enumMixinStr__SC_BARRIERS = `enum _SC_BARRIERS = _SC_BARRIERS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BARRIERS); }))) {
            mixin(enumMixinStr__SC_BARRIERS);
        }
    }




    static if(!is(typeof(_SC_ADVISORY_INFO))) {
        private enum enumMixinStr__SC_ADVISORY_INFO = `enum _SC_ADVISORY_INFO = _SC_ADVISORY_INFO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ADVISORY_INFO); }))) {
            mixin(enumMixinStr__SC_ADVISORY_INFO);
        }
    }




    static if(!is(typeof(_SC_XOPEN_REALTIME_THREADS))) {
        private enum enumMixinStr__SC_XOPEN_REALTIME_THREADS = `enum _SC_XOPEN_REALTIME_THREADS = _SC_XOPEN_REALTIME_THREADS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_REALTIME_THREADS); }))) {
            mixin(enumMixinStr__SC_XOPEN_REALTIME_THREADS);
        }
    }




    static if(!is(typeof(_SC_XOPEN_REALTIME))) {
        private enum enumMixinStr__SC_XOPEN_REALTIME = `enum _SC_XOPEN_REALTIME = _SC_XOPEN_REALTIME;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_REALTIME); }))) {
            mixin(enumMixinStr__SC_XOPEN_REALTIME);
        }
    }




    static if(!is(typeof(_SC_XOPEN_LEGACY))) {
        private enum enumMixinStr__SC_XOPEN_LEGACY = `enum _SC_XOPEN_LEGACY = _SC_XOPEN_LEGACY;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_LEGACY); }))) {
            mixin(enumMixinStr__SC_XOPEN_LEGACY);
        }
    }




    static if(!is(typeof(_SC_XBS5_LPBIG_OFFBIG))) {
        private enum enumMixinStr__SC_XBS5_LPBIG_OFFBIG = `enum _SC_XBS5_LPBIG_OFFBIG = _SC_XBS5_LPBIG_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_LPBIG_OFFBIG); }))) {
            mixin(enumMixinStr__SC_XBS5_LPBIG_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_XBS5_LP64_OFF64))) {
        private enum enumMixinStr__SC_XBS5_LP64_OFF64 = `enum _SC_XBS5_LP64_OFF64 = _SC_XBS5_LP64_OFF64;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_LP64_OFF64); }))) {
            mixin(enumMixinStr__SC_XBS5_LP64_OFF64);
        }
    }




    static if(!is(typeof(_SC_XBS5_ILP32_OFFBIG))) {
        private enum enumMixinStr__SC_XBS5_ILP32_OFFBIG = `enum _SC_XBS5_ILP32_OFFBIG = _SC_XBS5_ILP32_OFFBIG;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_ILP32_OFFBIG); }))) {
            mixin(enumMixinStr__SC_XBS5_ILP32_OFFBIG);
        }
    }




    static if(!is(typeof(_SC_XBS5_ILP32_OFF32))) {
        private enum enumMixinStr__SC_XBS5_ILP32_OFF32 = `enum _SC_XBS5_ILP32_OFF32 = _SC_XBS5_ILP32_OFF32;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XBS5_ILP32_OFF32); }))) {
            mixin(enumMixinStr__SC_XBS5_ILP32_OFF32);
        }
    }




    static if(!is(typeof(_SC_NL_TEXTMAX))) {
        private enum enumMixinStr__SC_NL_TEXTMAX = `enum _SC_NL_TEXTMAX = _SC_NL_TEXTMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_TEXTMAX); }))) {
            mixin(enumMixinStr__SC_NL_TEXTMAX);
        }
    }




    static if(!is(typeof(_SC_NL_SETMAX))) {
        private enum enumMixinStr__SC_NL_SETMAX = `enum _SC_NL_SETMAX = _SC_NL_SETMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_SETMAX); }))) {
            mixin(enumMixinStr__SC_NL_SETMAX);
        }
    }




    static if(!is(typeof(_SC_NL_NMAX))) {
        private enum enumMixinStr__SC_NL_NMAX = `enum _SC_NL_NMAX = _SC_NL_NMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_NMAX); }))) {
            mixin(enumMixinStr__SC_NL_NMAX);
        }
    }




    static if(!is(typeof(_SC_NL_MSGMAX))) {
        private enum enumMixinStr__SC_NL_MSGMAX = `enum _SC_NL_MSGMAX = _SC_NL_MSGMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_MSGMAX); }))) {
            mixin(enumMixinStr__SC_NL_MSGMAX);
        }
    }




    static if(!is(typeof(_SC_NL_LANGMAX))) {
        private enum enumMixinStr__SC_NL_LANGMAX = `enum _SC_NL_LANGMAX = _SC_NL_LANGMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_LANGMAX); }))) {
            mixin(enumMixinStr__SC_NL_LANGMAX);
        }
    }




    static if(!is(typeof(_SC_NL_ARGMAX))) {
        private enum enumMixinStr__SC_NL_ARGMAX = `enum _SC_NL_ARGMAX = _SC_NL_ARGMAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NL_ARGMAX); }))) {
            mixin(enumMixinStr__SC_NL_ARGMAX);
        }
    }




    static if(!is(typeof(_SC_USHRT_MAX))) {
        private enum enumMixinStr__SC_USHRT_MAX = `enum _SC_USHRT_MAX = _SC_USHRT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_USHRT_MAX); }))) {
            mixin(enumMixinStr__SC_USHRT_MAX);
        }
    }




    static if(!is(typeof(_SC_ULONG_MAX))) {
        private enum enumMixinStr__SC_ULONG_MAX = `enum _SC_ULONG_MAX = _SC_ULONG_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ULONG_MAX); }))) {
            mixin(enumMixinStr__SC_ULONG_MAX);
        }
    }




    static if(!is(typeof(_SC_UINT_MAX))) {
        private enum enumMixinStr__SC_UINT_MAX = `enum _SC_UINT_MAX = _SC_UINT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_UINT_MAX); }))) {
            mixin(enumMixinStr__SC_UINT_MAX);
        }
    }




    static if(!is(typeof(_SC_UCHAR_MAX))) {
        private enum enumMixinStr__SC_UCHAR_MAX = `enum _SC_UCHAR_MAX = _SC_UCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_UCHAR_MAX); }))) {
            mixin(enumMixinStr__SC_UCHAR_MAX);
        }
    }




    static if(!is(typeof(_SC_SHRT_MIN))) {
        private enum enumMixinStr__SC_SHRT_MIN = `enum _SC_SHRT_MIN = _SC_SHRT_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHRT_MIN); }))) {
            mixin(enumMixinStr__SC_SHRT_MIN);
        }
    }




    static if(!is(typeof(_SC_SHRT_MAX))) {
        private enum enumMixinStr__SC_SHRT_MAX = `enum _SC_SHRT_MAX = _SC_SHRT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHRT_MAX); }))) {
            mixin(enumMixinStr__SC_SHRT_MAX);
        }
    }




    static if(!is(typeof(_SC_SCHAR_MIN))) {
        private enum enumMixinStr__SC_SCHAR_MIN = `enum _SC_SCHAR_MIN = _SC_SCHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SCHAR_MIN); }))) {
            mixin(enumMixinStr__SC_SCHAR_MIN);
        }
    }




    static if(!is(typeof(_SC_SCHAR_MAX))) {
        private enum enumMixinStr__SC_SCHAR_MAX = `enum _SC_SCHAR_MAX = _SC_SCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SCHAR_MAX); }))) {
            mixin(enumMixinStr__SC_SCHAR_MAX);
        }
    }




    static if(!is(typeof(_SC_SSIZE_MAX))) {
        private enum enumMixinStr__SC_SSIZE_MAX = `enum _SC_SSIZE_MAX = _SC_SSIZE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SSIZE_MAX); }))) {
            mixin(enumMixinStr__SC_SSIZE_MAX);
        }
    }




    static if(!is(typeof(_SC_NZERO))) {
        private enum enumMixinStr__SC_NZERO = `enum _SC_NZERO = _SC_NZERO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NZERO); }))) {
            mixin(enumMixinStr__SC_NZERO);
        }
    }




    static if(!is(typeof(_SC_MB_LEN_MAX))) {
        private enum enumMixinStr__SC_MB_LEN_MAX = `enum _SC_MB_LEN_MAX = _SC_MB_LEN_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MB_LEN_MAX); }))) {
            mixin(enumMixinStr__SC_MB_LEN_MAX);
        }
    }




    static if(!is(typeof(_SC_WORD_BIT))) {
        private enum enumMixinStr__SC_WORD_BIT = `enum _SC_WORD_BIT = _SC_WORD_BIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_WORD_BIT); }))) {
            mixin(enumMixinStr__SC_WORD_BIT);
        }
    }




    static if(!is(typeof(_SC_LONG_BIT))) {
        private enum enumMixinStr__SC_LONG_BIT = `enum _SC_LONG_BIT = _SC_LONG_BIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LONG_BIT); }))) {
            mixin(enumMixinStr__SC_LONG_BIT);
        }
    }




    static if(!is(typeof(_SC_INT_MIN))) {
        private enum enumMixinStr__SC_INT_MIN = `enum _SC_INT_MIN = _SC_INT_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_INT_MIN); }))) {
            mixin(enumMixinStr__SC_INT_MIN);
        }
    }




    static if(!is(typeof(_SC_INT_MAX))) {
        private enum enumMixinStr__SC_INT_MAX = `enum _SC_INT_MAX = _SC_INT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_INT_MAX); }))) {
            mixin(enumMixinStr__SC_INT_MAX);
        }
    }




    static if(!is(typeof(_SC_CHAR_MIN))) {
        private enum enumMixinStr__SC_CHAR_MIN = `enum _SC_CHAR_MIN = _SC_CHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHAR_MIN); }))) {
            mixin(enumMixinStr__SC_CHAR_MIN);
        }
    }




    static if(!is(typeof(_SC_CHAR_MAX))) {
        private enum enumMixinStr__SC_CHAR_MAX = `enum _SC_CHAR_MAX = _SC_CHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHAR_MAX); }))) {
            mixin(enumMixinStr__SC_CHAR_MAX);
        }
    }




    static if(!is(typeof(_SC_CHAR_BIT))) {
        private enum enumMixinStr__SC_CHAR_BIT = `enum _SC_CHAR_BIT = _SC_CHAR_BIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHAR_BIT); }))) {
            mixin(enumMixinStr__SC_CHAR_BIT);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XPG4))) {
        private enum enumMixinStr__SC_XOPEN_XPG4 = `enum _SC_XOPEN_XPG4 = _SC_XOPEN_XPG4;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XPG4); }))) {
            mixin(enumMixinStr__SC_XOPEN_XPG4);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XPG3))) {
        private enum enumMixinStr__SC_XOPEN_XPG3 = `enum _SC_XOPEN_XPG3 = _SC_XOPEN_XPG3;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XPG3); }))) {
            mixin(enumMixinStr__SC_XOPEN_XPG3);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XPG2))) {
        private enum enumMixinStr__SC_XOPEN_XPG2 = `enum _SC_XOPEN_XPG2 = _SC_XOPEN_XPG2;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XPG2); }))) {
            mixin(enumMixinStr__SC_XOPEN_XPG2);
        }
    }




    static if(!is(typeof(_SC_2_UPE))) {
        private enum enumMixinStr__SC_2_UPE = `enum _SC_2_UPE = _SC_2_UPE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_UPE); }))) {
            mixin(enumMixinStr__SC_2_UPE);
        }
    }




    static if(!is(typeof(_SC_2_C_VERSION))) {
        private enum enumMixinStr__SC_2_C_VERSION = `enum _SC_2_C_VERSION = _SC_2_C_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_C_VERSION); }))) {
            mixin(enumMixinStr__SC_2_C_VERSION);
        }
    }




    static if(!is(typeof(_SC_2_CHAR_TERM))) {
        private enum enumMixinStr__SC_2_CHAR_TERM = `enum _SC_2_CHAR_TERM = _SC_2_CHAR_TERM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_CHAR_TERM); }))) {
            mixin(enumMixinStr__SC_2_CHAR_TERM);
        }
    }




    static if(!is(typeof(_SC_XOPEN_SHM))) {
        private enum enumMixinStr__SC_XOPEN_SHM = `enum _SC_XOPEN_SHM = _SC_XOPEN_SHM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_SHM); }))) {
            mixin(enumMixinStr__SC_XOPEN_SHM);
        }
    }




    static if(!is(typeof(_SC_XOPEN_ENH_I18N))) {
        private enum enumMixinStr__SC_XOPEN_ENH_I18N = `enum _SC_XOPEN_ENH_I18N = _SC_XOPEN_ENH_I18N;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_ENH_I18N); }))) {
            mixin(enumMixinStr__SC_XOPEN_ENH_I18N);
        }
    }




    static if(!is(typeof(_SC_XOPEN_CRYPT))) {
        private enum enumMixinStr__SC_XOPEN_CRYPT = `enum _SC_XOPEN_CRYPT = _SC_XOPEN_CRYPT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_CRYPT); }))) {
            mixin(enumMixinStr__SC_XOPEN_CRYPT);
        }
    }




    static if(!is(typeof(_SC_XOPEN_UNIX))) {
        private enum enumMixinStr__SC_XOPEN_UNIX = `enum _SC_XOPEN_UNIX = _SC_XOPEN_UNIX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_UNIX); }))) {
            mixin(enumMixinStr__SC_XOPEN_UNIX);
        }
    }




    static if(!is(typeof(_SC_XOPEN_XCU_VERSION))) {
        private enum enumMixinStr__SC_XOPEN_XCU_VERSION = `enum _SC_XOPEN_XCU_VERSION = _SC_XOPEN_XCU_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_XCU_VERSION); }))) {
            mixin(enumMixinStr__SC_XOPEN_XCU_VERSION);
        }
    }




    static if(!is(typeof(_SC_XOPEN_VERSION))) {
        private enum enumMixinStr__SC_XOPEN_VERSION = `enum _SC_XOPEN_VERSION = _SC_XOPEN_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_XOPEN_VERSION); }))) {
            mixin(enumMixinStr__SC_XOPEN_VERSION);
        }
    }




    static if(!is(typeof(_SC_PASS_MAX))) {
        private enum enumMixinStr__SC_PASS_MAX = `enum _SC_PASS_MAX = _SC_PASS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PASS_MAX); }))) {
            mixin(enumMixinStr__SC_PASS_MAX);
        }
    }




    static if(!is(typeof(_SC_ATEXIT_MAX))) {
        private enum enumMixinStr__SC_ATEXIT_MAX = `enum _SC_ATEXIT_MAX = _SC_ATEXIT_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ATEXIT_MAX); }))) {
            mixin(enumMixinStr__SC_ATEXIT_MAX);
        }
    }




    static if(!is(typeof(_SC_AVPHYS_PAGES))) {
        private enum enumMixinStr__SC_AVPHYS_PAGES = `enum _SC_AVPHYS_PAGES = _SC_AVPHYS_PAGES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AVPHYS_PAGES); }))) {
            mixin(enumMixinStr__SC_AVPHYS_PAGES);
        }
    }




    static if(!is(typeof(_SC_PHYS_PAGES))) {
        private enum enumMixinStr__SC_PHYS_PAGES = `enum _SC_PHYS_PAGES = _SC_PHYS_PAGES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PHYS_PAGES); }))) {
            mixin(enumMixinStr__SC_PHYS_PAGES);
        }
    }




    static if(!is(typeof(_SC_NPROCESSORS_ONLN))) {
        private enum enumMixinStr__SC_NPROCESSORS_ONLN = `enum _SC_NPROCESSORS_ONLN = _SC_NPROCESSORS_ONLN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NPROCESSORS_ONLN); }))) {
            mixin(enumMixinStr__SC_NPROCESSORS_ONLN);
        }
    }




    static if(!is(typeof(_SC_NPROCESSORS_CONF))) {
        private enum enumMixinStr__SC_NPROCESSORS_CONF = `enum _SC_NPROCESSORS_CONF = _SC_NPROCESSORS_CONF;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NPROCESSORS_CONF); }))) {
            mixin(enumMixinStr__SC_NPROCESSORS_CONF);
        }
    }




    static if(!is(typeof(_SC_THREAD_PROCESS_SHARED))) {
        private enum enumMixinStr__SC_THREAD_PROCESS_SHARED = `enum _SC_THREAD_PROCESS_SHARED = _SC_THREAD_PROCESS_SHARED;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PROCESS_SHARED); }))) {
            mixin(enumMixinStr__SC_THREAD_PROCESS_SHARED);
        }
    }




    static if(!is(typeof(_SC_THREAD_PRIO_PROTECT))) {
        private enum enumMixinStr__SC_THREAD_PRIO_PROTECT = `enum _SC_THREAD_PRIO_PROTECT = _SC_THREAD_PRIO_PROTECT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PRIO_PROTECT); }))) {
            mixin(enumMixinStr__SC_THREAD_PRIO_PROTECT);
        }
    }




    static if(!is(typeof(_SC_THREAD_PRIO_INHERIT))) {
        private enum enumMixinStr__SC_THREAD_PRIO_INHERIT = `enum _SC_THREAD_PRIO_INHERIT = _SC_THREAD_PRIO_INHERIT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PRIO_INHERIT); }))) {
            mixin(enumMixinStr__SC_THREAD_PRIO_INHERIT);
        }
    }




    static if(!is(typeof(_SC_THREAD_PRIORITY_SCHEDULING))) {
        private enum enumMixinStr__SC_THREAD_PRIORITY_SCHEDULING = `enum _SC_THREAD_PRIORITY_SCHEDULING = _SC_THREAD_PRIORITY_SCHEDULING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_PRIORITY_SCHEDULING); }))) {
            mixin(enumMixinStr__SC_THREAD_PRIORITY_SCHEDULING);
        }
    }




    static if(!is(typeof(_SC_THREAD_ATTR_STACKSIZE))) {
        private enum enumMixinStr__SC_THREAD_ATTR_STACKSIZE = `enum _SC_THREAD_ATTR_STACKSIZE = _SC_THREAD_ATTR_STACKSIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ATTR_STACKSIZE); }))) {
            mixin(enumMixinStr__SC_THREAD_ATTR_STACKSIZE);
        }
    }




    static if(!is(typeof(_SC_THREAD_ATTR_STACKADDR))) {
        private enum enumMixinStr__SC_THREAD_ATTR_STACKADDR = `enum _SC_THREAD_ATTR_STACKADDR = _SC_THREAD_ATTR_STACKADDR;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_ATTR_STACKADDR); }))) {
            mixin(enumMixinStr__SC_THREAD_ATTR_STACKADDR);
        }
    }




    static if(!is(typeof(_SC_THREAD_THREADS_MAX))) {
        private enum enumMixinStr__SC_THREAD_THREADS_MAX = `enum _SC_THREAD_THREADS_MAX = _SC_THREAD_THREADS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_THREADS_MAX); }))) {
            mixin(enumMixinStr__SC_THREAD_THREADS_MAX);
        }
    }




    static if(!is(typeof(_SC_THREAD_STACK_MIN))) {
        private enum enumMixinStr__SC_THREAD_STACK_MIN = `enum _SC_THREAD_STACK_MIN = _SC_THREAD_STACK_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_STACK_MIN); }))) {
            mixin(enumMixinStr__SC_THREAD_STACK_MIN);
        }
    }







    static if(!is(typeof(_SC_THREAD_KEYS_MAX))) {
        private enum enumMixinStr__SC_THREAD_KEYS_MAX = `enum _SC_THREAD_KEYS_MAX = _SC_THREAD_KEYS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_KEYS_MAX); }))) {
            mixin(enumMixinStr__SC_THREAD_KEYS_MAX);
        }
    }







    static if(!is(typeof(_SC_THREAD_DESTRUCTOR_ITERATIONS))) {
        private enum enumMixinStr__SC_THREAD_DESTRUCTOR_ITERATIONS = `enum _SC_THREAD_DESTRUCTOR_ITERATIONS = _SC_THREAD_DESTRUCTOR_ITERATIONS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_DESTRUCTOR_ITERATIONS); }))) {
            mixin(enumMixinStr__SC_THREAD_DESTRUCTOR_ITERATIONS);
        }
    }




    static if(!is(typeof(_SC_TTY_NAME_MAX))) {
        private enum enumMixinStr__SC_TTY_NAME_MAX = `enum _SC_TTY_NAME_MAX = _SC_TTY_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TTY_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_TTY_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_LOGIN_NAME_MAX))) {
        private enum enumMixinStr__SC_LOGIN_NAME_MAX = `enum _SC_LOGIN_NAME_MAX = _SC_LOGIN_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LOGIN_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_LOGIN_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_GETPW_R_SIZE_MAX))) {
        private enum enumMixinStr__SC_GETPW_R_SIZE_MAX = `enum _SC_GETPW_R_SIZE_MAX = _SC_GETPW_R_SIZE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_GETPW_R_SIZE_MAX); }))) {
            mixin(enumMixinStr__SC_GETPW_R_SIZE_MAX);
        }
    }




    static if(!is(typeof(_SC_GETGR_R_SIZE_MAX))) {
        private enum enumMixinStr__SC_GETGR_R_SIZE_MAX = `enum _SC_GETGR_R_SIZE_MAX = _SC_GETGR_R_SIZE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_GETGR_R_SIZE_MAX); }))) {
            mixin(enumMixinStr__SC_GETGR_R_SIZE_MAX);
        }
    }




    static if(!is(typeof(_SC_THREAD_SAFE_FUNCTIONS))) {
        private enum enumMixinStr__SC_THREAD_SAFE_FUNCTIONS = `enum _SC_THREAD_SAFE_FUNCTIONS = _SC_THREAD_SAFE_FUNCTIONS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREAD_SAFE_FUNCTIONS); }))) {
            mixin(enumMixinStr__SC_THREAD_SAFE_FUNCTIONS);
        }
    }




    static if(!is(typeof(_SC_THREADS))) {
        private enum enumMixinStr__SC_THREADS = `enum _SC_THREADS = _SC_THREADS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_THREADS); }))) {
            mixin(enumMixinStr__SC_THREADS);
        }
    }




    static if(!is(typeof(_SC_T_IOV_MAX))) {
        private enum enumMixinStr__SC_T_IOV_MAX = `enum _SC_T_IOV_MAX = _SC_T_IOV_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_T_IOV_MAX); }))) {
            mixin(enumMixinStr__SC_T_IOV_MAX);
        }
    }




    static if(!is(typeof(_SC_PII_OSI_M))) {
        private enum enumMixinStr__SC_PII_OSI_M = `enum _SC_PII_OSI_M = _SC_PII_OSI_M;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI_M); }))) {
            mixin(enumMixinStr__SC_PII_OSI_M);
        }
    }




    static if(!is(typeof(_SC_PII_OSI_CLTS))) {
        private enum enumMixinStr__SC_PII_OSI_CLTS = `enum _SC_PII_OSI_CLTS = _SC_PII_OSI_CLTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI_CLTS); }))) {
            mixin(enumMixinStr__SC_PII_OSI_CLTS);
        }
    }




    static if(!is(typeof(_SC_PII_OSI_COTS))) {
        private enum enumMixinStr__SC_PII_OSI_COTS = `enum _SC_PII_OSI_COTS = _SC_PII_OSI_COTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI_COTS); }))) {
            mixin(enumMixinStr__SC_PII_OSI_COTS);
        }
    }




    static if(!is(typeof(_SC_PII_INTERNET_DGRAM))) {
        private enum enumMixinStr__SC_PII_INTERNET_DGRAM = `enum _SC_PII_INTERNET_DGRAM = _SC_PII_INTERNET_DGRAM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_INTERNET_DGRAM); }))) {
            mixin(enumMixinStr__SC_PII_INTERNET_DGRAM);
        }
    }




    static if(!is(typeof(_SC_PII_INTERNET_STREAM))) {
        private enum enumMixinStr__SC_PII_INTERNET_STREAM = `enum _SC_PII_INTERNET_STREAM = _SC_PII_INTERNET_STREAM;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_INTERNET_STREAM); }))) {
            mixin(enumMixinStr__SC_PII_INTERNET_STREAM);
        }
    }




    static if(!is(typeof(_SC_IOV_MAX))) {
        private enum enumMixinStr__SC_IOV_MAX = `enum _SC_IOV_MAX = _SC_IOV_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_IOV_MAX); }))) {
            mixin(enumMixinStr__SC_IOV_MAX);
        }
    }







    static if(!is(typeof(_SC_UIO_MAXIOV))) {
        private enum enumMixinStr__SC_UIO_MAXIOV = `enum _SC_UIO_MAXIOV = _SC_UIO_MAXIOV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_UIO_MAXIOV); }))) {
            mixin(enumMixinStr__SC_UIO_MAXIOV);
        }
    }




    static if(!is(typeof(_SC_SELECT))) {
        private enum enumMixinStr__SC_SELECT = `enum _SC_SELECT = _SC_SELECT;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SELECT); }))) {
            mixin(enumMixinStr__SC_SELECT);
        }
    }




    static if(!is(typeof(_SC_POLL))) {
        private enum enumMixinStr__SC_POLL = `enum _SC_POLL = _SC_POLL;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_POLL); }))) {
            mixin(enumMixinStr__SC_POLL);
        }
    }




    static if(!is(typeof(_SC_PII_OSI))) {
        private enum enumMixinStr__SC_PII_OSI = `enum _SC_PII_OSI = _SC_PII_OSI;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_OSI); }))) {
            mixin(enumMixinStr__SC_PII_OSI);
        }
    }




    static if(!is(typeof(_SC_PII_INTERNET))) {
        private enum enumMixinStr__SC_PII_INTERNET = `enum _SC_PII_INTERNET = _SC_PII_INTERNET;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_INTERNET); }))) {
            mixin(enumMixinStr__SC_PII_INTERNET);
        }
    }




    static if(!is(typeof(_SC_PII_SOCKET))) {
        private enum enumMixinStr__SC_PII_SOCKET = `enum _SC_PII_SOCKET = _SC_PII_SOCKET;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_SOCKET); }))) {
            mixin(enumMixinStr__SC_PII_SOCKET);
        }
    }




    static if(!is(typeof(_SC_PII_XTI))) {
        private enum enumMixinStr__SC_PII_XTI = `enum _SC_PII_XTI = _SC_PII_XTI;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII_XTI); }))) {
            mixin(enumMixinStr__SC_PII_XTI);
        }
    }







    static if(!is(typeof(_SC_PII))) {
        private enum enumMixinStr__SC_PII = `enum _SC_PII = _SC_PII;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PII); }))) {
            mixin(enumMixinStr__SC_PII);
        }
    }




    static if(!is(typeof(_SC_2_LOCALEDEF))) {
        private enum enumMixinStr__SC_2_LOCALEDEF = `enum _SC_2_LOCALEDEF = _SC_2_LOCALEDEF;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_LOCALEDEF); }))) {
            mixin(enumMixinStr__SC_2_LOCALEDEF);
        }
    }




    static if(!is(typeof(_SC_2_SW_DEV))) {
        private enum enumMixinStr__SC_2_SW_DEV = `enum _SC_2_SW_DEV = _SC_2_SW_DEV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_SW_DEV); }))) {
            mixin(enumMixinStr__SC_2_SW_DEV);
        }
    }




    static if(!is(typeof(_SC_2_FORT_RUN))) {
        private enum enumMixinStr__SC_2_FORT_RUN = `enum _SC_2_FORT_RUN = _SC_2_FORT_RUN;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_FORT_RUN); }))) {
            mixin(enumMixinStr__SC_2_FORT_RUN);
        }
    }




    static if(!is(typeof(_SC_2_FORT_DEV))) {
        private enum enumMixinStr__SC_2_FORT_DEV = `enum _SC_2_FORT_DEV = _SC_2_FORT_DEV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_FORT_DEV); }))) {
            mixin(enumMixinStr__SC_2_FORT_DEV);
        }
    }




    static if(!is(typeof(_SC_2_C_DEV))) {
        private enum enumMixinStr__SC_2_C_DEV = `enum _SC_2_C_DEV = _SC_2_C_DEV;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_C_DEV); }))) {
            mixin(enumMixinStr__SC_2_C_DEV);
        }
    }




    static if(!is(typeof(_SC_2_C_BIND))) {
        private enum enumMixinStr__SC_2_C_BIND = `enum _SC_2_C_BIND = _SC_2_C_BIND;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_C_BIND); }))) {
            mixin(enumMixinStr__SC_2_C_BIND);
        }
    }




    static if(!is(typeof(_SC_2_VERSION))) {
        private enum enumMixinStr__SC_2_VERSION = `enum _SC_2_VERSION = _SC_2_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_2_VERSION); }))) {
            mixin(enumMixinStr__SC_2_VERSION);
        }
    }




    static if(!is(typeof(_SC_CHARCLASS_NAME_MAX))) {
        private enum enumMixinStr__SC_CHARCLASS_NAME_MAX = `enum _SC_CHARCLASS_NAME_MAX = _SC_CHARCLASS_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHARCLASS_NAME_MAX); }))) {
            mixin(enumMixinStr__SC_CHARCLASS_NAME_MAX);
        }
    }




    static if(!is(typeof(_SC_RE_DUP_MAX))) {
        private enum enumMixinStr__SC_RE_DUP_MAX = `enum _SC_RE_DUP_MAX = _SC_RE_DUP_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_RE_DUP_MAX); }))) {
            mixin(enumMixinStr__SC_RE_DUP_MAX);
        }
    }




    static if(!is(typeof(_SC_LINE_MAX))) {
        private enum enumMixinStr__SC_LINE_MAX = `enum _SC_LINE_MAX = _SC_LINE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_LINE_MAX); }))) {
            mixin(enumMixinStr__SC_LINE_MAX);
        }
    }




    static if(!is(typeof(_SC_EXPR_NEST_MAX))) {
        private enum enumMixinStr__SC_EXPR_NEST_MAX = `enum _SC_EXPR_NEST_MAX = _SC_EXPR_NEST_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_EXPR_NEST_MAX); }))) {
            mixin(enumMixinStr__SC_EXPR_NEST_MAX);
        }
    }




    static if(!is(typeof(_SC_EQUIV_CLASS_MAX))) {
        private enum enumMixinStr__SC_EQUIV_CLASS_MAX = `enum _SC_EQUIV_CLASS_MAX = _SC_EQUIV_CLASS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_EQUIV_CLASS_MAX); }))) {
            mixin(enumMixinStr__SC_EQUIV_CLASS_MAX);
        }
    }




    static if(!is(typeof(_SC_COLL_WEIGHTS_MAX))) {
        private enum enumMixinStr__SC_COLL_WEIGHTS_MAX = `enum _SC_COLL_WEIGHTS_MAX = _SC_COLL_WEIGHTS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_COLL_WEIGHTS_MAX); }))) {
            mixin(enumMixinStr__SC_COLL_WEIGHTS_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_STRING_MAX))) {
        private enum enumMixinStr__SC_BC_STRING_MAX = `enum _SC_BC_STRING_MAX = _SC_BC_STRING_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_STRING_MAX); }))) {
            mixin(enumMixinStr__SC_BC_STRING_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_SCALE_MAX))) {
        private enum enumMixinStr__SC_BC_SCALE_MAX = `enum _SC_BC_SCALE_MAX = _SC_BC_SCALE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_SCALE_MAX); }))) {
            mixin(enumMixinStr__SC_BC_SCALE_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_DIM_MAX))) {
        private enum enumMixinStr__SC_BC_DIM_MAX = `enum _SC_BC_DIM_MAX = _SC_BC_DIM_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_DIM_MAX); }))) {
            mixin(enumMixinStr__SC_BC_DIM_MAX);
        }
    }




    static if(!is(typeof(_SC_BC_BASE_MAX))) {
        private enum enumMixinStr__SC_BC_BASE_MAX = `enum _SC_BC_BASE_MAX = _SC_BC_BASE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_BC_BASE_MAX); }))) {
            mixin(enumMixinStr__SC_BC_BASE_MAX);
        }
    }




    static if(!is(typeof(LXW_ZIP_BUFFER_SIZE))) {
        private enum enumMixinStr_LXW_ZIP_BUFFER_SIZE = `enum LXW_ZIP_BUFFER_SIZE = ( 16384 );`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_ZIP_BUFFER_SIZE); }))) {
            mixin(enumMixinStr_LXW_ZIP_BUFFER_SIZE);
        }
    }







    static if(!is(typeof(_SC_TIMER_MAX))) {
        private enum enumMixinStr__SC_TIMER_MAX = `enum _SC_TIMER_MAX = _SC_TIMER_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TIMER_MAX); }))) {
            mixin(enumMixinStr__SC_TIMER_MAX);
        }
    }




    static if(!is(typeof(_SC_SIGQUEUE_MAX))) {
        private enum enumMixinStr__SC_SIGQUEUE_MAX = `enum _SC_SIGQUEUE_MAX = _SC_SIGQUEUE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SIGQUEUE_MAX); }))) {
            mixin(enumMixinStr__SC_SIGQUEUE_MAX);
        }
    }




    static if(!is(typeof(_SC_SEM_VALUE_MAX))) {
        private enum enumMixinStr__SC_SEM_VALUE_MAX = `enum _SC_SEM_VALUE_MAX = _SC_SEM_VALUE_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SEM_VALUE_MAX); }))) {
            mixin(enumMixinStr__SC_SEM_VALUE_MAX);
        }
    }




    static if(!is(typeof(_SC_SEM_NSEMS_MAX))) {
        private enum enumMixinStr__SC_SEM_NSEMS_MAX = `enum _SC_SEM_NSEMS_MAX = _SC_SEM_NSEMS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SEM_NSEMS_MAX); }))) {
            mixin(enumMixinStr__SC_SEM_NSEMS_MAX);
        }
    }




    static if(!is(typeof(_SC_RTSIG_MAX))) {
        private enum enumMixinStr__SC_RTSIG_MAX = `enum _SC_RTSIG_MAX = _SC_RTSIG_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_RTSIG_MAX); }))) {
            mixin(enumMixinStr__SC_RTSIG_MAX);
        }
    }







    static if(!is(typeof(_SC_PAGE_SIZE))) {
        private enum enumMixinStr__SC_PAGE_SIZE = `enum _SC_PAGE_SIZE = _SC_PAGESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PAGE_SIZE); }))) {
            mixin(enumMixinStr__SC_PAGE_SIZE);
        }
    }




    static if(!is(typeof(_SC_PAGESIZE))) {
        private enum enumMixinStr__SC_PAGESIZE = `enum _SC_PAGESIZE = _SC_PAGESIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PAGESIZE); }))) {
            mixin(enumMixinStr__SC_PAGESIZE);
        }
    }




    static if(!is(typeof(_SC_VERSION))) {
        private enum enumMixinStr__SC_VERSION = `enum _SC_VERSION = _SC_VERSION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_VERSION); }))) {
            mixin(enumMixinStr__SC_VERSION);
        }
    }




    static if(!is(typeof(_SC_MQ_PRIO_MAX))) {
        private enum enumMixinStr__SC_MQ_PRIO_MAX = `enum _SC_MQ_PRIO_MAX = _SC_MQ_PRIO_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MQ_PRIO_MAX); }))) {
            mixin(enumMixinStr__SC_MQ_PRIO_MAX);
        }
    }




    static if(!is(typeof(_SC_MQ_OPEN_MAX))) {
        private enum enumMixinStr__SC_MQ_OPEN_MAX = `enum _SC_MQ_OPEN_MAX = _SC_MQ_OPEN_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MQ_OPEN_MAX); }))) {
            mixin(enumMixinStr__SC_MQ_OPEN_MAX);
        }
    }




    static if(!is(typeof(_SC_DELAYTIMER_MAX))) {
        private enum enumMixinStr__SC_DELAYTIMER_MAX = `enum _SC_DELAYTIMER_MAX = _SC_DELAYTIMER_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_DELAYTIMER_MAX); }))) {
            mixin(enumMixinStr__SC_DELAYTIMER_MAX);
        }
    }




    static if(!is(typeof(_SC_AIO_PRIO_DELTA_MAX))) {
        private enum enumMixinStr__SC_AIO_PRIO_DELTA_MAX = `enum _SC_AIO_PRIO_DELTA_MAX = _SC_AIO_PRIO_DELTA_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AIO_PRIO_DELTA_MAX); }))) {
            mixin(enumMixinStr__SC_AIO_PRIO_DELTA_MAX);
        }
    }




    static if(!is(typeof(_SC_AIO_MAX))) {
        private enum enumMixinStr__SC_AIO_MAX = `enum _SC_AIO_MAX = _SC_AIO_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AIO_MAX); }))) {
            mixin(enumMixinStr__SC_AIO_MAX);
        }
    }




    static if(!is(typeof(_SC_AIO_LISTIO_MAX))) {
        private enum enumMixinStr__SC_AIO_LISTIO_MAX = `enum _SC_AIO_LISTIO_MAX = _SC_AIO_LISTIO_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_AIO_LISTIO_MAX); }))) {
            mixin(enumMixinStr__SC_AIO_LISTIO_MAX);
        }
    }




    static if(!is(typeof(_SC_SHARED_MEMORY_OBJECTS))) {
        private enum enumMixinStr__SC_SHARED_MEMORY_OBJECTS = `enum _SC_SHARED_MEMORY_OBJECTS = _SC_SHARED_MEMORY_OBJECTS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SHARED_MEMORY_OBJECTS); }))) {
            mixin(enumMixinStr__SC_SHARED_MEMORY_OBJECTS);
        }
    }




    static if(!is(typeof(_SC_SEMAPHORES))) {
        private enum enumMixinStr__SC_SEMAPHORES = `enum _SC_SEMAPHORES = _SC_SEMAPHORES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SEMAPHORES); }))) {
            mixin(enumMixinStr__SC_SEMAPHORES);
        }
    }




    static if(!is(typeof(_SC_MESSAGE_PASSING))) {
        private enum enumMixinStr__SC_MESSAGE_PASSING = `enum _SC_MESSAGE_PASSING = _SC_MESSAGE_PASSING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MESSAGE_PASSING); }))) {
            mixin(enumMixinStr__SC_MESSAGE_PASSING);
        }
    }




    static if(!is(typeof(_SC_MEMORY_PROTECTION))) {
        private enum enumMixinStr__SC_MEMORY_PROTECTION = `enum _SC_MEMORY_PROTECTION = _SC_MEMORY_PROTECTION;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MEMORY_PROTECTION); }))) {
            mixin(enumMixinStr__SC_MEMORY_PROTECTION);
        }
    }




    static if(!is(typeof(_SC_MEMLOCK_RANGE))) {
        private enum enumMixinStr__SC_MEMLOCK_RANGE = `enum _SC_MEMLOCK_RANGE = _SC_MEMLOCK_RANGE;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MEMLOCK_RANGE); }))) {
            mixin(enumMixinStr__SC_MEMLOCK_RANGE);
        }
    }




    static if(!is(typeof(_SC_MEMLOCK))) {
        private enum enumMixinStr__SC_MEMLOCK = `enum _SC_MEMLOCK = _SC_MEMLOCK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MEMLOCK); }))) {
            mixin(enumMixinStr__SC_MEMLOCK);
        }
    }




    static if(!is(typeof(_SC_MAPPED_FILES))) {
        private enum enumMixinStr__SC_MAPPED_FILES = `enum _SC_MAPPED_FILES = _SC_MAPPED_FILES;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_MAPPED_FILES); }))) {
            mixin(enumMixinStr__SC_MAPPED_FILES);
        }
    }







    static if(!is(typeof(_SC_FSYNC))) {
        private enum enumMixinStr__SC_FSYNC = `enum _SC_FSYNC = _SC_FSYNC;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_FSYNC); }))) {
            mixin(enumMixinStr__SC_FSYNC);
        }
    }




    static if(!is(typeof(_SC_SYNCHRONIZED_IO))) {
        private enum enumMixinStr__SC_SYNCHRONIZED_IO = `enum _SC_SYNCHRONIZED_IO = _SC_SYNCHRONIZED_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SYNCHRONIZED_IO); }))) {
            mixin(enumMixinStr__SC_SYNCHRONIZED_IO);
        }
    }




    static if(!is(typeof(_SC_PRIORITIZED_IO))) {
        private enum enumMixinStr__SC_PRIORITIZED_IO = `enum _SC_PRIORITIZED_IO = _SC_PRIORITIZED_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PRIORITIZED_IO); }))) {
            mixin(enumMixinStr__SC_PRIORITIZED_IO);
        }
    }




    static if(!is(typeof(_SC_ASYNCHRONOUS_IO))) {
        private enum enumMixinStr__SC_ASYNCHRONOUS_IO = `enum _SC_ASYNCHRONOUS_IO = _SC_ASYNCHRONOUS_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ASYNCHRONOUS_IO); }))) {
            mixin(enumMixinStr__SC_ASYNCHRONOUS_IO);
        }
    }




    static if(!is(typeof(_SC_TIMERS))) {
        private enum enumMixinStr__SC_TIMERS = `enum _SC_TIMERS = _SC_TIMERS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TIMERS); }))) {
            mixin(enumMixinStr__SC_TIMERS);
        }
    }




    static if(!is(typeof(_SC_PRIORITY_SCHEDULING))) {
        private enum enumMixinStr__SC_PRIORITY_SCHEDULING = `enum _SC_PRIORITY_SCHEDULING = _SC_PRIORITY_SCHEDULING;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_PRIORITY_SCHEDULING); }))) {
            mixin(enumMixinStr__SC_PRIORITY_SCHEDULING);
        }
    }




    static if(!is(typeof(_SC_REALTIME_SIGNALS))) {
        private enum enumMixinStr__SC_REALTIME_SIGNALS = `enum _SC_REALTIME_SIGNALS = _SC_REALTIME_SIGNALS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_REALTIME_SIGNALS); }))) {
            mixin(enumMixinStr__SC_REALTIME_SIGNALS);
        }
    }




    static if(!is(typeof(_SC_SAVED_IDS))) {
        private enum enumMixinStr__SC_SAVED_IDS = `enum _SC_SAVED_IDS = _SC_SAVED_IDS;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_SAVED_IDS); }))) {
            mixin(enumMixinStr__SC_SAVED_IDS);
        }
    }







    static if(!is(typeof(_SC_JOB_CONTROL))) {
        private enum enumMixinStr__SC_JOB_CONTROL = `enum _SC_JOB_CONTROL = _SC_JOB_CONTROL;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_JOB_CONTROL); }))) {
            mixin(enumMixinStr__SC_JOB_CONTROL);
        }
    }




    static if(!is(typeof(_SC_TZNAME_MAX))) {
        private enum enumMixinStr__SC_TZNAME_MAX = `enum _SC_TZNAME_MAX = _SC_TZNAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_TZNAME_MAX); }))) {
            mixin(enumMixinStr__SC_TZNAME_MAX);
        }
    }




    static if(!is(typeof(_SC_STREAM_MAX))) {
        private enum enumMixinStr__SC_STREAM_MAX = `enum _SC_STREAM_MAX = _SC_STREAM_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_STREAM_MAX); }))) {
            mixin(enumMixinStr__SC_STREAM_MAX);
        }
    }




    static if(!is(typeof(_SC_OPEN_MAX))) {
        private enum enumMixinStr__SC_OPEN_MAX = `enum _SC_OPEN_MAX = _SC_OPEN_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_OPEN_MAX); }))) {
            mixin(enumMixinStr__SC_OPEN_MAX);
        }
    }




    static if(!is(typeof(_SC_NGROUPS_MAX))) {
        private enum enumMixinStr__SC_NGROUPS_MAX = `enum _SC_NGROUPS_MAX = _SC_NGROUPS_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_NGROUPS_MAX); }))) {
            mixin(enumMixinStr__SC_NGROUPS_MAX);
        }
    }




    static if(!is(typeof(_SC_CLK_TCK))) {
        private enum enumMixinStr__SC_CLK_TCK = `enum _SC_CLK_TCK = _SC_CLK_TCK;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CLK_TCK); }))) {
            mixin(enumMixinStr__SC_CLK_TCK);
        }
    }




    static if(!is(typeof(_SC_CHILD_MAX))) {
        private enum enumMixinStr__SC_CHILD_MAX = `enum _SC_CHILD_MAX = _SC_CHILD_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_CHILD_MAX); }))) {
            mixin(enumMixinStr__SC_CHILD_MAX);
        }
    }




    static if(!is(typeof(_SC_ARG_MAX))) {
        private enum enumMixinStr__SC_ARG_MAX = `enum _SC_ARG_MAX = _SC_ARG_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__SC_ARG_MAX); }))) {
            mixin(enumMixinStr__SC_ARG_MAX);
        }
    }







    static if(!is(typeof(_PC_2_SYMLINKS))) {
        private enum enumMixinStr__PC_2_SYMLINKS = `enum _PC_2_SYMLINKS = _PC_2_SYMLINKS;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_2_SYMLINKS); }))) {
            mixin(enumMixinStr__PC_2_SYMLINKS);
        }
    }




    static if(!is(typeof(_PC_SYMLINK_MAX))) {
        private enum enumMixinStr__PC_SYMLINK_MAX = `enum _PC_SYMLINK_MAX = _PC_SYMLINK_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_SYMLINK_MAX); }))) {
            mixin(enumMixinStr__PC_SYMLINK_MAX);
        }
    }




    static if(!is(typeof(_PC_ALLOC_SIZE_MIN))) {
        private enum enumMixinStr__PC_ALLOC_SIZE_MIN = `enum _PC_ALLOC_SIZE_MIN = _PC_ALLOC_SIZE_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_ALLOC_SIZE_MIN); }))) {
            mixin(enumMixinStr__PC_ALLOC_SIZE_MIN);
        }
    }




    static if(!is(typeof(_PC_REC_XFER_ALIGN))) {
        private enum enumMixinStr__PC_REC_XFER_ALIGN = `enum _PC_REC_XFER_ALIGN = _PC_REC_XFER_ALIGN;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_XFER_ALIGN); }))) {
            mixin(enumMixinStr__PC_REC_XFER_ALIGN);
        }
    }




    static if(!is(typeof(_PC_REC_MIN_XFER_SIZE))) {
        private enum enumMixinStr__PC_REC_MIN_XFER_SIZE = `enum _PC_REC_MIN_XFER_SIZE = _PC_REC_MIN_XFER_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_MIN_XFER_SIZE); }))) {
            mixin(enumMixinStr__PC_REC_MIN_XFER_SIZE);
        }
    }




    static if(!is(typeof(_PC_REC_MAX_XFER_SIZE))) {
        private enum enumMixinStr__PC_REC_MAX_XFER_SIZE = `enum _PC_REC_MAX_XFER_SIZE = _PC_REC_MAX_XFER_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_MAX_XFER_SIZE); }))) {
            mixin(enumMixinStr__PC_REC_MAX_XFER_SIZE);
        }
    }




    static if(!is(typeof(_PC_REC_INCR_XFER_SIZE))) {
        private enum enumMixinStr__PC_REC_INCR_XFER_SIZE = `enum _PC_REC_INCR_XFER_SIZE = _PC_REC_INCR_XFER_SIZE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_REC_INCR_XFER_SIZE); }))) {
            mixin(enumMixinStr__PC_REC_INCR_XFER_SIZE);
        }
    }




    static if(!is(typeof(_PC_FILESIZEBITS))) {
        private enum enumMixinStr__PC_FILESIZEBITS = `enum _PC_FILESIZEBITS = _PC_FILESIZEBITS;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_FILESIZEBITS); }))) {
            mixin(enumMixinStr__PC_FILESIZEBITS);
        }
    }




    static if(!is(typeof(_PC_SOCK_MAXBUF))) {
        private enum enumMixinStr__PC_SOCK_MAXBUF = `enum _PC_SOCK_MAXBUF = _PC_SOCK_MAXBUF;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_SOCK_MAXBUF); }))) {
            mixin(enumMixinStr__PC_SOCK_MAXBUF);
        }
    }




    static if(!is(typeof(_PC_PRIO_IO))) {
        private enum enumMixinStr__PC_PRIO_IO = `enum _PC_PRIO_IO = _PC_PRIO_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_PRIO_IO); }))) {
            mixin(enumMixinStr__PC_PRIO_IO);
        }
    }







    static if(!is(typeof(_PC_ASYNC_IO))) {
        private enum enumMixinStr__PC_ASYNC_IO = `enum _PC_ASYNC_IO = _PC_ASYNC_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_ASYNC_IO); }))) {
            mixin(enumMixinStr__PC_ASYNC_IO);
        }
    }




    static if(!is(typeof(_PC_SYNC_IO))) {
        private enum enumMixinStr__PC_SYNC_IO = `enum _PC_SYNC_IO = _PC_SYNC_IO;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_SYNC_IO); }))) {
            mixin(enumMixinStr__PC_SYNC_IO);
        }
    }




    static if(!is(typeof(_PC_VDISABLE))) {
        private enum enumMixinStr__PC_VDISABLE = `enum _PC_VDISABLE = _PC_VDISABLE;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_VDISABLE); }))) {
            mixin(enumMixinStr__PC_VDISABLE);
        }
    }




    static if(!is(typeof(_PC_NO_TRUNC))) {
        private enum enumMixinStr__PC_NO_TRUNC = `enum _PC_NO_TRUNC = _PC_NO_TRUNC;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_NO_TRUNC); }))) {
            mixin(enumMixinStr__PC_NO_TRUNC);
        }
    }




    static if(!is(typeof(_PC_CHOWN_RESTRICTED))) {
        private enum enumMixinStr__PC_CHOWN_RESTRICTED = `enum _PC_CHOWN_RESTRICTED = _PC_CHOWN_RESTRICTED;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_CHOWN_RESTRICTED); }))) {
            mixin(enumMixinStr__PC_CHOWN_RESTRICTED);
        }
    }




    static if(!is(typeof(_PC_PIPE_BUF))) {
        private enum enumMixinStr__PC_PIPE_BUF = `enum _PC_PIPE_BUF = _PC_PIPE_BUF;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_PIPE_BUF); }))) {
            mixin(enumMixinStr__PC_PIPE_BUF);
        }
    }




    static if(!is(typeof(_PC_PATH_MAX))) {
        private enum enumMixinStr__PC_PATH_MAX = `enum _PC_PATH_MAX = _PC_PATH_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_PATH_MAX); }))) {
            mixin(enumMixinStr__PC_PATH_MAX);
        }
    }







    static if(!is(typeof(_PC_NAME_MAX))) {
        private enum enumMixinStr__PC_NAME_MAX = `enum _PC_NAME_MAX = _PC_NAME_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_NAME_MAX); }))) {
            mixin(enumMixinStr__PC_NAME_MAX);
        }
    }




    static if(!is(typeof(_PC_MAX_INPUT))) {
        private enum enumMixinStr__PC_MAX_INPUT = `enum _PC_MAX_INPUT = _PC_MAX_INPUT;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_MAX_INPUT); }))) {
            mixin(enumMixinStr__PC_MAX_INPUT);
        }
    }




    static if(!is(typeof(_PC_MAX_CANON))) {
        private enum enumMixinStr__PC_MAX_CANON = `enum _PC_MAX_CANON = _PC_MAX_CANON;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_MAX_CANON); }))) {
            mixin(enumMixinStr__PC_MAX_CANON);
        }
    }




    static if(!is(typeof(_PC_LINK_MAX))) {
        private enum enumMixinStr__PC_LINK_MAX = `enum _PC_LINK_MAX = _PC_LINK_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr__PC_LINK_MAX); }))) {
            mixin(enumMixinStr__PC_LINK_MAX);
        }
    }
    static if(!is(typeof(_BITS_BYTESWAP_H))) {
        enum _BITS_BYTESWAP_H = 1;
    }
    static if(!is(typeof(_FILE_OFFSET_BIT))) {
        enum _FILE_OFFSET_BIT = 64;
    }







    static if(!is(typeof(EHWPOISON))) {
        enum EHWPOISON = 133;
    }




    static if(!is(typeof(ERFKILL))) {
        enum ERFKILL = 132;
    }




    static if(!is(typeof(MAXU32))) {
        enum MAXU32 = 0xffffffff;
    }




    static if(!is(typeof(ENOTRECOVERABLE))) {
        enum ENOTRECOVERABLE = 131;
    }




    static if(!is(typeof(ZLIB_FILEFUNC_SEEK_CUR))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_SEEK_CUR = `enum ZLIB_FILEFUNC_SEEK_CUR = ( 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_SEEK_CUR); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_SEEK_CUR);
        }
    }




    static if(!is(typeof(ZLIB_FILEFUNC_SEEK_END))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_SEEK_END = `enum ZLIB_FILEFUNC_SEEK_END = ( 2 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_SEEK_END); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_SEEK_END);
        }
    }




    static if(!is(typeof(ZLIB_FILEFUNC_SEEK_SET))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_SEEK_SET = `enum ZLIB_FILEFUNC_SEEK_SET = ( 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_SEEK_SET); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_SEEK_SET);
        }
    }




    static if(!is(typeof(ZLIB_FILEFUNC_MODE_READ))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_MODE_READ = `enum ZLIB_FILEFUNC_MODE_READ = ( 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_READ); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_READ);
        }
    }




    static if(!is(typeof(ZLIB_FILEFUNC_MODE_WRITE))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_MODE_WRITE = `enum ZLIB_FILEFUNC_MODE_WRITE = ( 2 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_WRITE); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_WRITE);
        }
    }




    static if(!is(typeof(ZLIB_FILEFUNC_MODE_READWRITEFILTER))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_MODE_READWRITEFILTER = `enum ZLIB_FILEFUNC_MODE_READWRITEFILTER = ( 3 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_READWRITEFILTER); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_READWRITEFILTER);
        }
    }




    static if(!is(typeof(ZLIB_FILEFUNC_MODE_EXISTING))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_MODE_EXISTING = `enum ZLIB_FILEFUNC_MODE_EXISTING = ( 4 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_EXISTING); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_EXISTING);
        }
    }




    static if(!is(typeof(ZLIB_FILEFUNC_MODE_CREATE))) {
        private enum enumMixinStr_ZLIB_FILEFUNC_MODE_CREATE = `enum ZLIB_FILEFUNC_MODE_CREATE = ( 8 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_CREATE); }))) {
            mixin(enumMixinStr_ZLIB_FILEFUNC_MODE_CREATE);
        }
    }







    static if(!is(typeof(EOWNERDEAD))) {
        enum EOWNERDEAD = 130;
    }




    static if(!is(typeof(EKEYREJECTED))) {
        enum EKEYREJECTED = 129;
    }




    static if(!is(typeof(EKEYREVOKED))) {
        enum EKEYREVOKED = 128;
    }




    static if(!is(typeof(EKEYEXPIRED))) {
        enum EKEYEXPIRED = 127;
    }




    static if(!is(typeof(ENOKEY))) {
        enum ENOKEY = 126;
    }




    static if(!is(typeof(ECANCELED))) {
        enum ECANCELED = 125;
    }




    static if(!is(typeof(EMEDIUMTYPE))) {
        enum EMEDIUMTYPE = 124;
    }




    static if(!is(typeof(ENOMEDIUM))) {
        enum ENOMEDIUM = 123;
    }




    static if(!is(typeof(EDQUOT))) {
        enum EDQUOT = 122;
    }




    static if(!is(typeof(EREMOTEIO))) {
        enum EREMOTEIO = 121;
    }




    static if(!is(typeof(EISNAM))) {
        enum EISNAM = 120;
    }




    static if(!is(typeof(ENAVAIL))) {
        enum ENAVAIL = 119;
    }




    static if(!is(typeof(ENOTNAM))) {
        enum ENOTNAM = 118;
    }




    static if(!is(typeof(EUCLEAN))) {
        enum EUCLEAN = 117;
    }




    static if(!is(typeof(ESTALE))) {
        enum ESTALE = 116;
    }




    static if(!is(typeof(EINPROGRESS))) {
        enum EINPROGRESS = 115;
    }




    static if(!is(typeof(EALREADY))) {
        enum EALREADY = 114;
    }




    static if(!is(typeof(EHOSTUNREACH))) {
        enum EHOSTUNREACH = 113;
    }




    static if(!is(typeof(EHOSTDOWN))) {
        enum EHOSTDOWN = 112;
    }




    static if(!is(typeof(ECONNREFUSED))) {
        enum ECONNREFUSED = 111;
    }




    static if(!is(typeof(ETIMEDOUT))) {
        enum ETIMEDOUT = 110;
    }




    static if(!is(typeof(ETOOMANYREFS))) {
        enum ETOOMANYREFS = 109;
    }




    static if(!is(typeof(ESHUTDOWN))) {
        enum ESHUTDOWN = 108;
    }




    static if(!is(typeof(ENOTCONN))) {
        enum ENOTCONN = 107;
    }




    static if(!is(typeof(EISCONN))) {
        enum EISCONN = 106;
    }




    static if(!is(typeof(ENOBUFS))) {
        enum ENOBUFS = 105;
    }




    static if(!is(typeof(ECONNRESET))) {
        enum ECONNRESET = 104;
    }




    static if(!is(typeof(ECONNABORTED))) {
        enum ECONNABORTED = 103;
    }




    static if(!is(typeof(ENETRESET))) {
        enum ENETRESET = 102;
    }




    static if(!is(typeof(ENETUNREACH))) {
        enum ENETUNREACH = 101;
    }




    static if(!is(typeof(ENETDOWN))) {
        enum ENETDOWN = 100;
    }




    static if(!is(typeof(EADDRNOTAVAIL))) {
        enum EADDRNOTAVAIL = 99;
    }




    static if(!is(typeof(EADDRINUSE))) {
        enum EADDRINUSE = 98;
    }




    static if(!is(typeof(EAFNOSUPPORT))) {
        enum EAFNOSUPPORT = 97;
    }




    static if(!is(typeof(EPFNOSUPPORT))) {
        enum EPFNOSUPPORT = 96;
    }




    static if(!is(typeof(EOPNOTSUPP))) {
        enum EOPNOTSUPP = 95;
    }




    static if(!is(typeof(ESOCKTNOSUPPORT))) {
        enum ESOCKTNOSUPPORT = 94;
    }




    static if(!is(typeof(EPROTONOSUPPORT))) {
        enum EPROTONOSUPPORT = 93;
    }




    static if(!is(typeof(ENOPROTOOPT))) {
        enum ENOPROTOOPT = 92;
    }




    static if(!is(typeof(EPROTOTYPE))) {
        enum EPROTOTYPE = 91;
    }
    static if(!is(typeof(EMSGSIZE))) {
        enum EMSGSIZE = 90;
    }




    static if(!is(typeof(EDESTADDRREQ))) {
        enum EDESTADDRREQ = 89;
    }




    static if(!is(typeof(ENOTSOCK))) {
        enum ENOTSOCK = 88;
    }




    static if(!is(typeof(EUSERS))) {
        enum EUSERS = 87;
    }




    static if(!is(typeof(ESTRPIPE))) {
        enum ESTRPIPE = 86;
    }




    static if(!is(typeof(ERESTART))) {
        enum ERESTART = 85;
    }




    static if(!is(typeof(EILSEQ))) {
        enum EILSEQ = 84;
    }
    static if(!is(typeof(SPLAY_NEGINF))) {
        private enum enumMixinStr_SPLAY_NEGINF = `enum SPLAY_NEGINF = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr_SPLAY_NEGINF); }))) {
            mixin(enumMixinStr_SPLAY_NEGINF);
        }
    }




    static if(!is(typeof(SPLAY_INF))) {
        enum SPLAY_INF = 1;
    }
    static if(!is(typeof(RB_BLACK))) {
        enum RB_BLACK = 0;
    }




    static if(!is(typeof(RB_RED))) {
        enum RB_RED = 1;
    }
    static if(!is(typeof(RB_NEGINF))) {
        private enum enumMixinStr_RB_NEGINF = `enum RB_NEGINF = - 1;`;
        static if(is(typeof({ mixin(enumMixinStr_RB_NEGINF); }))) {
            mixin(enumMixinStr_RB_NEGINF);
        }
    }




    static if(!is(typeof(RB_INF))) {
        enum RB_INF = 1;
    }
    static if(!is(typeof(ELIBEXEC))) {
        enum ELIBEXEC = 83;
    }




    static if(!is(typeof(ELIBMAX))) {
        enum ELIBMAX = 82;
    }
    static if(!is(typeof(Z_BZIP2ED))) {
        enum Z_BZIP2ED = 12;
    }




    static if(!is(typeof(ELIBSCN))) {
        enum ELIBSCN = 81;
    }




    static if(!is(typeof(ZIP_OK))) {
        private enum enumMixinStr_ZIP_OK = `enum ZIP_OK = ( 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZIP_OK); }))) {
            mixin(enumMixinStr_ZIP_OK);
        }
    }




    static if(!is(typeof(ZIP_EOF))) {
        private enum enumMixinStr_ZIP_EOF = `enum ZIP_EOF = ( 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZIP_EOF); }))) {
            mixin(enumMixinStr_ZIP_EOF);
        }
    }




    static if(!is(typeof(ZIP_ERRNO))) {
        private enum enumMixinStr_ZIP_ERRNO = `enum ZIP_ERRNO = ( ( - 1 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_ZIP_ERRNO); }))) {
            mixin(enumMixinStr_ZIP_ERRNO);
        }
    }




    static if(!is(typeof(ZIP_PARAMERROR))) {
        private enum enumMixinStr_ZIP_PARAMERROR = `enum ZIP_PARAMERROR = ( - 102 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZIP_PARAMERROR); }))) {
            mixin(enumMixinStr_ZIP_PARAMERROR);
        }
    }




    static if(!is(typeof(ZIP_BADZIPFILE))) {
        private enum enumMixinStr_ZIP_BADZIPFILE = `enum ZIP_BADZIPFILE = ( - 103 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZIP_BADZIPFILE); }))) {
            mixin(enumMixinStr_ZIP_BADZIPFILE);
        }
    }




    static if(!is(typeof(ZIP_INTERNALERROR))) {
        private enum enumMixinStr_ZIP_INTERNALERROR = `enum ZIP_INTERNALERROR = ( - 104 );`;
        static if(is(typeof({ mixin(enumMixinStr_ZIP_INTERNALERROR); }))) {
            mixin(enumMixinStr_ZIP_INTERNALERROR);
        }
    }




    static if(!is(typeof(ELIBBAD))) {
        enum ELIBBAD = 80;
    }




    static if(!is(typeof(DEF_MEM_LEVEL))) {
        enum DEF_MEM_LEVEL = 8;
    }




    static if(!is(typeof(ELIBACC))) {
        enum ELIBACC = 79;
    }




    static if(!is(typeof(EREMCHG))) {
        enum EREMCHG = 78;
    }




    static if(!is(typeof(EBADFD))) {
        enum EBADFD = 77;
    }




    static if(!is(typeof(ENOTUNIQ))) {
        enum ENOTUNIQ = 76;
    }




    static if(!is(typeof(EOVERFLOW))) {
        enum EOVERFLOW = 75;
    }




    static if(!is(typeof(APPEND_STATUS_CREATE))) {
        private enum enumMixinStr_APPEND_STATUS_CREATE = `enum APPEND_STATUS_CREATE = ( 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_APPEND_STATUS_CREATE); }))) {
            mixin(enumMixinStr_APPEND_STATUS_CREATE);
        }
    }




    static if(!is(typeof(APPEND_STATUS_CREATEAFTER))) {
        private enum enumMixinStr_APPEND_STATUS_CREATEAFTER = `enum APPEND_STATUS_CREATEAFTER = ( 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_APPEND_STATUS_CREATEAFTER); }))) {
            mixin(enumMixinStr_APPEND_STATUS_CREATEAFTER);
        }
    }




    static if(!is(typeof(APPEND_STATUS_ADDINZIP))) {
        private enum enumMixinStr_APPEND_STATUS_ADDINZIP = `enum APPEND_STATUS_ADDINZIP = ( 2 );`;
        static if(is(typeof({ mixin(enumMixinStr_APPEND_STATUS_ADDINZIP); }))) {
            mixin(enumMixinStr_APPEND_STATUS_ADDINZIP);
        }
    }




    static if(!is(typeof(EBADMSG))) {
        enum EBADMSG = 74;
    }




    static if(!is(typeof(EDOTDOT))) {
        enum EDOTDOT = 73;
    }




    static if(!is(typeof(EMULTIHOP))) {
        enum EMULTIHOP = 72;
    }




    static if(!is(typeof(EPROTO))) {
        enum EPROTO = 71;
    }




    static if(!is(typeof(ECOMM))) {
        enum ECOMM = 70;
    }




    static if(!is(typeof(ESRMNT))) {
        enum ESRMNT = 69;
    }




    static if(!is(typeof(EADV))) {
        enum EADV = 68;
    }




    static if(!is(typeof(ENOLINK))) {
        enum ENOLINK = 67;
    }




    static if(!is(typeof(EREMOTE))) {
        enum EREMOTE = 66;
    }




    static if(!is(typeof(ENOPKG))) {
        enum ENOPKG = 65;
    }




    static if(!is(typeof(ENONET))) {
        enum ENONET = 64;
    }




    static if(!is(typeof(ENOSR))) {
        enum ENOSR = 63;
    }




    static if(!is(typeof(ETIME))) {
        enum ETIME = 62;
    }




    static if(!is(typeof(ENODATA))) {
        enum ENODATA = 61;
    }




    static if(!is(typeof(ENOSTR))) {
        enum ENOSTR = 60;
    }




    static if(!is(typeof(EBFONT))) {
        enum EBFONT = 59;
    }




    static if(!is(typeof(EDEADLOCK))) {
        private enum enumMixinStr_EDEADLOCK = `enum EDEADLOCK = EDEADLK;`;
        static if(is(typeof({ mixin(enumMixinStr_EDEADLOCK); }))) {
            mixin(enumMixinStr_EDEADLOCK);
        }
    }




    static if(!is(typeof(EBADSLT))) {
        enum EBADSLT = 57;
    }




    static if(!is(typeof(EBADRQC))) {
        enum EBADRQC = 56;
    }




    static if(!is(typeof(ENOANO))) {
        enum ENOANO = 55;
    }




    static if(!is(typeof(EXFULL))) {
        enum EXFULL = 54;
    }




    static if(!is(typeof(EBADR))) {
        enum EBADR = 53;
    }




    static if(!is(typeof(EBADE))) {
        enum EBADE = 52;
    }




    static if(!is(typeof(EL2HLT))) {
        enum EL2HLT = 51;
    }




    static if(!is(typeof(ENOCSI))) {
        enum ENOCSI = 50;
    }




    static if(!is(typeof(EUNATCH))) {
        enum EUNATCH = 49;
    }




    static if(!is(typeof(ELNRNG))) {
        enum ELNRNG = 48;
    }




    static if(!is(typeof(EL3RST))) {
        enum EL3RST = 47;
    }




    static if(!is(typeof(EL3HLT))) {
        enum EL3HLT = 46;
    }




    static if(!is(typeof(EL2NSYNC))) {
        enum EL2NSYNC = 45;
    }




    static if(!is(typeof(ECHRNG))) {
        enum ECHRNG = 44;
    }




    static if(!is(typeof(EIDRM))) {
        enum EIDRM = 43;
    }




    static if(!is(typeof(ENOMSG))) {
        enum ENOMSG = 42;
    }




    static if(!is(typeof(EWOULDBLOCK))) {
        private enum enumMixinStr_EWOULDBLOCK = `enum EWOULDBLOCK = EAGAIN;`;
        static if(is(typeof({ mixin(enumMixinStr_EWOULDBLOCK); }))) {
            mixin(enumMixinStr_EWOULDBLOCK);
        }
    }




    static if(!is(typeof(ELOOP))) {
        enum ELOOP = 40;
    }




    static if(!is(typeof(ENOTEMPTY))) {
        enum ENOTEMPTY = 39;
    }




    static if(!is(typeof(ENOSYS))) {
        enum ENOSYS = 38;
    }




    static if(!is(typeof(ENOLCK))) {
        enum ENOLCK = 37;
    }




    static if(!is(typeof(ENAMETOOLONG))) {
        enum ENAMETOOLONG = 36;
    }




    static if(!is(typeof(EDEADLK))) {
        enum EDEADLK = 35;
    }







    static if(!is(typeof(ERANGE))) {
        enum ERANGE = 34;
    }




    static if(!is(typeof(EDOM))) {
        enum EDOM = 33;
    }




    static if(!is(typeof(EPIPE))) {
        enum EPIPE = 32;
    }




    static if(!is(typeof(EMLINK))) {
        enum EMLINK = 31;
    }




    static if(!is(typeof(EROFS))) {
        enum EROFS = 30;
    }




    static if(!is(typeof(ESPIPE))) {
        enum ESPIPE = 29;
    }




    static if(!is(typeof(ENOSPC))) {
        enum ENOSPC = 28;
    }




    static if(!is(typeof(EFBIG))) {
        enum EFBIG = 27;
    }




    static if(!is(typeof(ETXTBSY))) {
        enum ETXTBSY = 26;
    }




    static if(!is(typeof(ENOTTY))) {
        enum ENOTTY = 25;
    }




    static if(!is(typeof(EMFILE))) {
        enum EMFILE = 24;
    }




    static if(!is(typeof(ENFILE))) {
        enum ENFILE = 23;
    }




    static if(!is(typeof(EINVAL))) {
        enum EINVAL = 22;
    }




    static if(!is(typeof(EISDIR))) {
        enum EISDIR = 21;
    }







    static if(!is(typeof(ENOTDIR))) {
        enum ENOTDIR = 20;
    }




    static if(!is(typeof(ENODEV))) {
        enum ENODEV = 19;
    }




    static if(!is(typeof(EXDEV))) {
        enum EXDEV = 18;
    }




    static if(!is(typeof(EEXIST))) {
        enum EEXIST = 17;
    }
    static if(!is(typeof(EBUSY))) {
        enum EBUSY = 16;
    }




    static if(!is(typeof(ENOTBLK))) {
        enum ENOTBLK = 15;
    }




    static if(!is(typeof(EFAULT))) {
        enum EFAULT = 14;
    }




    static if(!is(typeof(EACCES))) {
        enum EACCES = 13;
    }




    static if(!is(typeof(ENOMEM))) {
        enum ENOMEM = 12;
    }




    static if(!is(typeof(EAGAIN))) {
        enum EAGAIN = 11;
    }




    static if(!is(typeof(ECHILD))) {
        enum ECHILD = 10;
    }




    static if(!is(typeof(EBADF))) {
        enum EBADF = 9;
    }




    static if(!is(typeof(ENOEXEC))) {
        enum ENOEXEC = 8;
    }




    static if(!is(typeof(E2BIG))) {
        enum E2BIG = 7;
    }




    static if(!is(typeof(ENXIO))) {
        enum ENXIO = 6;
    }




    static if(!is(typeof(EIO))) {
        enum EIO = 5;
    }




    static if(!is(typeof(EINTR))) {
        enum EINTR = 4;
    }




    static if(!is(typeof(ESRCH))) {
        enum ESRCH = 3;
    }




    static if(!is(typeof(ENOENT))) {
        enum ENOENT = 2;
    }




    static if(!is(typeof(EPERM))) {
        enum EPERM = 1;
    }
    static if(!is(typeof(_ALLOCA_H))) {
        enum _ALLOCA_H = 1;
    }




    static if(!is(typeof(lxw_strcasecmp))) {
        private enum enumMixinStr_lxw_strcasecmp = `enum lxw_strcasecmp = strcasecmp;`;
        static if(is(typeof({ mixin(enumMixinStr_lxw_strcasecmp); }))) {
            mixin(enumMixinStr_lxw_strcasecmp);
        }
    }
    static if(!is(typeof(LXW_DEFINED_NAME_LENGTH))) {
        enum LXW_DEFINED_NAME_LENGTH = 128;
    }
    static if(!is(typeof(LXW_ROW_MAX))) {
        enum LXW_ROW_MAX = 1048576;
    }




    static if(!is(typeof(LXW_COL_MAX))) {
        enum LXW_COL_MAX = 16384;
    }




    static if(!is(typeof(LXW_COL_META_MAX))) {
        enum LXW_COL_META_MAX = 128;
    }




    static if(!is(typeof(LXW_HEADER_FOOTER_MAX))) {
        enum LXW_HEADER_FOOTER_MAX = 255;
    }




    static if(!is(typeof(LXW_MAX_NUMBER_URLS))) {
        enum LXW_MAX_NUMBER_URLS = 65530;
    }




    static if(!is(typeof(LXW_PANE_NAME_LENGTH))) {
        enum LXW_PANE_NAME_LENGTH = 12;
    }




    static if(!is(typeof(LXW_IMAGE_BUFFER_SIZE))) {
        enum LXW_IMAGE_BUFFER_SIZE = 1024;
    }




    static if(!is(typeof(LXW_HEADER_FOOTER_OBJS_MAX))) {
        enum LXW_HEADER_FOOTER_OBJS_MAX = 6;
    }




    static if(!is(typeof(LXW_BREAKS_MAX))) {
        enum LXW_BREAKS_MAX = 1023;
    }




    static if(!is(typeof(LXW_DEF_COL_WIDTH))) {
        private enum enumMixinStr_LXW_DEF_COL_WIDTH = `enum LXW_DEF_COL_WIDTH = cast( double ) 8.43;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_DEF_COL_WIDTH); }))) {
            mixin(enumMixinStr_LXW_DEF_COL_WIDTH);
        }
    }




    static if(!is(typeof(LXW_DEF_ROW_HEIGHT))) {
        private enum enumMixinStr_LXW_DEF_ROW_HEIGHT = `enum LXW_DEF_ROW_HEIGHT = cast( double ) 15.0;`;
        static if(is(typeof({ mixin(enumMixinStr_LXW_DEF_ROW_HEIGHT); }))) {
            mixin(enumMixinStr_LXW_DEF_ROW_HEIGHT);
        }
    }




    static if(!is(typeof(LXW_DEF_COL_WIDTH_PIXELS))) {
        enum LXW_DEF_COL_WIDTH_PIXELS = 64;
    }




    static if(!is(typeof(LXW_DEF_ROW_HEIGHT_PIXELS))) {
        enum LXW_DEF_ROW_HEIGHT_PIXELS = 20;
    }
    static if(!is(typeof(LXW_MAX_ATTRIBUTE_LENGTH))) {
        enum LXW_MAX_ATTRIBUTE_LENGTH = 2080;
    }




    static if(!is(typeof(LXW_ATTR_32))) {
        enum LXW_ATTR_32 = 32;
    }
}


struct __va_list_tag;
