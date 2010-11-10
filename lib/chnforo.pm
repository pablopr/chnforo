package chnforo;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Template;
use Service::Article;
use HTML::Strip;
use Data::Pageset::Render;
require "utils.pl";

our $VERSION = '0.1';

my $article_service = new Service::Article();

before sub {
	my @articles = $article_service->get_last_articles; 
        var articles => \@articles;
        
        my @categories = $article_service->get_categories;
        var categories => \@categories;
        
};

get '/' => sub {
     my @random_articles = $article_service->get_random_articles;
     
     foreach my $article(@random_articles){
     	     my $text = &clean_text($article->{texto});
     	     $article->{texto} = $text;
     }
     
     my $seo_params = &create_seo_params(
     	     "titulo general",
     	     "keywords de la home",
     	     "descripcion general de chnforo"
     	     );
     
     my $params = { 
     	articles => vars->{articles},  
     	categories => vars->{categories} , 
     	main_articles => \@random_articles,
     	seo => $seo_params
     };
     
     template 'index', $params;
};

get '/article/view/:id' => sub {

        my $article = $article_service->get_article_by_id(params->{id});
        
        my $seo_params = &create_seo_params(
        	$article->{url_text},
        	$article->{url_text},
     	        $article->{url_text}
     	        );
        
        my $params = { 
        	articles => vars->{articles}, 
        	categories => vars->{categories}, 
        	article => $article,
        	seo => $seo_params
        };
        
        template 'article', $params;
    };
    
get '/category/:name/:page' => sub {
     
     my $entries_per_page = 30;
     my $category_name = params->{name};
     
     my $current_page = params->{page};
     if (!$current_page > 0){
     	     $current_page = 1;
     }
    
     my $total_entries = $article_service->count_articles_by_category(
     	     $category_name);
     debug "############## tenemos: $total_entries /n";
     
     my @articles = $article_service->get_paginated_articles_by_category(
     	     $category_name,$current_page,$entries_per_page);
     
     foreach my $article(@articles){
     	     my $text = &clean_text($article->{texto});
     	     $article->{texto} = $text;
     }
     
     my $url = "/category/$category_name/";
     my $pager = &create_pagination($total_entries,$current_page,$entries_per_page,$url);
     
     my $seo_params = &create_seo_params(
        	params->{name},
        	"Articles about ".params->{name},
     	        "Articles about ".params->{name}
     	        );
       
     my $params = { 
     	articles => vars->{articles},  
     	categories => vars->{categories} , 
     	main_articles => \@articles,
     	seo => $seo_params,
     	pager => $pager
     };
     
     template 'index', $params;
};
    
sub create_seo_params(){
	my ($title,$keywords,$description) = @_;
	{
		title => $title,
		keywords => $keywords,
		description => $description
	}
}
 
sub create_pagination(){
	my ($total_entries,$current_page,$entries_per_page,$url) = @_;
	
	my $pager = Data::Pageset::Render->new( {
			total_entries    => $total_entries,
			entries_per_page => $entries_per_page,
			current_page     => $current_page,
			pages_per_set    => 50,
			mode             => 'slider',
			
			link_format      => '<a href="'.$url.'%p">%a</a>',
	} );
	
	return $pager->html();
}
    
true;
