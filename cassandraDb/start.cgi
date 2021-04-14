#!/usr/bin/perl

require './cassandraDb-lib.pl';
system("service cassandra start")
&webmin_log("stop");
&redirect($in{'redir'});

