#!/usr/bin/perl
require 'cassandraDb-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);


my @sites = list_cassandraDb_websites();
my @table = ( );
foreach my $s (@sites) {
	push(@table, [ "<a href='edit.cgi?domain=".urlize($s->{'domain'}).
		       "'>".html_escape($s->{'domain'})."</a>",
		       html_escape($s->{'directory'})
		     ]);
	}


print ui_buttons_start();
print ui_buttons_row('start.cgi', 'Calistir', 'Cassandra db başlat');
print ui_buttons_row('stop.cgi', 'Durdur', 'Casssandra db durdur');
print ui_buttons_end(); 

ui_print_footer('/', $text{'index'});

