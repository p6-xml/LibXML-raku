use LibXML::Node :iterate-list, :iterate-set;
use LibXML::_DOMNode;

unit class LibXML::Element
    is LibXML::Node
    does LibXML::_DOMNode;

use NativeCall;

use LibXML::Attr;
use LibXML::Enums;
use LibXML::Item :box-class;
use LibXML::Namespace;
use LibXML::Native;
use LibXML::Types :QName, :NCName;
use XML::Grammar;
use Method::Also;

my subset NameVal of Pair where .key ~~ QName:D && .value ~~ Str:D;

multi submethod TWEAK(xmlElem:D :native($)!) { }
multi submethod TWEAK(:doc($doc-obj), QName :$name!, LibXML::Namespace :ns($ns-obj)) {
    my xmlDoc:D $doc = .native with $doc-obj;
    my xmlNs:D $ns = .native with $ns-obj;
    self.set-native: xmlElem.new( :$name, :$doc, :$ns );
}

method native handles<
        content
        getAttribute getAttributeNS getNamespaceDeclURI
        hasAttributes hasAttribute hasAttributeNS
        removeAttribute removeAttributeNS
        > { callsame() // xmlElem }

multi method new(QName:D $name, *%o) {
    self.new(:$name, |%o);
}

multi method new(|c) is default { nextsame }

method namespaces {
    iterate-list(self, LibXML::Namespace, :$.doc);
}

method !set-attributes(@atts) {
    # clear out old attributes
    with $.native.properties -> anyNode:D $node is copy {
        while $node.defined {
            my $next = $node.next;
            $node.Release
                if $node.type == XML_ATTRIBUTE_NODE;
            $node = $next;
        }
    }
    # set new attributes
    for @atts -> $att, {
        if $att.value ~~ NameVal|Hash {
            my $uri = $att.key;
            self.setAttributeNS($uri, $_)
                for $att.value.pairs.sort;
        }
        else {
            self.setAttribute($att.key, $att.value);
        }
    }
}

# hashy attribute containers
method attributes is rw is also<attribs attr> {
    Proxy.new(
        FETCH => {
            (require ::('LibXML::Attr::Map')).new: :node(self)
        },
        STORE => sub ($, %atts) {
            self!set-attributes: %atts.pairs.sort;
        }
    );
}

method to-ast(Bool :$blank = True) is rw {
    my @content;
    @content.push(.ast) for self.namespaces;
    @content.push(.ast) for self.properties;
    @content.push: .ast(:$blank) for self.children(:$blank);
    self.tag => @content;
}

method Hash { # handles: keys, pairs, kv -- see LibXML::Node
    my %h := callsame;
    %h{.xpath-key } = $_ for self.properties;
    %h;
}
multi method AT-KEY('@*') is rw { self.attributes }
multi method AT-KEY('attributes::') is rw { self.attributes }
multi method AT-KEY(Str:D $att-path where /^['@'|'attribute::'][<pfx=.XML::Grammar::pident>':']?<name=.XML::Grammar::pident>$/) is rw {
        my $ctx := $.xpath-context;
        my Str:D $name := $<name>.Str;
        my Str $href;
        with $<pfx> {
            fail "'xmlns' prefix is reserved"
                when $_ eq 'xmlns';
            $href = $ctx.lookupNs(.Str)
                // fail "unknown namespace prefix $_";
        }
        Proxy.new(
            FETCH => { $.xpath-context.findnodes($att-path) },
            STORE => sub ($, Str() $val) {
                self.setAttributeNS($href, $name, $val);
            }
        )
}
# attributes as an ordered list
method properties {
    iterate-list(self, LibXML::Attr);
}

method appendWellBalancedChunk(Str:D $string) {
    my $frag = (require ::('LibXML::DocumentFragment')).parse: :balanced, :$string;
    self.appendChild( $frag );
}

method requireNamespace(Str:D $uri where .so --> NCName) {
    $.lookupNamespacePrefix($uri)
    // do {
        my NCName:D $prefix = self.native.genNsPrefix;
        $.setNamespace($uri, $prefix, :!activate)
            && $prefix
    }
}

