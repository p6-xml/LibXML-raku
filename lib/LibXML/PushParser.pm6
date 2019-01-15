class LibXML::PushParser {
    use LibXML::Native;
    use LibXML::ParserContext;
    use LibXML::Document;

    has Bool $.html;
    has @!errors;
    has parserCtxt $!ctx;
    has LibXML::ParserContext $!ch;
    has Int $.err = 0;
    method ctx { $!ctx }

    multi submethod TWEAK(Str :chunk($str), |c) {
        my $chunk = $str.encode;
        self.TWEAK(:$chunk, |c);
    }

    multi submethod TWEAK(Blob :$chunk!, Str :$path, |c) {
        my \ctx-class = $!html ?? htmlPushParserCtxt !! xmlPushParserCtxt;
        $!ctx = ctx-class.new: :$chunk, :$path;
        $!ch .= new: :$!ctx, |c;
    }

    method !parse-chunk(Blob $chunk = Blob.new, UInt :$size = +$chunk, Bool :$terminate = False) {
        given  $!ctx.ParseChunk($chunk, $size, +$terminate) {
	    warn :$!err.perl if $!err;
	    die "XML not well-formed in xmlParseChunk" unless $!ctx.wellFormed;
            $!err ||= $_;
            $_;
	    
        }
    }

    multi method push(Str $chunk) {
        self!parse-chunk($chunk.encode);
    }

    multi method push(Blob $chunk) is default {
        self!parse-chunk($chunk);
    }

    method finish-push(Str :$uri) {
        self!parse-chunk: :terminate;
	$!ch.flush-errors;
        LibXML::Document.new( :$!ctx, :$uri);
    }
}

