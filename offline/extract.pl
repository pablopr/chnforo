#!/usr/bin/perl
use URI;
use Web::Scraper;
require ("dbInit.pl");
use WWW::Mechanize;
use Lingua::Translate;
my $lang = @ARGV[0];
our $BASE = "http://www.ixdba.net";
our $foro = "linux";
my $first = "/a/os/linux/list_11_6.html";
#my $first = "/";
our @hechos = &get_lista_query("select url from entradas");
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
     print "Link: $url,$url_text\n"; 
     if (($url =~ /http/) || (grep {$_ eq $url} @hechos) || !($url =~ /\.html/)) { 
        print "-- ERR: $url Rechazada por url\n"; next; 
     }
     sleep(1);
     $mech_link->get($BASE.$url);
     $content = $mech_link->content;
     $articulo = &get_content($content);
     if ($articulo eq "empty") { print "--ERR: Rechazada $url por falta de contenido\n";next; }
     $content_5000 = substr($articulo,0,4999);
     $content = $traductor->translate($content_5000);
     $content =~s/'/''/g;
     $fecha = &get_fecha($url);
     &do_query("insert into entradas values('','$foro','en','$url','$url_text','$fecha','','$content')");
     push(@hechos,$url);
  }
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
