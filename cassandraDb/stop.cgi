#!/usr/bin/perl

require './cassandraDb-lib.pl';
system("service cassandra stop")
&webmin_log("stop");
&redirect($in{'redir'});

