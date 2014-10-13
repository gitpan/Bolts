package Bolts::Role::Artifact;
$Bolts::Role::Artifact::VERSION = '0.142860';
# ABSTRACT: The role implemented by resolved artifacts

use Moose::Role;


requires 'get';


requires 'such_that';

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Bolts::Role::Artifact - The role implemented by resolved artifacts

=head1 VERSION

version 0.142860

=head1 DESCRIPTION

An artifact can be any kind of object. However, during acquistion, the resolution phase is only performed on objects implementing this role. Resolution allows the artifact to make decisions about how to construct, inject dependencies, and cache the object.

=head1 REQUIRED METHODS

=head2 get

    my $resolved_artifact = $artifact->get($bag, %options);

This method is called during resolution to all the artifact to decide how to resolve the real artifact.

=head2 such_that

    $artifact->such_that(
        isa  => $type,
        does => $type,
    );

This applies type constraints to the resolved object. These are invariants that should be applied as soon as the artifact is able to do so.

=head1 AUTHOR

Andrew Sterling Hanenkamp <hanenkamp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Qubling Software LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
