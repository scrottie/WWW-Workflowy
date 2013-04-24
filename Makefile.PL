use 5.012000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'WWW::Workflowy',
    VERSION_FROM      => 'lib/WWW/Workflowy.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM  => 'lib/WWW/Workflowy.pm', # retrieve abstract from module
    AUTHOR         => 'Scott Walters <scott@(none)>',
);
