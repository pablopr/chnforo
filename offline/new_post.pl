#!/usr/bin/env perl
use Posterous;
use strict;
require ("dbInit.pl");

my $posterous = Posterous->new('chnforo@imaginasoft.com','maskayerro');

#send one post by category by lang
&send_posts_by_lang($_) for qw(en pt es fr ca da fi gl nl is it no sv);

sub send_posts_by_lang{
	my $lang = shift;
	my @categories = &get_lista_query('SELECT distinct(category) from entries_'.$lang);
	
	my $article = {};
        my $url = "";
	my $content = "";
	for my $category(@categories){
		#$article = &get_hash_ref_query('select * from entries_'.$lang.' where category like "'.$category.'" order by rand() limit 1');
#solo uno por en general, no unos por categoria por ahora.
		$article = &get_hash_ref_query('select * from entries_'.$lang.' order by rand() limit 1');
                $url = '<a href="http://www.knowrepository.com/'.$lang.'/'.$article->{title_slug}.'/'.$article->{id}.'" title="'.$article->{title}.'" class="left">
'.$article->{title}.'</a>';
		$content = $url."<br />".$article->{summary};
                $posterous->add_post(title => $article->{title}, body => $content);
                print "Sending post: $article->{title} \n";
		sleep(5);
                break;
	}
}

1;
