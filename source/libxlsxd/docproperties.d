module libxlsxd.docproperties;

import libxlsxd.xlsxwrap;

struct DocProperties {
	lxw_doc_properties* handle;

	this(lxw_doc_properties* handle) @nogc nothrow pure @safe {
		this.handle = handle;
	}
}
