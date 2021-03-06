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

DROP TABLE IF EXISTS `entries_pt`;
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

DROP TABLE IF EXISTS `entries_es`;
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

DROP TABLE IF EXISTS `entries_fr`;
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

DROP TABLE IF EXISTS `entries_bg`;

DROP TABLE IF EXISTS `entries_ca`;
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

DROP TABLE IF EXISTS `entries_cs`;

DROP TABLE IF EXISTS `entries_da`;
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

DROP TABLE IF EXISTS `entries_fi`;
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

DROP TABLE IF EXISTS `entries_gl`;
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

DROP TABLE IF EXISTS `entries_el`;

DROP TABLE IF EXISTS `entries_nl`;
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

DROP TABLE IF EXISTS `entries_hu`;

DROP TABLE IF EXISTS `entries_is`;
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

DROP TABLE IF EXISTS `entries_it`;
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

DROP TABLE IF EXISTS `entries_no`;
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

DROP TABLE IF EXISTS `entries_pl`;

DROP TABLE IF EXISTS `entries_sv`;
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

DROP TABLE IF EXISTS `entries_tr`;


DROP TABLE IF EXISTS `tags_en`;
CREATE TABLE tags_en (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
DROP TABLE IF EXISTS `tags_pt`;
CREATE TABLE tags_pt (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_es`;
CREATE TABLE tags_es (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_fr`;
CREATE TABLE tags_fr (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_bg`;
  DROP TABLE IF EXISTS `tags_ca`;
CREATE TABLE tags_ca (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_cs`;
  DROP TABLE IF EXISTS `tags_da`;
CREATE TABLE tags_da (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_fi`;
CREATE TABLE tags_fi (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_gl`;
CREATE TABLE tags_gl (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_el`;
  DROP TABLE IF EXISTS `tags_nl`;
CREATE TABLE tags_nl (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_hu`;
  DROP TABLE IF EXISTS `tags_is`;
CREATE TABLE tags_is (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_it`;
CREATE TABLE tags_it (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_no`;
CREATE TABLE tags_no (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_pl`;
  DROP TABLE IF EXISTS `tags_sv`;
CREATE TABLE tags_sv (
  id int(10) unsigned not null auto_increment,
  tag varchar(128) not null,
  density int(10) unsigned not null,
  primary key (id));
  DROP TABLE IF EXISTS `tags_tr`;
