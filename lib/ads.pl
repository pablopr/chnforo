sub get_ads{
  my %ads;
  $ads{'Solaris'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=solaris&a_aid=qe5zt"><img style="border:0" src="/images/ads_solaris.png" width="150" height="942" alt="Solaris Books"></a>

print_tag

  $ads{'Linux'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=linux&a_aid=qe5zt"><img style="border:0" src="/images/ads_linux.png" width="150" height="942" alt="Linux Books">
</a>
print_tag

  $ads{'Cluster'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=linux+cluster&a_aid=qe5zt"><img style="border:0" src="/images/ads_cluster.png" width="150" height="942" alt="Cluster Books"></a>	
print_tag

  $ads{'Apache'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=apache+web&a_aid=qe5zt"><img style="border:0" src="/images/ads_apache.png" width="150" height="942" alt="Apache Books">
</a>
print_tag

  $ads{'Oracle'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=oracle+database&a_aid=qe5zt"><img style="border:0" src="/images/ads_oracle.png" width="150" height="942" alt="Oracle Books">
</a>
print_tag

  $ads{'IT'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=open+source&a_aid=qe5zt"><img style="border:0" src="/images/ads_it.png" width="150" height="942" alt="IT Books">
</a>
print_tag

  $ads{'Mysql'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=mysql&a_aid=qe5zt"><img style="border:0" src="/images/ads_mysql.png" width="150" height="942" alt="Mysql Books">
</a>
print_tag

  $ads{'Tomcat'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=apache+tomcat&a_aid=qe5zt"><img style="border:0" src="/images/ads_tomcat.png" width="150" height="942" alt="Tomcat Books">
</a>
print_tag

  $ads{'Clinic'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=open+source&a_aid=qe5zt"><img style="border:0" src="/images/ads_it.png" width="150" height="942" alt="Clinic Books">
</a>
print_tag

 $ads{'Nginx'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=open+source&a_aid=qe5zt"><img style="border:0" src="/images/ads_it.png" width="150" height="942" alt="Open Source Books">
</a>
print_tag

$ads{'Storage'} = <<print_tag;
<a href="http://www.bookdepository.co.uk/search?searchTerm=open+source&a_aid=qe5zt"><img style="border:0" src="/images/ads_it.png" width="150" height="942" alt="Open Source Books">
</a>
print_tag



return %ads;

}
true;