constant AttrNode = LibXML::Attr;
method !set-attr(QName $name, Str:D $value) {
    ? $.native.setAttribute($name, $value);
}
multi method setAttribute(NameVal:D $_ --> Bool) {
    self!set-attr(.key, .value);
}
multi method setAttribute(QName $name, Str:D $value) {
    self!set-attr($name, $value);
}
multi method setAttribute(*%atts) {
    self!set-attr(.key, .value)
        for %atts.pairs.sort;
}
method setAttributeNode(AttrNode:D $att --> AttrNode) {
    $att.keep: $.native.setAttributeNode($att.native);
}
method setAttributeNodeNS(AttrNode:D $att --> AttrNode) {
    $att.keep: $.native.setAttributeNodeNS($att.native);
}
multi method setAttributeNS(Str $uri, NameVal:D $_ --> AttrNode) {
    $.setAttributeNS($uri, .key, .value);
}
multi method setAttributeNS(Str $uri, QName $name, Str $value --> AttrNode) {
    if $name {
        self.registerNs($name.substr(0, $_), $uri) with $name.index(':');
    }
    &?ROUTINE.returns.box: $.native.setAttributeNS($uri, $name, $value);
}
method getAttributeNode(Str $att-name --> AttrNode) is also<attribute> {
    &?ROUTINE.returns.box: $.native.getAttributeNode($att-name);
}
method getAttributeNodeNS(Str $uri, Str $att-name --> AttrNode) {
    &?ROUTINE.returns.box: $.native.getAttributeNodeNS($uri, $att-name);
}
method removeAttributeNode(AttrNode $att --> AttrNode) {
    $att.keep: $.native.removeAttributeNode($att.native), :doc(LibXML::Node);
}

=begin pod
=head1 NAME

LibXML::Element - LibXML Class for Element Nodes

=head1 SYNOPSIS

  =begin code :lang<raku>
  use LibXML::Element;
  # Only methods specific to Element nodes are listed here,
  # see the LibXML::Node documentation for other methods

  my LibXML::Element $node .= new( $name );

  # -- Attributes -- #
  $node.setAttribute( $aname, $avalue );
  $node.setAttributeNS( $nsURI, $aname, $avalue );
  $avalue = $node.getAttribute( $aname );
  $avalue = $node.getAttributeNS( $nsURI, $aname );
  $attrnode = $node.getAttributeNode( $aname );
  $attrnode = $node{'@'~$aname}; # xpath attribute selection
  $attrnode = $node.getAttributeNodeNS( $namespaceURI, $aname );
  my Bool $has-atts = $node.hasAttributes();
  my LibXML::Attr::Map $attrs = $node.attributes();
  $attrs = $node<attributes::>; # xpath
  my LibXML::Attr @props = $node.properties();
  $node.removeAttribute( $aname );
  $node.removeAttributeNS( $nsURI, $aname );
  $boolean = $node.hasAttribute( $aname );
  $boolean = $node.hasAttributeNS( $nsURI, $aname );

  # -- Navigation -- #
  my LibXML::Node @nodes = $node.getChildrenByTagName($tagname);
  @nodes = $node.getChildrenByTagNameNS($nsURI,$tagname);
  @nodes = $node.getChildrenByLocalName($localname);
  @nodes = $node.children; # all child nodes
  @nodes = $node.children(:!blank); # non-blank child nodes
  my LibXML::Element @elems = $node.getElementsByTagName($tagname);
  @elems = $node.getElementsByTagNameNS($nsURI,$localname);
  @elems = $node.getElementsByLocalName($localname);
  @elems = $node.elements; # all child elements

  #-- DOM Manipulation -- #
  $node.appendWellBalancedChunk( $chunk );
  $node.appendText( $PCDATA );
  $node.appendTextNode( $PCDATA );
  $node.appendTextChild( $childname , $PCDATA );
  $node.setNamespace( $nsURI , $nsPrefix, :$activate );
  $node.setNamespaceDeclURI( $nsPrefix, $newURI );
  $node.setNamespaceDeclPrefix( $oldPrefix, $newPrefix );

  # -- Associative/XPath interface -- #
  @nodes = $node{$xpath-expression};  # xpath node selection
  my LibXML::Element @as = $elem<a>;  # equiv: $elem.getChildrenByLocalName('a');
  my $b-value  = $elem<@b>.Str;       # value of 'b' attribute
  my LibXML::Element @z-grand-kids = $elem<*/z>;   # equiv: $elem.findnodes('*/z', :deref);
  my $text-content = $elem<text()>;
  say $_ for $elem.keys;   # @att-1 .. @att-n .. tag-1 .. tag-n
  say $_ for $elem.attributes.keys;   # att-1 .. att-n
  say $_ for $elem.childNodes.keys;   # 0, 1, ...

  # -- Construction -- #
  use LibXML::Item :&ast-to-xml;
  $elem = ast-to-xml('Test' => [
                         'xmlns:mam' => 'urn:mammals', # namespace
                         :foo<bar>,                    # attribute
                         "\n  ",                       # whitespace
                         '#comment' => 'demo',         # comment
                         :baz[],                       # sub-element
                         '#cdata' => 'a&b',            # CData section
                         "Some text.\n",               # text content
                     ]
                    );
  say $elem;
  # <Test xmlns:mam="urn:mammals" foo="bar">
  #   <!--demo--><baz/><![CDATA[a&b]]>Some text.
  # </Test>
  =end code

