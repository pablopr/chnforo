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
  my $hash_ref = $self->get_by_id($id);
  my ($prev,$next) = $self->get_prev_next_by_id($id);
  $hash_ref->{prev} = $prev;
  $hash_ref->{next} = $next;
  return $hash_ref;
}

sub get_prev_next_by_id{
  my $self = shift;
  my $id = shift;
  my $prev = $self->get_title_by_id($id-1);
  my $next = $self->get_title_by_id($id+1);
  
  return ($prev,$next);
}

sub get_title_by_id{
  my $self = shift;
  my $id = shift;
   my $sth = database->prepare(
            'select id,title,title_slug from entries where id = ?',);
  $sth->execute($id);
  $sth->fetchrow_hashref;
  
}

sub get_by_id{
  my $self = shift;
  my $id = shift;
  my $sth = database->prepare(
            'select * from entries where id = ?',);
  $sth->execute($id);
  $sth->fetchrow_hashref;
}


sub get_last_articles{
  my $self = shift;
  my $sth = database->prepare('SELECT id,title,title_slug from entries order by created limit 20');
  $sth->execute();
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub get_random_articles{
  my $self = shift;
  my $sth = database->prepare('SELECT id,title,title_slug,summary from entries order by rand() limit 30');
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
  my $sth = database->prepare('SELECT id,title,title_slug,summary from entries where category=? order by created limit 30',);
  $sth->execute($category_name);
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub find_articles_by_keyword{
  my $self = shift;
  my $keyword = shift;
  my $sth = database->prepare('SELECT id,title,title_slug,summary from entries where title like ? order by created limit 30',);
  $sth->execute('%'.$keyword.'%');
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub count_articles_by_category{
  my $self = shift;
  my $category_name = shift;
  database->selectrow_array('SELECT count(*) from entries where category=?',undef,$category_name);
}

sub count_articles{
  my $self = shift;
  database->selectrow_array('SELECT count(*) from entries');
}
sub get_categories{
  my $self = shift;
  my $sth = database->prepare('SELECT distinct(category) from entries');
  $sth->execute();
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	  push(@hash_ref_list,$row->{category});
  }
    
  return @hash_ref_list;  
}

sub get_paginated_articles_by_category {
  my $self = shift;
  my $category_name = shift;
  my $page = shift;
  my $num_per_page = shift;
  my $cursor = ($page-1) * $num_per_page; 
  my $sth = database->prepare("SELECT * FROM entries where category=? ORDER BY id DESC LIMIT ?,?"); 
  $sth->execute($category_name,$cursor,$num_per_page+1);
  
  my @hash_ref_list= ();
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub get_paginated_articles {
  my $self = shift;
  my $page = shift;
  my $num_per_page = shift;
  my $cursor = ($page-1) * $num_per_page; 
  my $sth = database->prepare("SELECT id,title,title_slug FROM entries ORDER BY id DESC LIMIT ?,?"); 
  $sth->execute($cursor,$num_per_page+1);
  
  my @hash_ref_list= ();
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

1;
