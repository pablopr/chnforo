use DBI;
use DBD::mysql;
my $db = "chnforo";
my $user = "chnuser";
my $pass = "maskayerro";
our $dbh = DBI->connect("dbi:mysql:$db", $user, $pass ) || die( $DBI::errstr . "\n" );

sub do_query {
        my $query = shift;
        my $sth=$dbh->prepare($query);
        $sth->execute();
        $sth->finish();
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
