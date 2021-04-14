#!/usr/bin/perl
# Create, update or delete a website

require 'cassandraDb-lib.pl';
ReadParse();
error_setup($text{'save_err'});
lock_file($config{'cassandraDb_conf'});

# Get the old site object
if (!$in{'new'}) {
	my @sites = list_cassandraDb_websites();
        ($site) = grep { $_->{'domain'} eq $in{'old'} } @sites;
	$site || error($text{'save_egone'});
	}

if ($in{'delete'}) {
	# Just delete it
	delete_cassandraDb_website($site);
	}
else {
	# Validate inputs
	$in{'domain'} =~ /^[a-z0-9\.\-\_]+$/i ||
		error($text{'save_edomain'});
	$in{'directory'} =~ /^\// ||
		error($text{'save_edirectory'});
	-d $in{'directory'} ||
		error($text{'save_edirectory2'});
	$site->{'domain'} = $in{'domain'};
	$site->{'directory'} = $in{'directory'};

	# Update or create
	if ($in{'new'}) {
		create_cassandraDb_website($site);
		}
	else {
		modify_cassandraDb_website($site);
		}
	}

# Log the change
unlock_file($config{'cassandraDb_conf'});
apply_configuration();
webmin_log($in{'new'} ? 'create' :
	   $in{'delete'} ? 'delete' : 'modify',
	   'site',
	   $site->{'domain'});
&redirect('');

