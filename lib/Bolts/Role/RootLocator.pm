package Bolts::Role::RootLocator;
$Bolts::Role::RootLocator::VERSION = '0.142930';
# ABSTRACT: Interface for locating artifacts from some root bag

use Moose::Role;

with 'Bolts::Role::Locator';

use Bolts::Locator;
use Bolts::Util;
use Carp ();
use Safe::Isa;
use Scalar::Util ();


# TODO Rename root to something better.
requires 'root';


sub acquire {
    my ($self, @path) = @_;
    # use Data::Dumper;
    # Carp::cluck(Dumper(\@path));

    my $options = {};
    if (@path > 1 and ref $path[-1]) {
        $options = pop @path;
    }
    
    my $current_path = '';

    my $item = $self->root;
    while (@path) {
        my $component = shift @path;

        my $bag = $item;
        $item = $self->_get_from($bag, $component, $current_path);
        $item = $self->resolve($bag, $item, $options);

        $current_path .= ' ' if $current_path;
        $current_path .= qq["$component"];
    }

    return $item;
}


sub acquire_all {
    my ($self, @path) = @_;

    my $options = {};
    if (@path > 1 and ref $path[-1]) {
        $options = pop @path;
    }
    
    my $bag = $self->acquire(@path);
    if (ref $bag eq 'ARRAY') {
        return [
            map { $self->resolve($bag, $_, $options) } @$bag
        ];
    }

    else {
        return [];
    }
}


sub resolve {
    my ($self, $bag, $item, $options) = @_;

    return $item->get($bag, %$options)
        if $item->$_can('does')
       and $item->$_does('Bolts::Role::Artifact');

    return $item;
}


sub get {
    my ($self, $component) = @_;
    return $self->_get_from($self->root, $component);
}

sub _get_from {
    my ($self, $bag, $component, $current_path) = @_;
    $current_path //= '';

    Carp::croak("unable to acquire artifact for [$current_path]")
        unless defined $bag;

    # A bag can be any blessed object...
    if (Scalar::Util::blessed($bag)) {

        # So long as it has that method
        if ($bag->can($component)) {
            return $bag->$component;
        }
        
        else {
            Carp::croak(qq{no artifact named "$component" at [$current_path]});
        }
    }

    # Or any unblessed hash
    elsif (ref $bag eq 'HASH') {
        return $bag->{ $component };
    }

    # Or any unblessed array
    elsif (ref $bag eq 'ARRAY') {
        return $bag->[ $component ];
    }

    # But nothing else...
    else {
        my $path = join ' ', grep defined, $current_path, $component;
        Carp::croak(qq{not able to acquire artifact for [$path]});
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Bolts::Role::RootLocator - Interface for locating artifacts from some root bag

=head1 VERSION

version 0.142930

=head1 DESCRIPTION

This is the interface that any locator must implement. A locator's primary job is to provide a way to find artifacts within a bag or selection of bags. This performs the acquisition and resolution process. This actually also implements everything needed for the process except for the L</root>.

=head1 ROLES

=over

=item *

L<Bolts::Role::Locator>

=back

=head1 REQUIRED METHODS

=head2 root

This is the object to use as the bag to start searching. It may be an object, a reference to an array, or a reference to a hash.

B<Caution:> This will be renamed in the future.

=head1 METHODS

=head2 acquire

    my $artifact = $loc->acquire(@path, \%options);

Given a C<@path> of symbol names to traverse, this goes through each artifact in turn, resolves it, if necessary, and then continues to the next path component.

After it finds the artifact, it will resolve the artifact using the L</resolve> method, which is passed the (optional) B<%options>.

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
