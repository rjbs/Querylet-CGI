use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Querylet::CGI',
    AUTHOR              => 'Ricardo SIGNES <rjbs@cpan.org>',
    VERSION_FROM        => 'lib/Querylet/CGI.pm',
    ABSTRACT_FROM       => 'lib/Querylet/CGI.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'CGI'        => 2,
        'Querylet'        => 0.28,
        'Querylet::Input' => 0.22,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Querylet-CGI-*' },
);
