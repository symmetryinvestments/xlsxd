module libxlsxd.docproperties;

import xlsxwrap;

struct DocProperties {
	lxw_doc_properties* handle;

	this(lxw_doc_properties* handle) {
		this.handle = handle;
	}
}
