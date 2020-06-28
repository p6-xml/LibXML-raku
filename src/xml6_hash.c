#include "xml6.h"
#include <string.h>
#include <assert.h>
#include "xml6_hash.h"

static void _xml6_get_key(void* value, const xmlChar*** keys, xmlChar* key) {
    *((*keys)++) = xmlStrdup(key);
}

static void _xml6_get_value(void* value, const void*** values, xmlChar* key) {
    *((*values)++) = value;
}

static void _xml6_get_pair(void* value, const void*** pairs, xmlChar* key) {
    *((*pairs)++) = (void*) xmlStrdup(key);
    *((*pairs)++) = value;
}

static void _xml6_scan(xmlHashTablePtr self, xmlHashScanner scanner, int n, void** buf) {
    void** p;
    assert(self != NULL);
    assert(buf != NULL);
    p = buf;
    xmlHashScan(self, scanner, (void*) &p);
    assert(p == &(buf[xmlHashSize(self) * n]));
}

DLLEXPORT void xml6_hash_keys(xmlHashTablePtr self, void** buf) {
    _xml6_scan(self, (xmlHashScanner) _xml6_get_key, 1, buf);
}

DLLEXPORT void xml6_hash_values(xmlHashTablePtr self, void** buf) {
    _xml6_scan(self, (xmlHashScanner) _xml6_get_value, 1, buf);
}

DLLEXPORT void xml6_hash_key_values(xmlHashTablePtr self, void** buf) {
    _xml6_scan(self, (xmlHashScanner) _xml6_get_pair, 2, buf);
}

DLLEXPORT void xml6_hash_add_pairs(xmlHashTablePtr self, void** pairs, uint n, xmlHashDeallocator deallocator) {
    assert(self != NULL);
    assert((n % 2) == 0);

    if (n) {
        uint i = 0;
        assert(pairs != NULL);
        for (i = 0; i < n; i += 2) {
            xmlChar* key = (xmlChar*) pairs[i];
            void* value  = pairs[i+1];
            xmlHashUpdateEntry(self, key, value, deallocator);
        }
    }
}