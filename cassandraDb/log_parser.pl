do 'cassandraDb-lib.pl';

=head2 parse_webmin_log(user, script, action, type, object, &params)
=cut

sub parse_webmin_log
{
my ($user, $script, $action, $type, $object, $p) = @_;
return &text('log_'.$action, '<tt>'.html_escape($object).'</tt>');
}

