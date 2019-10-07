use v6;
#  -- DO NOT EDIT --
# generated by: etc/generator.p6 

unit module LibXML::Native::Gen::parserInternals;
# internals routines and limits exported by the parser.:
#    this module exports a number of internal parsing routines they are not really all intended for applications but can prove useful doing low level processing. 
use LibXML::Native::Defs :$lib, :xmlCharP;

our sub htmlCreateFile(Str $filename, Str $encoding --> htmlParserCtxt) is native(XML2) is symbol('htmlCreateFileParserCtxt') {*}
our sub htmlInitAutoClose() is native(XML2) is export {*}
our sub xmlCheckLanguageID(xmlCharP $lang --> int32) is native(XML2) is export {*}
our sub xmlCopyChar(int32 $len, xmlCharP $out, int32 $val --> int32) is native(XML2) is export {*}
our sub xmlCopyCharMultiByte(xmlCharP $out, int32 $val --> int32) is native(XML2) is export {*}
our sub xmlIsLetter(int32 $c --> int32) is native(XML2) is export {*}
our sub xmlSetEntityReferenceFunc(xmlEntityReferenceFunc $func) is native(XML2) is export {*}
