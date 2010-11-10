package chnforo;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Template;
use Service::Article;
use HTML::Strip;
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
    
get '/category/:name' => sub {
	
     my @articles = $article_service->get_articles_by_category(params->{name});
     
     foreach my $article(@articles){
     	     my $text = &clean_text($article->{texto});
     	     $article->{texto} = $text;
     }
     
     my $seo_params = &create_seo_params(
        	params->{name},
        	"Articles about ".params->{name},
     	        "Articles about ".params->{name}
     	        );
       
     my $params = { 
     	articles => vars->{articles},  
     	categories => vars->{categories} , 
     	main_articles => \@articles,
     	seo => $seo_params
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
    
true;
