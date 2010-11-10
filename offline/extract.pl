#!/usr/bin/perl
use URI;
use Web::Scraper;
require ("dbInit.pl");
use WWW::Mechanize;
use Lingua::Translate;
my $lang = @ARGV[0];
our $BASE = "http://www.ixdba.net";
our $foro = "linux";
our $category_slug = &slug($foro);
my $first = "/a/os/linux/";
#my $first = "/";
our @hechos = &get_lista_query("select url from entries");
our @seguidos;
push (@hechos,$first);
push (@hechos,$BASE);
our $traductor = &config_googletr();
my $mech = WWW::Mechanize->new( autocheck => 1 );
&process_url($first);
print "*** Mostrando la lista de hechos\n";
&ver_lista(@hechos);
print "Mostrando la lista de seguidos\n";
&ver_lista(@seguidos);


sub slug() {
  my $text = shift;
  $text =~s/ /_/g;
  return $text;
}

sub process_url() {
  my $url2do = shift;
  push(@seguidos,$url2do);
  #&do_query("insert into seguidos values ('$url2do')");
  print "**** Entra a process_url($url2do)\n";
  $mech->get($BASE.$url2do);
  sleep(1);
  #my @links = $mech->find_all_links( tag => "a", text_regex => qr/linux/i );
  my @links = $mech->find_all_links( tag => "a", url_regex => qr/\/linux/i);
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
     $url_text = $traductor->translate($url_text);
     $url_text =~s/】 【/ /gi;
     print "Link: $url,$url_text\n"; 
   }
}

sub process_links() {
  print "Entra en process_links\n";
  my $mech_link = WWW::Mechanize->new( autocheck => 1 );
  my @links = @_;
  my $cuantos = @links;
  my $fecha = "2010-11-12";
  print "Procesando $cuantos links\n";
  my $nextlink,$content,$content_5000,$articulo;
  foreach my $link (@links) { 
     my $url_text = $link->text();
     my $url = $link->url();
     $url_text = $traductor->translate($url_text);
     $url_text =~s/】 【/ /gi;
     my $title_slug = &slug($url_text);
     print "Link: $url,$url_text\n"; 
     if (($url =~ /http/) || (grep {$_ eq $url} @hechos) || !($url =~ /\.html/)) { 
        print "-- ERR: $url Rechazada por url\n"; next; 
     }
     sleep(1);
     $mech_link->get($BASE.$url);
     $content = $mech_link->content;
     $articulo = &get_content($content);
     if ($articulo eq "empty") { print "--ERR: Rechazada $url por falta de contenido\n";next; }
     my $art_size = length($articulo); 
     print "El articulo tiene $art_size size\n";
     my $max_google_text = 4999;
     if ($art_size > $max_google_text) {
       print "*** Entrando en articulo mayor de 5000, size: $art_size\n";
       my $articulo_tmp,$articulo_truncate;  
       for($x=0;$x<$art_size;$x=$x+$max_google_text) {
          print "*** Entra en el for truncando articulo desde $x\n";
          $articulo_truncate = substr($articulo,$x,$max_google_text);
          $articulo_tmp = $articulo_tmp . $traductor->translate($articulo_truncate);
          sleep(1);
       } 
       $articulo = $articulo_tmp; 
     }
     else { $articulo = $traductor->translate($articulo); }
     $articulo =~s/'/''/g;
     # Quito el principio basura de ixdba.net (solo para esta web)
     $articulo = &limpia_ixdba($articulo);
     $fecha = &get_fecha($url);
     my $summary = &get_html2text($articulo);
     $summary = &trunca($summary,300);
     &do_query("insert into entries values('','$foro','$category_slug','en','$url','$BASE','$url_text','$title_slug','$fecha','','$articulo','$summary')");
     push(@hechos,$url);
  }
}

sub limpia_ixdba() {
  my $articulo = shift();
  $articulo = substr($articulo,450,length($articulo));
  return($articulo);
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
  my $html = shift;
  my $scraper = scraper {
      process "div.content", "content[]" => 'HTML'; 
  };
  my $content = $scraper->scrape($html);
  
   for my $tweet (@{$content->{content}}) {
      return ($tweet);
  }
  return "empty"; 
}


sub get_html2text {
  my $html = shift;
  my $scraper = scraper {
      process "table", "content[]" => 'TEXT'; 
  };
  my $content = $scraper->scrape($html);
  
   for my $tweet (@{$content->{content}}) {
      return ($tweet);
  }
  return "empty"; 
}

sub config_googletr() {
  Lingua::Translate::config
     (
         back_end => 'Google',
         #api_key  => '',
         referer  => 'http://www.imaginasoft.com/translate/',
         format   => 'text',
         userip   => '192.168.1.1',
     );

  my $googletr = Lingua::Translate->new( src => 'zh-CN', dest => 'en' );
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
   print "Entra en trunca con $tring \n maxsize = $maxlength\n"; 
   $string = substr($string, 0, $maxlength+1);
   die("Can't truncate, no spaces\n") if(index($string, ' ') == -1);
   return substr($string, 0, rindex($string, ' '))."...";
}

