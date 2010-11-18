#!/usr/bin/perl
use strict;
require ("dbInit.pl");



my @languages =("en","pt","es","fr","bg","ca","cs","da","fi","gl","el","nl","hu","is","it","no","pl","sv","tr");

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
        $text =~s/\.//g;
	my @pieces = split(/_/,$text);
	print "###### tenemos estas palabras @pieces \n";
	my @tags = ();
	for my $piece(@pieces){
		$piece =~s/\W//g;
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
