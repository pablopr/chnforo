#!/usr/bin/env perl
use lib '/var/www/knowrepository/offline/';
use Posterous;
use strict;
require ("/var/www/knowrepository/offline/dbInit.pl");

my $posterous = Posterous->new('chnforo@imaginasoft.com','xxxx');

#send one post by category by lang
&send_posts_by_lang($_) for qw(en pt es fr ca da fi gl nl is it no sv);

sub send_posts_by_lang{
	my $lang = shift;
	my @categories = &get_lista_query('SELECT distinct(category) from entries_'.$lang);
	
	my $article = {};
        my $url = "";
	my $content = "";

	#solo uno en general, no uno por categoria por ahora.
	#for my $category(@categories){
		#$article = &get_hash_ref_query('select * from entries_'.$lang.' where category like "'.$category.'" order by rand() limit 1');

		$article = &get_hash_ref_query('select * from entries_'.$lang.' where posted = false order by rand() limit 1');
		&flag_article_as_posted($article->{id},$lang);
                $url = '<a href="http://www.knowrepository.com/'.$lang.'/'.$article->{title_slug}.'/'.$article->{id}.'" title="'.$article->{title}.'" class="left">
'.$article->{title}.'</a>';
		$content = $url."<br />".$article->{summary};
                $posterous->add_post(title => $article->{title}, body => $content);
                print "Sending post: $article->{title} \n";
		sleep(5);
                #break;
	#}
}

sub flag_article_as_posted{
	my $id = shift;
	my $lang = shift;
	&do_query('update entries_'.$lang.' set posted = true where id = '.$id);
}

1;
