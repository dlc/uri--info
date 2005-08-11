use strict;
use ExtUtils::MakeMaker;

my %PREREQ_PM = (
    'URI'           => 1.00,
    'LWP::Simple'   => 1.00,
);

my %clean = (
    'FILES' => '$(DISTVNAME).tar$(SUFFIX) *.ppd'
);

my %dist = (
    PREOP => 'perldoc -t lib/URI/Info.pm > README; cpansign -s',
);

WriteMakefile(
    'NAME'      => 'URI::Info',
    'VERSION'   => "1.00",
    'PREREQ_PM' => \%PREREQ_PM,
    'clean'     => \%clean,
    'dist'      => \%dist,
);
