package Service::Article;
use Dancer::Plugin::Database;
use Dancer ':syntax';

sub new {
  my $class = shift;
  my $self = {
  	  lang => 'en'
  };
  bless $self, $class;
  return $self;
}

sub set_lang{
 my $self = shift;
 my $lang = shift;
 $self->{lang} = $lang;
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
   	   'select id,title,title_slug from entries_'.$self->{lang}.' where id = ?',);
  $sth->execute($id);
  $sth->fetchrow_hashref;
  
}

sub get_by_id{
  my $self = shift;
  my $id = shift;
  my $sth = database->prepare(
            'select * from entries_'.$self->{lang}.' where id = ?',);
  $sth->execute($id);
  $sth->fetchrow_hashref;
}


sub get_last_articles{
  my $self = shift;
  my $sth = database->prepare('SELECT id,title,title_slug from entries_'.$self->{lang}.' order by created limit 30');
  $sth->execute();
  my @hash_ref_list= ();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub get_random_articles{
  my $self = shift;
  my $sth = database->prepare('SELECT id,title,title_slug,summary from entries_'.$self->{lang}.' order by rand() limit 30');
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
  my $sth = database->prepare('SELECT id,title,title_slug,summary from entries_'.$self->{lang}.' where category=? order by created limit 30',);
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
  my $sth = database->prepare('SELECT id,title,title_slug,summary from entries_'.$self->{lang}.' where title like ? order by created limit 40',);
  #my $sth = database->prepare("SELECT id,title,title_slug,summary FROM from entries_$self->{lang} WHERE MATCH (title) AGAINST (?  in boolean mode)",);
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
  database->selectrow_array('SELECT count(*) from entries_'.$self->{lang}.' where category=?',undef,$category_name);
}

sub count_articles{
  my $self = shift;
  database->selectrow_array('SELECT count(*) from entries_'.$self->{lang}.'');
}
sub get_categories{
  my $self = shift;
  my $sth = database->prepare('SELECT distinct(category) from entries_'.$self->{lang}.'');
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
  my $sth = database->prepare("SELECT * FROM entries_$self->{lang} where category=? ORDER BY id DESC LIMIT ?,?"); 
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
  my $sth = database->prepare("SELECT id,title,title_slug FROM entries_$self->{lang} ORDER BY id DESC LIMIT ?,?"); 
  $sth->execute($cursor,$num_per_page+1);
  
  my @hash_ref_list= ();
  while (my $row = $sth->fetchrow_hashref()) {
  	push(@hash_ref_list,$row);
  }
    
  return @hash_ref_list;  
}

sub get_tag_cloud_html{
  my $self = shift;
  my $cloud = HTML::TagCloud->new();
  
  my $sth = database->prepare("SELECT tag,density FROM tags_$self->{lang}"); 
  $sth->execute();
  
  while (my $row = $sth->fetchrow_hashref()) {
  	my $url = "/$self->{lang}/tag/$row->{tag}";
  	$cloud->add($row->{tag}, $url, $row->{density});
  }
  
  $cloud->html_and_css(100);
}

1;
