#!/usr/bin/perl
use URI;
use Web::Scraper;
use WWW::Mechanize;
use Lingua::Translate;
use Encode;
require ("/var/www/knowrepository/offline/dbInit.pl");
binmode( STDIN,  ':utf8' );
binmode( STDOUT, ':utf8' );

my %categories;
my %first;
$categories{'lb'} = "Cluster";
$first{'lb'} = "/a/lb";
$categories{'st'} = "Storage";
$first{'st'} = "/a/st";
$categories{'mz'} = "Clinic";
$first{'mz'} = "/a/mz";
$categories{'IT'} = "IT";
$first{'IT'} = "/a/IT";
$categories{'Solris'} = "Solaris";
$first{'Solris'} = "/a/os/Solris";
$categories{'linux'} = "Linux";
$first{'linux'} = "/a/os/linux";
$categories{'mysql'} = "Mysql";
$first{'mysql'} = "/a/db/mysql";
$categories{'oracle'} = "Oracle";
$first{'oracle'} = "/a/db/oracle";
$categories{'apache'} = "Apache";
$first{'apache'} = "/a/web/apache";
$categories{'tomcat'} = "Tomcat";
$first{'tomcat'} = "/a/web/tomcat";
$categories{'nginx'} = "Nginx";
$first{'nginx'} = "/a/web/nginx";



our @langs = ("en","pt","es","fr","ca","da","fi","gl","nl","is","it","no","sv");
our $BASE = "http://www.ixdba.net";
our @hechos = &get_lista_query("select url from entries_en");
our @seguidos;
my $mech = WWW::Mechanize->new( autocheck => 1 );

foreach my $key (%categories) {
  print "Starting with Foro = $categories{$key} Path = $key\n";
  my $foro = $categories{$key};
  my $primero = $first{$key};
  &process_url($primero,$key,$foro);
}
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
  my $patron_url = shift;
  my $foro = shift;
  push(@seguidos,$url2do);
  print "**** Entra a process_url($url2do) con foro = $foro y patron = $patron_url\n";
  $mech->get($BASE.$url2do);
  sleep(1);
  #my @links = $mech->find_all_links( tag => "a", text_regex => qr/linux/i );
  my @links = $mech->find_all_links( tag => "a", url_regex => qr/\/$patron_url/i);
  #&ver_links(@links);die;
  &process_links($foro,@links);
  foreach $link (@links) {
     $url = $link->url();
     print "Analizando url = $url\n"; 
     if (($url =~ /http/) || (grep {$_ eq $url} @seguidos) || ($url =~/ftp:/))  { print "Se descarta $url\n"; next; }
     &process_url($url,$patron_url,$foro);
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
  my $foro = shift;
  my $category_slug = &slug($foro);
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
          $text_tmp = $text_tmp . $traducido;
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

