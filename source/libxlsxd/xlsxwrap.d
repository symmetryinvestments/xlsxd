module libxlsxd.xlsxwrap;


        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; }



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }

    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }


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
    alias wchar_t = int;
	version(Posix) {
		version(X86) {
			alias c_ulong = uint;
		}
		version(X86_64) {
			alias c_ulong = size_t;
		}
	}
	version(Win32) {
		alias c_ulong = uint;
	}
	version(Win64) {
		alias c_ulong = size_t;
	}
    alias ptrdiff_t = c_long;
    struct max_align_t
    {
        long __clang_max_align_nonce1;
        real __clang_max_align_nonce2;
    }
    int gzvprintf(gzFile_s*, const(char)*, va_list*) @nogc nothrow;
    int deflateResetKeep(z_stream_s*) @nogc nothrow;
    int inflateResetKeep(z_stream_s*) @nogc nothrow;
    c_ulong inflateCodesUsed(z_stream_s*) @nogc nothrow;
    int inflateValidate(z_stream_s*, int) @nogc nothrow;
    int inflateUndermine(z_stream_s*, int) @nogc nothrow;
    const(uint)* get_crc_table() @nogc nothrow;
    int inflateSyncPoint(z_stream_s*) @nogc nothrow;
    const(char)* zError(int) @nogc nothrow;
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
    c_ulong crc32_z(c_ulong, const(ubyte)*, c_ulong) @nogc nothrow;
    c_ulong crc32(c_ulong, const(ubyte)*, uint) @nogc nothrow;
    c_ulong adler32_z(c_ulong, const(ubyte)*, c_ulong) @nogc nothrow;
    c_ulong adler32(c_ulong, const(ubyte)*, uint) @nogc nothrow;
    void gzclearerr(gzFile_s*) @nogc nothrow;
    const(char)* gzerror(gzFile_s*, int*) @nogc nothrow;
    int gzclose_w(gzFile_s*) @nogc nothrow;
    int gzclose_r(gzFile_s*) @nogc nothrow;
    int gzclose(gzFile_s*) @nogc nothrow;
    int gzdirect(gzFile_s*) @nogc nothrow;
    int gzeof(gzFile_s*) @nogc nothrow;
    int gzrewind(gzFile_s*) @nogc nothrow;
    int gzflush(gzFile_s*, int) @nogc nothrow;
    int gzungetc(int, gzFile_s*) @nogc nothrow;
    pragma(mangle, "gzgetc") int gzgetc_(gzFile_s*) @nogc nothrow;
    int gzputc(gzFile_s*, int) @nogc nothrow;
    char* gzgets(gzFile_s*, char*, int) @nogc nothrow;
    int gzputs(gzFile_s*, const(char)*) @nogc nothrow;
    int gzprintf(gzFile_s*, const(char)*, ...) @nogc nothrow;
    c_ulong gzfwrite(const(void)*, c_ulong, c_ulong, gzFile_s*) @nogc nothrow;
    int gzwrite(gzFile_s*, const(void)*, uint) @nogc nothrow;
    c_ulong gzfread(void*, c_ulong, c_ulong, gzFile_s*) @nogc nothrow;
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
    c_long inflateMark(z_stream_s*) @nogc nothrow;
    struct lxw_heading_pair
    {
        char* key;
        char* value;
        static struct _Anonymous_0
        {
            lxw_heading_pair* stqe_next;
        }
        _Anonymous_0 list_pointers;
    }
    struct lxw_heading_pairs
    {
        lxw_heading_pair* stqh_first;
        lxw_heading_pair** stqh_last;
    }
    struct lxw_part_name
    {
        char* name;
        static struct _Anonymous_1
        {
            lxw_part_name* stqe_next;
        }
        _Anonymous_1 list_pointers;
    }
    struct lxw_part_names
    {
        lxw_part_name* stqh_first;
        lxw_part_name** stqh_last;
    }
    struct lxw_app
    {
        _IO_FILE* file;
        lxw_heading_pairs* heading_pairs;
        lxw_part_names* part_names;
        lxw_doc_properties* properties;
        uint num_heading_pairs;
        uint num_part_names;
    }
    lxw_app* lxw_app_new() @nogc nothrow;
    void lxw_app_free(lxw_app*) @nogc nothrow;
    void lxw_app_assemble_xml_file(lxw_app*) @nogc nothrow;
    void lxw_app_add_part_name(lxw_app*, const(char)*) @nogc nothrow;
    void lxw_app_add_heading_pair(lxw_app*, const(char)*, const(char)*) @nogc nothrow;
    struct lxw_chart_series_list
    {
        lxw_chart_series* stqh_first;
        lxw_chart_series** stqh_last;
    }
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
        ushort point_count;
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
        static struct _Anonymous_2
        {
            lxw_chart_series* stqe_next;
        }
        _Anonymous_2 list_pointers;
    }
    struct lxw_series_data_points
    {
        lxw_series_data_point* stqh_first;
        lxw_series_data_point** stqh_last;
    }
    struct lxw_series_data_point
    {
        ubyte is_string;
        double number;
        char* string;
        ubyte no_data;
        static struct _Anonymous_3
        {
            lxw_series_data_point* stqe_next;
        }
        _Anonymous_3 list_pointers;
    }
    int inflatePrime(z_stream_s*, int, int) @nogc nothrow;
    enum lxw_chart_type
    {
        LXW_CHART_NONE = 0,
        LXW_CHART_AREA = 1,
        LXW_CHART_AREA_STACKED = 2,
        LXW_CHART_AREA_STACKED_PERCENT = 3,
        LXW_CHART_BAR = 4,
        LXW_CHART_BAR_STACKED = 5,
        LXW_CHART_BAR_STACKED_PERCENT = 6,
        LXW_CHART_COLUMN = 7,
        LXW_CHART_COLUMN_STACKED = 8,
        LXW_CHART_COLUMN_STACKED_PERCENT = 9,
        LXW_CHART_DOUGHNUT = 10,
        LXW_CHART_LINE = 11,
        LXW_CHART_PIE = 12,
        LXW_CHART_SCATTER = 13,
        LXW_CHART_SCATTER_STRAIGHT = 14,
        LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS = 15,
        LXW_CHART_SCATTER_SMOOTH = 16,
        LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS = 17,
        LXW_CHART_RADAR = 18,
        LXW_CHART_RADAR_WITH_MARKERS = 19,
        LXW_CHART_RADAR_FILLED = 20,
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
    enum LXW_CHART_PIE = lxw_chart_type.LXW_CHART_PIE;
    enum LXW_CHART_SCATTER = lxw_chart_type.LXW_CHART_SCATTER;
    enum LXW_CHART_SCATTER_STRAIGHT = lxw_chart_type.LXW_CHART_SCATTER_STRAIGHT;
    enum LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS = lxw_chart_type.LXW_CHART_SCATTER_STRAIGHT_WITH_MARKERS;
    enum LXW_CHART_SCATTER_SMOOTH = lxw_chart_type.LXW_CHART_SCATTER_SMOOTH;
    enum LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS = lxw_chart_type.LXW_CHART_SCATTER_SMOOTH_WITH_MARKERS;
    enum LXW_CHART_RADAR = lxw_chart_type.LXW_CHART_RADAR;
    enum LXW_CHART_RADAR_WITH_MARKERS = lxw_chart_type.LXW_CHART_RADAR_WITH_MARKERS;
    enum LXW_CHART_RADAR_FILLED = lxw_chart_type.LXW_CHART_RADAR_FILLED;
    enum lxw_chart_legend_position
    {
        LXW_CHART_LEGEND_NONE = 0,
        LXW_CHART_LEGEND_RIGHT = 1,
        LXW_CHART_LEGEND_LEFT = 2,
        LXW_CHART_LEGEND_TOP = 3,
        LXW_CHART_LEGEND_BOTTOM = 4,
        LXW_CHART_LEGEND_TOP_RIGHT = 5,
        LXW_CHART_LEGEND_OVERLAY_RIGHT = 6,
        LXW_CHART_LEGEND_OVERLAY_LEFT = 7,
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
    enum lxw_chart_line_dash_type
    {
        LXW_CHART_LINE_DASH_SOLID = 0,
        LXW_CHART_LINE_DASH_ROUND_DOT = 1,
        LXW_CHART_LINE_DASH_SQUARE_DOT = 2,
        LXW_CHART_LINE_DASH_DASH = 3,
        LXW_CHART_LINE_DASH_DASH_DOT = 4,
        LXW_CHART_LINE_DASH_LONG_DASH = 5,
        LXW_CHART_LINE_DASH_LONG_DASH_DOT = 6,
        LXW_CHART_LINE_DASH_LONG_DASH_DOT_DOT = 7,
        LXW_CHART_LINE_DASH_DOT = 8,
        LXW_CHART_LINE_DASH_SYSTEM_DASH_DOT = 9,
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
    enum lxw_chart_marker_type
    {
        LXW_CHART_MARKER_AUTOMATIC = 0,
        LXW_CHART_MARKER_NONE = 1,
        LXW_CHART_MARKER_SQUARE = 2,
        LXW_CHART_MARKER_DIAMOND = 3,
        LXW_CHART_MARKER_TRIANGLE = 4,
        LXW_CHART_MARKER_X = 5,
        LXW_CHART_MARKER_STAR = 6,
        LXW_CHART_MARKER_SHORT_DASH = 7,
        LXW_CHART_MARKER_LONG_DASH = 8,
        LXW_CHART_MARKER_CIRCLE = 9,
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
    enum lxw_chart_pattern_type
    {
        LXW_CHART_PATTERN_NONE = 0,
        LXW_CHART_PATTERN_PERCENT_5 = 1,
        LXW_CHART_PATTERN_PERCENT_10 = 2,
        LXW_CHART_PATTERN_PERCENT_20 = 3,
        LXW_CHART_PATTERN_PERCENT_25 = 4,
        LXW_CHART_PATTERN_PERCENT_30 = 5,
        LXW_CHART_PATTERN_PERCENT_40 = 6,
        LXW_CHART_PATTERN_PERCENT_50 = 7,
        LXW_CHART_PATTERN_PERCENT_60 = 8,
        LXW_CHART_PATTERN_PERCENT_70 = 9,
        LXW_CHART_PATTERN_PERCENT_75 = 10,
        LXW_CHART_PATTERN_PERCENT_80 = 11,
        LXW_CHART_PATTERN_PERCENT_90 = 12,
        LXW_CHART_PATTERN_LIGHT_DOWNWARD_DIAGONAL = 13,
        LXW_CHART_PATTERN_LIGHT_UPWARD_DIAGONAL = 14,
        LXW_CHART_PATTERN_DARK_DOWNWARD_DIAGONAL = 15,
        LXW_CHART_PATTERN_DARK_UPWARD_DIAGONAL = 16,
        LXW_CHART_PATTERN_WIDE_DOWNWARD_DIAGONAL = 17,
        LXW_CHART_PATTERN_WIDE_UPWARD_DIAGONAL = 18,
        LXW_CHART_PATTERN_LIGHT_VERTICAL = 19,
        LXW_CHART_PATTERN_LIGHT_HORIZONTAL = 20,
        LXW_CHART_PATTERN_NARROW_VERTICAL = 21,
        LXW_CHART_PATTERN_NARROW_HORIZONTAL = 22,
        LXW_CHART_PATTERN_DARK_VERTICAL = 23,
        LXW_CHART_PATTERN_DARK_HORIZONTAL = 24,
        LXW_CHART_PATTERN_DASHED_DOWNWARD_DIAGONAL = 25,
        LXW_CHART_PATTERN_DASHED_UPWARD_DIAGONAL = 26,
        LXW_CHART_PATTERN_DASHED_HORIZONTAL = 27,
        LXW_CHART_PATTERN_DASHED_VERTICAL = 28,
        LXW_CHART_PATTERN_SMALL_CONFETTI = 29,
        LXW_CHART_PATTERN_LARGE_CONFETTI = 30,
        LXW_CHART_PATTERN_ZIGZAG = 31,
        LXW_CHART_PATTERN_WAVE = 32,
        LXW_CHART_PATTERN_DIAGONAL_BRICK = 33,
        LXW_CHART_PATTERN_HORIZONTAL_BRICK = 34,
        LXW_CHART_PATTERN_WEAVE = 35,
        LXW_CHART_PATTERN_PLAID = 36,
        LXW_CHART_PATTERN_DIVOT = 37,
        LXW_CHART_PATTERN_DOTTED_GRID = 38,
        LXW_CHART_PATTERN_DOTTED_DIAMOND = 39,
        LXW_CHART_PATTERN_SHINGLE = 40,
        LXW_CHART_PATTERN_TRELLIS = 41,
        LXW_CHART_PATTERN_SPHERE = 42,
        LXW_CHART_PATTERN_SMALL_GRID = 43,
        LXW_CHART_PATTERN_LARGE_GRID = 44,
        LXW_CHART_PATTERN_SMALL_CHECK = 45,
        LXW_CHART_PATTERN_LARGE_CHECK = 46,
        LXW_CHART_PATTERN_OUTLINED_DIAMOND = 47,
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
    enum lxw_chart_label_position
    {
        LXW_CHART_LABEL_POSITION_DEFAULT = 0,
        LXW_CHART_LABEL_POSITION_CENTER = 1,
        LXW_CHART_LABEL_POSITION_RIGHT = 2,
        LXW_CHART_LABEL_POSITION_LEFT = 3,
        LXW_CHART_LABEL_POSITION_ABOVE = 4,
        LXW_CHART_LABEL_POSITION_BELOW = 5,
        LXW_CHART_LABEL_POSITION_INSIDE_BASE = 6,
        LXW_CHART_LABEL_POSITION_INSIDE_END = 7,
        LXW_CHART_LABEL_POSITION_OUTSIDE_END = 8,
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
    enum lxw_chart_label_separator
    {
        LXW_CHART_LABEL_SEPARATOR_COMMA = 0,
        LXW_CHART_LABEL_SEPARATOR_SEMICOLON = 1,
        LXW_CHART_LABEL_SEPARATOR_PERIOD = 2,
        LXW_CHART_LABEL_SEPARATOR_NEWLINE = 3,
        LXW_CHART_LABEL_SEPARATOR_SPACE = 4,
    }
    enum LXW_CHART_LABEL_SEPARATOR_COMMA = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_COMMA;
    enum LXW_CHART_LABEL_SEPARATOR_SEMICOLON = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_SEMICOLON;
    enum LXW_CHART_LABEL_SEPARATOR_PERIOD = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_PERIOD;
    enum LXW_CHART_LABEL_SEPARATOR_NEWLINE = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_NEWLINE;
    enum LXW_CHART_LABEL_SEPARATOR_SPACE = lxw_chart_label_separator.LXW_CHART_LABEL_SEPARATOR_SPACE;
    enum lxw_chart_axis_type
    {
        LXW_CHART_AXIS_TYPE_X = 0,
        LXW_CHART_AXIS_TYPE_Y = 1,
    }
    enum LXW_CHART_AXIS_TYPE_X = lxw_chart_axis_type.LXW_CHART_AXIS_TYPE_X;
    enum LXW_CHART_AXIS_TYPE_Y = lxw_chart_axis_type.LXW_CHART_AXIS_TYPE_Y;
    enum lxw_chart_subtype
    {
        LXW_CHART_SUBTYPE_NONE = 0,
        LXW_CHART_SUBTYPE_STACKED = 1,
        LXW_CHART_SUBTYPE_STACKED_PERCENT = 2,
    }
    enum LXW_CHART_SUBTYPE_NONE = lxw_chart_subtype.LXW_CHART_SUBTYPE_NONE;
    enum LXW_CHART_SUBTYPE_STACKED = lxw_chart_subtype.LXW_CHART_SUBTYPE_STACKED;
    enum LXW_CHART_SUBTYPE_STACKED_PERCENT = lxw_chart_subtype.LXW_CHART_SUBTYPE_STACKED_PERCENT;
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
    enum lxw_chart_axis_tick_position
    {
        LXW_CHART_AXIS_POSITION_DEFAULT = 0,
        LXW_CHART_AXIS_POSITION_ON_TICK = 1,
        LXW_CHART_AXIS_POSITION_BETWEEN = 2,
    }
    enum LXW_CHART_AXIS_POSITION_DEFAULT = lxw_chart_axis_tick_position.LXW_CHART_AXIS_POSITION_DEFAULT;
    enum LXW_CHART_AXIS_POSITION_ON_TICK = lxw_chart_axis_tick_position.LXW_CHART_AXIS_POSITION_ON_TICK;
    enum LXW_CHART_AXIS_POSITION_BETWEEN = lxw_chart_axis_tick_position.LXW_CHART_AXIS_POSITION_BETWEEN;
    enum lxw_chart_axis_label_position
    {
        LXW_CHART_AXIS_LABEL_POSITION_NEXT_TO = 0,
        LXW_CHART_AXIS_LABEL_POSITION_HIGH = 1,
        LXW_CHART_AXIS_LABEL_POSITION_LOW = 2,
        LXW_CHART_AXIS_LABEL_POSITION_NONE = 3,
    }
    enum LXW_CHART_AXIS_LABEL_POSITION_NEXT_TO = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_NEXT_TO;
    enum LXW_CHART_AXIS_LABEL_POSITION_HIGH = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_HIGH;
    enum LXW_CHART_AXIS_LABEL_POSITION_LOW = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_LOW;
    enum LXW_CHART_AXIS_LABEL_POSITION_NONE = lxw_chart_axis_label_position.LXW_CHART_AXIS_LABEL_POSITION_NONE;
    enum lxw_chart_axis_label_alignment
    {
        LXW_CHART_AXIS_LABEL_ALIGN_CENTER = 0,
        LXW_CHART_AXIS_LABEL_ALIGN_LEFT = 1,
        LXW_CHART_AXIS_LABEL_ALIGN_RIGHT = 2,
    }
    enum LXW_CHART_AXIS_LABEL_ALIGN_CENTER = lxw_chart_axis_label_alignment.LXW_CHART_AXIS_LABEL_ALIGN_CENTER;
    enum LXW_CHART_AXIS_LABEL_ALIGN_LEFT = lxw_chart_axis_label_alignment.LXW_CHART_AXIS_LABEL_ALIGN_LEFT;
    enum LXW_CHART_AXIS_LABEL_ALIGN_RIGHT = lxw_chart_axis_label_alignment.LXW_CHART_AXIS_LABEL_ALIGN_RIGHT;
    enum lxw_chart_axis_display_unit
    {
        LXW_CHART_AXIS_UNITS_NONE = 0,
        LXW_CHART_AXIS_UNITS_HUNDREDS = 1,
        LXW_CHART_AXIS_UNITS_THOUSANDS = 2,
        LXW_CHART_AXIS_UNITS_TEN_THOUSANDS = 3,
        LXW_CHART_AXIS_UNITS_HUNDRED_THOUSANDS = 4,
        LXW_CHART_AXIS_UNITS_MILLIONS = 5,
        LXW_CHART_AXIS_UNITS_TEN_MILLIONS = 6,
        LXW_CHART_AXIS_UNITS_HUNDRED_MILLIONS = 7,
        LXW_CHART_AXIS_UNITS_BILLIONS = 8,
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
    alias lxw_chart_tick_mark = lxw_chart_axis_tick_mark;
    enum lxw_chart_axis_tick_mark
    {
        LXW_CHART_AXIS_TICK_MARK_DEFAULT = 0,
        LXW_CHART_AXIS_TICK_MARK_NONE = 1,
        LXW_CHART_AXIS_TICK_MARK_INSIDE = 2,
        LXW_CHART_AXIS_TICK_MARK_OUTSIDE = 3,
        LXW_CHART_AXIS_TICK_MARK_CROSSING = 4,
    }
    enum LXW_CHART_AXIS_TICK_MARK_DEFAULT = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_DEFAULT;
    enum LXW_CHART_AXIS_TICK_MARK_NONE = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_NONE;
    enum LXW_CHART_AXIS_TICK_MARK_INSIDE = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_INSIDE;
    enum LXW_CHART_AXIS_TICK_MARK_OUTSIDE = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_OUTSIDE;
    enum LXW_CHART_AXIS_TICK_MARK_CROSSING = lxw_chart_axis_tick_mark.LXW_CHART_AXIS_TICK_MARK_CROSSING;
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
    struct lxw_chart_line
    {
        int color;
        ubyte none;
        float width;
        ubyte dash_type;
        ubyte transparency;
        ubyte has_color;
    }
    struct lxw_chart_fill
    {
        int color;
        ubyte none;
        ubyte transparency;
        ubyte has_color;
    }
    struct lxw_chart_pattern
    {
        int fg_color;
        int bg_color;
        ubyte type;
        ubyte has_fg_color;
        ubyte has_bg_color;
    }
    struct lxw_chart_font
    {
        char* name;
        double size;
        ubyte bold;
        ubyte italic;
        ubyte underline;
        int rotation;
        int color;
        ubyte pitch_family;
        ubyte charset;
        byte baseline;
        ubyte has_color;
    }
    struct lxw_chart_marker
    {
        ubyte type;
        ubyte size;
        lxw_chart_line* line;
        lxw_chart_fill* fill;
        lxw_chart_pattern* pattern;
    }
    struct lxw_chart_legend
    {
        lxw_chart_font* font;
        ubyte position;
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
    struct lxw_chart_point
    {
        lxw_chart_line* line;
        lxw_chart_fill* fill;
        lxw_chart_pattern* pattern;
    }
    enum lxw_chart_blank
    {
        LXW_CHART_BLANKS_AS_GAP = 0,
        LXW_CHART_BLANKS_AS_ZERO = 1,
        LXW_CHART_BLANKS_AS_CONNECTED = 2,
    }
    enum LXW_CHART_BLANKS_AS_GAP = lxw_chart_blank.LXW_CHART_BLANKS_AS_GAP;
    enum LXW_CHART_BLANKS_AS_ZERO = lxw_chart_blank.LXW_CHART_BLANKS_AS_ZERO;
    enum LXW_CHART_BLANKS_AS_CONNECTED = lxw_chart_blank.LXW_CHART_BLANKS_AS_CONNECTED;
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
    enum lxw_chart_error_bar_type
    {
        LXW_CHART_ERROR_BAR_TYPE_STD_ERROR = 0,
        LXW_CHART_ERROR_BAR_TYPE_FIXED = 1,
        LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE = 2,
        LXW_CHART_ERROR_BAR_TYPE_STD_DEV = 3,
    }
    enum LXW_CHART_ERROR_BAR_TYPE_STD_ERROR = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_STD_ERROR;
    enum LXW_CHART_ERROR_BAR_TYPE_FIXED = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_FIXED;
    enum LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_PERCENTAGE;
    enum LXW_CHART_ERROR_BAR_TYPE_STD_DEV = lxw_chart_error_bar_type.LXW_CHART_ERROR_BAR_TYPE_STD_DEV;
    enum lxw_chart_error_bar_direction
    {
        LXW_CHART_ERROR_BAR_DIR_BOTH = 0,
        LXW_CHART_ERROR_BAR_DIR_PLUS = 1,
        LXW_CHART_ERROR_BAR_DIR_MINUS = 2,
    }
    enum LXW_CHART_ERROR_BAR_DIR_BOTH = lxw_chart_error_bar_direction.LXW_CHART_ERROR_BAR_DIR_BOTH;
    enum LXW_CHART_ERROR_BAR_DIR_PLUS = lxw_chart_error_bar_direction.LXW_CHART_ERROR_BAR_DIR_PLUS;
    enum LXW_CHART_ERROR_BAR_DIR_MINUS = lxw_chart_error_bar_direction.LXW_CHART_ERROR_BAR_DIR_MINUS;
    enum lxw_chart_error_bar_axis
    {
        LXW_CHART_ERROR_BAR_AXIS_X = 0,
        LXW_CHART_ERROR_BAR_AXIS_Y = 1,
    }
    enum LXW_CHART_ERROR_BAR_AXIS_X = lxw_chart_error_bar_axis.LXW_CHART_ERROR_BAR_AXIS_X;
    enum LXW_CHART_ERROR_BAR_AXIS_Y = lxw_chart_error_bar_axis.LXW_CHART_ERROR_BAR_AXIS_Y;
    enum lxw_chart_error_bar_cap
    {
        LXW_CHART_ERROR_BAR_END_CAP = 0,
        LXW_CHART_ERROR_BAR_NO_CAP = 1,
    }
    enum LXW_CHART_ERROR_BAR_END_CAP = lxw_chart_error_bar_cap.LXW_CHART_ERROR_BAR_END_CAP;
    enum LXW_CHART_ERROR_BAR_NO_CAP = lxw_chart_error_bar_cap.LXW_CHART_ERROR_BAR_NO_CAP;
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
    enum lxw_chart_trendline_type
    {
        LXW_CHART_TRENDLINE_TYPE_LINEAR = 0,
        LXW_CHART_TRENDLINE_TYPE_LOG = 1,
        LXW_CHART_TRENDLINE_TYPE_POLY = 2,
        LXW_CHART_TRENDLINE_TYPE_POWER = 3,
        LXW_CHART_TRENDLINE_TYPE_EXP = 4,
        LXW_CHART_TRENDLINE_TYPE_AVERAGE = 5,
    }
    enum LXW_CHART_TRENDLINE_TYPE_LINEAR = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_LINEAR;
    enum LXW_CHART_TRENDLINE_TYPE_LOG = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_LOG;
    enum LXW_CHART_TRENDLINE_TYPE_POLY = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_POLY;
    enum LXW_CHART_TRENDLINE_TYPE_POWER = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_POWER;
    enum LXW_CHART_TRENDLINE_TYPE_EXP = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_EXP;
    enum LXW_CHART_TRENDLINE_TYPE_AVERAGE = lxw_chart_trendline_type.LXW_CHART_TRENDLINE_TYPE_AVERAGE;
    struct lxw_chart_gridline
    {
        ubyte visible;
        lxw_chart_line* line;
    }
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
        ubyte crossing_max;
        double crossing;
    }
    struct lxw_chart
    {
        _IO_FILE* file;
        ubyte type;
        ubyte subtype;
        ushort series_index;
        void function(lxw_chart*) write_chart_type;
        void function(lxw_chart*) write_plot_area;
        lxw_chart_axis* x_axis;
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
        static struct _Anonymous_4
        {
            lxw_chart* stqe_next;
        }
        _Anonymous_4 ordered_list_pointers;
        static struct _Anonymous_5
        {
            lxw_chart* stqe_next;
        }
        _Anonymous_5 list_pointers;
    }
    lxw_chart* lxw_chart_new(ubyte) @nogc nothrow;
    void lxw_chart_free(lxw_chart*) @nogc nothrow;
    void lxw_chart_assemble_xml_file(lxw_chart*) @nogc nothrow;
    lxw_chart_series* chart_add_series(lxw_chart*, const(char)*, const(char)*) @nogc nothrow;
    void chart_series_set_categories(lxw_chart_series*, const(char)*, uint, ushort, uint, ushort) @nogc nothrow;
    void chart_series_set_values(lxw_chart_series*, const(char)*, uint, ushort, uint, ushort) @nogc nothrow;
    void chart_series_set_name(lxw_chart_series*, const(char)*) @nogc nothrow;
    void chart_series_set_name_range(lxw_chart_series*, const(char)*, uint, ushort) @nogc nothrow;
    void chart_series_set_line(lxw_chart_series*, lxw_chart_line*) @nogc nothrow;
    void chart_series_set_fill(lxw_chart_series*, lxw_chart_fill*) @nogc nothrow;
    void chart_series_set_invert_if_negative(lxw_chart_series*) @nogc nothrow;
    void chart_series_set_pattern(lxw_chart_series*, lxw_chart_pattern*) @nogc nothrow;
    void chart_series_set_marker_type(lxw_chart_series*, ubyte) @nogc nothrow;
    void chart_series_set_marker_size(lxw_chart_series*, ubyte) @nogc nothrow;
    void chart_series_set_marker_line(lxw_chart_series*, lxw_chart_line*) @nogc nothrow;
    void chart_series_set_marker_fill(lxw_chart_series*, lxw_chart_fill*) @nogc nothrow;
    void chart_series_set_marker_pattern(lxw_chart_series*, lxw_chart_pattern*) @nogc nothrow;
    lxw_error chart_series_set_points(lxw_chart_series*, lxw_chart_point**) @nogc nothrow;
    void chart_series_set_smooth(lxw_chart_series*, ubyte) @nogc nothrow;
    void chart_series_set_labels(lxw_chart_series*) @nogc nothrow;
    void chart_series_set_labels_options(lxw_chart_series*, ubyte, ubyte, ubyte) @nogc nothrow;
    void chart_series_set_labels_separator(lxw_chart_series*, ubyte) @nogc nothrow;
    void chart_series_set_labels_position(lxw_chart_series*, ubyte) @nogc nothrow;
    void chart_series_set_labels_leader_line(lxw_chart_series*) @nogc nothrow;
    void chart_series_set_labels_legend(lxw_chart_series*) @nogc nothrow;
    void chart_series_set_labels_percentage(lxw_chart_series*) @nogc nothrow;
    void chart_series_set_labels_num_format(lxw_chart_series*, const(char)*) @nogc nothrow;
    void chart_series_set_labels_font(lxw_chart_series*, lxw_chart_font*) @nogc nothrow;
    void chart_series_set_trendline(lxw_chart_series*, ubyte, ubyte) @nogc nothrow;
    void chart_series_set_trendline_forecast(lxw_chart_series*, double, double) @nogc nothrow;
    void chart_series_set_trendline_equation(lxw_chart_series*) @nogc nothrow;
    void chart_series_set_trendline_r_squared(lxw_chart_series*) @nogc nothrow;
    void chart_series_set_trendline_intercept(lxw_chart_series*, double) @nogc nothrow;
    void chart_series_set_trendline_name(lxw_chart_series*, const(char)*) @nogc nothrow;
    void chart_series_set_trendline_line(lxw_chart_series*, lxw_chart_line*) @nogc nothrow;
    lxw_series_error_bars* chart_series_get_error_bars(lxw_chart_series*, lxw_chart_error_bar_axis) @nogc nothrow;
    void chart_series_set_error_bars(lxw_series_error_bars*, ubyte, double) @nogc nothrow;
    void chart_series_set_error_bars_direction(lxw_series_error_bars*, ubyte) @nogc nothrow;
    void chart_series_set_error_bars_endcap(lxw_series_error_bars*, ubyte) @nogc nothrow;
    void chart_series_set_error_bars_line(lxw_series_error_bars*, lxw_chart_line*) @nogc nothrow;
    lxw_chart_axis* chart_axis_get(lxw_chart*, lxw_chart_axis_type) @nogc nothrow;
    void chart_axis_set_name(lxw_chart_axis*, const(char)*) @nogc nothrow;
    void chart_axis_set_name_range(lxw_chart_axis*, const(char)*, uint, ushort) @nogc nothrow;
    void chart_axis_set_name_font(lxw_chart_axis*, lxw_chart_font*) @nogc nothrow;
    void chart_axis_set_num_font(lxw_chart_axis*, lxw_chart_font*) @nogc nothrow;
    void chart_axis_set_num_format(lxw_chart_axis*, const(char)*) @nogc nothrow;
    void chart_axis_set_line(lxw_chart_axis*, lxw_chart_line*) @nogc nothrow;
    void chart_axis_set_fill(lxw_chart_axis*, lxw_chart_fill*) @nogc nothrow;
    void chart_axis_set_pattern(lxw_chart_axis*, lxw_chart_pattern*) @nogc nothrow;
    void chart_axis_set_reverse(lxw_chart_axis*) @nogc nothrow;
    void chart_axis_set_crossing(lxw_chart_axis*, double) @nogc nothrow;
    void chart_axis_set_crossing_max(lxw_chart_axis*) @nogc nothrow;
    void chart_axis_off(lxw_chart_axis*) @nogc nothrow;
    void chart_axis_set_position(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_set_label_position(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_set_label_align(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_set_min(lxw_chart_axis*, double) @nogc nothrow;
    void chart_axis_set_max(lxw_chart_axis*, double) @nogc nothrow;
    void chart_axis_set_log_base(lxw_chart_axis*, ushort) @nogc nothrow;
    void chart_axis_set_major_tick_mark(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_set_minor_tick_mark(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_set_interval_unit(lxw_chart_axis*, ushort) @nogc nothrow;
    void chart_axis_set_interval_tick(lxw_chart_axis*, ushort) @nogc nothrow;
    void chart_axis_set_major_unit(lxw_chart_axis*, double) @nogc nothrow;
    void chart_axis_set_minor_unit(lxw_chart_axis*, double) @nogc nothrow;
    void chart_axis_set_display_units(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_set_display_units_visible(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_major_gridlines_set_visible(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_minor_gridlines_set_visible(lxw_chart_axis*, ubyte) @nogc nothrow;
    void chart_axis_major_gridlines_set_line(lxw_chart_axis*, lxw_chart_line*) @nogc nothrow;
    void chart_axis_minor_gridlines_set_line(lxw_chart_axis*, lxw_chart_line*) @nogc nothrow;
    void chart_title_set_name(lxw_chart*, const(char)*) @nogc nothrow;
    void chart_title_set_name_range(lxw_chart*, const(char)*, uint, ushort) @nogc nothrow;
    void chart_title_set_name_font(lxw_chart*, lxw_chart_font*) @nogc nothrow;
    void chart_title_off(lxw_chart*) @nogc nothrow;
    void chart_legend_set_position(lxw_chart*, ubyte) @nogc nothrow;
    void chart_legend_set_font(lxw_chart*, lxw_chart_font*) @nogc nothrow;
    lxw_error chart_legend_delete_series(lxw_chart*, short*) @nogc nothrow;
    void chart_chartarea_set_line(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    void chart_chartarea_set_fill(lxw_chart*, lxw_chart_fill*) @nogc nothrow;
    void chart_chartarea_set_pattern(lxw_chart*, lxw_chart_pattern*) @nogc nothrow;
    void chart_plotarea_set_line(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    void chart_plotarea_set_fill(lxw_chart*, lxw_chart_fill*) @nogc nothrow;
    void chart_plotarea_set_pattern(lxw_chart*, lxw_chart_pattern*) @nogc nothrow;
    void chart_set_style(lxw_chart*, ubyte) @nogc nothrow;
    void chart_set_table(lxw_chart*) @nogc nothrow;
    void chart_set_table_grid(lxw_chart*, ubyte, ubyte, ubyte, ubyte) @nogc nothrow;
    void chart_set_table_font(lxw_chart*, lxw_chart_font*) @nogc nothrow;
    void chart_set_up_down_bars(lxw_chart*) @nogc nothrow;
    void chart_set_up_down_bars_format(lxw_chart*, lxw_chart_line*, lxw_chart_fill*, lxw_chart_line*, lxw_chart_fill*) @nogc nothrow;
    void chart_set_drop_lines(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    void chart_set_high_low_lines(lxw_chart*, lxw_chart_line*) @nogc nothrow;
    void chart_set_series_overlap(lxw_chart*, byte) @nogc nothrow;
    void chart_set_series_gap(lxw_chart*, ushort) @nogc nothrow;
    void chart_show_blanks_as(lxw_chart*, ubyte) @nogc nothrow;
    void chart_show_hidden_data(lxw_chart*) @nogc nothrow;
    void chart_set_rotation(lxw_chart*, ushort) @nogc nothrow;
    void chart_set_hole_size(lxw_chart*, ubyte) @nogc nothrow;
    lxw_error lxw_chart_add_data_cache(lxw_series_range*, ubyte*, ushort, ubyte, ubyte) @nogc nothrow;
    struct lxw_chartsheet
    {
        _IO_FILE* file;
        lxw_worksheet* worksheet;
        lxw_chart* chart;
        lxw_protection protection;
        ubyte is_protected;
        char* name;
        char* quoted_name;
        char* tmpdir;
        uint index;
        ubyte active;
        ubyte selected;
        ubyte hidden;
        ushort* active_sheet;
        ushort* first_sheet;
        ushort rel_count;
        static struct _Anonymous_6
        {
            lxw_chartsheet* stqe_next;
        }
        _Anonymous_6 list_pointers;
    }
    lxw_error chartsheet_set_chart(lxw_chartsheet*, lxw_chart*) @nogc nothrow;
    lxw_error chartsheet_set_chart_opt(lxw_chartsheet*, lxw_chart*, lxw_image_options*) @nogc nothrow;
    void chartsheet_activate(lxw_chartsheet*) @nogc nothrow;
    void chartsheet_select(lxw_chartsheet*) @nogc nothrow;
    void chartsheet_hide(lxw_chartsheet*) @nogc nothrow;
    void chartsheet_set_first_sheet(lxw_chartsheet*) @nogc nothrow;
    void chartsheet_set_tab_color(lxw_chartsheet*, int) @nogc nothrow;
    void chartsheet_protect(lxw_chartsheet*, const(char)*, lxw_protection*) @nogc nothrow;
    void chartsheet_set_zoom(lxw_chartsheet*, ushort) @nogc nothrow;
    void chartsheet_set_landscape(lxw_chartsheet*) @nogc nothrow;
    void chartsheet_set_portrait(lxw_chartsheet*) @nogc nothrow;
    void chartsheet_set_paper(lxw_chartsheet*, ubyte) @nogc nothrow;
    void chartsheet_set_margins(lxw_chartsheet*, double, double, double, double) @nogc nothrow;
    lxw_error chartsheet_set_header(lxw_chartsheet*, const(char)*) @nogc nothrow;
    lxw_error chartsheet_set_footer(lxw_chartsheet*, const(char)*) @nogc nothrow;
    lxw_error chartsheet_set_header_opt(lxw_chartsheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    lxw_error chartsheet_set_footer_opt(lxw_chartsheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    lxw_chartsheet* lxw_chartsheet_new(lxw_worksheet_init_data*) @nogc nothrow;
    void lxw_chartsheet_free(lxw_chartsheet*) @nogc nothrow;
    void lxw_chartsheet_assemble_xml_file(lxw_chartsheet*) @nogc nothrow;
    alias lxw_row_t = uint;
    alias lxw_col_t = ushort;
    enum lxw_boolean
    {
        LXW_FALSE = 0,
        LXW_TRUE = 1,
    }
    enum LXW_FALSE = lxw_boolean.LXW_FALSE;
    enum LXW_TRUE = lxw_boolean.LXW_TRUE;
    enum lxw_error
    {
        LXW_NO_ERROR = 0,
        LXW_ERROR_MEMORY_MALLOC_FAILED = 1,
        LXW_ERROR_CREATING_XLSX_FILE = 2,
        LXW_ERROR_CREATING_TMPFILE = 3,
        LXW_ERROR_READING_TMPFILE = 4,
        LXW_ERROR_ZIP_FILE_OPERATION = 5,
        LXW_ERROR_ZIP_PARAMETER_ERROR = 6,
        LXW_ERROR_ZIP_BAD_ZIP_FILE = 7,
        LXW_ERROR_ZIP_INTERNAL_ERROR = 8,
        LXW_ERROR_ZIP_FILE_ADD = 9,
        LXW_ERROR_ZIP_CLOSE = 10,
        LXW_ERROR_NULL_PARAMETER_IGNORED = 11,
        LXW_ERROR_PARAMETER_VALIDATION = 12,
        LXW_ERROR_SHEETNAME_LENGTH_EXCEEDED = 13,
        LXW_ERROR_INVALID_SHEETNAME_CHARACTER = 14,
        LXW_ERROR_SHEETNAME_START_END_APOSTROPHE = 15,
        LXW_ERROR_SHEETNAME_ALREADY_USED = 16,
        LXW_ERROR_SHEETNAME_RESERVED = 17,
        LXW_ERROR_32_STRING_LENGTH_EXCEEDED = 18,
        LXW_ERROR_128_STRING_LENGTH_EXCEEDED = 19,
        LXW_ERROR_255_STRING_LENGTH_EXCEEDED = 20,
        LXW_ERROR_MAX_STRING_LENGTH_EXCEEDED = 21,
        LXW_ERROR_SHARED_STRING_INDEX_NOT_FOUND = 22,
        LXW_ERROR_WORKSHEET_INDEX_OUT_OF_RANGE = 23,
        LXW_ERROR_WORKSHEET_MAX_NUMBER_URLS_EXCEEDED = 24,
        LXW_ERROR_IMAGE_DIMENSIONS = 25,
        LXW_MAX_ERRNO = 26,
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
    enum LXW_ERROR_NULL_PARAMETER_IGNORED = lxw_error.LXW_ERROR_NULL_PARAMETER_IGNORED;
    enum LXW_ERROR_PARAMETER_VALIDATION = lxw_error.LXW_ERROR_PARAMETER_VALIDATION;
    enum LXW_ERROR_SHEETNAME_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_SHEETNAME_LENGTH_EXCEEDED;
    enum LXW_ERROR_INVALID_SHEETNAME_CHARACTER = lxw_error.LXW_ERROR_INVALID_SHEETNAME_CHARACTER;
    enum LXW_ERROR_SHEETNAME_START_END_APOSTROPHE = lxw_error.LXW_ERROR_SHEETNAME_START_END_APOSTROPHE;
    enum LXW_ERROR_SHEETNAME_ALREADY_USED = lxw_error.LXW_ERROR_SHEETNAME_ALREADY_USED;
    enum LXW_ERROR_SHEETNAME_RESERVED = lxw_error.LXW_ERROR_SHEETNAME_RESERVED;
    enum LXW_ERROR_32_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_32_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_128_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_128_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_255_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_255_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_MAX_STRING_LENGTH_EXCEEDED = lxw_error.LXW_ERROR_MAX_STRING_LENGTH_EXCEEDED;
    enum LXW_ERROR_SHARED_STRING_INDEX_NOT_FOUND = lxw_error.LXW_ERROR_SHARED_STRING_INDEX_NOT_FOUND;
    enum LXW_ERROR_WORKSHEET_INDEX_OUT_OF_RANGE = lxw_error.LXW_ERROR_WORKSHEET_INDEX_OUT_OF_RANGE;
    enum LXW_ERROR_WORKSHEET_MAX_NUMBER_URLS_EXCEEDED = lxw_error.LXW_ERROR_WORKSHEET_MAX_NUMBER_URLS_EXCEEDED;
    enum LXW_ERROR_IMAGE_DIMENSIONS = lxw_error.LXW_ERROR_IMAGE_DIMENSIONS;
    enum LXW_MAX_ERRNO = lxw_error.LXW_MAX_ERRNO;
    struct lxw_datetime
    {
        int year;
        int month;
        int day;
        int hour;
        int min;
        double sec;
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
    struct lxw_format
    {
        _IO_FILE* file;
        lxw_hash_table* xf_format_indices;
        ushort* num_xf_formats;
        int xf_index;
        int dxf_index;
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
        int font_color;
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
        int fg_color;
        int bg_color;
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
        int bottom_color;
        int diag_color;
        int left_color;
        int right_color;
        int top_color;
        ubyte indent;
        ubyte shrink;
        ubyte merge_range;
        ubyte reading_order;
        ubyte just_distrib;
        ubyte color_indexed;
        ubyte font_only;
        static struct _Anonymous_7
        {
            lxw_format* stqe_next;
        }
        _Anonymous_7 list_pointers;
    }
    struct lxw_formats
    {
        lxw_format* stqh_first;
        lxw_format** stqh_last;
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
        static struct _Anonymous_8
        {
            lxw_tuple* stqe_next;
        }
        _Anonymous_8 list_pointers;
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
        static union _Anonymous_9
        {
            char* string;
            double number;
            int integer;
            ubyte boolean;
            lxw_datetime datetime;
        }
        _Anonymous_9 u;
        static struct _Anonymous_10
        {
            lxw_custom_property* stqe_next;
        }
        _Anonymous_10 list_pointers;
    }
    int deflateParams(z_stream_s*, int, int) @nogc nothrow;
    struct lxw_content_types
    {
        _IO_FILE* file;
        lxw_tuples* default_types;
        lxw_tuples* overrides;
    }
    lxw_content_types* lxw_content_types_new() @nogc nothrow;
    void lxw_content_types_free(lxw_content_types*) @nogc nothrow;
    void lxw_content_types_assemble_xml_file(lxw_content_types*) @nogc nothrow;
    void lxw_ct_add_default(lxw_content_types*, const(char)*, const(char)*) @nogc nothrow;
    void lxw_ct_add_override(lxw_content_types*, const(char)*, const(char)*) @nogc nothrow;
    void lxw_ct_add_worksheet_name(lxw_content_types*, const(char)*) @nogc nothrow;
    void lxw_ct_add_chartsheet_name(lxw_content_types*, const(char)*) @nogc nothrow;
    void lxw_ct_add_chart_name(lxw_content_types*, const(char)*) @nogc nothrow;
    void lxw_ct_add_drawing_name(lxw_content_types*, const(char)*) @nogc nothrow;
    void lxw_ct_add_shared_strings(lxw_content_types*) @nogc nothrow;
    void lxw_ct_add_calc_chain(lxw_content_types*) @nogc nothrow;
    void lxw_ct_add_custom_properties(lxw_content_types*) @nogc nothrow;
    struct lxw_core
    {
        _IO_FILE* file;
        lxw_doc_properties* properties;
    }
    lxw_core* lxw_core_new() @nogc nothrow;
    void lxw_core_free(lxw_core*) @nogc nothrow;
    void lxw_core_assemble_xml_file(lxw_core*) @nogc nothrow;
    int deflateReset(z_stream_s*) @nogc nothrow;
    struct lxw_custom
    {
        _IO_FILE* file;
        lxw_custom_properties* custom_properties;
        uint pid;
    }
    lxw_custom* lxw_custom_new() @nogc nothrow;
    void lxw_custom_free(lxw_custom*) @nogc nothrow;
    void lxw_custom_assemble_xml_file(lxw_custom*) @nogc nothrow;
    struct lxw_drawing_objects
    {
        lxw_drawing_object* stqh_first;
        lxw_drawing_object** stqh_last;
    }
    struct lxw_drawing_object
    {
        ubyte anchor_type;
        ubyte edit_as;
        lxw_drawing_coords from;
        lxw_drawing_coords to;
        uint col_absolute;
        uint row_absolute;
        uint width;
        uint height;
        ubyte shape;
        char* description;
        char* url;
        char* tip;
        static struct _Anonymous_11
        {
            lxw_drawing_object* stqe_next;
        }
        _Anonymous_11 list_pointers;
    }
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
    enum lxw_anchor_types
    {
        LXW_ANCHOR_TYPE_NONE = 0,
        LXW_ANCHOR_TYPE_IMAGE = 1,
        LXW_ANCHOR_TYPE_CHART = 2,
    }
    enum LXW_ANCHOR_TYPE_NONE = lxw_anchor_types.LXW_ANCHOR_TYPE_NONE;
    enum LXW_ANCHOR_TYPE_IMAGE = lxw_anchor_types.LXW_ANCHOR_TYPE_IMAGE;
    enum LXW_ANCHOR_TYPE_CHART = lxw_anchor_types.LXW_ANCHOR_TYPE_CHART;
    enum lxw_anchor_edit_types
    {
        LXW_ANCHOR_EDIT_AS_NONE = 0,
        LXW_ANCHOR_EDIT_AS_RELATIVE = 1,
        LXW_ANCHOR_EDIT_AS_ONE_CELL = 2,
        LXW_ANCHOR_EDIT_AS_ABSOLUTE = 3,
    }
    enum LXW_ANCHOR_EDIT_AS_NONE = lxw_anchor_edit_types.LXW_ANCHOR_EDIT_AS_NONE;
    enum LXW_ANCHOR_EDIT_AS_RELATIVE = lxw_anchor_edit_types.LXW_ANCHOR_EDIT_AS_RELATIVE;
    enum LXW_ANCHOR_EDIT_AS_ONE_CELL = lxw_anchor_edit_types.LXW_ANCHOR_EDIT_AS_ONE_CELL;
    enum LXW_ANCHOR_EDIT_AS_ABSOLUTE = lxw_anchor_edit_types.LXW_ANCHOR_EDIT_AS_ABSOLUTE;
    enum image_types
    {
        LXW_IMAGE_UNKNOWN = 0,
        LXW_IMAGE_PNG = 1,
        LXW_IMAGE_JPEG = 2,
        LXW_IMAGE_BMP = 3,
    }
    enum LXW_IMAGE_UNKNOWN = image_types.LXW_IMAGE_UNKNOWN;
    enum LXW_IMAGE_PNG = image_types.LXW_IMAGE_PNG;
    enum LXW_IMAGE_JPEG = image_types.LXW_IMAGE_JPEG;
    enum LXW_IMAGE_BMP = image_types.LXW_IMAGE_BMP;
    struct lxw_drawing_coords
    {
        uint col;
        uint row;
        double col_offset;
        double row_offset;
    }
    struct lxw_drawing
    {
        _IO_FILE* file;
        ubyte embedded;
        ubyte orientation;
        lxw_drawing_objects* drawing_objects;
    }
    lxw_drawing* lxw_drawing_new() @nogc nothrow;
    void lxw_drawing_free(lxw_drawing*) @nogc nothrow;
    void lxw_drawing_assemble_xml_file(lxw_drawing*) @nogc nothrow;
    void lxw_free_drawing_object(lxw_drawing_object*) @nogc nothrow;
    void lxw_add_drawing_object(lxw_drawing*, lxw_drawing_object*) @nogc nothrow;
    alias lxw_color_t = int;
    int deflateCopy(z_stream_s*, z_stream_s*) @nogc nothrow;
    int deflateGetDictionary(z_stream_s*, ubyte*, uint*) @nogc nothrow;
    enum lxw_format_underlines
    {
        LXW_UNDERLINE_SINGLE = 1,
        LXW_UNDERLINE_DOUBLE = 2,
        LXW_UNDERLINE_SINGLE_ACCOUNTING = 3,
        LXW_UNDERLINE_DOUBLE_ACCOUNTING = 4,
    }
    enum LXW_UNDERLINE_SINGLE = lxw_format_underlines.LXW_UNDERLINE_SINGLE;
    enum LXW_UNDERLINE_DOUBLE = lxw_format_underlines.LXW_UNDERLINE_DOUBLE;
    enum LXW_UNDERLINE_SINGLE_ACCOUNTING = lxw_format_underlines.LXW_UNDERLINE_SINGLE_ACCOUNTING;
    enum LXW_UNDERLINE_DOUBLE_ACCOUNTING = lxw_format_underlines.LXW_UNDERLINE_DOUBLE_ACCOUNTING;
    enum lxw_format_scripts
    {
        LXW_FONT_SUPERSCRIPT = 1,
        LXW_FONT_SUBSCRIPT = 2,
    }
    enum LXW_FONT_SUPERSCRIPT = lxw_format_scripts.LXW_FONT_SUPERSCRIPT;
    enum LXW_FONT_SUBSCRIPT = lxw_format_scripts.LXW_FONT_SUBSCRIPT;
    enum lxw_format_alignments
    {
        LXW_ALIGN_NONE = 0,
        LXW_ALIGN_LEFT = 1,
        LXW_ALIGN_CENTER = 2,
        LXW_ALIGN_RIGHT = 3,
        LXW_ALIGN_FILL = 4,
        LXW_ALIGN_JUSTIFY = 5,
        LXW_ALIGN_CENTER_ACROSS = 6,
        LXW_ALIGN_DISTRIBUTED = 7,
        LXW_ALIGN_VERTICAL_TOP = 8,
        LXW_ALIGN_VERTICAL_BOTTOM = 9,
        LXW_ALIGN_VERTICAL_CENTER = 10,
        LXW_ALIGN_VERTICAL_JUSTIFY = 11,
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
    enum lxw_format_diagonal_types
    {
        LXW_DIAGONAL_BORDER_UP = 1,
        LXW_DIAGONAL_BORDER_DOWN = 2,
        LXW_DIAGONAL_BORDER_UP_DOWN = 3,
    }
    enum LXW_DIAGONAL_BORDER_UP = lxw_format_diagonal_types.LXW_DIAGONAL_BORDER_UP;
    enum LXW_DIAGONAL_BORDER_DOWN = lxw_format_diagonal_types.LXW_DIAGONAL_BORDER_DOWN;
    enum LXW_DIAGONAL_BORDER_UP_DOWN = lxw_format_diagonal_types.LXW_DIAGONAL_BORDER_UP_DOWN;
    enum lxw_defined_colors
    {
        LXW_COLOR_BLACK = 16777216,
        LXW_COLOR_BLUE = 255,
        LXW_COLOR_BROWN = 8388608,
        LXW_COLOR_CYAN = 65535,
        LXW_COLOR_GRAY = 8421504,
        LXW_COLOR_GREEN = 32768,
        LXW_COLOR_LIME = 65280,
        LXW_COLOR_MAGENTA = 16711935,
        LXW_COLOR_NAVY = 128,
        LXW_COLOR_ORANGE = 16737792,
        LXW_COLOR_PINK = 16711935,
        LXW_COLOR_PURPLE = 8388736,
        LXW_COLOR_RED = 16711680,
        LXW_COLOR_SILVER = 12632256,
        LXW_COLOR_WHITE = 16777215,
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
    enum lxw_format_patterns
    {
        LXW_PATTERN_NONE = 0,
        LXW_PATTERN_SOLID = 1,
        LXW_PATTERN_MEDIUM_GRAY = 2,
        LXW_PATTERN_DARK_GRAY = 3,
        LXW_PATTERN_LIGHT_GRAY = 4,
        LXW_PATTERN_DARK_HORIZONTAL = 5,
        LXW_PATTERN_DARK_VERTICAL = 6,
        LXW_PATTERN_DARK_DOWN = 7,
        LXW_PATTERN_DARK_UP = 8,
        LXW_PATTERN_DARK_GRID = 9,
        LXW_PATTERN_DARK_TRELLIS = 10,
        LXW_PATTERN_LIGHT_HORIZONTAL = 11,
        LXW_PATTERN_LIGHT_VERTICAL = 12,
        LXW_PATTERN_LIGHT_DOWN = 13,
        LXW_PATTERN_LIGHT_UP = 14,
        LXW_PATTERN_LIGHT_GRID = 15,
        LXW_PATTERN_LIGHT_TRELLIS = 16,
        LXW_PATTERN_GRAY_125 = 17,
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
    enum lxw_format_borders
    {
        LXW_BORDER_NONE = 0,
        LXW_BORDER_THIN = 1,
        LXW_BORDER_MEDIUM = 2,
        LXW_BORDER_DASHED = 3,
        LXW_BORDER_DOTTED = 4,
        LXW_BORDER_THICK = 5,
        LXW_BORDER_DOUBLE = 6,
        LXW_BORDER_HAIR = 7,
        LXW_BORDER_MEDIUM_DASHED = 8,
        LXW_BORDER_DASH_DOT = 9,
        LXW_BORDER_MEDIUM_DASH_DOT = 10,
        LXW_BORDER_DASH_DOT_DOT = 11,
        LXW_BORDER_MEDIUM_DASH_DOT_DOT = 12,
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
    struct lxw_font
    {
        char[128] font_name;
        double font_size;
        ubyte bold;
        ubyte italic;
        ubyte underline;
        ubyte font_strikeout;
        ubyte font_outline;
        ubyte font_shadow;
        ubyte font_script;
        ubyte font_family;
        ubyte font_charset;
        ubyte font_condense;
        ubyte font_extend;
        int font_color;
    }
    struct lxw_border
    {
        ubyte bottom;
        ubyte diag_border;
        ubyte diag_type;
        ubyte left;
        ubyte right;
        ubyte top;
        int bottom_color;
        int diag_color;
        int left_color;
        int right_color;
        int top_color;
    }
    struct lxw_fill
    {
        int fg_color;
        int bg_color;
        ubyte pattern;
    }
    lxw_format* lxw_format_new() @nogc nothrow;
    void lxw_format_free(lxw_format*) @nogc nothrow;
    int lxw_format_get_xf_index(lxw_format*) @nogc nothrow;
    lxw_font* lxw_format_get_font_key(lxw_format*) @nogc nothrow;
    lxw_border* lxw_format_get_border_key(lxw_format*) @nogc nothrow;
    lxw_fill* lxw_format_get_fill_key(lxw_format*) @nogc nothrow;
    int lxw_format_check_color(int) @nogc nothrow;
    void format_set_font_name(lxw_format*, const(char)*) @nogc nothrow;
    void format_set_font_size(lxw_format*, double) @nogc nothrow;
    void format_set_font_color(lxw_format*, int) @nogc nothrow;
    void format_set_bold(lxw_format*) @nogc nothrow;
    void format_set_italic(lxw_format*) @nogc nothrow;
    void format_set_underline(lxw_format*, ubyte) @nogc nothrow;
    void format_set_font_strikeout(lxw_format*) @nogc nothrow;
    void format_set_font_script(lxw_format*, ubyte) @nogc nothrow;
    void format_set_num_format(lxw_format*, const(char)*) @nogc nothrow;
    void format_set_num_format_index(lxw_format*, ubyte) @nogc nothrow;
    void format_set_unlocked(lxw_format*) @nogc nothrow;
    void format_set_hidden(lxw_format*) @nogc nothrow;
    void format_set_align(lxw_format*, ubyte) @nogc nothrow;
    void format_set_text_wrap(lxw_format*) @nogc nothrow;
    void format_set_rotation(lxw_format*, short) @nogc nothrow;
    void format_set_indent(lxw_format*, ubyte) @nogc nothrow;
    void format_set_shrink(lxw_format*) @nogc nothrow;
    void format_set_pattern(lxw_format*, ubyte) @nogc nothrow;
    void format_set_bg_color(lxw_format*, int) @nogc nothrow;
    void format_set_fg_color(lxw_format*, int) @nogc nothrow;
    void format_set_border(lxw_format*, ubyte) @nogc nothrow;
    void format_set_bottom(lxw_format*, ubyte) @nogc nothrow;
    void format_set_top(lxw_format*, ubyte) @nogc nothrow;
    void format_set_left(lxw_format*, ubyte) @nogc nothrow;
    void format_set_right(lxw_format*, ubyte) @nogc nothrow;
    void format_set_border_color(lxw_format*, int) @nogc nothrow;
    void format_set_bottom_color(lxw_format*, int) @nogc nothrow;
    void format_set_top_color(lxw_format*, int) @nogc nothrow;
    void format_set_left_color(lxw_format*, int) @nogc nothrow;
    void format_set_right_color(lxw_format*, int) @nogc nothrow;
    void format_set_diag_type(lxw_format*, ubyte) @nogc nothrow;
    void format_set_diag_color(lxw_format*, int) @nogc nothrow;
    void format_set_diag_border(lxw_format*, ubyte) @nogc nothrow;
    void format_set_font_outline(lxw_format*) @nogc nothrow;
    void format_set_font_shadow(lxw_format*) @nogc nothrow;
    void format_set_font_family(lxw_format*, ubyte) @nogc nothrow;
    void format_set_font_charset(lxw_format*, ubyte) @nogc nothrow;
    void format_set_font_scheme(lxw_format*, const(char)*) @nogc nothrow;
    void format_set_font_condense(lxw_format*) @nogc nothrow;
    void format_set_font_extend(lxw_format*) @nogc nothrow;
    void format_set_reading_order(lxw_format*, ubyte) @nogc nothrow;
    void format_set_theme(lxw_format*, ubyte) @nogc nothrow;
    int deflateSetDictionary(z_stream_s*, const(ubyte)*, uint) @nogc nothrow;
    struct lxw_hash_element
    {
        void* key;
        void* value;
        static struct _Anonymous_12
        {
            lxw_hash_element* stqe_next;
        }
        _Anonymous_12 lxw_hash_order_pointers;
        static struct _Anonymous_13
        {
            lxw_hash_element* sle_next;
        }
        _Anonymous_13 lxw_hash_list_pointers;
    }
    struct lxw_hash_order_list
    {
        lxw_hash_element* stqh_first;
        lxw_hash_element** stqh_last;
    }
    struct lxw_hash_bucket_list
    {
        lxw_hash_element* slh_first;
    }
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
    lxw_hash_element* lxw_hash_key_exists(lxw_hash_table*, void*, c_ulong) @nogc nothrow;
    lxw_hash_element* lxw_insert_hash_element(lxw_hash_table*, void*, void*, c_ulong) @nogc nothrow;
    lxw_hash_table* lxw_hash_new(uint, ubyte, ubyte) @nogc nothrow;
    void lxw_hash_free(lxw_hash_table*) @nogc nothrow;
    int inflateEnd(z_stream_s*) @nogc nothrow;
    struct lxw_packager
    {
        _IO_FILE* file;
        lxw_workbook* workbook;
        c_ulong buffer_size;
        void* zipfile;
        zip_fileinfo zipfile_info;
        char* filename;
        char* buffer;
        char* tmpdir;
        ubyte use_zip64;
    }
    lxw_packager* lxw_packager_new(const(char)*, char*, ubyte) @nogc nothrow;
    void lxw_packager_free(lxw_packager*) @nogc nothrow;
    lxw_error lxw_create_package(lxw_packager*) @nogc nothrow;
    struct lxw_rel_tuple
    {
        char* type;
        char* target;
        char* target_mode;
        static struct _Anonymous_14
        {
            lxw_rel_tuple* stqe_next;
        }
        _Anonymous_14 list_pointers;
    }
    struct lxw_relationships
    {
        _IO_FILE* file;
        uint rel_id;
        lxw_rel_tuples* relationships;
    }
    lxw_relationships* lxw_relationships_new() @nogc nothrow;
    void lxw_free_relationships(lxw_relationships*) @nogc nothrow;
    void lxw_relationships_assemble_xml_file(lxw_relationships*) @nogc nothrow;
    void lxw_add_document_relationship(lxw_relationships*, const(char)*, const(char)*) @nogc nothrow;
    void lxw_add_package_relationship(lxw_relationships*, const(char)*, const(char)*) @nogc nothrow;
    void lxw_add_ms_package_relationship(lxw_relationships*, const(char)*, const(char)*) @nogc nothrow;
    void lxw_add_worksheet_relationship(lxw_relationships*, const(char)*, const(char)*, const(char)*) @nogc nothrow;
    struct sst_element
    {
        uint index;
        char* string;
        ubyte is_rich_string;
        static struct _Anonymous_15
        {
            sst_element* stqe_next;
        }
        _Anonymous_15 sst_order_pointers;
        static struct _Anonymous_16
        {
            sst_element* rbe_left;
            sst_element* rbe_right;
            sst_element* rbe_parent;
            int rbe_color;
        }
        _Anonymous_16 sst_tree_pointers;
    }
    struct sst_rb_tree
    {
        sst_element* rbh_root;
    }
    struct sst_order_list
    {
        sst_element* stqh_first;
        sst_element** stqh_last;
    }
    int inflate(z_stream_s*, int) @nogc nothrow;
    struct lxw_sst
    {
        _IO_FILE* file;
        uint string_count;
        uint unique_count;
        sst_order_list* order_list;
        sst_rb_tree* rb_tree;
    }
    lxw_sst* lxw_sst_new() @nogc nothrow;
    void lxw_sst_free(lxw_sst*) @nogc nothrow;
    sst_element* lxw_get_sst_index(lxw_sst*, const(char)*, ubyte) @nogc nothrow;
    void lxw_sst_assemble_xml_file(lxw_sst*) @nogc nothrow;
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
    }
    lxw_styles* lxw_styles_new() @nogc nothrow;
    void lxw_styles_free(lxw_styles*) @nogc nothrow;
    void lxw_styles_assemble_xml_file(lxw_styles*) @nogc nothrow;
    void lxw_styles_write_string_fragment(lxw_styles*, char*) @nogc nothrow;
    void lxw_styles_write_rich_font(lxw_styles*, lxw_format*) @nogc nothrow;
    struct lxw_theme
    {
        _IO_FILE* file;
    }
    lxw_theme* lxw_theme_new() @nogc nothrow;
    void lxw_theme_free(lxw_theme*) @nogc nothrow;
    void lxw_theme_xml_declaration(lxw_theme*) @nogc nothrow;
    void lxw_theme_assemble_xml_file(lxw_theme*) @nogc nothrow;
    int deflateEnd(z_stream_s*) @nogc nothrow;
    alias ZPOS64_T = ulong;
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
    alias open_file_func = void* function(void*, const(char)*, int);
    alias read_file_func = c_ulong function(void*, void*, void*, c_ulong);
    alias write_file_func = c_ulong function(void*, void*, const(void)*, c_ulong);
    alias close_file_func = int function(void*, void*);
    alias testerror_file_func = int function(void*, void*);
    alias tell_file_func = c_long function(void*, void*);
    alias seek_file_func = c_long function(void*, void*, c_ulong, int);
    alias zlib_filefunc_def = zlib_filefunc_def_s;
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
    alias tell64_file_func = ulong function(void*, void*);
    alias seek64_file_func = c_long function(void*, void*, ulong, int);
    alias open64_file_func = void* function(void*, const(void)*, int);
    alias zlib_filefunc64_def = zlib_filefunc64_def_s;
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
    void fill_fopen64_filefunc(zlib_filefunc64_def_s*) @nogc nothrow;
    void fill_fopen_filefunc(zlib_filefunc_def_s*) @nogc nothrow;
    alias zlib_filefunc64_32_def = zlib_filefunc64_32_def_s;
    struct zlib_filefunc64_32_def_s
    {
        zlib_filefunc64_def_s zfile_func64;
        void* function(void*, const(char)*, int) zopen32_file;
        c_long function(void*, void*) ztell32_file;
        c_long function(void*, void*, c_ulong, int) zseek32_file;
    }
    alias z_streamp = z_stream_s*;
    void* call_zopen64(const(zlib_filefunc64_32_def_s)*, const(void)*, int) @nogc nothrow;
    c_long call_zseek64(const(zlib_filefunc64_32_def_s)*, void*, ulong, int) @nogc nothrow;
    ulong call_ztell64(const(zlib_filefunc64_32_def_s)*, void*) @nogc nothrow;
    void fill_zlib_filefunc64_32_def_from_filefunc32(zlib_filefunc64_32_def_s*, const(zlib_filefunc_def_s)*) @nogc nothrow;
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
    alias free_func = void function(void*, void*);
    alias alloc_func = void* function(void*, uint, uint);
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
    void* sbrk(c_long) @nogc nothrow;
    int brk(void*) @nogc nothrow;
    int ftruncate(int, c_long) @nogc nothrow;
    int truncate(const(char)*, c_long) @nogc nothrow;
    int getdtablesize() @nogc nothrow;
    int getpagesize() @nogc nothrow;
    void sync() @nogc nothrow;
    c_long gethostid() @nogc nothrow;
    int fsync(int) @nogc nothrow;
    char* getpass(const(char)*) @nogc nothrow;
    int chroot(const(char)*) @nogc nothrow;
    int daemon(int, int) @nogc nothrow;
    void setusershell() @nogc nothrow;
    void endusershell() @nogc nothrow;
    char* getusershell() @nogc nothrow;
    int acct(const(char)*) @nogc nothrow;
    int profil(ushort*, c_ulong, c_ulong, uint) @nogc nothrow;
    int revoke(const(char)*) @nogc nothrow;
    int vhangup() @nogc nothrow;
    int setdomainname(const(char)*, c_ulong) @nogc nothrow;
    int getdomainname(char*, c_ulong) @nogc nothrow;
    int sethostid(c_long) @nogc nothrow;
    int sethostname(const(char)*, c_ulong) @nogc nothrow;
    int gethostname(char*, c_ulong) @nogc nothrow;
    int setlogin(const(char)*) @nogc nothrow;
    int getlogin_r(char*, c_ulong) @nogc nothrow;
    char* getlogin() @nogc nothrow;
    int tcsetpgrp(int, int) @nogc nothrow;
    int tcgetpgrp(int) @nogc nothrow;
    int rmdir(const(char)*) @nogc nothrow;
    int unlinkat(int, const(char)*, int) @nogc nothrow;
    alias zipFile = void*;
    int unlink(const(char)*) @nogc nothrow;
    c_long readlinkat(int, const(char)*, char*, c_ulong) @nogc nothrow;
    alias tm_zip = tm_zip_s;
    struct tm_zip_s
    {
        uint tm_sec;
        uint tm_min;
        uint tm_hour;
        uint tm_mday;
        uint tm_mon;
        uint tm_year;
    }
    struct zip_fileinfo
    {
        tm_zip_s tmz_date;
        c_ulong dosDate;
        c_ulong internal_fa;
        c_ulong external_fa;
    }
    alias zipcharpc = const(char)*;
    int symlinkat(const(char)*, int, const(char)*) @nogc nothrow;
    void* zipOpen(const(char)*, int) @nogc nothrow;
    void* zipOpen64(const(void)*, int) @nogc nothrow;
    void* zipOpen2(const(char)*, int, const(char)**, zlib_filefunc_def_s*) @nogc nothrow;
    void* zipOpen2_64(const(void)*, int, const(char)**, zlib_filefunc64_def_s*) @nogc nothrow;
    int zipOpenNewFileInZip(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int) @nogc nothrow;
    int zipOpenNewFileInZip64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int) @nogc nothrow;
    int zipOpenNewFileInZip2(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int) @nogc nothrow;
    int zipOpenNewFileInZip2_64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int) @nogc nothrow;
    int zipOpenNewFileInZip3(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong) @nogc nothrow;
    int zipOpenNewFileInZip3_64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong, int) @nogc nothrow;
    int zipOpenNewFileInZip4(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong, c_ulong, c_ulong) @nogc nothrow;
    int zipOpenNewFileInZip4_64(void*, const(char)*, const(zip_fileinfo)*, const(void)*, uint, const(void)*, uint, const(char)*, int, int, int, int, int, int, const(char)*, c_ulong, c_ulong, c_ulong, int) @nogc nothrow;
    int zipWriteInFileInZip(void*, const(void)*, uint) @nogc nothrow;
    int zipCloseFileInZip(void*) @nogc nothrow;
    int zipCloseFileInZipRaw(void*, c_ulong, c_ulong) @nogc nothrow;
    int zipCloseFileInZipRaw64(void*, ulong, c_ulong) @nogc nothrow;
    int zipClose(void*, const(char)*) @nogc nothrow;
    int zipRemoveExtraInfoBlock(char*, int*, short) @nogc nothrow;
    c_long readlink(const(char)*, char*, c_ulong) @nogc nothrow;
    const(char)* lxw_version() @nogc nothrow;
    char* lxw_strerror(lxw_error) @nogc nothrow;
    char* lxw_quote_sheetname(const(char)*) @nogc nothrow;
    void lxw_col_to_name(char*, ushort, ubyte) @nogc nothrow;
    void lxw_rowcol_to_cell(char*, uint, ushort) @nogc nothrow;
    void lxw_rowcol_to_cell_abs(char*, uint, ushort, ubyte, ubyte) @nogc nothrow;
    void lxw_rowcol_to_range(char*, uint, ushort, uint, ushort) @nogc nothrow;
    void lxw_rowcol_to_range_abs(char*, uint, ushort, uint, ushort) @nogc nothrow;
    void lxw_rowcol_to_formula_abs(char*, const(char)*, uint, ushort, uint, ushort) @nogc nothrow;
    uint lxw_name_to_row(const(char)*) @nogc nothrow;
    ushort lxw_name_to_col(const(char)*) @nogc nothrow;
    uint lxw_name_to_row_2(const(char)*) @nogc nothrow;
    ushort lxw_name_to_col_2(const(char)*) @nogc nothrow;
    double lxw_datetime_to_excel_date(lxw_datetime*, ubyte) @nogc nothrow;
    char* lxw_strdup(const(char)*) @nogc nothrow;
    char* lxw_strdup_formula(const(char)*) @nogc nothrow;
    c_ulong lxw_utf8_strlen(const(char)*) @nogc nothrow;
    void lxw_str_tolower(char*) @nogc nothrow;
    _IO_FILE* lxw_tmpfile(char*) @nogc nothrow;
    ushort lxw_hash_password(const(char)*) @nogc nothrow;
    int symlink(const(char)*, const(char)*) @nogc nothrow;
    struct lxw_worksheet_name
    {
        const(char)* name;
        lxw_worksheet* worksheet;
        static struct _Anonymous_17
        {
            lxw_worksheet_name* rbe_left;
            lxw_worksheet_name* rbe_right;
            lxw_worksheet_name* rbe_parent;
            int rbe_color;
        }
        _Anonymous_17 tree_pointers;
    }
    struct lxw_worksheet_names
    {
        lxw_worksheet_name* rbh_root;
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
    struct lxw_chartsheet_names
    {
        lxw_chartsheet_name* rbh_root;
    }
    struct lxw_sheet
    {
        ubyte is_chartsheet;
        static union _Anonymous_19
        {
            lxw_worksheet* worksheet;
            lxw_chartsheet* chartsheet;
        }
        _Anonymous_19 u;
        static struct _Anonymous_20
        {
            lxw_sheet* stqe_next;
        }
        _Anonymous_20 list_pointers;
    }
    struct lxw_sheets
    {
        lxw_sheet* stqh_first;
        lxw_sheet** stqh_last;
    }
    struct lxw_worksheets
    {
        lxw_worksheet* stqh_first;
        lxw_worksheet** stqh_last;
    }
    struct lxw_chartsheets
    {
        lxw_chartsheet* stqh_first;
        lxw_chartsheet** stqh_last;
    }
    struct lxw_charts
    {
        lxw_chart* stqh_first;
        lxw_chart** stqh_last;
    }
    struct lxw_defined_names
    {
        lxw_defined_name* tqh_first;
        lxw_defined_name** tqh_last;
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
        static struct _Anonymous_21
        {
            lxw_defined_name* tqe_next;
            lxw_defined_name** tqe_prev;
        }
        _Anonymous_21 list_pointers;
    }
    struct lxw_doc_properties
    {
        char* title;
        char* subject;
        char* author;
        char* manager;
        char* company;
        char* category;
        char* keywords;
        char* comments;
        char* status;
        char* hyperlink_base;
        c_long created;
    }
    struct lxw_workbook_options
    {
        ubyte constant_memory;
        char* tmpdir;
        ubyte use_zip64;
    }
    struct lxw_workbook
    {
        _IO_FILE* file;
        lxw_sheets* sheets;
        lxw_worksheets* worksheets;
        lxw_chartsheets* chartsheets;
        lxw_worksheet_names* worksheet_names;
        lxw_chartsheet_names* chartsheet_names;
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
        ushort num_format_count;
        ushort drawing_count;
        ushort font_count;
        ushort border_count;
        ushort fill_count;
        ubyte optimize;
        ubyte has_png;
        ubyte has_jpeg;
        ubyte has_bmp;
        lxw_hash_table* used_xf_formats;
        char* vba_project;
        char* vba_codename;
    }
    lxw_workbook* workbook_new(const(char)*) @nogc nothrow;
    lxw_workbook* workbook_new_opt(const(char)*, lxw_workbook_options*) @nogc nothrow;
    lxw_workbook* new_workbook(const(char)*) @nogc nothrow;
    lxw_workbook* new_workbook_opt(const(char)*, lxw_workbook_options*) @nogc nothrow;
    lxw_worksheet* workbook_add_worksheet(lxw_workbook*, const(char)*) @nogc nothrow;
    lxw_chartsheet* workbook_add_chartsheet(lxw_workbook*, const(char)*) @nogc nothrow;
    lxw_format* workbook_add_format(lxw_workbook*) @nogc nothrow;
    lxw_chart* workbook_add_chart(lxw_workbook*, ubyte) @nogc nothrow;
    lxw_error workbook_close(lxw_workbook*) @nogc nothrow;
    lxw_error workbook_set_properties(lxw_workbook*, lxw_doc_properties*) @nogc nothrow;
    lxw_error workbook_set_custom_property_string(lxw_workbook*, const(char)*, const(char)*) @nogc nothrow;
    lxw_error workbook_set_custom_property_number(lxw_workbook*, const(char)*, double) @nogc nothrow;
    lxw_error workbook_set_custom_property_integer(lxw_workbook*, const(char)*, int) @nogc nothrow;
    lxw_error workbook_set_custom_property_boolean(lxw_workbook*, const(char)*, ubyte) @nogc nothrow;
    lxw_error workbook_set_custom_property_datetime(lxw_workbook*, const(char)*, lxw_datetime*) @nogc nothrow;
    lxw_error workbook_define_name(lxw_workbook*, const(char)*, const(char)*) @nogc nothrow;
    lxw_worksheet* workbook_get_worksheet_by_name(lxw_workbook*, const(char)*) @nogc nothrow;
    lxw_chartsheet* workbook_get_chartsheet_by_name(lxw_workbook*, const(char)*) @nogc nothrow;
    lxw_error workbook_validate_sheet_name(lxw_workbook*, const(char)*) @nogc nothrow;
    lxw_error workbook_add_vba_project(lxw_workbook*, const(char)*) @nogc nothrow;
    lxw_error workbook_set_vba_name(lxw_workbook*, const(char)*) @nogc nothrow;
    void lxw_workbook_free(lxw_workbook*) @nogc nothrow;
    void lxw_workbook_assemble_xml_file(lxw_workbook*) @nogc nothrow;
    void lxw_workbook_set_default_xf_indices(lxw_workbook*) @nogc nothrow;
    int linkat(int, const(char)*, int, const(char)*, int) @nogc nothrow;
    int link(const(char)*, const(char)*) @nogc nothrow;
    int ttyslot() @nogc nothrow;
    enum lxw_gridlines
    {
        LXW_HIDE_ALL_GRIDLINES = 0,
        LXW_SHOW_SCREEN_GRIDLINES = 1,
        LXW_SHOW_PRINT_GRIDLINES = 2,
        LXW_SHOW_ALL_GRIDLINES = 3,
    }
    enum LXW_HIDE_ALL_GRIDLINES = lxw_gridlines.LXW_HIDE_ALL_GRIDLINES;
    enum LXW_SHOW_SCREEN_GRIDLINES = lxw_gridlines.LXW_SHOW_SCREEN_GRIDLINES;
    enum LXW_SHOW_PRINT_GRIDLINES = lxw_gridlines.LXW_SHOW_PRINT_GRIDLINES;
    enum LXW_SHOW_ALL_GRIDLINES = lxw_gridlines.LXW_SHOW_ALL_GRIDLINES;
    enum lxw_validation_boolean
    {
        LXW_VALIDATION_DEFAULT = 0,
        LXW_VALIDATION_OFF = 1,
        LXW_VALIDATION_ON = 2,
    }
    enum LXW_VALIDATION_DEFAULT = lxw_validation_boolean.LXW_VALIDATION_DEFAULT;
    enum LXW_VALIDATION_OFF = lxw_validation_boolean.LXW_VALIDATION_OFF;
    enum LXW_VALIDATION_ON = lxw_validation_boolean.LXW_VALIDATION_ON;
    enum lxw_validation_types
    {
        LXW_VALIDATION_TYPE_NONE = 0,
        LXW_VALIDATION_TYPE_INTEGER = 1,
        LXW_VALIDATION_TYPE_INTEGER_FORMULA = 2,
        LXW_VALIDATION_TYPE_DECIMAL = 3,
        LXW_VALIDATION_TYPE_DECIMAL_FORMULA = 4,
        LXW_VALIDATION_TYPE_LIST = 5,
        LXW_VALIDATION_TYPE_LIST_FORMULA = 6,
        LXW_VALIDATION_TYPE_DATE = 7,
        LXW_VALIDATION_TYPE_DATE_FORMULA = 8,
        LXW_VALIDATION_TYPE_DATE_NUMBER = 9,
        LXW_VALIDATION_TYPE_TIME = 10,
        LXW_VALIDATION_TYPE_TIME_FORMULA = 11,
        LXW_VALIDATION_TYPE_TIME_NUMBER = 12,
        LXW_VALIDATION_TYPE_LENGTH = 13,
        LXW_VALIDATION_TYPE_LENGTH_FORMULA = 14,
        LXW_VALIDATION_TYPE_CUSTOM_FORMULA = 15,
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
    enum lxw_validation_criteria
    {
        LXW_VALIDATION_CRITERIA_NONE = 0,
        LXW_VALIDATION_CRITERIA_BETWEEN = 1,
        LXW_VALIDATION_CRITERIA_NOT_BETWEEN = 2,
        LXW_VALIDATION_CRITERIA_EQUAL_TO = 3,
        LXW_VALIDATION_CRITERIA_NOT_EQUAL_TO = 4,
        LXW_VALIDATION_CRITERIA_GREATER_THAN = 5,
        LXW_VALIDATION_CRITERIA_LESS_THAN = 6,
        LXW_VALIDATION_CRITERIA_GREATER_THAN_OR_EQUAL_TO = 7,
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
    enum lxw_validation_error_types
    {
        LXW_VALIDATION_ERROR_TYPE_STOP = 0,
        LXW_VALIDATION_ERROR_TYPE_WARNING = 1,
        LXW_VALIDATION_ERROR_TYPE_INFORMATION = 2,
    }
    enum LXW_VALIDATION_ERROR_TYPE_STOP = lxw_validation_error_types.LXW_VALIDATION_ERROR_TYPE_STOP;
    enum LXW_VALIDATION_ERROR_TYPE_WARNING = lxw_validation_error_types.LXW_VALIDATION_ERROR_TYPE_WARNING;
    enum LXW_VALIDATION_ERROR_TYPE_INFORMATION = lxw_validation_error_types.LXW_VALIDATION_ERROR_TYPE_INFORMATION;
    enum cell_types
    {
        NUMBER_CELL = 1,
        STRING_CELL = 2,
        INLINE_STRING_CELL = 3,
        INLINE_RICH_STRING_CELL = 4,
        FORMULA_CELL = 5,
        ARRAY_FORMULA_CELL = 6,
        BLANK_CELL = 7,
        BOOLEAN_CELL = 8,
        HYPERLINK_URL = 9,
        HYPERLINK_INTERNAL = 10,
        HYPERLINK_EXTERNAL = 11,
    }
    enum NUMBER_CELL = cell_types.NUMBER_CELL;
    enum STRING_CELL = cell_types.STRING_CELL;
    enum INLINE_STRING_CELL = cell_types.INLINE_STRING_CELL;
    enum INLINE_RICH_STRING_CELL = cell_types.INLINE_RICH_STRING_CELL;
    enum FORMULA_CELL = cell_types.FORMULA_CELL;
    enum ARRAY_FORMULA_CELL = cell_types.ARRAY_FORMULA_CELL;
    enum BLANK_CELL = cell_types.BLANK_CELL;
    enum BOOLEAN_CELL = cell_types.BOOLEAN_CELL;
    enum HYPERLINK_URL = cell_types.HYPERLINK_URL;
    enum HYPERLINK_INTERNAL = cell_types.HYPERLINK_INTERNAL;
    enum HYPERLINK_EXTERNAL = cell_types.HYPERLINK_EXTERNAL;
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
    struct lxw_cell
    {
        uint row_num;
        ushort col_num;
        cell_types type;
        lxw_format* format;
        static union _Anonymous_22
        {
            double number;
            int string_id;
            char* string;
        }
        _Anonymous_22 u;
        double formula_result;
        char* user_data1;
        char* user_data2;
        char* sst_string;
        static struct _Anonymous_23
        {
            lxw_cell* rbe_left;
            lxw_cell* rbe_right;
            lxw_cell* rbe_parent;
            int rbe_color;
        }
        _Anonymous_23 tree_pointers;
    }
    struct lxw_table_cells
    {
        lxw_cell* rbh_root;
    }
    struct lxw_table_rows
    {
        lxw_row* rbh_root;
        lxw_row* cached_row;
        uint cached_row_num;
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
        static struct _Anonymous_24
        {
            lxw_row* rbe_left;
            lxw_row* rbe_right;
            lxw_row* rbe_parent;
            int rbe_color;
        }
        _Anonymous_24 tree_pointers;
    }
    int isatty(int) @nogc nothrow;
    struct lxw_merged_range
    {
        uint first_row;
        uint last_row;
        ushort first_col;
        ushort last_col;
        static struct _Anonymous_25
        {
            lxw_merged_range* stqe_next;
        }
        _Anonymous_25 list_pointers;
    }
    struct lxw_merged_ranges
    {
        lxw_merged_range* stqh_first;
        lxw_merged_range** stqh_last;
    }
    struct lxw_selection
    {
        char[12] pane;
        char[28] active_cell;
        char[28] sqref;
        static struct _Anonymous_26
        {
            lxw_selection* stqe_next;
        }
        _Anonymous_26 list_pointers;
    }
    struct lxw_selections
    {
        lxw_selection* stqh_first;
        lxw_selection** stqh_last;
    }
    struct lxw_data_validations
    {
        lxw_data_validation* stqh_first;
        lxw_data_validation** stqh_last;
    }
    struct lxw_data_validation
    {
        ubyte validate;
        ubyte criteria;
        ubyte ignore_blank;
        ubyte show_input;
        ubyte show_error;
        ubyte error_type;
        ubyte dropdown;
        ubyte is_between;
        double value_number;
        char* value_formula;
        char** value_list;
        lxw_datetime value_datetime;
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
        static struct _Anonymous_27
        {
            lxw_data_validation* stqe_next;
        }
        _Anonymous_27 list_pointers;
    }
    struct lxw_image_data
    {
        lxw_image_options* stqh_first;
        lxw_image_options** stqh_last;
    }
    struct lxw_image_options
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
        ubyte anchor;
        _IO_FILE* stream;
        ubyte image_type;
        ubyte is_image_buffer;
        ubyte* image_buffer;
        c_ulong image_buffer_size;
        double width;
        double height;
        char* extension;
        double x_dpi;
        double y_dpi;
        lxw_chart* chart;
        static struct _Anonymous_28
        {
            lxw_image_options* stqe_next;
        }
        _Anonymous_28 list_pointers;
    }
    struct lxw_chart_data
    {
        lxw_image_options* stqh_first;
        lxw_image_options** stqh_last;
    }
    struct lxw_row_col_options
    {
        ubyte hidden;
        ubyte level;
        ubyte collapsed;
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
    struct lxw_repeat_rows
    {
        ubyte in_use;
        uint first_row;
        uint last_row;
    }
    struct lxw_repeat_cols
    {
        ubyte in_use;
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
    struct lxw_autofilter
    {
        ubyte in_use;
        uint first_row;
        uint last_row;
        ushort first_col;
        ushort last_col;
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
    struct lxw_header_footer_options
    {
        double margin;
    }
    struct lxw_protection
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
    struct lxw_rich_string_tuple
    {
        lxw_format* format;
        char* string;
    }
    struct lxw_worksheet
    {
        _IO_FILE* file;
        _IO_FILE* optimize_tmpfile;
        lxw_table_rows* table;
        lxw_table_rows* hyperlinks;
        lxw_cell** array;
        lxw_merged_ranges* merged_ranges;
        lxw_selections* selections;
        lxw_data_validations* data_validations;
        lxw_image_data* image_data;
        lxw_chart_data* chart_data;
        uint dim_rowmin;
        uint dim_rowmax;
        ushort dim_colmin;
        ushort dim_colmax;
        lxw_sst* sst;
        char* name;
        char* quoted_name;
        char* tmpdir;
        uint index;
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
        ubyte num_validations;
        char* vba_codename;
        int tab_color;
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
        char[255] header;
        char[255] footer;
        lxw_repeat_rows repeat_rows;
        lxw_repeat_cols repeat_cols;
        lxw_print_area print_area;
        lxw_autofilter autofilter;
        ushort merged_range_count;
        uint* hbreaks;
        ushort* vbreaks;
        ushort hbreaks_count;
        ushort vbreaks_count;
        lxw_rel_tuples* external_hyperlinks;
        lxw_rel_tuples* external_drawing_links;
        lxw_rel_tuples* drawing_links;
        lxw_panes panes;
        lxw_protection protection;
        lxw_drawing* drawing;
        static struct _Anonymous_29
        {
            lxw_worksheet* stqe_next;
        }
        _Anonymous_29 list_pointers;
    }
    struct lxw_rel_tuples
    {
        lxw_rel_tuple* stqh_first;
        lxw_rel_tuple** stqh_last;
    }
    struct lxw_worksheet_init_data
    {
        uint index;
        ubyte hidden;
        ubyte optimize;
        ushort* active_sheet;
        ushort* first_sheet;
        lxw_sst* sst;
        char* name;
        char* quoted_name;
        char* tmpdir;
    }
    lxw_error worksheet_write_number(lxw_worksheet*, uint, ushort, double, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_string(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_formula(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_array_formula(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_array_formula_num(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*, double) @nogc nothrow;
    lxw_error worksheet_write_datetime(lxw_worksheet*, uint, ushort, lxw_datetime*, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_url_opt(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*, const(char)*, const(char)*) @nogc nothrow;
    lxw_error worksheet_write_url(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_boolean(lxw_worksheet*, uint, ushort, int, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_blank(lxw_worksheet*, uint, ushort, lxw_format*) @nogc nothrow;
    lxw_error worksheet_write_formula_num(lxw_worksheet*, uint, ushort, const(char)*, lxw_format*, double) @nogc nothrow;
    lxw_error worksheet_write_rich_string(lxw_worksheet*, uint, ushort, lxw_rich_string_tuple**, lxw_format*) @nogc nothrow;
    lxw_error worksheet_set_row(lxw_worksheet*, uint, double, lxw_format*) @nogc nothrow;
    lxw_error worksheet_set_row_opt(lxw_worksheet*, uint, double, lxw_format*, lxw_row_col_options*) @nogc nothrow;
    lxw_error worksheet_set_column(lxw_worksheet*, ushort, ushort, double, lxw_format*) @nogc nothrow;
    lxw_error worksheet_set_column_opt(lxw_worksheet*, ushort, ushort, double, lxw_format*, lxw_row_col_options*) @nogc nothrow;
    lxw_error worksheet_insert_image(lxw_worksheet*, uint, ushort, const(char)*) @nogc nothrow;
    lxw_error worksheet_insert_image_opt(lxw_worksheet*, uint, ushort, const(char)*, lxw_image_options*) @nogc nothrow;
    lxw_error worksheet_insert_image_buffer(lxw_worksheet*, uint, ushort, const(ubyte)*, c_ulong) @nogc nothrow;
    lxw_error worksheet_insert_image_buffer_opt(lxw_worksheet*, uint, ushort, const(ubyte)*, c_ulong, lxw_image_options*) @nogc nothrow;
    lxw_error worksheet_insert_chart(lxw_worksheet*, uint, ushort, lxw_chart*) @nogc nothrow;
    lxw_error worksheet_insert_chart_opt(lxw_worksheet*, uint, ushort, lxw_chart*, lxw_image_options*) @nogc nothrow;
    lxw_error worksheet_merge_range(lxw_worksheet*, uint, ushort, uint, ushort, const(char)*, lxw_format*) @nogc nothrow;
    lxw_error worksheet_autofilter(lxw_worksheet*, uint, ushort, uint, ushort) @nogc nothrow;
    lxw_error worksheet_data_validation_cell(lxw_worksheet*, uint, ushort, lxw_data_validation*) @nogc nothrow;
    lxw_error worksheet_data_validation_range(lxw_worksheet*, uint, ushort, uint, ushort, lxw_data_validation*) @nogc nothrow;
    void worksheet_activate(lxw_worksheet*) @nogc nothrow;
    void worksheet_select(lxw_worksheet*) @nogc nothrow;
    void worksheet_hide(lxw_worksheet*) @nogc nothrow;
    void worksheet_set_first_sheet(lxw_worksheet*) @nogc nothrow;
    void worksheet_freeze_panes(lxw_worksheet*, uint, ushort) @nogc nothrow;
    void worksheet_split_panes(lxw_worksheet*, double, double) @nogc nothrow;
    void worksheet_freeze_panes_opt(lxw_worksheet*, uint, ushort, uint, ushort, ubyte) @nogc nothrow;
    void worksheet_split_panes_opt(lxw_worksheet*, double, double, uint, ushort) @nogc nothrow;
    void worksheet_set_selection(lxw_worksheet*, uint, ushort, uint, ushort) @nogc nothrow;
    void worksheet_set_landscape(lxw_worksheet*) @nogc nothrow;
    void worksheet_set_portrait(lxw_worksheet*) @nogc nothrow;
    void worksheet_set_page_view(lxw_worksheet*) @nogc nothrow;
    void worksheet_set_paper(lxw_worksheet*, ubyte) @nogc nothrow;
    void worksheet_set_margins(lxw_worksheet*, double, double, double, double) @nogc nothrow;
    lxw_error worksheet_set_header(lxw_worksheet*, const(char)*) @nogc nothrow;
    lxw_error worksheet_set_footer(lxw_worksheet*, const(char)*) @nogc nothrow;
    lxw_error worksheet_set_header_opt(lxw_worksheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    lxw_error worksheet_set_footer_opt(lxw_worksheet*, const(char)*, lxw_header_footer_options*) @nogc nothrow;
    lxw_error worksheet_set_h_pagebreaks(lxw_worksheet*, uint*) @nogc nothrow;
    lxw_error worksheet_set_v_pagebreaks(lxw_worksheet*, ushort*) @nogc nothrow;
    void worksheet_print_across(lxw_worksheet*) @nogc nothrow;
    void worksheet_set_zoom(lxw_worksheet*, ushort) @nogc nothrow;
    void worksheet_gridlines(lxw_worksheet*, ubyte) @nogc nothrow;
    void worksheet_center_horizontally(lxw_worksheet*) @nogc nothrow;
    void worksheet_center_vertically(lxw_worksheet*) @nogc nothrow;
    void worksheet_print_row_col_headers(lxw_worksheet*) @nogc nothrow;
    lxw_error worksheet_repeat_rows(lxw_worksheet*, uint, uint) @nogc nothrow;
    lxw_error worksheet_repeat_columns(lxw_worksheet*, ushort, ushort) @nogc nothrow;
    lxw_error worksheet_print_area(lxw_worksheet*, uint, ushort, uint, ushort) @nogc nothrow;
    void worksheet_fit_to_pages(lxw_worksheet*, ushort, ushort) @nogc nothrow;
    void worksheet_set_start_page(lxw_worksheet*, ushort) @nogc nothrow;
    void worksheet_set_print_scale(lxw_worksheet*, ushort) @nogc nothrow;
    void worksheet_right_to_left(lxw_worksheet*) @nogc nothrow;
    void worksheet_hide_zero(lxw_worksheet*) @nogc nothrow;
    void worksheet_set_tab_color(lxw_worksheet*, int) @nogc nothrow;
    void worksheet_protect(lxw_worksheet*, const(char)*, lxw_protection*) @nogc nothrow;
    void worksheet_outline_settings(lxw_worksheet*, ubyte, ubyte, ubyte, ubyte) @nogc nothrow;
    void worksheet_set_default_row(lxw_worksheet*, double, ubyte) @nogc nothrow;
    lxw_error worksheet_set_vba_name(lxw_worksheet*, const(char)*) @nogc nothrow;
    lxw_worksheet* lxw_worksheet_new(lxw_worksheet_init_data*) @nogc nothrow;
    void lxw_worksheet_free(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_assemble_xml_file(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_write_single_row(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_prepare_image(lxw_worksheet*, uint, uint, lxw_image_options*) @nogc nothrow;
    void lxw_worksheet_prepare_chart(lxw_worksheet*, uint, uint, lxw_image_options*, ubyte) @nogc nothrow;
    lxw_row* lxw_worksheet_find_row(lxw_worksheet*, uint) @nogc nothrow;
    lxw_cell* lxw_worksheet_find_cell(lxw_row*, ushort) @nogc nothrow;
    void lxw_worksheet_write_sheet_views(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_write_page_margins(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_write_drawings(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_write_sheet_protection(lxw_worksheet*, lxw_protection*) @nogc nothrow;
    void lxw_worksheet_write_sheet_pr(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_write_page_setup(lxw_worksheet*) @nogc nothrow;
    void lxw_worksheet_write_header_footer(lxw_worksheet*) @nogc nothrow;
    int ttyname_r(int, char*, c_ulong) @nogc nothrow;
    struct xml_attribute
    {
        char[256] key;
        char[256] value;
        static struct _Anonymous_30
        {
            xml_attribute* stqe_next;
        }
        _Anonymous_30 list_entries;
    }
    struct xml_attribute_list
    {
        xml_attribute* stqh_first;
        xml_attribute** stqh_last;
    }
    xml_attribute* lxw_new_attribute_str(const(char)*, const(char)*) @nogc nothrow;
    xml_attribute* lxw_new_attribute_int(const(char)*, uint) @nogc nothrow;
    xml_attribute* lxw_new_attribute_dbl(const(char)*, double) @nogc nothrow;
    char* ttyname(int) @nogc nothrow;
    int vfork() @nogc nothrow;
    void lxw_xml_declaration(_IO_FILE*) @nogc nothrow;
    void lxw_xml_start_tag(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    void lxw_xml_start_tag_unencoded(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    void lxw_xml_end_tag(_IO_FILE*, const(char)*) @nogc nothrow;
    void lxw_xml_empty_tag(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    void lxw_xml_empty_tag_unencoded(_IO_FILE*, const(char)*, xml_attribute_list*) @nogc nothrow;
    void lxw_xml_data_element(_IO_FILE*, const(char)*, const(char)*, xml_attribute_list*) @nogc nothrow;
    void lxw_xml_rich_si_element(_IO_FILE*, const(char)*) @nogc nothrow;
    char* lxw_escape_control_characters(const(char)*) @nogc nothrow;
    char* lxw_escape_data(const(char)*) @nogc nothrow;
    pragma(mangle, "alloca") void* alloca_(c_ulong) @nogc nothrow;
    int fork() @nogc nothrow;
    int setegid(uint) @nogc nothrow;
    int setregid(uint, uint) @nogc nothrow;
    int setgid(uint) @nogc nothrow;
    int seteuid(uint) @nogc nothrow;
    int setreuid(uint, uint) @nogc nothrow;
    int setuid(uint) @nogc nothrow;
    int getgroups(int, uint*) @nogc nothrow;
    uint getegid() @nogc nothrow;
    uint getgid() @nogc nothrow;
    uint geteuid() @nogc nothrow;
    uint getuid() @nogc nothrow;
    int getsid(int) @nogc nothrow;
    int setsid() @nogc nothrow;
    int setpgrp() @nogc nothrow;
    int setpgid(int, int) @nogc nothrow;
    int getpgid(int) @nogc nothrow;
    int __getpgid(int) @nogc nothrow;
    int getpgrp() @nogc nothrow;
    int getppid() @nogc nothrow;
    int getpid() @nogc nothrow;
    c_ulong confstr(int, char*, c_ulong) @nogc nothrow;
    c_long sysconf(int) @nogc nothrow;
    c_long fpathconf(int, int) @nogc nothrow;
    c_long pathconf(const(char)*, int) @nogc nothrow;
    void _exit(int) @nogc nothrow;
    int nice(int) @nogc nothrow;
    int execlp(const(char)*, const(char)*, ...) @nogc nothrow;
    int execvp(const(char)*, char**) @nogc nothrow;
    int execl(const(char)*, const(char)*, ...) @nogc nothrow;
    int execle(const(char)*, const(char)*, ...) @nogc nothrow;
    int execv(const(char)*, char**) @nogc nothrow;
    int fexecve(int, char**, char**) @nogc nothrow;
    int execve(const(char)*, char**, char**) @nogc nothrow;
    extern __gshared char** __environ;
    int dup2(int, int) @nogc nothrow;
    int dup(int) @nogc nothrow;
    char* getwd(char*) @nogc nothrow;
    char* getcwd(char*, c_ulong) @nogc nothrow;
    int fchdir(int) @nogc nothrow;
    int chdir(const(char)*) @nogc nothrow;
    int fchownat(int, const(char)*, uint, uint, int) @nogc nothrow;
    int lchown(const(char)*, uint, uint) @nogc nothrow;
    int fchown(int, uint, uint) @nogc nothrow;
    int chown(const(char)*, uint, uint) @nogc nothrow;
    int pause() @nogc nothrow;
    int usleep(uint) @nogc nothrow;
    uint ualarm(uint, uint) @nogc nothrow;
    static ushort __bswap_16(ushort) @nogc nothrow;
    static uint __bswap_32(uint) @nogc nothrow;
    static c_ulong __bswap_64(c_ulong) @nogc nothrow;
    enum _Anonymous_31
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
    enum _PC_LINK_MAX = _Anonymous_31._PC_LINK_MAX;
    enum _PC_MAX_CANON = _Anonymous_31._PC_MAX_CANON;
    enum _PC_MAX_INPUT = _Anonymous_31._PC_MAX_INPUT;
    enum _PC_NAME_MAX = _Anonymous_31._PC_NAME_MAX;
    enum _PC_PATH_MAX = _Anonymous_31._PC_PATH_MAX;
    enum _PC_PIPE_BUF = _Anonymous_31._PC_PIPE_BUF;
    enum _PC_CHOWN_RESTRICTED = _Anonymous_31._PC_CHOWN_RESTRICTED;
    enum _PC_NO_TRUNC = _Anonymous_31._PC_NO_TRUNC;
    enum _PC_VDISABLE = _Anonymous_31._PC_VDISABLE;
    enum _PC_SYNC_IO = _Anonymous_31._PC_SYNC_IO;
    enum _PC_ASYNC_IO = _Anonymous_31._PC_ASYNC_IO;
    enum _PC_PRIO_IO = _Anonymous_31._PC_PRIO_IO;
    enum _PC_SOCK_MAXBUF = _Anonymous_31._PC_SOCK_MAXBUF;
    enum _PC_FILESIZEBITS = _Anonymous_31._PC_FILESIZEBITS;
    enum _PC_REC_INCR_XFER_SIZE = _Anonymous_31._PC_REC_INCR_XFER_SIZE;
    enum _PC_REC_MAX_XFER_SIZE = _Anonymous_31._PC_REC_MAX_XFER_SIZE;
    enum _PC_REC_MIN_XFER_SIZE = _Anonymous_31._PC_REC_MIN_XFER_SIZE;
    enum _PC_REC_XFER_ALIGN = _Anonymous_31._PC_REC_XFER_ALIGN;
    enum _PC_ALLOC_SIZE_MIN = _Anonymous_31._PC_ALLOC_SIZE_MIN;
    enum _PC_SYMLINK_MAX = _Anonymous_31._PC_SYMLINK_MAX;
    enum _PC_2_SYMLINKS = _Anonymous_31._PC_2_SYMLINKS;
    uint sleep(uint) @nogc nothrow;
    uint alarm(uint) @nogc nothrow;
    int pipe(int*) @nogc nothrow;
    c_long pwrite(int, const(void)*, c_ulong, c_long) @nogc nothrow;
    c_long pread(int, void*, c_ulong, c_long) @nogc nothrow;
    c_long write(int, const(void)*, c_ulong) @nogc nothrow;
    c_long read(int, void*, c_ulong) @nogc nothrow;
    int close(int) @nogc nothrow;
    c_long lseek(int, c_long, int) @nogc nothrow;
    enum _Anonymous_32
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
    }
    enum _SC_ARG_MAX = _Anonymous_32._SC_ARG_MAX;
    enum _SC_CHILD_MAX = _Anonymous_32._SC_CHILD_MAX;
    enum _SC_CLK_TCK = _Anonymous_32._SC_CLK_TCK;
    enum _SC_NGROUPS_MAX = _Anonymous_32._SC_NGROUPS_MAX;
    enum _SC_OPEN_MAX = _Anonymous_32._SC_OPEN_MAX;
    enum _SC_STREAM_MAX = _Anonymous_32._SC_STREAM_MAX;
    enum _SC_TZNAME_MAX = _Anonymous_32._SC_TZNAME_MAX;
    enum _SC_JOB_CONTROL = _Anonymous_32._SC_JOB_CONTROL;
    enum _SC_SAVED_IDS = _Anonymous_32._SC_SAVED_IDS;
    enum _SC_REALTIME_SIGNALS = _Anonymous_32._SC_REALTIME_SIGNALS;
    enum _SC_PRIORITY_SCHEDULING = _Anonymous_32._SC_PRIORITY_SCHEDULING;
    enum _SC_TIMERS = _Anonymous_32._SC_TIMERS;
    enum _SC_ASYNCHRONOUS_IO = _Anonymous_32._SC_ASYNCHRONOUS_IO;
    enum _SC_PRIORITIZED_IO = _Anonymous_32._SC_PRIORITIZED_IO;
    enum _SC_SYNCHRONIZED_IO = _Anonymous_32._SC_SYNCHRONIZED_IO;
    enum _SC_FSYNC = _Anonymous_32._SC_FSYNC;
    enum _SC_MAPPED_FILES = _Anonymous_32._SC_MAPPED_FILES;
    enum _SC_MEMLOCK = _Anonymous_32._SC_MEMLOCK;
    enum _SC_MEMLOCK_RANGE = _Anonymous_32._SC_MEMLOCK_RANGE;
    enum _SC_MEMORY_PROTECTION = _Anonymous_32._SC_MEMORY_PROTECTION;
    enum _SC_MESSAGE_PASSING = _Anonymous_32._SC_MESSAGE_PASSING;
    enum _SC_SEMAPHORES = _Anonymous_32._SC_SEMAPHORES;
    enum _SC_SHARED_MEMORY_OBJECTS = _Anonymous_32._SC_SHARED_MEMORY_OBJECTS;
    enum _SC_AIO_LISTIO_MAX = _Anonymous_32._SC_AIO_LISTIO_MAX;
    enum _SC_AIO_MAX = _Anonymous_32._SC_AIO_MAX;
    enum _SC_AIO_PRIO_DELTA_MAX = _Anonymous_32._SC_AIO_PRIO_DELTA_MAX;
    enum _SC_DELAYTIMER_MAX = _Anonymous_32._SC_DELAYTIMER_MAX;
    enum _SC_MQ_OPEN_MAX = _Anonymous_32._SC_MQ_OPEN_MAX;
    enum _SC_MQ_PRIO_MAX = _Anonymous_32._SC_MQ_PRIO_MAX;
    enum _SC_VERSION = _Anonymous_32._SC_VERSION;
    enum _SC_PAGESIZE = _Anonymous_32._SC_PAGESIZE;
    enum _SC_RTSIG_MAX = _Anonymous_32._SC_RTSIG_MAX;
    enum _SC_SEM_NSEMS_MAX = _Anonymous_32._SC_SEM_NSEMS_MAX;
    enum _SC_SEM_VALUE_MAX = _Anonymous_32._SC_SEM_VALUE_MAX;
    enum _SC_SIGQUEUE_MAX = _Anonymous_32._SC_SIGQUEUE_MAX;
    enum _SC_TIMER_MAX = _Anonymous_32._SC_TIMER_MAX;
    enum _SC_BC_BASE_MAX = _Anonymous_32._SC_BC_BASE_MAX;
    enum _SC_BC_DIM_MAX = _Anonymous_32._SC_BC_DIM_MAX;
    enum _SC_BC_SCALE_MAX = _Anonymous_32._SC_BC_SCALE_MAX;
    enum _SC_BC_STRING_MAX = _Anonymous_32._SC_BC_STRING_MAX;
    enum _SC_COLL_WEIGHTS_MAX = _Anonymous_32._SC_COLL_WEIGHTS_MAX;
    enum _SC_EQUIV_CLASS_MAX = _Anonymous_32._SC_EQUIV_CLASS_MAX;
    enum _SC_EXPR_NEST_MAX = _Anonymous_32._SC_EXPR_NEST_MAX;
    enum _SC_LINE_MAX = _Anonymous_32._SC_LINE_MAX;
    enum _SC_RE_DUP_MAX = _Anonymous_32._SC_RE_DUP_MAX;
    enum _SC_CHARCLASS_NAME_MAX = _Anonymous_32._SC_CHARCLASS_NAME_MAX;
    enum _SC_2_VERSION = _Anonymous_32._SC_2_VERSION;
    enum _SC_2_C_BIND = _Anonymous_32._SC_2_C_BIND;
    enum _SC_2_C_DEV = _Anonymous_32._SC_2_C_DEV;
    enum _SC_2_FORT_DEV = _Anonymous_32._SC_2_FORT_DEV;
    enum _SC_2_FORT_RUN = _Anonymous_32._SC_2_FORT_RUN;
    enum _SC_2_SW_DEV = _Anonymous_32._SC_2_SW_DEV;
    enum _SC_2_LOCALEDEF = _Anonymous_32._SC_2_LOCALEDEF;
    enum _SC_PII = _Anonymous_32._SC_PII;
    enum _SC_PII_XTI = _Anonymous_32._SC_PII_XTI;
    enum _SC_PII_SOCKET = _Anonymous_32._SC_PII_SOCKET;
    enum _SC_PII_INTERNET = _Anonymous_32._SC_PII_INTERNET;
    enum _SC_PII_OSI = _Anonymous_32._SC_PII_OSI;
    enum _SC_POLL = _Anonymous_32._SC_POLL;
    enum _SC_SELECT = _Anonymous_32._SC_SELECT;
    enum _SC_UIO_MAXIOV = _Anonymous_32._SC_UIO_MAXIOV;
    enum _SC_IOV_MAX = _Anonymous_32._SC_IOV_MAX;
    enum _SC_PII_INTERNET_STREAM = _Anonymous_32._SC_PII_INTERNET_STREAM;
    enum _SC_PII_INTERNET_DGRAM = _Anonymous_32._SC_PII_INTERNET_DGRAM;
    enum _SC_PII_OSI_COTS = _Anonymous_32._SC_PII_OSI_COTS;
    enum _SC_PII_OSI_CLTS = _Anonymous_32._SC_PII_OSI_CLTS;
    enum _SC_PII_OSI_M = _Anonymous_32._SC_PII_OSI_M;
    enum _SC_T_IOV_MAX = _Anonymous_32._SC_T_IOV_MAX;
    enum _SC_THREADS = _Anonymous_32._SC_THREADS;
    enum _SC_THREAD_SAFE_FUNCTIONS = _Anonymous_32._SC_THREAD_SAFE_FUNCTIONS;
    enum _SC_GETGR_R_SIZE_MAX = _Anonymous_32._SC_GETGR_R_SIZE_MAX;
    enum _SC_GETPW_R_SIZE_MAX = _Anonymous_32._SC_GETPW_R_SIZE_MAX;
    enum _SC_LOGIN_NAME_MAX = _Anonymous_32._SC_LOGIN_NAME_MAX;
    enum _SC_TTY_NAME_MAX = _Anonymous_32._SC_TTY_NAME_MAX;
    enum _SC_THREAD_DESTRUCTOR_ITERATIONS = _Anonymous_32._SC_THREAD_DESTRUCTOR_ITERATIONS;
    enum _SC_THREAD_KEYS_MAX = _Anonymous_32._SC_THREAD_KEYS_MAX;
    enum _SC_THREAD_STACK_MIN = _Anonymous_32._SC_THREAD_STACK_MIN;
    enum _SC_THREAD_THREADS_MAX = _Anonymous_32._SC_THREAD_THREADS_MAX;
    enum _SC_THREAD_ATTR_STACKADDR = _Anonymous_32._SC_THREAD_ATTR_STACKADDR;
    enum _SC_THREAD_ATTR_STACKSIZE = _Anonymous_32._SC_THREAD_ATTR_STACKSIZE;
    enum _SC_THREAD_PRIORITY_SCHEDULING = _Anonymous_32._SC_THREAD_PRIORITY_SCHEDULING;
    enum _SC_THREAD_PRIO_INHERIT = _Anonymous_32._SC_THREAD_PRIO_INHERIT;
    enum _SC_THREAD_PRIO_PROTECT = _Anonymous_32._SC_THREAD_PRIO_PROTECT;
    enum _SC_THREAD_PROCESS_SHARED = _Anonymous_32._SC_THREAD_PROCESS_SHARED;
    enum _SC_NPROCESSORS_CONF = _Anonymous_32._SC_NPROCESSORS_CONF;
    enum _SC_NPROCESSORS_ONLN = _Anonymous_32._SC_NPROCESSORS_ONLN;
    enum _SC_PHYS_PAGES = _Anonymous_32._SC_PHYS_PAGES;
    enum _SC_AVPHYS_PAGES = _Anonymous_32._SC_AVPHYS_PAGES;
    enum _SC_ATEXIT_MAX = _Anonymous_32._SC_ATEXIT_MAX;
    enum _SC_PASS_MAX = _Anonymous_32._SC_PASS_MAX;
    enum _SC_XOPEN_VERSION = _Anonymous_32._SC_XOPEN_VERSION;
    enum _SC_XOPEN_XCU_VERSION = _Anonymous_32._SC_XOPEN_XCU_VERSION;
    enum _SC_XOPEN_UNIX = _Anonymous_32._SC_XOPEN_UNIX;
    enum _SC_XOPEN_CRYPT = _Anonymous_32._SC_XOPEN_CRYPT;
    enum _SC_XOPEN_ENH_I18N = _Anonymous_32._SC_XOPEN_ENH_I18N;
    enum _SC_XOPEN_SHM = _Anonymous_32._SC_XOPEN_SHM;
    enum _SC_2_CHAR_TERM = _Anonymous_32._SC_2_CHAR_TERM;
    enum _SC_2_C_VERSION = _Anonymous_32._SC_2_C_VERSION;
    enum _SC_2_UPE = _Anonymous_32._SC_2_UPE;
    enum _SC_XOPEN_XPG2 = _Anonymous_32._SC_XOPEN_XPG2;
    enum _SC_XOPEN_XPG3 = _Anonymous_32._SC_XOPEN_XPG3;
    enum _SC_XOPEN_XPG4 = _Anonymous_32._SC_XOPEN_XPG4;
    enum _SC_CHAR_BIT = _Anonymous_32._SC_CHAR_BIT;
    enum _SC_CHAR_MAX = _Anonymous_32._SC_CHAR_MAX;
    enum _SC_CHAR_MIN = _Anonymous_32._SC_CHAR_MIN;
    enum _SC_INT_MAX = _Anonymous_32._SC_INT_MAX;
    enum _SC_INT_MIN = _Anonymous_32._SC_INT_MIN;
    enum _SC_LONG_BIT = _Anonymous_32._SC_LONG_BIT;
    enum _SC_WORD_BIT = _Anonymous_32._SC_WORD_BIT;
    enum _SC_MB_LEN_MAX = _Anonymous_32._SC_MB_LEN_MAX;
    enum _SC_NZERO = _Anonymous_32._SC_NZERO;
    enum _SC_SSIZE_MAX = _Anonymous_32._SC_SSIZE_MAX;
    enum _SC_SCHAR_MAX = _Anonymous_32._SC_SCHAR_MAX;
    enum _SC_SCHAR_MIN = _Anonymous_32._SC_SCHAR_MIN;
    enum _SC_SHRT_MAX = _Anonymous_32._SC_SHRT_MAX;
    enum _SC_SHRT_MIN = _Anonymous_32._SC_SHRT_MIN;
    enum _SC_UCHAR_MAX = _Anonymous_32._SC_UCHAR_MAX;
    enum _SC_UINT_MAX = _Anonymous_32._SC_UINT_MAX;
    enum _SC_ULONG_MAX = _Anonymous_32._SC_ULONG_MAX;
    enum _SC_USHRT_MAX = _Anonymous_32._SC_USHRT_MAX;
    enum _SC_NL_ARGMAX = _Anonymous_32._SC_NL_ARGMAX;
    enum _SC_NL_LANGMAX = _Anonymous_32._SC_NL_LANGMAX;
    enum _SC_NL_MSGMAX = _Anonymous_32._SC_NL_MSGMAX;
    enum _SC_NL_NMAX = _Anonymous_32._SC_NL_NMAX;
    enum _SC_NL_SETMAX = _Anonymous_32._SC_NL_SETMAX;
    enum _SC_NL_TEXTMAX = _Anonymous_32._SC_NL_TEXTMAX;
    enum _SC_XBS5_ILP32_OFF32 = _Anonymous_32._SC_XBS5_ILP32_OFF32;
    enum _SC_XBS5_ILP32_OFFBIG = _Anonymous_32._SC_XBS5_ILP32_OFFBIG;
    enum _SC_XBS5_LP64_OFF64 = _Anonymous_32._SC_XBS5_LP64_OFF64;
    enum _SC_XBS5_LPBIG_OFFBIG = _Anonymous_32._SC_XBS5_LPBIG_OFFBIG;
    enum _SC_XOPEN_LEGACY = _Anonymous_32._SC_XOPEN_LEGACY;
    enum _SC_XOPEN_REALTIME = _Anonymous_32._SC_XOPEN_REALTIME;
    enum _SC_XOPEN_REALTIME_THREADS = _Anonymous_32._SC_XOPEN_REALTIME_THREADS;
    enum _SC_ADVISORY_INFO = _Anonymous_32._SC_ADVISORY_INFO;
    enum _SC_BARRIERS = _Anonymous_32._SC_BARRIERS;
    enum _SC_BASE = _Anonymous_32._SC_BASE;
    enum _SC_C_LANG_SUPPORT = _Anonymous_32._SC_C_LANG_SUPPORT;
    enum _SC_C_LANG_SUPPORT_R = _Anonymous_32._SC_C_LANG_SUPPORT_R;
    enum _SC_CLOCK_SELECTION = _Anonymous_32._SC_CLOCK_SELECTION;
    enum _SC_CPUTIME = _Anonymous_32._SC_CPUTIME;
    enum _SC_THREAD_CPUTIME = _Anonymous_32._SC_THREAD_CPUTIME;
    enum _SC_DEVICE_IO = _Anonymous_32._SC_DEVICE_IO;
    enum _SC_DEVICE_SPECIFIC = _Anonymous_32._SC_DEVICE_SPECIFIC;
    enum _SC_DEVICE_SPECIFIC_R = _Anonymous_32._SC_DEVICE_SPECIFIC_R;
    enum _SC_FD_MGMT = _Anonymous_32._SC_FD_MGMT;
    enum _SC_FIFO = _Anonymous_32._SC_FIFO;
    enum _SC_PIPE = _Anonymous_32._SC_PIPE;
    enum _SC_FILE_ATTRIBUTES = _Anonymous_32._SC_FILE_ATTRIBUTES;
    enum _SC_FILE_LOCKING = _Anonymous_32._SC_FILE_LOCKING;
    enum _SC_FILE_SYSTEM = _Anonymous_32._SC_FILE_SYSTEM;
    enum _SC_MONOTONIC_CLOCK = _Anonymous_32._SC_MONOTONIC_CLOCK;
    enum _SC_MULTI_PROCESS = _Anonymous_32._SC_MULTI_PROCESS;
    enum _SC_SINGLE_PROCESS = _Anonymous_32._SC_SINGLE_PROCESS;
    enum _SC_NETWORKING = _Anonymous_32._SC_NETWORKING;
    enum _SC_READER_WRITER_LOCKS = _Anonymous_32._SC_READER_WRITER_LOCKS;
    enum _SC_SPIN_LOCKS = _Anonymous_32._SC_SPIN_LOCKS;
    enum _SC_REGEXP = _Anonymous_32._SC_REGEXP;
    enum _SC_REGEX_VERSION = _Anonymous_32._SC_REGEX_VERSION;
    enum _SC_SHELL = _Anonymous_32._SC_SHELL;
    enum _SC_SIGNALS = _Anonymous_32._SC_SIGNALS;
    enum _SC_SPAWN = _Anonymous_32._SC_SPAWN;
    enum _SC_SPORADIC_SERVER = _Anonymous_32._SC_SPORADIC_SERVER;
    enum _SC_THREAD_SPORADIC_SERVER = _Anonymous_32._SC_THREAD_SPORADIC_SERVER;
    enum _SC_SYSTEM_DATABASE = _Anonymous_32._SC_SYSTEM_DATABASE;
    enum _SC_SYSTEM_DATABASE_R = _Anonymous_32._SC_SYSTEM_DATABASE_R;
    enum _SC_TIMEOUTS = _Anonymous_32._SC_TIMEOUTS;
    enum _SC_TYPED_MEMORY_OBJECTS = _Anonymous_32._SC_TYPED_MEMORY_OBJECTS;
    enum _SC_USER_GROUPS = _Anonymous_32._SC_USER_GROUPS;
    enum _SC_USER_GROUPS_R = _Anonymous_32._SC_USER_GROUPS_R;
    enum _SC_2_PBS = _Anonymous_32._SC_2_PBS;
    enum _SC_2_PBS_ACCOUNTING = _Anonymous_32._SC_2_PBS_ACCOUNTING;
    enum _SC_2_PBS_LOCATE = _Anonymous_32._SC_2_PBS_LOCATE;
    enum _SC_2_PBS_MESSAGE = _Anonymous_32._SC_2_PBS_MESSAGE;
    enum _SC_2_PBS_TRACK = _Anonymous_32._SC_2_PBS_TRACK;
    enum _SC_SYMLOOP_MAX = _Anonymous_32._SC_SYMLOOP_MAX;
    enum _SC_STREAMS = _Anonymous_32._SC_STREAMS;
    enum _SC_2_PBS_CHECKPOINT = _Anonymous_32._SC_2_PBS_CHECKPOINT;
    enum _SC_V6_ILP32_OFF32 = _Anonymous_32._SC_V6_ILP32_OFF32;
    enum _SC_V6_ILP32_OFFBIG = _Anonymous_32._SC_V6_ILP32_OFFBIG;
    enum _SC_V6_LP64_OFF64 = _Anonymous_32._SC_V6_LP64_OFF64;
    enum _SC_V6_LPBIG_OFFBIG = _Anonymous_32._SC_V6_LPBIG_OFFBIG;
    enum _SC_HOST_NAME_MAX = _Anonymous_32._SC_HOST_NAME_MAX;
    enum _SC_TRACE = _Anonymous_32._SC_TRACE;
    enum _SC_TRACE_EVENT_FILTER = _Anonymous_32._SC_TRACE_EVENT_FILTER;
    enum _SC_TRACE_INHERIT = _Anonymous_32._SC_TRACE_INHERIT;
    enum _SC_TRACE_LOG = _Anonymous_32._SC_TRACE_LOG;
    enum _SC_LEVEL1_ICACHE_SIZE = _Anonymous_32._SC_LEVEL1_ICACHE_SIZE;
    enum _SC_LEVEL1_ICACHE_ASSOC = _Anonymous_32._SC_LEVEL1_ICACHE_ASSOC;
    enum _SC_LEVEL1_ICACHE_LINESIZE = _Anonymous_32._SC_LEVEL1_ICACHE_LINESIZE;
    enum _SC_LEVEL1_DCACHE_SIZE = _Anonymous_32._SC_LEVEL1_DCACHE_SIZE;
    enum _SC_LEVEL1_DCACHE_ASSOC = _Anonymous_32._SC_LEVEL1_DCACHE_ASSOC;
    enum _SC_LEVEL1_DCACHE_LINESIZE = _Anonymous_32._SC_LEVEL1_DCACHE_LINESIZE;
    enum _SC_LEVEL2_CACHE_SIZE = _Anonymous_32._SC_LEVEL2_CACHE_SIZE;
    enum _SC_LEVEL2_CACHE_ASSOC = _Anonymous_32._SC_LEVEL2_CACHE_ASSOC;
    enum _SC_LEVEL2_CACHE_LINESIZE = _Anonymous_32._SC_LEVEL2_CACHE_LINESIZE;
    enum _SC_LEVEL3_CACHE_SIZE = _Anonymous_32._SC_LEVEL3_CACHE_SIZE;
    enum _SC_LEVEL3_CACHE_ASSOC = _Anonymous_32._SC_LEVEL3_CACHE_ASSOC;
    enum _SC_LEVEL3_CACHE_LINESIZE = _Anonymous_32._SC_LEVEL3_CACHE_LINESIZE;
    enum _SC_LEVEL4_CACHE_SIZE = _Anonymous_32._SC_LEVEL4_CACHE_SIZE;
    enum _SC_LEVEL4_CACHE_ASSOC = _Anonymous_32._SC_LEVEL4_CACHE_ASSOC;
    enum _SC_LEVEL4_CACHE_LINESIZE = _Anonymous_32._SC_LEVEL4_CACHE_LINESIZE;
    enum _SC_IPV6 = _Anonymous_32._SC_IPV6;
    enum _SC_RAW_SOCKETS = _Anonymous_32._SC_RAW_SOCKETS;
    enum _SC_V7_ILP32_OFF32 = _Anonymous_32._SC_V7_ILP32_OFF32;
    enum _SC_V7_ILP32_OFFBIG = _Anonymous_32._SC_V7_ILP32_OFFBIG;
    enum _SC_V7_LP64_OFF64 = _Anonymous_32._SC_V7_LP64_OFF64;
    enum _SC_V7_LPBIG_OFFBIG = _Anonymous_32._SC_V7_LPBIG_OFFBIG;
    enum _SC_SS_REPL_MAX = _Anonymous_32._SC_SS_REPL_MAX;
    enum _SC_TRACE_EVENT_NAME_MAX = _Anonymous_32._SC_TRACE_EVENT_NAME_MAX;
    enum _SC_TRACE_NAME_MAX = _Anonymous_32._SC_TRACE_NAME_MAX;
    enum _SC_TRACE_SYS_MAX = _Anonymous_32._SC_TRACE_SYS_MAX;
    enum _SC_TRACE_USER_EVENT_MAX = _Anonymous_32._SC_TRACE_USER_EVENT_MAX;
    enum _SC_XOPEN_STREAMS = _Anonymous_32._SC_XOPEN_STREAMS;
    enum _SC_THREAD_ROBUST_PRIO_INHERIT = _Anonymous_32._SC_THREAD_ROBUST_PRIO_INHERIT;
    enum _SC_THREAD_ROBUST_PRIO_PROTECT = _Anonymous_32._SC_THREAD_ROBUST_PRIO_PROTECT;
    int faccessat(int, const(char)*, int, int) @nogc nothrow;
    int access(const(char)*, int) @nogc nothrow;
    alias socklen_t = uint;
    alias useconds_t = uint;
    int timespec_get(timespec*, int) @nogc nothrow;
    int timer_getoverrun(void*) @nogc nothrow;
    int timer_gettime(void*, itimerspec*) @nogc nothrow;
    int timer_settime(void*, int, const(itimerspec)*, itimerspec*) @nogc nothrow;
    int timer_delete(void*) @nogc nothrow;
    int timer_create(int, sigevent*, void**) @nogc nothrow;
    int clock_getcpuclockid(int, int*) @nogc nothrow;
    int clock_nanosleep(int, int, const(timespec)*, timespec*) @nogc nothrow;
    int clock_settime(int, const(timespec)*) @nogc nothrow;
    int clock_gettime(int, timespec*) @nogc nothrow;
    int clock_getres(int, timespec*) @nogc nothrow;
    int nanosleep(const(timespec)*, timespec*) @nogc nothrow;
    int dysize(int) @nogc nothrow;
    c_long timelocal(tm*) @nogc nothrow;
    c_long timegm(tm*) @nogc nothrow;
    int stime(const(c_long)*) @nogc nothrow;
    extern __gshared c_long timezone;
    extern __gshared int daylight;
    void tzset() @nogc nothrow;
    extern __gshared char*[2] tzname;
    extern __gshared c_long __timezone;
    extern __gshared int __daylight;
    extern __gshared char*[2] __tzname;
    char* ctime_r(const(c_long)*, char*) @nogc nothrow;
    char* asctime_r(const(tm)*, char*) @nogc nothrow;
    char* ctime(const(c_long)*) @nogc nothrow;
    char* asctime(const(tm)*) @nogc nothrow;
    tm* localtime_r(const(c_long)*, tm*) @nogc nothrow;
    tm* gmtime_r(const(c_long)*, tm*) @nogc nothrow;
    tm* localtime(const(c_long)*) @nogc nothrow;
    tm* gmtime(const(c_long)*) @nogc nothrow;
    c_ulong strftime_l(char*, c_ulong, const(char)*, const(tm)*, __locale_struct*) @nogc nothrow;
    c_ulong strftime(char*, c_ulong, const(char)*, const(tm)*) @nogc nothrow;
    c_long mktime(tm*) @nogc nothrow;
    double difftime(c_long, c_long) @nogc nothrow;
    c_long time(c_long*) @nogc nothrow;
    c_long clock() @nogc nothrow;
    struct sigevent;
    alias fsfilcnt_t = c_ulong;
    alias fsblkcnt_t = c_ulong;
    alias blkcnt_t = c_long;
    alias blksize_t = c_long;
    alias register_t = c_long;
    alias u_int64_t = c_ulong;
    alias u_int32_t = uint;
    alias u_int16_t = ushort;
    alias u_int8_t = ubyte;
    alias key_t = int;
    alias caddr_t = char*;
    alias daddr_t = int;
    alias id_t = uint;
    alias pid_t = int;
    alias uid_t = uint;
    alias nlink_t = c_ulong;
    alias mode_t = uint;
    alias gid_t = uint;
    alias dev_t = c_ulong;
    alias ino_t = c_ulong;
    alias loff_t = c_long;
    alias fsid_t = __fsid_t;
    alias u_quad_t = c_ulong;
    alias quad_t = c_long;
    alias u_long = c_ulong;
    alias u_int = uint;
    alias u_short = ushort;
    alias u_char = ubyte;
    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;
    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;
    alias fd_mask = c_long;
    struct fd_set
    {
        c_long[16] __fds_bits;
    }
    alias __fd_mask = c_long;
    alias suseconds_t = c_long;
    enum _Anonymous_33
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
    enum _CS_PATH = _Anonymous_33._CS_PATH;
    enum _CS_V6_WIDTH_RESTRICTED_ENVS = _Anonymous_33._CS_V6_WIDTH_RESTRICTED_ENVS;
    enum _CS_GNU_LIBC_VERSION = _Anonymous_33._CS_GNU_LIBC_VERSION;
    enum _CS_GNU_LIBPTHREAD_VERSION = _Anonymous_33._CS_GNU_LIBPTHREAD_VERSION;
    enum _CS_V5_WIDTH_RESTRICTED_ENVS = _Anonymous_33._CS_V5_WIDTH_RESTRICTED_ENVS;
    enum _CS_V7_WIDTH_RESTRICTED_ENVS = _Anonymous_33._CS_V7_WIDTH_RESTRICTED_ENVS;
    enum _CS_LFS_CFLAGS = _Anonymous_33._CS_LFS_CFLAGS;
    enum _CS_LFS_LDFLAGS = _Anonymous_33._CS_LFS_LDFLAGS;
    enum _CS_LFS_LIBS = _Anonymous_33._CS_LFS_LIBS;
    enum _CS_LFS_LINTFLAGS = _Anonymous_33._CS_LFS_LINTFLAGS;
    enum _CS_LFS64_CFLAGS = _Anonymous_33._CS_LFS64_CFLAGS;
    enum _CS_LFS64_LDFLAGS = _Anonymous_33._CS_LFS64_LDFLAGS;
    enum _CS_LFS64_LIBS = _Anonymous_33._CS_LFS64_LIBS;
    enum _CS_LFS64_LINTFLAGS = _Anonymous_33._CS_LFS64_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFF32_CFLAGS = _Anonymous_33._CS_XBS5_ILP32_OFF32_CFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LDFLAGS = _Anonymous_33._CS_XBS5_ILP32_OFF32_LDFLAGS;
    enum _CS_XBS5_ILP32_OFF32_LIBS = _Anonymous_33._CS_XBS5_ILP32_OFF32_LIBS;
    enum _CS_XBS5_ILP32_OFF32_LINTFLAGS = _Anonymous_33._CS_XBS5_ILP32_OFF32_LINTFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_CFLAGS = _Anonymous_33._CS_XBS5_ILP32_OFFBIG_CFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LDFLAGS = _Anonymous_33._CS_XBS5_ILP32_OFFBIG_LDFLAGS;
    enum _CS_XBS5_ILP32_OFFBIG_LIBS = _Anonymous_33._CS_XBS5_ILP32_OFFBIG_LIBS;
    enum _CS_XBS5_ILP32_OFFBIG_LINTFLAGS = _Anonymous_33._CS_XBS5_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_XBS5_LP64_OFF64_CFLAGS = _Anonymous_33._CS_XBS5_LP64_OFF64_CFLAGS;
    enum _CS_XBS5_LP64_OFF64_LDFLAGS = _Anonymous_33._CS_XBS5_LP64_OFF64_LDFLAGS;
    enum _CS_XBS5_LP64_OFF64_LIBS = _Anonymous_33._CS_XBS5_LP64_OFF64_LIBS;
    enum _CS_XBS5_LP64_OFF64_LINTFLAGS = _Anonymous_33._CS_XBS5_LP64_OFF64_LINTFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_CFLAGS = _Anonymous_33._CS_XBS5_LPBIG_OFFBIG_CFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _Anonymous_33._CS_XBS5_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_XBS5_LPBIG_OFFBIG_LIBS = _Anonymous_33._CS_XBS5_LPBIG_OFFBIG_LIBS;
    enum _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_33._CS_XBS5_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_CFLAGS = _Anonymous_33._CS_POSIX_V6_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _Anonymous_33._CS_POSIX_V6_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFF32_LIBS = _Anonymous_33._CS_POSIX_V6_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS = _Anonymous_33._CS_POSIX_V6_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _Anonymous_33._CS_POSIX_V6_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _Anonymous_33._CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LIBS = _Anonymous_33._CS_POSIX_V6_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS = _Anonymous_33._CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_CFLAGS = _Anonymous_33._CS_POSIX_V6_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LDFLAGS = _Anonymous_33._CS_POSIX_V6_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V6_LP64_OFF64_LIBS = _Anonymous_33._CS_POSIX_V6_LP64_OFF64_LIBS;
    enum _CS_POSIX_V6_LP64_OFF64_LINTFLAGS = _Anonymous_33._CS_POSIX_V6_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _Anonymous_33._CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _Anonymous_33._CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _Anonymous_33._CS_POSIX_V6_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_33._CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_CFLAGS = _Anonymous_33._CS_POSIX_V7_ILP32_OFF32_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LDFLAGS = _Anonymous_33._CS_POSIX_V7_ILP32_OFF32_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFF32_LIBS = _Anonymous_33._CS_POSIX_V7_ILP32_OFF32_LIBS;
    enum _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS = _Anonymous_33._CS_POSIX_V7_ILP32_OFF32_LINTFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = _Anonymous_33._CS_POSIX_V7_ILP32_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = _Anonymous_33._CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LIBS = _Anonymous_33._CS_POSIX_V7_ILP32_OFFBIG_LIBS;
    enum _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS = _Anonymous_33._CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_CFLAGS = _Anonymous_33._CS_POSIX_V7_LP64_OFF64_CFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LDFLAGS = _Anonymous_33._CS_POSIX_V7_LP64_OFF64_LDFLAGS;
    enum _CS_POSIX_V7_LP64_OFF64_LIBS = _Anonymous_33._CS_POSIX_V7_LP64_OFF64_LIBS;
    enum _CS_POSIX_V7_LP64_OFF64_LINTFLAGS = _Anonymous_33._CS_POSIX_V7_LP64_OFF64_LINTFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = _Anonymous_33._CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = _Anonymous_33._CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LIBS = _Anonymous_33._CS_POSIX_V7_LPBIG_OFFBIG_LIBS;
    enum _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS = _Anonymous_33._CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS;
    enum _CS_V6_ENV = _Anonymous_33._CS_V6_ENV;
    enum _CS_V7_ENV = _Anonymous_33._CS_V7_ENV;
    int strncasecmp_l(const(char)*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    int strcasecmp_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    int strncasecmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;
    int strcasecmp(const(char)*, const(char)*) @nogc nothrow;
    int ffsll(long) @nogc nothrow;
    int ffsl(c_long) @nogc nothrow;
    int ffs(int) @nogc nothrow;
    char* rindex(const(char)*, int) @nogc nothrow;
    char* index(const(char)*, int) @nogc nothrow;
    void bzero(void*, c_ulong) @nogc nothrow;
    void bcopy(const(void)*, void*, c_ulong) @nogc nothrow;
    int bcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;
    alias _Float32 = float;
    alias _Float64 = double;
    alias _Float32x = double;
    char* stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    alias _Float64x = real;
    char* __stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* stpcpy(char*, const(char)*) @nogc nothrow;
    char* __stpcpy(char*, const(char)*) @nogc nothrow;
    char* strsignal(int) @nogc nothrow;
    extern __gshared char* optarg;
    extern __gshared int optind;
    extern __gshared int opterr;
    extern __gshared int optopt;
    int getopt(int, char**, const(char)*) @nogc nothrow;
    char* strsep(char**, const(char)*) @nogc nothrow;
    void explicit_bzero(void*, c_ulong) @nogc nothrow;
    char* strerror_l(int, __locale_struct*) @nogc nothrow;
    int strerror_r(int, char*, c_ulong) @nogc nothrow;
    char* strerror(int) @nogc nothrow;
    c_ulong strnlen(const(char)*, c_ulong) @nogc nothrow;
    c_ulong strlen(const(char)*) @nogc nothrow;
    char* strtok_r(char*, const(char)*, char**) @nogc nothrow;
    char* __strtok_r(char*, const(char)*, char**) @nogc nothrow;
    char* strtok(char*, const(char)*) @nogc nothrow;
    char* strstr(const(char)*, const(char)*) @nogc nothrow;
    char* strpbrk(const(char)*, const(char)*) @nogc nothrow;
    c_ulong strspn(const(char)*, const(char)*) @nogc nothrow;
    c_ulong strcspn(const(char)*, const(char)*) @nogc nothrow;
    char* strrchr(const(char)*, int) @nogc nothrow;
    char* strchr(const(char)*, int) @nogc nothrow;
    char* strndup(const(char)*, c_ulong) @nogc nothrow;
    char* strdup(const(char)*) @nogc nothrow;
    c_ulong strxfrm_l(char*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    int strcoll_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    c_ulong strxfrm(char*, const(char)*, c_ulong) @nogc nothrow;
    int strcoll(const(char)*, const(char)*) @nogc nothrow;
    int strncmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;
    int strcmp(const(char)*, const(char)*) @nogc nothrow;
    char* strncat(char*, const(char)*, c_ulong) @nogc nothrow;
    char* strcat(char*, const(char)*) @nogc nothrow;
    char* strncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* strcpy(char*, const(char)*) @nogc nothrow;
    void* memchr(const(void)*, int, c_ulong) @nogc nothrow;
    int memcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;
    void* memset(void*, int, c_ulong) @nogc nothrow;
    void* memccpy(void*, const(void)*, int, c_ulong) @nogc nothrow;
    void* memmove(void*, const(void)*, c_ulong) @nogc nothrow;
    void* memcpy(void*, const(void)*, c_ulong) @nogc nothrow;
    int getloadavg(double*, int) @nogc nothrow;
    int getsubopt(char**, char**, char**) @nogc nothrow;
    int rpmatch(const(char)*) @nogc nothrow;
    c_ulong wcstombs(char*, const(int)*, c_ulong) @nogc nothrow;
    c_ulong mbstowcs(int*, const(char)*, c_ulong) @nogc nothrow;
    int wctomb(char*, int) @nogc nothrow;
    int mbtowc(int*, const(char)*, c_ulong) @nogc nothrow;
    int mblen(const(char)*, c_ulong) @nogc nothrow;
    int qfcvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
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
    int qecvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
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
    int fcvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int ecvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    alias int8_t = byte;
    alias int16_t = short;
    alias int32_t = int;
    alias int64_t = c_long;
    alias uint8_t = ubyte;
    alias uint16_t = ushort;
    alias uint32_t = uint;
    alias uint64_t = ulong;
    char* qgcvt(real, int, char*) @nogc nothrow;
    char* qfcvt(real, int, int*, int*) @nogc nothrow;
    extern __gshared int sys_nerr;
    extern __gshared const(const(char)*)[0] sys_errlist;
    alias __pthread_list_t = __pthread_internal_list;
    struct __pthread_internal_list
    {
        __pthread_internal_list* __prev;
        __pthread_internal_list* __next;
    }
    char* qecvt(real, int, int*, int*) @nogc nothrow;
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
    struct __pthread_cond_s
    {
        static union _Anonymous_34
        {
            ulong __wseq;
            static struct _Anonymous_35
            {
                uint __low;
                uint __high;
            }
            _Anonymous_35 __wseq32;
        }
        _Anonymous_34 _anonymous_36;
        auto __wseq() @property @nogc pure nothrow { return _anonymous_36.__wseq; }
        void __wseq(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_36.__wseq = val; }
        auto __wseq32() @property @nogc pure nothrow { return _anonymous_36.__wseq32; }
        void __wseq32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_36.__wseq32 = val; }
        static union _Anonymous_37
        {
            ulong __g1_start;
            static struct _Anonymous_38
            {
                uint __low;
                uint __high;
            }
            _Anonymous_38 __g1_start32;
        }
        _Anonymous_37 _anonymous_39;
        auto __g1_start() @property @nogc pure nothrow { return _anonymous_39.__g1_start; }
        void __g1_start(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_39.__g1_start = val; }
        auto __g1_start32() @property @nogc pure nothrow { return _anonymous_39.__g1_start32; }
        void __g1_start32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_39.__g1_start32 = val; }
        uint[2] __g_refs;
        uint[2] __g_size;
        uint __g1_orig_size;
        uint __wrefs;
        uint[2] __g_signals;
    }
    char* gcvt(double, int, char*) @nogc nothrow;
    char* fcvt(double, int, int*, int*) @nogc nothrow;
    char* ecvt(double, int, int*, int*) @nogc nothrow;
    lldiv_t lldiv(long, long) @nogc nothrow;
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
    ldiv_t ldiv(c_long, c_long) @nogc nothrow;
    div_t div(int, int) @nogc nothrow;
    long llabs(long) @nogc nothrow;
    c_long labs(c_long) @nogc nothrow;
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
    int abs(int) @nogc nothrow;
    alias FILE = _IO_FILE;
    void qsort(void*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    struct _IO_FILE_DUMMY
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
	version(LDC) {
		import core.stdc.stdio : _IO_FILE;
	} else version(Windows) {
		alias _IO_FILE = _IO_FILE_DUMMY;
	} else {
		alias _IO_FILE = _IO_FILE_DUMMY;
	}
    alias __FILE = _IO_FILE;
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
    void* bsearch(const(void)*, const(void)*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    struct __locale_struct
    {
        __locale_data*[13] __locales;
        const(ushort)* __ctype_b;
        const(int)* __ctype_tolower;
        const(int)* __ctype_toupper;
        const(char)*[13] __names;
    }
    alias __locale_t = __locale_struct*;
    alias __compar_fn_t = int function(const(void)*, const(void)*);
    struct __mbstate_t
    {
        int __count;
        static union _Anonymous_40
        {
            uint __wch;
            char[4] __wchb;
        }
        _Anonymous_40 __value;
    }
    struct __sigset_t
    {
        c_ulong[16] __val;
    }
    char* realpath(const(char)*, char*) @nogc nothrow;
    alias clock_t = c_long;
    alias clockid_t = int;
    alias locale_t = __locale_struct*;
    int system(const(char)*) @nogc nothrow;
    alias sigset_t = __sigset_t;
    struct _IO_marker;
    struct _IO_codecvt;
    struct _IO_wide_data;
    alias _IO_lock_t = void;
    char* mkdtemp(char*) @nogc nothrow;
    int mkstemps(char*, int) @nogc nothrow;
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
    int mkstemp(char*) @nogc nothrow;
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
    alias time_t = c_long;
    alias timer_t = void*;
    char* mktemp(char*) @nogc nothrow;
    int clearenv() @nogc nothrow;
    int unsetenv(const(char)*) @nogc nothrow;
    int setenv(const(char)*, const(char)*, int) @nogc nothrow;
    int putenv(char*) @nogc nothrow;
    char* getenv(const(char)*) @nogc nothrow;
    void _Exit(int) @nogc nothrow;
    void quick_exit(int) @nogc nothrow;
    void exit(int) @nogc nothrow;
    int on_exit(void function(int, void*), void*) @nogc nothrow;
    int at_quick_exit(void function()) @nogc nothrow;
    static ushort __uint16_identity(ushort) @nogc nothrow;
    static uint __uint32_identity(uint) @nogc nothrow;
    static c_ulong __uint64_identity(c_ulong) @nogc nothrow;
    int atexit(void function()) @nogc nothrow;
    void abort() @nogc nothrow;
    void* aligned_alloc(c_ulong, c_ulong) @nogc nothrow;
    int posix_memalign(void**, c_ulong, c_ulong) @nogc nothrow;
    void* valloc(c_ulong) @nogc nothrow;
    void free(void*) @nogc nothrow;
    void* reallocarray(void*, c_ulong, c_ulong) @nogc nothrow;
    void* realloc(void*, c_ulong) @nogc nothrow;
    void* calloc(c_ulong, c_ulong) @nogc nothrow;
    void* malloc(c_ulong) @nogc nothrow;
    int lcong48_r(ushort*, drand48_data*) @nogc nothrow;
    int seed48_r(ushort*, drand48_data*) @nogc nothrow;
    enum _Anonymous_41
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
    enum _ISupper = _Anonymous_41._ISupper;
    enum _ISlower = _Anonymous_41._ISlower;
    enum _ISalpha = _Anonymous_41._ISalpha;
    enum _ISdigit = _Anonymous_41._ISdigit;
    enum _ISxdigit = _Anonymous_41._ISxdigit;
    enum _ISspace = _Anonymous_41._ISspace;
    enum _ISprint = _Anonymous_41._ISprint;
    enum _ISgraph = _Anonymous_41._ISgraph;
    enum _ISblank = _Anonymous_41._ISblank;
    enum _IScntrl = _Anonymous_41._IScntrl;
    enum _ISpunct = _Anonymous_41._ISpunct;
    enum _ISalnum = _Anonymous_41._ISalnum;
    const(ushort)** __ctype_b_loc() @nogc nothrow;
    const(int)** __ctype_tolower_loc() @nogc nothrow;
    const(int)** __ctype_toupper_loc() @nogc nothrow;
    int srand48_r(c_long, drand48_data*) @nogc nothrow;
    int jrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    pragma(mangle, "isalnum") int isalnum_(int) @nogc nothrow;
    pragma(mangle, "isalpha") int isalpha_(int) @nogc nothrow;
    pragma(mangle, "iscntrl") int iscntrl_(int) @nogc nothrow;
    pragma(mangle, "isdigit") int isdigit_(int) @nogc nothrow;
    pragma(mangle, "islower") int islower_(int) @nogc nothrow;
    pragma(mangle, "isgraph") int isgraph_(int) @nogc nothrow;
    pragma(mangle, "isprint") int isprint_(int) @nogc nothrow;
    pragma(mangle, "ispunct") int ispunct_(int) @nogc nothrow;
    pragma(mangle, "isspace") int isspace_(int) @nogc nothrow;
    pragma(mangle, "isupper") int isupper_(int) @nogc nothrow;
    pragma(mangle, "isxdigit") int isxdigit_(int) @nogc nothrow;
    int tolower(int) @nogc nothrow;
    int toupper(int) @nogc nothrow;
    pragma(mangle, "isblank") int isblank_(int) @nogc nothrow;
    pragma(mangle, "isascii") int isascii_(int) @nogc nothrow;
    pragma(mangle, "toascii") int toascii_(int) @nogc nothrow;
    pragma(mangle, "_toupper") int _toupper_(int) @nogc nothrow;
    pragma(mangle, "_tolower") int _tolower_(int) @nogc nothrow;
    int mrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int nrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    int lrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int erand48_r(ushort*, drand48_data*, double*) @nogc nothrow;
    int drand48_r(drand48_data*, double*) @nogc nothrow;
    struct drand48_data
    {
        ushort[3] __x;
        ushort[3] __old_x;
        ushort __c;
        ushort __init;
        ulong __a;
    }
    pragma(mangle, "isalnum_l") int isalnum_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isalpha_l") int isalpha_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "iscntrl_l") int iscntrl_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isdigit_l") int isdigit_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "islower_l") int islower_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isgraph_l") int isgraph_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isprint_l") int isprint_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "ispunct_l") int ispunct_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isspace_l") int isspace_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isupper_l") int isupper_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isxdigit_l") int isxdigit_l_(int, __locale_struct*) @nogc nothrow;
    pragma(mangle, "isblank_l") int isblank_l_(int, __locale_struct*) @nogc nothrow;
    int __tolower_l(int, __locale_struct*) @nogc nothrow;
    int tolower_l(int, __locale_struct*) @nogc nothrow;
    int __toupper_l(int, __locale_struct*) @nogc nothrow;
    int toupper_l(int, __locale_struct*) @nogc nothrow;
    void lcong48(ushort*) @nogc nothrow;
    ushort* seed48(ushort*) @nogc nothrow;
    void srand48(c_long) @nogc nothrow;
    c_long jrand48(ushort*) @nogc nothrow;
    c_long mrand48() @nogc nothrow;
    c_long nrand48(ushort*) @nogc nothrow;
    c_long lrand48() @nogc nothrow;
    double erand48(ushort*) @nogc nothrow;
    double drand48() @nogc nothrow;
    int rand_r(uint*) @nogc nothrow;
    void srand(uint) @nogc nothrow;
    int rand() @nogc nothrow;
    int setstate_r(char*, random_data*) @nogc nothrow;
    int initstate_r(uint, char*, c_ulong, random_data*) @nogc nothrow;
    int srandom_r(uint, random_data*) @nogc nothrow;
    int random_r(random_data*, int*) @nogc nothrow;
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
    char* setstate(char*) @nogc nothrow;
    char* initstate(uint, char*, c_ulong) @nogc nothrow;
    void srandom(uint) @nogc nothrow;
    int* __errno_location() @nogc nothrow;
    c_long random() @nogc nothrow;
    c_long a64l(const(char)*) @nogc nothrow;
    char* l64a(c_long) @nogc nothrow;
    ulong strtoull(const(char)*, char**, int) @nogc nothrow;
    long strtoll(const(char)*, char**, int) @nogc nothrow;
    ulong strtouq(const(char)*, char**, int) @nogc nothrow;
    long strtoq(const(char)*, char**, int) @nogc nothrow;
    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;
    c_long strtol(const(char)*, char**, int) @nogc nothrow;
    real strtold(const(char)*, char**) @nogc nothrow;
    float strtof(const(char)*, char**) @nogc nothrow;
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
    double strtod(const(char)*, char**) @nogc nothrow;
    alias uintptr_t = c_ulong;
    alias intmax_t = c_long;
    alias uintmax_t = c_ulong;
    long atoll(const(char)*) @nogc nothrow;
    c_long atol(const(char)*) @nogc nothrow;
    int atoi(const(char)*) @nogc nothrow;
    double atof(const(char)*) @nogc nothrow;
    c_ulong __ctype_get_mb_cur_max() @nogc nothrow;
    struct lldiv_t
    {
        long quot;
        long rem;
    }
    struct ldiv_t
    {
        c_long quot;
        c_long rem;
    }
    struct div_t
    {
        int quot;
        int rem;
    }
    int __overflow(_IO_FILE*, int) @nogc nothrow;
    int __uflow(_IO_FILE*) @nogc nothrow;
    void funlockfile(_IO_FILE*) @nogc nothrow;
    int ftrylockfile(_IO_FILE*) @nogc nothrow;
    void flockfile(_IO_FILE*) @nogc nothrow;
    char* ctermid(char*) @nogc nothrow;
    int pclose(_IO_FILE*) @nogc nothrow;
    _IO_FILE* popen(const(char)*, const(char)*) @nogc nothrow;
    int fileno_unlocked(_IO_FILE*) @nogc nothrow;
    int fileno(_IO_FILE*) @nogc nothrow;
    alias off_t = c_long;
    alias ssize_t = c_long;
    void perror(const(char)*) @nogc nothrow;
    alias fpos_t = _G_fpos_t;
    int ferror_unlocked(_IO_FILE*) @nogc nothrow;
    int feof_unlocked(_IO_FILE*) @nogc nothrow;
    void clearerr_unlocked(_IO_FILE*) @nogc nothrow;
    extern __gshared _IO_FILE* stdin;
    extern __gshared _IO_FILE* stdout;
    extern __gshared _IO_FILE* stderr;
    int ferror(_IO_FILE*) @nogc nothrow;
    int remove(const(char)*) @nogc nothrow;
    int rename(const(char)*, const(char)*) @nogc nothrow;
    int renameat(int, const(char)*, int, const(char)*) @nogc nothrow;
    _IO_FILE* tmpfile() @nogc nothrow;
    char* tmpnam(char*) @nogc nothrow;
    char* tmpnam_r(char*) @nogc nothrow;
    char* tempnam(const(char)*, const(char)*) @nogc nothrow;
    int fclose(_IO_FILE*) @nogc nothrow;
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
    static if(!is(typeof(_STDLIB_H))) {
        enum _STDLIB_H = 1;
    }
    static if(!is(typeof(__ldiv_t_defined))) {
        enum __ldiv_t_defined = 1;
    }
    static if(!is(typeof(__lldiv_t_defined))) {
        enum __lldiv_t_defined = 1;
    }




    static if(!is(typeof(RAND_MAX))) {
        enum RAND_MAX = 2147483647;
    }




    static if(!is(typeof(EXIT_FAILURE))) {
        enum EXIT_FAILURE = 1;
    }




    static if(!is(typeof(EXIT_SUCCESS))) {
        enum EXIT_SUCCESS = 0;
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
    static if(!is(typeof(MB_LEN_MAX))) {
        enum MB_LEN_MAX = 16;
    }




    static if(!is(typeof(_LIBC_LIMITS_H_))) {
        enum _LIBC_LIMITS_H_ = 1;
    }
    static if(!is(typeof(__GLIBC_MINOR__))) {
        enum __GLIBC_MINOR__ = 29;
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




    static if(!is(typeof(_DEFAULT_SOURCE))) {
        enum _DEFAULT_SOURCE = 1;
    }
    static if(!is(typeof(_FEATURES_H))) {
        enum _FEATURES_H = 1;
    }






    static if(!is(typeof(_ERRNO_H))) {
        enum _ERRNO_H = 1;
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




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        enum __RLIM_T_MATCHES_RLIM64_T = 1;
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        enum __INO_T_MATCHES_INO64_T = 1;
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        enum __OFF_T_MATCHES_OFF64_T = 1;
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
    static if(!is(typeof(_BITS_TYPES_H))) {
        enum _BITS_TYPES_H = 1;
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






    static if(!is(typeof(_BITS_TIME_H))) {
        enum _BITS_TIME_H = 1;
    }




    static if(!is(typeof(__PTHREAD_MUTEX_HAVE_PREV))) {
        enum __PTHREAD_MUTEX_HAVE_PREV = 1;
    }
    static if(!is(typeof(_THREAD_SHARED_TYPES_H))) {
        enum _THREAD_SHARED_TYPES_H = 1;
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
    static if(!is(typeof(__FD_ZERO_STOS))) {
        enum __FD_ZERO_STOS = "stosq";
    }




    static if(!is(typeof(__have_pthread_attr_t))) {
        enum __have_pthread_attr_t = 1;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_COMMON_H))) {
        enum _BITS_PTHREADTYPES_COMMON_H = 1;
    }




    static if(!is(typeof(__PTHREAD_RWLOCK_INT_FLAGS_SHARED))) {
        enum __PTHREAD_RWLOCK_INT_FLAGS_SHARED = 1;
    }
    static if(!is(typeof(__PTHREAD_MUTEX_USE_UNION))) {
        enum __PTHREAD_MUTEX_USE_UNION = 0;
    }




    static if(!is(typeof(__PTHREAD_MUTEX_NUSERS_AFTER_KIND))) {
        enum __PTHREAD_MUTEX_NUSERS_AFTER_KIND = 0;
    }




    static if(!is(typeof(__PTHREAD_MUTEX_LOCK_ELISION))) {
        enum __PTHREAD_MUTEX_LOCK_ELISION = 1;
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




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEX_T))) {
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_ATTR_T))) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_ARCH_H))) {
        enum _BITS_PTHREADTYPES_ARCH_H = 1;
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




    static if(!is(typeof(_STRING_H))) {
        enum _STRING_H = 1;
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






    static if(!is(typeof(CHARCLASS_NAME_MAX))) {
        enum CHARCLASS_NAME_MAX = 2048;
    }
    static if(!is(typeof(COLL_WEIGHTS_MAX))) {
        enum COLL_WEIGHTS_MAX = 255;
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




    static if(!is(typeof(PTHREAD_STACK_MIN))) {
        enum PTHREAD_STACK_MIN = 16384;
    }




    static if(!is(typeof(AIO_PRIO_DELTA_MAX))) {
        enum AIO_PRIO_DELTA_MAX = 20;
    }




    static if(!is(typeof(_POSIX_THREAD_THREADS_MAX))) {
        enum _POSIX_THREAD_THREADS_MAX = 64;
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




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;
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
    static if(!is(typeof(_STRINGS_H))) {
        enum _STRINGS_H = 1;
    }
    static if(!is(typeof(__HAVE_FLOATN_NOT_TYPEDEF))) {
        enum __HAVE_FLOATN_NOT_TYPEDEF = 0;
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
    static if(!is(typeof(_SYS_CDEFS_H))) {
        enum _SYS_CDEFS_H = 1;
    }
    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        enum __glibc_c99_flexarr_available = 1;
    }
    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        enum __HAVE_GENERIC_SELECTION = 1;
    }




    static if(!is(typeof(_SYS_SELECT_H))) {
        enum _SYS_SELECT_H = 1;
    }
    static if(!is(typeof(_SYS_TYPES_H))) {
        enum _SYS_TYPES_H = 1;
    }
    static if(!is(typeof(__BIT_TYPES_DEFINED__))) {
        enum __BIT_TYPES_DEFINED__ = 1;
    }
    static if(!is(typeof(_TIME_H))) {
        enum _TIME_H = 1;
    }
    static if(!is(typeof(TIME_UTC))) {
        enum TIME_UTC = 1;
    }
    static if(!is(typeof(_UNISTD_H))) {
        enum _UNISTD_H = 1;
    }
    static if(!is(typeof(_POSIX_VERSION))) {
        enum _POSIX_VERSION = 200809L;
    }






    static if(!is(typeof(__POSIX2_THIS_VERSION))) {
        enum __POSIX2_THIS_VERSION = 200809L;
    }
    static if(!is(typeof(_XOPEN_VERSION))) {
        enum _XOPEN_VERSION = 700;
    }




    static if(!is(typeof(_XOPEN_XCU_VERSION))) {
        enum _XOPEN_XCU_VERSION = 4;
    }




    static if(!is(typeof(_XOPEN_XPG2))) {
        enum _XOPEN_XPG2 = 1;
    }




    static if(!is(typeof(_XOPEN_XPG3))) {
        enum _XOPEN_XPG3 = 1;
    }




    static if(!is(typeof(_XOPEN_XPG4))) {
        enum _XOPEN_XPG4 = 1;
    }




    static if(!is(typeof(_XOPEN_UNIX))) {
        enum _XOPEN_UNIX = 1;
    }




    static if(!is(typeof(_XOPEN_ENH_I18N))) {
        enum _XOPEN_ENH_I18N = 1;
    }




    static if(!is(typeof(_XOPEN_LEGACY))) {
        enum _XOPEN_LEGACY = 1;
    }
    static if(!is(typeof(STDIN_FILENO))) {
        enum STDIN_FILENO = 0;
    }




    static if(!is(typeof(STDOUT_FILENO))) {
        enum STDOUT_FILENO = 1;
    }




    static if(!is(typeof(STDERR_FILENO))) {
        enum STDERR_FILENO = 2;
    }
    static if(!is(typeof(R_OK))) {
        enum R_OK = 4;
    }




    static if(!is(typeof(W_OK))) {
        enum W_OK = 2;
    }




    static if(!is(typeof(X_OK))) {
        enum X_OK = 1;
    }




    static if(!is(typeof(F_OK))) {
        enum F_OK = 0;
    }
    static if(!is(typeof(_BITS_BYTESWAP_H))) {
        enum _BITS_BYTESWAP_H = 1;
    }




    static if(!is(typeof(EHWPOISON))) {
        enum EHWPOISON = 133;
    }




    static if(!is(typeof(ERFKILL))) {
        enum ERFKILL = 132;
    }




    static if(!is(typeof(ENOTRECOVERABLE))) {
        enum ENOTRECOVERABLE = 131;
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




    static if(!is(typeof(ELIBEXEC))) {
        enum ELIBEXEC = 83;
    }




    static if(!is(typeof(ELIBMAX))) {
        enum ELIBMAX = 82;
    }




    static if(!is(typeof(ELIBSCN))) {
        enum ELIBSCN = 81;
    }




    static if(!is(typeof(ELIBBAD))) {
        enum ELIBBAD = 80;
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
    static if(!is(typeof(LXW_ATTR_32))) {
        enum LXW_ATTR_32 = 32;
    }




    static if(!is(typeof(LXW_MAX_ATTRIBUTE_LENGTH))) {
        enum LXW_MAX_ATTRIBUTE_LENGTH = 256;
    }
    static if(!is(typeof(LXW_BREAKS_MAX))) {
        enum LXW_BREAKS_MAX = 1023;
    }




    static if(!is(typeof(LXW_PANE_NAME_LENGTH))) {
        enum LXW_PANE_NAME_LENGTH = 12;
    }




    static if(!is(typeof(LXW_MAX_NUMBER_URLS))) {
        enum LXW_MAX_NUMBER_URLS = 65530;
    }




    static if(!is(typeof(LXW_HEADER_FOOTER_MAX))) {
        enum LXW_HEADER_FOOTER_MAX = 255;
    }




    static if(!is(typeof(LXW_COL_META_MAX))) {
        enum LXW_COL_META_MAX = 128;
    }




    static if(!is(typeof(LXW_COL_MAX))) {
        enum LXW_COL_MAX = 16384;
    }




    static if(!is(typeof(LXW_ROW_MAX))) {
        enum LXW_ROW_MAX = 1048576;
    }
    static if(!is(typeof(LXW_DEFINED_NAME_LENGTH))) {
        enum LXW_DEFINED_NAME_LENGTH = 128;
    }
    static if(!is(typeof(DEF_MEM_LEVEL))) {
        enum DEF_MEM_LEVEL = 8;
    }
    static if(!is(typeof(Z_BZIP2ED))) {
        enum Z_BZIP2ED = 12;
    }
    static if(!is(typeof(RB_INF))) {
        enum RB_INF = 1;
    }
    static if(!is(typeof(RB_RED))) {
        enum RB_RED = 1;
    }




    static if(!is(typeof(RB_BLACK))) {
        enum RB_BLACK = 0;
    }
    static if(!is(typeof(SPLAY_INF))) {
        enum SPLAY_INF = 1;
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
    static if(!is(typeof(MAX_MEM_LEVEL))) {
        enum MAX_MEM_LEVEL = 9;
    }




    static if(!is(typeof(MAX_WBITS))) {
        enum MAX_WBITS = 15;
    }
    static if(!is(typeof(ZLIB_VERSION))) {
        enum ZLIB_VERSION = "1.2.11";
    }




    static if(!is(typeof(ZLIB_VERNUM))) {
        enum ZLIB_VERNUM = 0x12b0;
    }




    static if(!is(typeof(ZLIB_VER_MAJOR))) {
        enum ZLIB_VER_MAJOR = 1;
    }




    static if(!is(typeof(ZLIB_VER_MINOR))) {
        enum ZLIB_VER_MINOR = 2;
    }




    static if(!is(typeof(ZLIB_VER_REVISION))) {
        enum ZLIB_VER_REVISION = 11;
    }




    static if(!is(typeof(ZLIB_VER_SUBREVISION))) {
        enum ZLIB_VER_SUBREVISION = 0;
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
    static if(!is(typeof(Z_NO_COMPRESSION))) {
        enum Z_NO_COMPRESSION = 0;
    }




    static if(!is(typeof(Z_BEST_SPEED))) {
        enum Z_BEST_SPEED = 1;
    }




    static if(!is(typeof(Z_BEST_COMPRESSION))) {
        enum Z_BEST_COMPRESSION = 9;
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






    static if(!is(typeof(Z_UNKNOWN))) {
        enum Z_UNKNOWN = 2;
    }




    static if(!is(typeof(Z_DEFLATED))) {
        enum Z_DEFLATED = 8;
    }




    static if(!is(typeof(Z_NULL))) {
        enum Z_NULL = 0;
    }
    static if(!is(typeof(MAXU32))) {
        enum MAXU32 = 0xffffffff;
    }




    static if(!is(typeof(_FILE_OFFSET_BIT))) {
        enum _FILE_OFFSET_BIT = 64;
    }
    static if(!is(typeof(LXW_MAX_FONT_SIZE))) {
        enum LXW_MAX_FONT_SIZE = 409.0;
    }




    static if(!is(typeof(LXW_MIN_FONT_SIZE))) {
        enum LXW_MIN_FONT_SIZE = 1.0;
    }




    static if(!is(typeof(LXW_COLOR_MASK))) {
        enum LXW_COLOR_MASK = 0xFFFFFF;
    }
    static if(!is(typeof(LXW_DEFAULT_FONT_THEME))) {
        enum LXW_DEFAULT_FONT_THEME = 1;
    }




    static if(!is(typeof(LXW_DEFAULT_FONT_FAMILY))) {
        enum LXW_DEFAULT_FONT_FAMILY = 2;
    }




    static if(!is(typeof(LXW_DEFAULT_FONT_NAME))) {
        enum LXW_DEFAULT_FONT_NAME = "Calibri";
    }




    static if(!is(typeof(LXW_FORMAT_FIELD_LEN))) {
        enum LXW_FORMAT_FIELD_LEN = 128;
    }
    static if(!is(typeof(LXW_APP_MSEXCEL))) {
        enum LXW_APP_MSEXCEL = "application/vnd.ms-excel.";
    }




    static if(!is(typeof(LXW_APP_DOCUMENT))) {
        enum LXW_APP_DOCUMENT = "application/vnd.openxmlformats-officedocument.";
    }




    static if(!is(typeof(LXW_APP_PACKAGE))) {
        enum LXW_APP_PACKAGE = "application/vnd.openxmlformats-package.";
    }
    static if(!is(typeof(LXW_SCHEMA_ROOT))) {
        enum LXW_SCHEMA_ROOT = "http://schemas.openxmlformats.org";
    }




    static if(!is(typeof(LXW_SCHEMA_MS))) {
        enum LXW_SCHEMA_MS = "http://schemas.microsoft.com/office/2006/relationships";
    }




    static if(!is(typeof(LXW_LANDSCAPE))) {
        enum LXW_LANDSCAPE = 0;
    }




    static if(!is(typeof(LXW_PORTRAIT))) {
        enum LXW_PORTRAIT = 1;
    }




    static if(!is(typeof(LXW_IGNORE))) {
        enum LXW_IGNORE = 1;
    }




    static if(!is(typeof(LXW_FILENAME_LENGTH))) {
        enum LXW_FILENAME_LENGTH = 128;
    }






    static if(!is(typeof(LXW_EPOCH_1904))) {
        enum LXW_EPOCH_1904 = 1;
    }




    static if(!is(typeof(LXW_EPOCH_1900))) {
        enum LXW_EPOCH_1900 = 0;
    }
    static if(!is(typeof(LXW_SHEETNAME_MAX))) {
        enum LXW_SHEETNAME_MAX = 31;
    }
    static if(!is(typeof(LXW_CHART_DEFAULT_GAP))) {
        enum LXW_CHART_DEFAULT_GAP = 501;
    }




    static if(!is(typeof(LXW_CHART_NUM_FORMAT_LEN))) {
        enum LXW_CHART_NUM_FORMAT_LEN = 128;
    }
    static if(!is(typeof(__GNUC_VA_LIST))) {
        enum __GNUC_VA_LIST = 1;
    }
}


struct __va_list_tag;
