#!/usr/bin/env perl
use strict;
require ("dbInit.pl");


&alter_table($_) for qw(en pt es fr ca da fi gl nl is it no sv);

sub alter_table{
	my $lang = shift;
	&do_query('ALTER TABLE entries_'.$lang.' ADD posted boolean NOT NULL default false');
}

1;
