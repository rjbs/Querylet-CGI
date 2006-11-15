use Test::More tests => 3;

BEGIN {
  require_ok('Querylet::Query');
  require_ok('Querylet::CGI');
  require_ok('Querylet::CGI::Auto');
}

diag( "Testing $Querylet::CGI::VERSION" );