=head1 METHODS

The class inherits from L<<<<<< LibXML::Node >>>>>>. The documentation for Inherited methods is not listed here. 

Many functions listed here are extensively documented in the DOM Level 3 specification (L<<<<<< http://www.w3.org/TR/DOM-Level-3-Core/ >>>>>>). Please refer to the specification for extensive documentation. 

=begin item1
new
  =begin code :lang<raku>
  my LibXML::Element $node .= new( $name );
  =end code
This function creates a new node unbound to any DOM.

=end item1

=begin item1
setAttribute
  =begin code :lang<raku>
  $node.setAttribute( $aname, $avalue );
  =end code
This method sets or replaces the node's attribute C<<<<<< $aname >>>>>> to the value C<<<<<< $avalue >>>>>>

=end item1

=begin item1
setAttributeNS
  =begin code :lang<raku>
  $node.setAttributeNS( $nsURI, $aname, $avalue );
  =end code
Namespace-aware version of C<<<<<< setAttribute >>>>>>, where C<<<<<< $nsURI >>>>>> is a namespace URI, C<<<<<< $aname >>>>>> is a qualified name, and C<<<<<< $avalue >>>>>> is the value. The namespace URI may be Str:U (undefined) in order to
create an attribute which has no namespace.

The current implementation differs from DOM in the following aspects 

If an attribute with the same local name and namespace URI already exists on
the element, but its prefix differs from the prefix of C<<<<<< $aname >>>>>>, then this function is supposed to change the prefix (regardless of namespace
declarations and possible collisions). However, the current implementation does
rather the opposite. If a prefix is declared for the namespace URI in the scope
of the attribute, then the already declared prefix is used, disregarding the
prefix specified in C<<<<<< $aname >>>>>>. If no prefix is declared for the namespace, the function tries to declare the
prefix specified in C<<<<<< $aname >>>>>> and dies if the prefix is already taken by some other namespace. 

According to DOM Level 2 specification, this method can also be used to create
or modify special attributes used for declaring XML namespaces (which belong to
the namespace "http://www.w3.org/2000/xmlns/" and have prefix or name "xmlns").
The implementation differs from DOM specification in the following: if a
declaration of the same namespace prefix already exists on the element, then
changing its value via this method automatically changes the namespace of all
elements and attributes in its scope. This is because in libxml2 the namespace
URI of an element is not static but is computed from a pointer to a namespace
declaration attribute.

=end item1

=begin item1
getAttribute
  =begin code :lang<raku>
  my Str $avalue = $node.getAttribute( $aname );
  =end code
If C<<<<<< $node >>>>>> has an attribute with the name C<<<<<< $aname >>>>>>, the value of this attribute will get returned.

=end item1

=begin item1
getAttributeNS
  =begin code :lang<raku>
  my Str $avalue = $node.getAttributeNS( $nsURI, $aname );
  =end code
Retrieves an attribute value by local name and namespace URI.

=end item1

=begin item1
getAttributeNode
  =begin code :lang<raku>
  my LibXML::Attr $attrnode = $node.getAttributeNode( $aname );
  =end code
Retrieve an attribute node by name. If no attribute with a given name exists, C<<<<<< LibXML::Attr:U >>>>>> is returned.

=end item1

=begin item1
getAttributeNodeNS
  =begin code :lang<raku>
  my LibXML::Attr $attrnode = $node.getAttributeNodeNS( $namespaceURI, $aname );
  =end code
Retrieves an attribute node by local name and namespace URI. If no attribute
with a given localname and namespace exists, C<<<<<< LibXML::Attr:U >>>>>> is returned.

=end item1

=begin item1
removeAttribute
  =begin code :lang<raku>
  my Bool $released = $node.removeAttribute( $aname );
  =end code
The method removes the attribute C<<<<<< $aname >>>>>> from the node's attribute list, if the attribute can be found.

=end item1

=begin item1
removeAttributeNS
  =begin code :lang<raku>
  my Bool $released = $node.removeAttributeNS( $nsURI, $aname );
  =end code
Namespace version of C<<<<<< removeAttribute >>>>>>

=end item1

=begin item1
hasAttribute
  =begin code :lang<raku>
  my Bool $has-this-att = $node.hasAttribute( $aname );
  =end code
This function tests if the named attribute is set for the node. If the
attribute is specified, True will be returned, otherwise the return value
is False.

=end item1

=begin item1
hasAttributeNS
  =begin code :lang<raku>
  my Bool $has-this-att = $node.hasAttributeNS( $nsURI, $aname );
  =end code
namespace version of C<<<<<< hasAttribute >>>>>>

=end item1

=begin item1
hasAttributes
  =begin code :lang<raku>
  my Bool $has-any-atts = $node.hasAttributes();
  =end code
returns True if the current node has any attributes set, otherwise False is returned.

=end item1

=begin item1
attributes

  =begin code :lang<raku>
  use LibXML::Attr::Map;
  my LibXML::Attr::Map $atts = $elem.attributes();

  for $atts.keys { ... }
  $atts<color> = 'red';
  $atts<style>:delete;
  =end code

Proves an associative interface to a node's attributes.

Unlike the equivalent Perl 5 method, this method retrieves only L<LibXML::Attr> (not L<LibXML::Namespace>) nodes.

See also:

  =item the C<properties> method, which returns an L<LibXML::Attr> attributes iterator.

  =item the C<namespaces> method, which returns an L<LibXML::Namespace> namespaces iterator.

=end item1

=begin item
properties
  =begin code :lang<raku>
  my LibXML::Attr @props = $elem.properties;
  my LibXML::Node::List $props = $elem.properties;
  =end code
returns attributes for the node. It can be used to iterate through an elements properties:

  for $elem.properties -> LibXML::Attr $attr { ... }

=end item

=begin item
namespaces
  =begin code :lang<raku>
  my LibXML::Namespace @ns = $node.namespaces;
  my LibXML::Node::List $ns = $node.namespaces;
  =end code
returns a list of Namespace declarations for the node. It can be used to iterate through an element's namespaces:

  for $elem.namespaces -> LibXML::Namespace $ns { ... }

=end item

=begin item1
getChildrenByTagName
  =begin code :lang<raku>
  my LibXML::Node @nodes = $node.getChildrenByTagName($tagname);
  my LibXML::Node::Set $nodes = $node.getChildrenByTagName($tagname);
  =end code
The function gives direct access to all child elements of the current node with
a given tagname, where tagname is a qualified name, that is, in case of
namespace usage it may consist of a prefix and local name. This function makes
things a lot easier if one needs to handle big data sets. A special tagname '*'
can be used to match any name.

=end item1

=begin item1
getChildrenByTagNameNS
  =begin code :lang<raku>
  my LibXML::Element @nodes = $node.getChildrenByTagNameNS($nsURI,$tagname);
  my LibXML::Node::Set $nodes = $node.getChildrenByTagNameNS($nsURI,$tagname);
  =end code
Namespace version of C<<<<<< getChildrenByTagName >>>>>>. A special nsURI '*' matches any namespace URI, in which case the function
behaves just like C<<<<<< getChildrenByLocalName >>>>>>.

=end item1

=begin item1
getChildrenByLocalName
  =begin code :lang<raku>
  my LibXML::Element @nodes = $node.getChildrenByLocalName($localname);
  my LibXML::Node::Set $nodes = $node.getChildrenByLocalName($localname);
  =end code
The function gives direct access to all child elements of the current node with
a given local name. It makes things a lot easier if one needs to handle big
data sets. Note:

  =item A special C<<<<<< localname >>>>>> '*' can be used to match all ements.
  =item C<@*> can be used to fetch attributes as a node-set
  =item C<?*> (all), or C<?name> can be used to fetch processing instructions
  =item The special names C<#text>, C<#comment> and C<#cdata-section> can be used to match Text, Comment or CDATA Section nodes.

=end item1

=begin item1
getElementsByTagName
  =begin code :lang<raku>
  my LibXML::Element @nodes = $node.getElementsByTagName($tagname);
  my LibXML::Node::Set $nodes = $node.getElementsByTagName($tagname);
  =end code
This function is part of the spec. It fetches all descendants of a node with a
given tagname, where C<<<<<< tagname >>>>>> is a qualified name, that is, in case of namespace usage it may consist of a
prefix and local name. A special C<<<<<< tagname >>>>>> '*' can be used to match any tag name. 

=end item1

=begin item1
getElementsByTagNameNS
  =begin code :lang<raku>
  my LibXML::Element @nodes = $node.getElementsByTagNameNS($nsURI,$localname);
  my LibXML::Node::Set $nodes = $node.getElementsByTagNameNS($nsURI,$localname);
  =end code
Namespace version of C<<<<<< getElementsByTagName >>>>>> as found in the DOM spec. A special C<<<<<< localname >>>>>> '*' can be used to match any local name and C<<<<<< nsURI >>>>>> '*' can be used to match any namespace URI.


=end item1

=begin item1
getElementsByLocalName
  =begin code :lang<raku>
  my LibXML::Element @nodes = $node.getElementsByLocalName($localname);
  my LibXML::Node::Set $nodes = $node.getElementsByLocalName($localname);
  =end code
This function is not found in the DOM specification. It is a mix of
getElementsByTagName and getElementsByTagNameNS. It will fetch all tags
matching the given local-name. This allows one to select tags with the same
local name across namespace borders.

In item context this function returns an L<<<<<< LibXML::Node::Set >>>>>> object.

=end item1

=begin item1
elements

Equivalent to `.getElementsByLocalName('*')`

=end item1

=begin item1
appendWellBalancedChunk
  =begin code :lang<raku>
  $node.appendWellBalancedChunk( $chunk );
  =end code
Sometimes it is necessary to append a string coded XML Tree to a node. I<<<<<< appendWellBalancedChunk >>>>>> will do the trick for you. But this is only done if the String is C<<<<<< well-balanced >>>>>>.

I<<<<<< Note that appendWellBalancedChunk() is only left for compatibility reasons >>>>>>. Implicitly it uses

  =begin code :lang<raku>
  my LibXML::DocumentFragment $fragment = $parser.parse: :balanced, :$chunk;
  $node.appendChild( $fragment );
  =end code

This form is more explicit and makes it easier to control the flow of a script.

=end item1

=begin item1
appendText
  =begin code :lang<raku>
  $node.appendText( $PCDATA );
  =end code
alias for appendTextNode().

=end item1

=begin item1
appendTextNode
  =begin code :lang<raku>
  $node.appendTextNode( $PCDATA );
  =end code
This wrapper function lets you add a string directly to an element node.

=end item1

=begin item1
appendTextChild
  =begin code :lang<raku>
  $node.appendTextChild( $childname , $PCDATA );
  =end code
Somewhat similar with C<<<<<< appendTextNode >>>>>>: It lets you set an Element, that contains only a C<<<<<< text node >>>>>> directly by specifying the name and the text content.

=end item1

=begin item1
setNamespace
  =begin code :lang<raku>
  $node.setNamespace( $nsURI , $nsPrefix, :$activate );
  =end code
setNamespace() allows one to apply a namespace to an element. The function
takes three parameters: 1. the namespace URI, which is required and the two
optional values prefix, which is the namespace prefix, as it should be used in
child elements or attributes as well as the additional activate parameter. If
prefix is not given, undefined or empty, this function tries to create a
declaration of the default namespace. 

The activate parameter is most useful: If this parameter is set to False, a
new namespace declaration is simply added to the element while the element's
namespace itself is not altered. Nevertheless, activate is set to True on
default. In this case the namespace is used as the node's effective namespace.
This means the namespace prefix is added to the node name and if there was a
namespace already active for the node, it will be replaced (but its declaration
is not removed from the document). A new namespace declaration is only created
if necessary (that is, if the element is already in the scope of a namespace
declaration associating the prefix with the namespace URI, then this
declaration is reused). 

The following example may clarify this:

  =begin code :lang<raku>
  my $e1 = $doc.createElement("bar");
  $e1.setNamespace("http://foobar.org", "foo")
  =end code
results in:

  =begin code :lang<xml>
  <foo:bar xmlns:foo="http://foobar.org"/>
  =end code
while:

  =begin code :lang<raku>
  my $e2 = $doc.createElement("bar");
  $e2.setNamespace("http://foobar.org", "foo", :!activate)
  =end code

results in:

  =begin code :lang<xml>
  <bar xmlns:foo="http://foobar.org"/>
  =end code
By using :!activate it is possible to create multiple namespace
declarations on a single element.

The function fails if it is required to create a declaration associating the
prefix with the namespace URI but the element already carries a declaration
with the same prefix but different namespace URI. 

=end item1

=begin item1
requireNamespace
  =begin code :lang<raku>
   use LibXML::Types ::NCName;
   my NCName:D $prefix = $node.requireNamespace(<http://myns.org>)
  =end code
Return the prefix for any any existing namespace in the node's scope that
matches the URL. If not found, a new namespace is created for the URI
on the node with an anonimised prefix (_ns0, _ns1, ...).

=end item1

=begin item1
setNamespaceDeclURI
  =begin code :lang<raku>
  $node.setNamespaceDeclURI( $nsPrefix, $newURI );
  =end code
This function is NOT part of any DOM API.

This function manipulates directly with an existing namespace declaration on an
element. It takes two parameters: the prefix by which it looks up the namespace
declaration and a new namespace URI which replaces its previous value.

It returns True if the namespace declaration was found and changed, False otherwise.

All elements and attributes (even those previously unbound from the document)
for which the namespace declaration determines their namespace belong to the
new namespace after the change.  For example:
  =begin code :lang<raku>
  my LibXML::Element $elem = .root()
      given LibXML.parse('<Doc xmlns:xxx="http://ns.com"><xxx:elem/></Doc>');
  $elem.setNamespaceDeclURI( 'xxx', 'http://ns2.com'  );
  say $elem.Str; # <Doc xmlns:xxx="http://ns2.com"><xxx:elem/></Doc>
  =end code
If the new URI is undefined or empty, the nodes have no namespace and no prefix
after the change. Namespace declarations once nulled in this way do not further
appear in the serialized output (but do remain in the document for internal
integrity of libxml2 data structures). 

=end item1

=begin item1
setNamespaceDeclPrefix
  =begin code :lang<raku>
  $node.setNamespaceDeclPrefix( $oldPrefix, $newPrefix );
  =end code
This function is NOT part of any DOM API.

This function manipulates directly with an existing namespace declaration on an
element. It takes two parameters: the old prefix by which it looks up the
namespace declaration and a new prefix which is to replace the old one.

The function dies with an error if the element is in the scope of another
declaration whose prefix equals to the new prefix, or if the change should
result in a declaration with a non-empty prefix but empty namespace URI.
Otherwise, it returns True if the namespace declaration was found and changed,
or False if not found.

All elements and attributes (even those previously unbound from the document)
for which the namespace declaration determines their namespace change their
prefix to the new value. For example:
  =begin code :lang<raku>
  my $node = .root()
      given LibXML.parse('<Doc xmlns:xxx="http://ns.com"><xxx:elem/></Doc>');
  $node.setNamespaceDeclPrefix( 'xxx', 'yyy' );
  say $node.Str; # <Doc xmlns:yyy="http://ns.com"><yyy:elem/></Doc>
  =end code
If the new prefix is undefined or empty, the namespace declaration becomes a
declaration of a default namespace. The corresponding nodes drop their
namespace prefix (but remain in the, now default, namespace). In this case the
function fails, if the containing element is in the scope of another default
namespace declaration. 

=end item1


=head1 COPYRIGHT

2001-2007, AxKit.com Ltd.

2002-2006, Christian Glahn.

2006-2009, Petr Pajas.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under
the terms of the Artistic License 2.0 L<http://www.perlfoundation.org/artistic_license_2_0>.

=end pod