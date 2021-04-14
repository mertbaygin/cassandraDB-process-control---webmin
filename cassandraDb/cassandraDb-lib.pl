=head1 cassandraDb-lib.pl
=cut

use WebminCore;
init_config();

=head2 list_cassandraDb_websites()


=cut
sub list_cassandraDb_websites
{
my @rv;
my $lnum = 0;
open(CONF, $config{'cassandraDb_conf'});
while(<CONF>) {
	s/\r|\n//g;
	s/#.*$//;
	my ($dom, $dir) = split(/\s+/, $_);
	if ($dom && $dir) {
		push(@rv, { 'domain' => $dom,
			    'directory' => $dir,
			    'line' => $lnum });
		}
	$lnum++;
	}
close(CONF);
return @rv;
}

=head2 create_cassandraDb_website(&site)

=cut
sub create_cassandraDb_website
{
my ($site) = @_;
open_tempfile(CONF, ">>$config{'cassandraDb_conf'}");
print_tempfile(CONF, $site->{'domain'}." ".$site->{'directory'}."\n");
close_tempfile(CONF);
}

=head2 modify_cassandraDb_website(&site)

=cut
sub modify_cassandraDb_website
{
my ($site) = @_;
my $lref = read_file_lines($config{'cassandraDb_conf'});
$lref->[$site->{'line'}] = $site->{'domain'}." ".$site->{'directory'};
flush_file_lines($config{'cassandraDb_conf'});
}

=head2 delete_cassandraDb_website(&site)

=cut

sub delete_cassandraDb_website
{
my ($site) = @_;
my $lref = read_file_lines($config{'cassandraDb_conf'});
splice(@$lref, $site->{'line'}, 1);
flush_file_lines($config{'cassandraDb_conf'});
}

=head2 apply_configuration()
=cut
sub apply_configuration
{
kill_byname_logged('HUP', 'cassandra');
}

1;

sub stop_cassandra
{
local $out;
if ($config{'stop_cmd'}) {
        # use the configured stop command
        $out = &backquote_logged("($config{'stop_cmd'}) 2>&1");
        if ($?) {
                return "<pre>".&html_escape($out)."</pre>";
                }
        }
return undef;
}


sub start_cassandra
{
local $out;
if ($config{'start_cmd'}) {
        $out = &backquote_logged("($config{'start_cmd'}) 2>&1");
        if ($?) {
                return "<pre>".&html_escape($out)."</pre>";
                }
        }
return undef;
}
