package Bolts::Role::Locator;
$Bolts::Role::Locator::VERSION = '0.142930';
# ABSTRACT: Interface for locating artifacts in a bag

use Moose::Role;


requires 'acquire';


requires 'acquire_all';


requires 'resolve';


requires 'get';

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Bolts::Role::Locator - Interface for locating artifacts in a bag

=head1 VERSION

version 0.142930

=head1 DESCRIPTION

This is the interface that any locator must implement. A locator's primary job is to provide a way to find artifacts within a bag or selection of bags. This performs the acquisition and resolution process.

The reference implementation of this interface is found in L<Bolts::Role::RootLocator>.

=head1 REQUIRED METHODS

=head2 acquire

    my $artifact = $loc->acquire(\@path);

Given a C<@path> of symbol names to traverse, this goes through each artifact in turn, resolves it, if necessary, and then continues to the next path component.

When complete, the complete, resolved artifact found is returned.

=head2 acquire_all

    my @artifacts = @{ $loc->acquire_all(\@path) };

This is similar to L<acquire>, but if the last bag is a reference to an array, then all the artifacts within that bag are acquired, resolved, and returned as a reference to an array.

If the last item found at the path is not an array, it returns an empty list.

=head2 resolve

    my $resolved_artifact = $loc->resolve($bag, $artifact, \%options);

After the artifact has been found, this method resolves the a partial artifact implementing the L<Bolts::Role::Artifact> and turns it into the complete artifact.

=head2 get

    my $artifact = $log->get($component);

Given a single symbol name as the path component to find during acquisition it returns the partial artifact for it. This artifact is incomplete and still needs to be resolved.

=head1 AUTHOR

Andrew Sterling Hanenkamp <hanenkamp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Qubling Software LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
