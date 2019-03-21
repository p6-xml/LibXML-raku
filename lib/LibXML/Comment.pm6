use LibXML::Node;

unit class LibXML::Comment
    is LibXML::Node;

use LibXML::Native;

multi submethod TWEAK(LibXML::Node :doc($)!, domNode:D :struct($)!) { }
multi submethod TWEAK(LibXML::Node :doc($owner), Str :$content!) {
    my xmlDoc:D $doc = .unbox with $owner;
    my xmlCommentNode $comment-struct .= new: :$content, :$doc;
    self.struct = $comment-struct;
}
