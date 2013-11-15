use strict;
use warnings;
package Querylet::CGI::Auto;
use parent qw(Querylet::Input);
# ABSTRACT: run a querylet as context suggests

=head1 SYNOPSIS

 use Querylet;
 use Querylet::CGI::Auto;
 use Querylet::Output::Text;

 query:
   SELECT firstname, age
   FROM people
   WHERE lastname = ?
   ORDER BY firstname
 
 input type: auto
 output format: text

 input: lastname

 query parameter: $input->{lastname}

=head1 DESCRIPTION

Querylet::CGI::Auto registers the "auto" input handler, which will use "cgi" if
the GATEWAY_ENVIRONMENT environment variable is set, and "term" otherwise.
Since Querylet::CGI will set the output format on its own, the output format
should be set to the type to be used if running outside of a CGI environment.

=method default_type

Querylet::CGI::Auto acts as a Querylet::Input module, and registers itself as
an input handler when used.  The default type to register is 'auto'

=cut

sub default_type { 'auto' }

=method handler

The default registered handler will (ack!) use magic goto to switch to the
correct handler, based on the environment.

=cut

sub handler { \&_auto_cgi }

sub _auto_cgi {
	if ($ENV{GATEWAY_INTERFACE}) {
		require Querylet::CGI;
		goto &Querylet::CGI::_from_cgi;
	} else {
		goto &Querylet::Query::from_term;
	}
}

1;
