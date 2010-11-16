DROP TABLE IF EXISTS `entradas`;
DROP TABLE IF EXISTS `entries`;
DROP TABLE IF EXISTS `entries_en`;
CREATE TABLE entries_en (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux', 
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_pt (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_es (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_fr (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_bg (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_ca (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_cs (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_da (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_fi (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_gl (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_el (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_nl (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_hu (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_is (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_it (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_no (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_pl (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_sv (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));

CREATE TABLE entries_tr (
  id int(10) unsigned not null auto_increment,
  category varchar(128) not null default 'Linux',
  category_slug varchar(128) not null default 'Linux',
  url varchar(255) not null,
  url_base varchar(255) not null,
  title varchar(255) not null,
  title_slug varchar(255) not null,
  original_date date not null,
  created timestamp default CURRENT_TIMESTAMP,
  content text,
  summary text,
  primary key (id));
