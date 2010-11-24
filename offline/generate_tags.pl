#!/usr/bin/perl
use strict;
require Encode;
use Unicode::Normalize;
require ("dbInit.pl");


my @languages = ("en","pt","es","fr","ca","da","fi","gl","nl","is","it","no","sv");

for my $lang(@languages){
	 my @articles = &get_articles($lang);
	 
	 &do_query("DELETE FROM tags_$lang");
	 
	 print "###### Extracting tags in $lang \n";
	 for my $article(@articles){
	 	 &create_tags_from_string($lang,$article);
	 }
}


sub create_tags_from_string{
	my $lang = shift;
	my $text = shift;
        my @tags = &extract_tags_from_text($text);
	for my $tag(@tags){
		&insert_or_update_tag($lang,$tag);	
	}
}

sub extract_tags_from_text{
	my $text = shift;
	$text =~s/ /_/g;
	$text =~s/\W//g;
	


 for ( $text ) {  # the variable we work on

   ##  convert to Unicode first
   ##  if your data comes in Latin-1, then uncomment:
   $_ = Encode::decode( 'utf8', $_ );  

   s/\xe4/ae/g;  ##  treat characters ä ñ ö ü ÿ
   s/\xf1/ny/g;  ##  this was wrong in previous version of this doc    
   s/\xf6/oe/g;
   s/\xfc/ue/g;
   s/\xff/yu/g;

   $_ = NFD( $_ );   ##  decompose (Unicode Normalization Form D)
   s/\pM//g;         ##  strip combining characters

   # additional normalizations:

   s/\x{00df}/ss/g;  ##  German beta “ß” -> “ss”
   s/\x{00c6}/AE/g;  ##  Æ
   s/\x{00e6}/ae/g;  ##  æ
   s/\x{0132}/IJ/g;  ##  Ĳ
   s/\x{0133}/ij/g;  ##  ĳ
   s/\x{0152}/Oe/g;  ##  Œ
   s/\x{0153}/oe/g;  ##  œ

   tr/\x{00d0}\x{0110}\x{00f0}\x{0111}\x{0126}\x{0127}/DDddHh/; # ÐĐðđĦħ
   tr/\x{0131}\x{0138}\x{013f}\x{0141}\x{0140}\x{0142}/ikLLll/; # ıĸĿŁŀł
   tr/\x{014a}\x{0149}\x{014b}\x{00d8}\x{00f8}\x{017f}/NnnOos/; # ŊŉŋØøſ
   tr/\x{00de}\x{0166}\x{00fe}\x{0167}/TTtt/;                   # ÞŦþŧ

   s/[^\0-\x80]//g;  ##  clear everything else; optional
 }
	
	
	
	my @pieces = split(/_/,$text);
	print "###### tenemos estas palabras @pieces \n";
	my @tags = ();
	for my $piece(@pieces){
		
		
		if (length($piece) > 2 ){
			push(@tags,$piece);
		}
	}
	return @tags;
}

sub insert_or_update_tag(){
	my $lang = shift;
	my $tag = shift;
	if(&tag_exists($lang,$tag)){
		&do_query("update tags_$lang set density = density + 1 where tag = '$tag'");
	}
	else{
		&do_query("insert into tags_$lang (id,tag,density) values('','$tag',1)");
	}
}

sub tag_exists{
	my $lang = shift;
	my $tag = shift;
	&get_lista_query("select count(*) from tags_$lang where tag = '$tag'");	
}

sub get_articles{
  my $lang = shift;	
  &get_lista_query('SELECT title from entries_'.$lang);

}





1;
