

    sub clean_text{
    	 my $text = shift;
    	 $text =~ s/Reproduced in the form of a hyperlink when you identify the source and author information in the article and the statement//;
    	 my $hs = HTML::Strip->new();
    	 my $clean_text = $hs->parse( $text );
         $hs->eof;
    	 
    	 return &truncate($clean_text,300);
    }
    sub truncate {
	  my($string, $maxlength) = @_;
	  $string = substr($string, 0, $maxlength+1);
	  die("Can't truncate, no spaces\n") if(index($string, ' ') == -1);
	  return substr($string, 0, rindex($string, ' '))."...";
   }
   
true;
