package Service::Article;
use Dancer::Plugin::Database;

sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}


sub get_article_by_id{
  my $self = shift;
  my $id = shift;
  my $sth = database->prepare(
            'select * from entradas where id = ?',);
  $sth->execute($id);
  $sth->fetchrow_hashref;
}


sub get_last_articles{
  my $self = shift;
  my $sth = database->prepare('SELECT id,url_text from entradas order by fecha limit 20');
  $sth->execute();
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub get_random_articles{
  my $self = shift;
  my $sth = database->prepare('SELECT id,url_text,texto from entradas order by rand() limit 20');
  $sth->execute();
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub get_articles_by_category{
  my $self = shift;
  my $category_name = shift;
  my $sth = database->prepare('SELECT id,url_text,texto from entradas where foro=? order by fecha limit 20',);
  $sth->execute($category_name);
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub get_categories{
  my $self = shift;
  my $sth = database->prepare('SELECT distinct(foro) from entradas');
  $sth->execute();
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	  push(@hash_ref_list,$row->{foro});
  }
    
  return @hash_ref_list;  
}


1;
