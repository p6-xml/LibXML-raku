#include "xml6_reader.h"

DLLEXPORT int
xml6_reader_next_sibling(xmlTextReaderPtr self) {
    int rv = xmlTextReaderNextSibling(self);
    if (rv == -1) {
        int depth = xmlTextReaderDepth(self);
	rv = xmlTextReaderRead(self);
        while (rv == 1 && xmlTextReaderDepth(self) > depth) {
	    rv = xmlTextReaderNext(self);
        }
        if (rv == 1) {
	    if (xmlTextReaderDepth(self) != depth) {
                rv = 0;
	    } else if (xmlTextReaderNodeType(self) == XML_READER_TYPE_END_ELEMENT) {
                rv = xmlTextReaderRead(self);
	    }
        }
    }
    return rv;
}