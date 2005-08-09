package Querylet::CGI::Auto;
use base qw(Querylet::Input);

use warnings;
use strict;

=head1 NAME

Querylet::CGI::Auto - run a querylet as context suggests

=head1 VERSION

version 0.12

 $Id: Auto.pm,v 1.1 2004/09/20 18:40:20 rjbs Exp $

=cut

our $VERSION = '0.12';

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

=head1 METHODS

=over 4

=item C<< default_type >>

Querylet::CGI::Auto acts as a Querylet::Input module, and registers itself as
an input handler when used.  The default type to register is 'auto'

=cut

sub default_type { 'auto' }

=item C<< handler >>

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

=back

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-querylet-cgi@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2004 Ricardo SIGNES, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
