

    sub clean_text{
    	 my $text = shift;
    	 my $hs = HTML::Strip->new();
    	 my $clean_text = $hs->parse( $text );
         $hs->eof;
    	 
    	 return &truncate($clean_text,100);
    }
    sub truncate {
	  my($string, $maxlength) = @_;
	  $string = substr($string, 0, $maxlength+1);
	  die("Can't truncate, no spaces\n") if(index($string, ' ') == -1);
	  return substr($string, 0, rindex($string, ' ') - 1);
   }
   
true;
