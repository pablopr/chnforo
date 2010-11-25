#!/usr/bin/env perl
use strict;
use XML::Writer;
use IO;
require ("dbInit.pl");
  
  #creamos el primer sitemap
  &create_xml();
  
  #creamos los siguientes sitemaps si existen
  my $count = &create_next_sitemaps();
  
  &create_index_sitemap($count);
  
  sub create_index_sitemap{
  	my $count = shift;
        my $file = new IO::File(">../public/sitemap.xml");
	my $writer = XML::Writer->new(OUTPUT => $file);
	#my $writer = XML::Writer->new();
	$writer->xmlDecl();
	$writer->startTag('sitemapindex',
		 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9");
		  for (my $i=1; $i<$count ; $i++){
			      $writer->startTag('sitemap');
					$writer->startTag('loc');
						$writer->characters("http://www.knowrepository.com/sitemap_$i.xml");
					$writer->endTag('loc');  
					$writer->startTag('lastmod');
						#my $now = localtime time;
						$writer->characters('2010-11-23');
					$writer->endTag('lastmod');
			      $writer->endTag('sitemap');
		      }	
	$writer->endTag('sitemapindex');
	$writer->end();
	$file->close();
  }
  
  sub create_next_sitemaps{
     my $start = 2500;
     my $count = 2500;
     my $i = 2;
     while($count == 2500){
     	$count = &create_general_xml($start,$i);
     	$start =  $start+ $count;
     	$i++;
     }
     return $i;
  }
  
  sub add_all_url(){
  	  my $writer =shift;
      my $lang = shift;
      
      my @pages = ("tags","sitemap");
      
      for my $page(@pages){
      	      $writer->startTag('url');
			$writer->startTag('loc');
				$writer->characters("http://www.knowrepository.com/$lang/$page/");
			$writer->endTag('loc');  
			$writer->startTag('lastmod');
				$writer->characters('2010-11-11');
			$writer->endTag('lastmod');
			$writer->startTag('changefreq');
				$writer->characters('daily');
			$writer->endTag('changefreq');
			$writer->startTag('priority');
				$writer->characters(0.9);
			$writer->endTag('priority');
	      $writer->endTag('url');
      }
      
        my $start = 0;
     	&add_articles_urls_paginated($writer,$start,$lang);
  }
  
  sub add_articles_urls_paginated{
      my ($writer,$start,$lang) = @_;
      my @articles = &get_articles($lang,$start);
      
      my $count = 0;
      for my $article(@articles){
	 	 &add_url($writer,$lang,$article);
	 	 $count ++;
      }
      print "######### $count #### \n";
      return $count;
  }
  
  sub add_url(){
      my $writer =shift;
      my $lang = shift;  
      my $article = shift;
      
      $writer->startTag('url');
			$writer->startTag('loc');
			$writer->characters("http://www.knowrepository.com/$lang/$article->{title_slug}/$article->{id}");
			$writer->endTag('loc');  
			$writer->startTag('lastmod');
				$writer->characters($article->{original_date});
			$writer->endTag('lastmod');
			$writer->startTag('changefreq');
				$writer->characters('monthly');
			$writer->endTag('changefreq');
    $writer->endTag('url');
  }
  
  
  
  sub create_xml(){
        my $file = new IO::File(">../public/sitemap_1.xml");
    
	my $writer = XML::Writer->new(OUTPUT => $file);
	#my $writer = XML::Writer->new();
	$writer->xmlDecl();
	$writer->startTag('urlset',
		 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9");
	          $writer->startTag('url');
			$writer->startTag('loc');
				$writer->characters("http://www.knowrepository.com/");
			$writer->endTag('loc');  
			$writer->startTag('lastmod');
				$writer->characters('2010-11-11');
			$writer->endTag('lastmod');
			$writer->startTag('changefreq');
				$writer->characters('daily');
			$writer->endTag('changefreq');
			$writer->startTag('priority');
				$writer->characters(1.0);
			$writer->endTag('priority');
	          $writer->endTag('url');
		  # Add top urls by language
		  my $count = &add_all_url($writer,$_) for qw(en pt es fr ca da fi gl nl is it no sv);
		
	$writer->endTag('urlset');
	
	$writer->end();
	
	$file->close();
	
	return $count;
}


  sub create_general_xml(){
  	my $start = shift;
  	my $count = shift;
        my $file = new IO::File(">../public/sitemap_$count.xml");
        print "######### creando sitemap_$count.xml #### \n";
    
	my $writer = XML::Writer->new(OUTPUT => $file);
	#my $writer = XML::Writer->new();
	$writer->xmlDecl();
	$writer->startTag('urlset',
		 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9");
		  my $count = &add_articles_urls_paginated($writer,$start,$_) for qw(en pt es fr ca da fi gl nl is it no sv);
	$writer->endTag('urlset');
	$writer->end();
	$file->close();
	return $count;
}


sub get_articles{
  my $lang = shift;
  my $start = shift;
  #el tamaño max es 50000 entre el numero de idiomas
  my $size=2500;
  &get_lista_hashref_query('SELECT * from entries_'.$lang.' ORDER BY id DESC LIMIT '.$start.' , '.$size);
}
1;
