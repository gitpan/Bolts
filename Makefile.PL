
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.019.
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "An Inversion of Control framework for Perl",
  "AUTHOR" => "Andrew Sterling Hanenkamp <hanenkamp\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Bolts",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Bolts",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Class::Load" => 0,
    "Hash::Util::FieldHash" => 0,
    "List::MoreUtils" => 0,
    "Moose" => 0,
    "Moose::Exporter" => 0,
    "Moose::Role" => 0,
    "Moose::Util" => 0,
    "Moose::Util::MetaRole" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "Safe::Isa" => 0,
    "Scalar::Util" => 0
  },
  "TEST_REQUIRES" => {
    "List::Util" => 0,
    "Test::More" => 0,
    "lib" => 0,
    "strict" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.143171",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Class::Load" => 0,
  "Hash::Util::FieldHash" => 0,
  "List::MoreUtils" => 0,
  "List::Util" => 0,
  "Moose" => 0,
  "Moose::Exporter" => 0,
  "Moose::Role" => 0,
  "Moose::Util" => 0,
  "Moose::Util::MetaRole" => 0,
  "Moose::Util::TypeConstraints" => 0,
  "Safe::Isa" => 0,
  "Scalar::Util" => 0,
  "Test::More" => 0,
  "lib" => 0,
  "strict" => 0,
  "vars" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



