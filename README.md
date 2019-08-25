[![Build Status](https://travis-ci.org/p6-xml/LibXML-p6.svg?branch=master)](https://travis-ci.org/p6-xml/LibXML-p6)

NAME
====

LibXML - Perl 6 bindings to the libxml2 native library

SYNOPSIS
========

    use LibXML;
    use LibXML::Document;
    my LibXML::Document $doc =  LibXML.parse: :string('<Hello/>');
    $doc.root.nodeValue = 'World!';
    say $doc.Str;
    # <?xml version="1.0" encoding="UTF-8"?>
    # <Hello>World!</Hello>

    my Version $library-version = LibXML.version;
    my Version $module-version = LibXML.^ver;

DESCRIPTION
===========

This module is an interface to libxml2, providing XML and HTML parsers with DOM, SAX and XMLReader interfaces, a large subset of DOM Layer 3 interface and a XML::XPath-like interface to XPath API of libxml2. The module is split into several packages which are not described in this section; unless stated otherwise, you only need to `use XML::LibXML; ` in your programs.

For further information, please check the following documentation:

DOM Objects
-----------

The nodes in the Document Object Model (DOM) are represented by the following classes (most of which "inherit" from [LibXML::Node ](LibXML::Node )):

  * [LibXML::Document](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Document.md) - LibXML DOM attribute class

  * [LibXML::DocumentFragment](https://github.com/p6-xml/LibXML-p6/blob/master/doc/DocumentFragment.md) - LibXML's DOM L2 Document Fragment implementation

  * [LibXML::Element](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Element.md) - LibXML class for DOM element nodes

  * [LibXML::Attr](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Attr.md) - LibXML DOM attribute class

  * [LibXML::Attr::Map](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Attr/Map.md) - LibXML DOM attribute map class

  * [LibXML::CDATA](https://github.com/p6-xml/LibXML-p6/blob/master/doc/CDATASection.md) - LibXML class for DOM CDATA sections

  * [LibXML::Comment](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Comment.md) - LibXML class for comment DOM nodes

  * [LibXML::Dtd](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Dtd.md) - LibXML frontend for DTD validation

  * [LibXML::Namespace](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Namespace.md) - LibXML DOM namespace nodes

  * [LibXML::Node](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Node.md) - LibXML DOM base node class

  * [LibXML::Namespace](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Namespace.md) - LibXML DOM namespaces

  * [LibXML::Text](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Text.md) - LibXML text node class

  * [LibXML::PI](https://github.com/p6-xml/LibXML-p6/blob/master/doc/PI.md) - LibXML DOM processing instruction nodes

Other
-----

  * [LibXML::Node::Set](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Node/Set.md) - LibXML schema validation class

  * [LibXML::Schema](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Schema.md) - LibXML schema validation class

  * [LibXML::RelaxNG](https://github.com/p6-xml/LibXML-p6/blob/master/doc/RelaxNG.md) - LibXML RelaxNG validation class

  * [LibXML::ErrorHandler](https://github.com/p6-xml/LibXML-p6/blob/master/doc/ErrorHandler.md) - LibXML class for Error handling

  * [LibXML::InputCallback](https://github.com/p6-xml/LibXML-p6/blob/master/doc/InputCallback.md) - LibXML class for Input callback handling

  * [LibXML::Parser](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Parser.md) - LibXML Parser bindings

  * [LibXML::Pattern](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Pattern.md) - LibXML Patterns

  * [LibXML::RegExp](https://github.com/p6-xml/LibXML-p6/blob/master/doc/RegExp.md) - LibXML Regular Expression bindings

  * [LibXML::Reader](https://github.com/p6-xml/LibXML-p6/blob/master/doc/Reader.md) - LibXML Reader (pull parser) bindings

  * [LibXML::XPath::Expression](https://github.com/p6-xml/LibXML-p6/blob/master/doc/XPath/Context.md) - XPath Compiled Expressions

  * [LibXML::XPath::Context](https://github.com/p6-xml/LibXML-p6/blob/master/doc/XPath/Context.md) - XPath Evaluation Contexts

