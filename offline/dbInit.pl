use DBI;
use DBD::mysql;
my $db = "chnforo";
my $user = "chnuser";
my $pass = "maskayerro";
our $dbh = DBI->connect("dbi:mysql:$db",$user,$pass ) || die( $DBI::errstr . "\n" );
$dbh->{'mysql_enable_utf8'} = 1;
$dbh->do("SET NAMES 'utf8'");
$dbh->do("SET CHARACTER SET 'utf8'");

sub do_query {
        my $query = shift;
        my $sth=$dbh->prepare($query);
        $sth->execute();
        $sth->finish();
}

sub get_hash_ref_query{
 my $query = shift;
 my $sth=$dbh->prepare($query);
 $sth->execute();
 $sth->fetchrow_hashref;
}

sub get_lista_query {
  my $query = shift;
  my $sth=$dbh->prepare($query);
  $sth->execute();
  my $fila;
  my @lista;
  while ($fila=$sth->fetchrow()) {
    push (@lista,$fila);
  }
  return(@lista);
}


sub get_lista_hashref_query {
  my $query = shift;
  my $sth=$dbh->prepare($query);
  $sth->execute();
   my @hash_ref_list= ();
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}


