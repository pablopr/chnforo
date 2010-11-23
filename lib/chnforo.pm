package chnforo;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Template;
use Service::Article;
use HTML::Strip;
use Data::Pageset::Render;
use HTML::TagCloud;
require "utils.pl";

our $VERSION = '0.1';
my $article_service;

before sub{
	$article_service = new Service::Article();
};

before_template sub {
	my $tokens = shift;
	#metemos el idioma para todas las plantillas
        $tokens->{lang} = $article_service->{lang};
        my @languages =("en","pt","es","fr","bg","ca","cs","da","fi","gl","el","nl","hu","is","it","no","pl","sv","tr");
        $tokens->{languages} = \@languages;
};

get '/' => sub {
	&index_page;
};

get qr{ /([a-z]{2})/?\Z}x => sub{
     my ($lang) = splat;
     
     $article_service->set_lang($lang);
     &index_page;
};

get  qr{ /([a-z]{2})/tag/(\w+)}x => sub {
	my ($lang,$tag) = splat;
	
	#seteamos el lenguaje que viene en la url
	$article_service->set_lang($lang);
	
	my @articles = $article_service->find_articles_by_keyword($tag);
	
	#recupera los datos para los menus laterales
	&prepare_lateral_menus;

        my $seo_params = &create_seo_params($tag,$tag,$tag);
        
     	#parametros que metemos en la request
        my $params = { 
        	articles => vars->{articles}, 
        	categories => vars->{categories}, 
        	cloud_html => vars->{cloud_html},
        	main_articles => \@articles,
		seo => $seo_params,
        };
        
        template 'index', $params;
    };



get  qr{ /([a-z]{2})/sitemap/([0-9]+)}x => sub {
     my ($lang,$current_page) = splat;
     $article_service->set_lang($lang);
     my $entries_per_page = 30;
    
     my $total_entries = $article_service->count_articles;
     
     my @articles = $article_service->get_paginated_articles($current_page,$entries_per_page);
     
     my $url = "/$lang/sitemap/";
     my $pager = &create_pagination($total_entries,$current_page,$entries_per_page,$url);
     
     my $seo_params = &create_seo_params(
        	"Sitemap",
        	"Sitemap",
     	        "Sitemap"
     	        );
       
     my $params = { 
     	articles => vars->{articles},  
     	categories => vars->{categories} , 
     	main_articles => \@articles,
     	seo => $seo_params,
     	pager => $pager,
     };
     
     template 'sitemap', $params;
};

#get '/category/:name/:page' => sub {
get  qr{ /([a-z]{2})/category/(\w+)/([0-9]+)}x => sub {
     my ($lang,$category_slug,$current_page) = splat;
     
     #seteamos el lenguaje que viene en la url
     $article_service->set_lang($lang);
     
     #recupera los datos para los menus laterales
     &prepare_lateral_menus;
     
     #datos para la paginacion
     my $entries_per_page = 30;
     if (!$current_page > 0){
     	     $current_page = 1;
     }
     
     my $total_entries = $article_service->count_articles_by_category(
     	     $category_slug);
     
     #los articulos paginados
     my @articles = $article_service->get_paginated_articles_by_category(
     	     $category_slug,$current_page,$entries_per_page);
    
     #Creamos paginador
     my $url = "/$lang/category/$category_slug/";
     my $pager = &create_pagination($total_entries,$current_page,$entries_per_page,$url);
     
     my $seo_params = &create_seo_params(
        	$category_slug,
        	$category_slug,
     	        $category_slug
     	        );
     
     #parametros que metemos en la request
     my $params = { 
     	articles => vars->{articles},  
     	categories => vars->{categories} , 
     	cloud_html => vars->{cloud_html},
     	main_articles => \@articles,
     	seo => $seo_params,
     	pager => $pager,
     };
     
     template 'index', $params;
};

#pagina de detalle de articulo
get  qr{ /([a-z]{2})/(\w+)/([0-9]+)}x => sub {
	my ($lang,$title_slug,$id) = splat;
	
	#seteamos el lenguaje que viene en la url
	$article_service->set_lang($lang);
	
	#recupera los datos para los menus laterales
	&prepare_lateral_menus;

	#detalles del articulo principal
        my $article = $article_service->get_article_by_id($id);
        
        
        my $seo_params = &create_seo_params(
        	$article->{title},
        	$article->{title},
     	        $article->{title}
     	        );
        
     	debug "######### Title:  $article->{title} \n";
     	#parametros que metemos en la request
        my $params = { 
        	articles => vars->{articles}, 
        	categories => vars->{categories}, 
        	cloud_html => vars->{cloud_html},
        	article => $article,
        	seo => $seo_params,
        };
        
        template 'article', $params;
    };
    
    post '/:lang/search' => sub {
    	    my $lang = params->{lang};
    	    #seteamos el lenguaje que viene en la url
	    $article_service->set_lang($lang);
	    
	    #realiza la busqueda por key
    	    my @articles = $article_service->find_articles_by_keyword(params->{keyword});
    	    
    	    #recupera los datos para los menus laterales
	    &prepare_lateral_menus;
    	    
    	    my $seo_params = &create_seo_params(
        	params->{keyword},
        	"Articles about ".params->{keyword},
     	        "Articles about ".params->{keyword}
     	        );
       
	     my $params = { 
		articles => vars->{articles},  
		categories => vars->{categories} , 
		cloud_html => vars->{cloud_html},
		main_articles => \@articles,
		seo => $seo_params,
	     };
	     
	     template 'index', $params
    };
    
    
    ## Crea la pagina de inicio independientemente del idioma
    sub index_page(){
    	     
    	     &prepare_lateral_menus;
    	     
    	     my @random_articles = $article_service->get_random_articles;
	     my $seo_params = &create_seo_params(
		     "Bring Knowledge To You",
		     "linux,oracle,web,IT,mysql,databases",
		     "One Repository for technical documents about Linux, Mysql, Oracle, Open Source, etc. "
		     );
	     
	     my $params = { 
		articles => vars->{articles},  
		categories => vars->{categories} , 
		cloud_html => vars->{cloud_html},
		main_articles => \@random_articles,
		seo => $seo_params
	     };
	     
	     template 'index', $params;	    
    }
    
#Crea un hash con los valores para seo
sub create_seo_params(){
	my ($title,$keywords,$description) = @_;
	{
		title => $title,
		keywords => $keywords,
		description => $description
	}
}

#llamadas a bd para traer los datos de los menus laterales
sub prepare_lateral_menus(){
        my @articles = $article_service->get_last_articles; 
        var articles => \@articles;
        
        my @categories = $article_service->get_categories;
       debug "##### @categories";
        var categories => \@categories;
        
        var cloud_html => $article_service->get_tag_cloud_html;
}

#crea el paginador
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
