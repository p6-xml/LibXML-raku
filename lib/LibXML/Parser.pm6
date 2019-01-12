class LibXML::Parser {

    use LibXML::Native;
    use LibXML::Enums;
    use LibXML::Document;
    use LibXML::PushParser;

    has parserCtxt $!parser-ctx;
    has Bool $.html;
    has Bool $.line-numbers = False;
    has uint32 $.flags is rw = XML_PARSE_NODICT +| XML_PARSE_DTDLOAD;
    has Str $.base-uri is rw;

    constant %FLAGS = %(
        :recover(XML_PARSE_RECOVER),
        :expand-entities(XML_PARSE_NOENT),
        :load-ext-dtd(XML_PARSE_DTDLOAD),
        :complete-attributes(XML_PARSE_DTDATTR),
        :validation(XML_PARSE_DTDVALID),
        :suppress-errors(XML_PARSE_NOERROR),
        :suppress-warnings(XML_PARSE_NOWARNING),
        :pedantic-parser(XML_PARSE_PEDANTIC),
        :keep-blanks(XML_PARSE_NOBLANKS),
        :expand-xinclude(XML_PARSE_XINCLUDE),
        :xinclude(XML_PARSE_XINCLUDE),
        :no-network(XML_PARSE_NONET),
        :clean-namespaces(XML_PARSE_NSCLEAN),
        :no-cdata(XML_PARSE_NOCDATA),
        :no-xinclude-nodes(XML_PARSE_NOXINCNODE),
        :old10(XML_PARSE_OLD10),
        :no-base-fix(XML_PARSE_NOBASEFIX),
        :huge(XML_PARSE_HUGE),
        :oldsax(XML_PARSE_OLDSAX),
    );

    method !context(parserCtxt :$ctx!) {
        LibXML::ParserContext.new: :$ctx, :$!flags, :$!line-numbers;
    }

    method !finish(LibXML::Document $doc, :$uri, LibXML::ParserContext :$ch!) {
        $ch.flush-errors;
        $doc.uri = $_ with $uri;
        self.process-xincludes($doc)
            if $.expand-xinclude;
        $doc;
    }

    method process-xincludes(LibXML::Document $doc) {
        my xmlDoc $xml-doc = $doc.doc;
        my xmlXIncludeCtxt $ctx .= new( :doc($xml-doc) );
        my LibXML::ParserContext $ch = self!context: :$ctx;
        my xmlNode $root = $xml-doc.GetRootElement;
        my $n = $ctx.ProcessNode($root);
        $ch.flush-errors;
        $ctx.Free;
        $n;
    }

    multi method parse(Str:D() :$string!,
                       Str :$uri = $!base-uri,
                       Str :$enc) {

        my parserCtxt $ctx = $!html
           ?? htmlParserCtxt.new
           !! xmlParserCtxt.new;

        my LibXML::ParserContext $ch = self!context: :$ctx;

        with $ctx.ReadDoc($string, $uri, $enc, $!flags) -> $doc {
            self!finish: LibXML::Document.new( :$ctx, :$doc), :$ch;
        }
        else {
##            $ctx.Free; # hangs!?
            $ch.flush-errors(:die);
        }
    }

    multi method parse(Str:D :$file!,
                       Str :$uri = $!base-uri) {

        my parserCtxt $ctx = $!html
           ?? htmlFileParserCtxt.new(:$file)
           !! xmlFileParserCtxt.new(:$file);

        my LibXML::ParserContext $ch = self!context: :$ctx;

        if $ctx.ParseDocument == 0 {
            self!finish: LibXML::Document.new(:$ctx, :$uri), :$ch;
        }
        else {
            $ctx.Free;
            $ch.flush-errors;
        }
    }

    has LibXML::PushParser $!push-parser;
    has @!push-errors;
    method parse-chunk($chunk) {
        with $!push-parser {
            .push($chunk)
        }
        else {
            $_ .= new: :$chunk, :$!html, :$!flags, :$!line-numbers;
        }
    }
    method finish-push(
        Str :$uri = $!base-uri,
    )
    {
        with $!push-parser {
            .finish-push(:$uri);
        }
        else {
            die "no active push parser";
        }
    }

    multi method parse(IO::Handle :$io!,
                       Str :$uri = $!base-uri,
                       UInt :$chunk-size = 4096,
                      ) {

        # read initial block to determine encoding
        my Str $path = $io.path.path;
        my Blob $chunk = $io.read($chunk-size);
        my LibXML::PushParser $push-parser .= new: :$chunk, :$!html, :$path, :$!flags, :$!line-numbers;

        my Bool $more = ?$chunk;

        while $more && !$push-parser.err {
            $chunk = $io.read($chunk-size);
            $more = ?$chunk;
            $push-parser.push($chunk)
                if $more;
        }

        $push-parser.finish-push;
    }

    multi method parse(IO() :io($path)!, |c) {
        my IO::Handle $io = $path.open(:bin, :r);
        $.parse(:$io, |c);
    }

    method !flag-accessor(uint32 $flag) is rw {
        Proxy.new(
            FETCH => sub ($) { $!flags +& $flag },
            STORE => sub ($, Bool() $_) {
                if .so {
                    $!flags +|= $flag;
                }
                else {
                    my uint32 $mask = 0xffffffff +^ $flag;
                    $!flags +&= $mask;
                }
            });
    }

    submethod TWEAK(:html($), :line-numbers($), :flags($), :uri($), *%flags) {
        for %flags.pairs.sort -> $f {
            with %FLAGS{$f.key} {
                self!flag-accessor($_) = $f.value;
            }
            else {
                warn "ignoring option: {$f.key}";
            }
        }
    }

    method FALLBACK($method, |c) is rw {
        # set up flag accessors;
        with %FLAGS{$method} {
            self!flag-accessor($_,|c);
        }
        else {
            die X::Method::NotFound.new( :$method, :typename(self.^name) )
        }
    }

}
