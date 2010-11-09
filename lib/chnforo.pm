package chnforo;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Template;
use Service::Article;
use HTML::Strip;
require "utils.pl";

our $VERSION = '0.1';

my $article_service = new Service::Article();

get '/' => sub {
     my @articles = $article_service->get_last_articles;
     
     my @random_articles = $article_service->get_random_articles;
     
     foreach my $article(@random_articles){
     	     my $text = &clean_text($article->{texto},100);
     	     $article->{texto} = $text;
     }
     
     template 'index', { articles => \@articles , random => \@random_articles};
};

get '/article/view/:id' => sub {

        my $article = $article_service->get_article_by_id(params->{id});
        
        my $texto = $article->{texto};
        $texto =~ s/Reproduced in the form of a hyperlink when you identify the source and author information in the article and the statement//;
        template 'ver_articulo', { texto => $texto, articulo => $article };
    };
    
    

true;
