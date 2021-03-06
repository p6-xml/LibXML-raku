use v6;

use Test;
use LibXML;
use LibXML::RelaxNG;

plan 16;

sub slurp(Str $_) { .IO.slurp }

my $xmlparser = LibXML.new();

my $file         = "test/relaxng/schema.rng";
my $badfile      = "test/relaxng/badschema.rng";
my $validfile    = "test/relaxng/demo.xml";
my $invalidfile  = "test/relaxng/invaliddemo.xml";
my $demo4        = "test/relaxng/demo4.rng";

# 1 parse schema from a file
{
    my $rngschema = LibXML::RelaxNG.new( location => $file );
    ok ( $rngschema, ' TODO : Add test name' );

    dies-ok { $rngschema = LibXML::RelaxNG.new( location => $badfile ); }, 'parse of bad file';

}

print "# 2 parse schema from a string\n";
{
    my $string = slurp($file);

    my $rngschema = LibXML::RelaxNG.new( string => $string );
    ok ( $rngschema, ' TODO : Add test name' );

    $string = slurp($badfile);

    dies-ok { $rngschema = LibXML::RelaxNG.new( string => $string ); }, 'bad rng schema dies';
}

print "# 3 parse schema from a document\n";
{
    my LibXML::Document:D $doc       = $xmlparser.parse: :file( $file );
    my $rngschema = LibXML::RelaxNG.new( :$doc );
    ok ( $rngschema, ' TODO : Add test name' );

    $doc       = $xmlparser.parse: :file( $badfile );
    dies-ok { $rngschema = LibXML::RelaxNG.new( :$doc ); }, 'parse of invalid doc dies';
}

print "# 4 validate a document\n";
{
    my $doc       = $xmlparser.parse: :file( $validfile );
    my $rngschema = LibXML::RelaxNG.new( location => $file );

    is-deeply $rngschema.is-valid( $doc ), True, 'is-valid on valid doc';
    my $valid = 0;
    lives-ok { $valid = $rngschema.validate( $doc ); }, 'validate valid document';
    is( $valid, 0, ' TODO : Add test name' );

    $doc       = $xmlparser.parse: :file( $invalidfile );
    $valid     = 0;
    dies-ok { $valid = $rngschema.validate( $doc ); }, 'validate invalid document';
     is-deeply $rngschema.is-valid( $doc ), False, 'is-valid on invalid doc';
}

print "# 5 re-validate a modified document\n";
{
  my $rng = LibXML::RelaxNG.new(location => $demo4);
  my $seed_xml = q:to<EOXML>;
<?xml version="1.0" encoding="UTF-8"?>
<root/>
EOXML

  my $doc = $xmlparser.parse: :string($seed_xml);
  my $rootElem = $doc.documentElement;
  my $bogusElem = $doc.createElement('bogus-element');

  dies-ok {$rng.validate($doc);}, 'unmodified (invalid) document dies';

  $rootElem.setAttribute('name', 'rootElem');
  lives-ok { $rng.validate($doc); }, 'modified (valid) document lives';

  $rootElem.appendChild($bogusElem);
  dies-ok {$rng.validate($doc);}, 'modified (invalid) document dies';

  $bogusElem.unlinkNode();
  lives-ok {$rng.validate($doc);}, 'modified (fixed) document lives';

  $rootElem.removeAttribute('name');
  dies-ok {$rng.validate($doc);}, 'modified (broken) document dies';

}
