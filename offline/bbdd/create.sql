--drop table entradas;
create table entradas(
  id int(10) unsigned not null auto_increment,
  foro varchar(20) not null default 'linux', 
  lang varchar(20) not null default 'en',
  url varchar(255) not null,
  url_text varchar(255) not null,
  fecha date not null,
  creado timestamp default CURRENT_TIMESTAMP,
  texto text,
  primary key (id))
  
