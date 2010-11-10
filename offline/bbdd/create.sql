DROP TABLE IF EXISTS `entradas`;
DROP TABLE IF EXISTS `entries`;
CREATE TABLE entries(
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux', 
  category_slug varchar(128) not null default 'Linux',
  lang varchar(20) not null default 'en',
  url varchar(255) not null,
  url_text varchar(255) not null,
  url_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  primary key (id));
