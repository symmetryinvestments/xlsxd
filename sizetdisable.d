import std.regex;
import std.file : readText;
import std.stdio : File;

void main() {
	string path = "source/libxlsxd/xlsxwrap.d";
	string t = readText(path);

	auto re = regex("    alias size_t = c_ulong;");

	string nt = replaceAll(t, re, "    //alias size_t = c_ulong; AUTO REPLACED");

	auto f = File(path, "w");
	f.write(nt);
}
