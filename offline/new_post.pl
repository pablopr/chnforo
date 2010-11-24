#!/usr/bin/env perl
use Posterous;
use strict;
require ("dbInit.pl");

my $posterous = Posterous->new('chnforo@imaginasoft.com','maskayerro');

#send one post by category by lang
&send_posts_by_lang($_) for qw(en pt es fr bg ca cs da fi gl el nl hu is it no pl sv tr);


sub send_posts_by_lang{
	my $lang = shift;
	my @categories = &get_lista_query('SELECT distinct(category) from entries_'.$lang);
	
	my $article = {};
        my $url = "";
	my $content = "";
	for my $category(@categories){
		$article = &get_hash_ref_query('select * from entries_'.$lang.' where category like "'.$category.'" order by rand() limit 1');
                $url = '<label>Link: </label>
				<a href="http://www.knowrepository.com/'.$lang.'/'.$article->{title_slug}.'/'.$article->{id}.'" title="'.$article->{title}.'" class="left">
'.$article->{title}.'</a>';
		$content = $article->{summary}."<br />".$url;
                $posterous->add_post(title => $article->{title}, body => $content);
                print "Sending post: $article->{title} \n";
		sleep(1);
	}
}

1;
