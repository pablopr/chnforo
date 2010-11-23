#!/usr/bin/perl
use URI;
use Web::Scraper;
require ("dbInit.pl");
use WWW::Mechanize;
use Lingua::Translate;
my $lang = @ARGV[0];
our %categories;
$categories{'lb'} = "Cluster Technology";
$categories{'st'} = "Storage";
$categories{'mz'} = "Technology Clinic";
our @langs = ("en","pt","es","fr","bg","ca","cs","da","fi","gl","el","nl","hu","is","it","no","pl","sv","tr");
#our @langs = ("en","es");
our $BASE = "http://www.ixdba.net";
our $foro = "Solaris";
our $category_slug = &slug($foro);
my $first = "/a/os/Solris";
#my $first = "/";
our @hechos = &get_lista_query("select url from entries_en");
our @seguidos;
my $mech = WWW::Mechanize->new( autocheck => 1 );
&process_url($first);
print "*** Mostrando la lista de hechos\n";
&ver_lista(@hechos);
print "Mostrando la lista de seguidos\n";
&ver_lista(@seguidos);


sub slug() {
  my $text = shift;
  $text =~s/ /_/g;
  $text =~s/\W//g;
  return $text;
}

sub process_url() {
  my $url2do = shift;
  push(@seguidos,$url2do);
  print "**** Entra a process_url($url2do)\n";
  $mech->get($BASE.$url2do);
  sleep(1);
  #my @links = $mech->find_all_links( tag => "a", text_regex => qr/linux/i );
  my @links = $mech->find_all_links( tag => "a", url_regex => qr/\/Solris/i);
  #&ver_links(@links);die;
  &process_links(@links);
  foreach $link (@links) {
     $url = $link->url();
     print "Analizando url = $url\n"; 
     if (($url =~ /http/) || (grep {$_ eq $url} @seguidos))  { print "Se descarta $url\n"; next; }
     &process_url($url);
  }
  print "SE termina una rama!!!\n";
  return;
}

sub ver_links() {
  my @links = @_;
  foreach my $link (@links) { 
     my $url_text = $link->text();
     my $url = $link->url();
     print "Url_text antes traducir: $url_text\n";
     $url_text = $traductor->translate($url_text);
     $url_text =~s/】 【/ /gi;
     print "Link: $url,$url_text\n"; 
   }
}

sub process_links() {
  my $mech_link = WWW::Mechanize->new( autocheck => 1 );
  my @links = @_;
  my $cuantos = @links;
  my $fecha = "2010-11-12";
  print "Procesando $cuantos links\n";
  foreach my $link (@links) { 
     my $url_text = $link->text();
     my $url = $link->url();
     if (($url =~ /http/) || (grep {$_ eq $url} @hechos) || !($url =~ /\.html/)) { 
        print "-- ERR: $url Rechazada por url\n"; next; 
     }
     $fecha = &get_fecha($url);
     $mech_link->get($BASE.$url);
     my $content = $mech_link->content;
     my $articulo = &get_content("HTML",$content);
     my $articulo_text = &get_content("TEXT",$content);
     #print "Articulo original = $articulo\n";
     #print "Articulo texto = $articulo_text\n";
     if (($articulo eq "empty") || ($articulo_text eq "empty")) { print "--ERR: Rechazada $url por falta de contenido\n";next; }
     my $size = length($articulo);
            
     # do it for every languages
     foreach my $lang (@langs)  {
        print "*** Traduciendo a $lang\n";
        my $url_text_lang = &traduce($lang,$url_text);
        $url_text_lang =~s/】 【/ /gi;
        my $title_slug = &slug($url_text_lang);
        print "Link: $url,$url_text_lang\n"; 
        my $articulo_lang = &traduce($lang,$articulo);
        $articulo_lang =~s/'/''/g;
        #print "Articulo traducido = $articulo_lang\n";
        my $summary = &html2text($articulo_lang);
        #print "Summary = $summary\n";
        if (length($summary) > 300) {
          $summary = &trunca($summary,300);
        }
        my $summary_short = $summary;
        if (length($summary_short) > 50) {
          $summary_short = &trunca($summary,50);
        }
        if ($url_text_lang eq "[IMG]") {
         #print "*** viene con IMG original es $url_text\n"; 
         $url_text_lang = $summary_short; 
         $title_slug = &slug($url_text_lang);
        }
        &do_query("insert into entries_$lang values('','$foro','$category_slug','$url','$BASE','$url_text_lang','$title_slug','$fecha',null,'$articulo_lang','$summary')");
        sleep(1);
     }
     push(@hechos,$url);
  }
}

sub traduce() {
  my $lang = shift;
  my $text = shift;
  my $traductor = &config_googletr($lang);
  my $text_size = length($text); 
  my $text_tmp,$text_truncate;  
  my $max_google_text = 4999;
  if ($text_size > $max_google_text) {
       for($x=0;$x<$text_size;$x=$x+$max_google_text) {
          $text_truncate = substr($text,$x,$max_google_text);
          $text_tmp = $text_tmp . $traductor->translate($text_truncate);
          sleep(1);
       } 
       $text = $text_tmp; 
     }
   else { $text = $traductor->translate($text); }
   return $text;
}

sub get_fecha() {
  my $url = shift;
  print "-- FECHA: Entra en get_fecha con url = $url\n";
  my $year = "2010";
  my $mes = "11";
  my $dia = "12";
  my @lista = split("\/",$url);
  my $cuantos = @lista;
  print "-- FECHA: cuantos: $cuantos\n";
  for ($i = 0;$i<$cuantos;$i++) {
    if (($lista[$i] eq "2010") || ($lista[$i] eq "2009") || ($lista[$i] eq "2008")) {
     $year = $lista[$i]; 
     $mes = substr($lista[$i+1],0,2);
     $dia = substr($lista[$i+1],2,2);
    }
  }
  return("$year-$mes-$dia");
}

sub url_invalida() {
  my $url = shift;
   if  (!($url =~ /\/a\/os\/linux\//) || ($url =~ /http/) ) {
       return 1;
     }
  return 0;
}

sub get_content() {
  my $tipo = shift;
  my $html = shift;
  my $scraper = scraper {
      process "div.content", "content[]" => scraper {
        process "td",table =>"$tipo";
      } 
  };
  my $content = $scraper->scrape($html);
  
   for my $tweet (@{$content->{content}}) {
      return ($tweet->{table});
  }
  return "empty"; 
}

sub html2text() {
  my $html = shift;
  my $scraper = scraper {
    process ".",texto => 'TEXT';
  };
  my $content = $scraper->scrape($html);
  return $content->{texto};
}


sub config_googletr() {
  my $lang = shift;
  Lingua::Translate::config
     (
         back_end => 'Google',
         #api_key  => '',
         referer  => 'http://www.imaginasoft.com/translate/',
         format   => 'text',
         userip   => '192.168.1.1',
     );

  my $googletr = Lingua::Translate->new( src => 'zh-CN', dest => "$lang" );
  return ($googletr);
}


sub ver_lista() {
  my @lista = @_;
  my $cuantos = @lista;
  my $c = 1;
  print "La lista tiene $cuantos elementos\n";
  foreach my $elemento (@lista) {
    print "Elemento $c: $elemento \n";$c++;
  }
}

sub trunca() {
   my($string, $maxlength) = @_;
   $string = substr($string, 0, $maxlength+1);
   die("Can't truncate, no spaces\n") if(index($string, ' ') == -1);
   return substr($string, 0, rindex($string, ' '));
}

