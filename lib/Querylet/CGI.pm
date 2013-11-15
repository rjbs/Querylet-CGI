use strict;
use warnings;
package Querylet::CGI;
use parent 'Querylet::Input';
# ABSTRACT: turn a querylet into a web application

use CGI qw/param/;

=head1 SYNOPSIS

 use Querylet;
 use Querylet::CGI;

 query:
   SELECT firstname, age
   FROM people
   WHERE lastname = ?
   ORDER BY firstname
 
 input type: cgi

 input: lastname

 query parameter: $input->{lastname}

=head1 DESCRIPTION

Querylet::CGI provides an input handler for Querylet, retrieving input
parameters from the CGI environment.  If not all required inputs are found, it
changes the Query object's output type, causing it to produce a form requesting
the required input parameters.

=method default_type

Querylet::CGI acts as a Querylet::Input module, and registers itself as an
input handler when used.  The default type to register is 'cgi'

=cut

sub default_type { 'cgi' }

=method handler

The default registered handler will retrieve parameters from the CGI
environment using the CGI module.

=cut

sub handler { \&_from_cgi }

sub _from_cgi {
	my $q = shift;
	my $parameter = shift;
	if (defined param($parameter)) {
		$q->{input}->{$parameter} = param($parameter);
		$q->output_type('cgi_html_table')
			unless ($q->output_type eq 'cgi_html_form');
	} else {
		$q->{input}->{$parameter} = undef;
		$q->output_type('cgi_html_form');
	}
}

Querylet::Query->register_output_handler(cgi_html_form => \&_as_form);
sub _as_form {
	my $q = shift;
	my $form = "Content-type: text/html\n\n";
	$form .= "<html><head><title>querylet input required</title></head>";
	$form .= "<body><form><table>";
	$form .= "<tr><th>$_</th><td><input name='$_' value='"
		. (defined param($_) ? param($_) : '')
		. "' /></td></tr>"
		for keys %{$q->{input}};
	$form .= "</table><input type='submit' />";
	$form .= "</form></body></html>\n";

	return $form;
}

Querylet::Query->register_output_handler(cgi_html_table => \&_as_html);
sub _as_html {
	my $q = shift;
	my $results = $q->results;
	my $columns = $q->columns;

	my $html = "Content-type: text/html\n\n";
	$html .= "<html><head><title>results of query</title></head>";
	$html .= "<body><table><tr>";
	$html .= join('', map { "<th>" . $q->header($_) . "</th>" } @$columns);
	$html .= "</tr>\n";

	if (@$results) {
		$html .= "<tr>" . join('', map { "<td>$_</td>" } @$_{@$columns}). "</tr>\n"
			foreach (@$results);
	} else {
		$html .= "<tr><td colspan='". scalar @$columns ."'>no results</td></tr>\n";
	}

	$html .= "</table></body></html>\n";
}

1;
