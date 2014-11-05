package Bolts::Util;
$Bolts::Util::VERSION = '0.142930';
# ABSTRACT: Utilities helpful for use with Bolts

use Moose ();
use Moose::Exporter;

use Bolts::Locator;
use Moose::Util;
use Safe::Isa;
use Hash::Util::FieldHash 'fieldhash';

use Bolts::Meta::Initializer;

Moose::Exporter->setup_import_methods(
    as_is => [ qw( bolts_init locator_for meta_locator_for ) ],
);

fieldhash my %locator;
fieldhash my %meta_locator;


sub locator_for {
    my ($bag) = @_;

    if ($bag->$_does('Bolts::Role::Locator')) {
        return $bag;
    }
    elsif (defined $locator{ $bag }) {
        return $locator{ $bag };
    }
    else {
        return $locator{ $bag } = Bolts::Locator->new($bag);
    }
}


sub meta_locator_for {
    my ($bag) = @_;

    my $meta = Moose::Util::find_meta($bag);
    if (defined $meta) {
        my $meta_meta = Moose::Util::find_meta($meta);
        if ($meta_meta->$_can('does_role') && $meta_meta->does_role('Bolts::Meta::Class::Trait::Locator')) {
            return $meta->locator;
        }
    }

    elsif (defined $meta_locator{ $bag }) {
        return $meta_locator{ $bag };
    }

    return $meta_locator{ $bag } = $Bolts::GLOBAL_FALLBACK_META_LOCATOR->new;
}


sub bolts_init { Bolts::Meta::Initializer->new(@_) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Bolts::Util - Utilities helpful for use with Bolts

=head1 VERSION

version 0.142930

=head1 SYNOPSIS

    use Bolts::Util qw( bolts_init locator_for meta_locator_for );

    my $loc   = locator_for($bag);
    my $thing = $loc->acquire('path', 'to', 'thing');

    my $metaloc = meta_locator_for($bag);
    my $blueprint = $metaloc->acquire('blueprint', 'factory', {
        class  => 'MyApp::Thing',
        method => 'fetch',
    });

    # See Bolts::Role::Initializer for a better synopsis
    my $obj = MyApp::Thing->new(
        foo => bolts_init('path', 'to', 'foo'),
    );

=head1 DESCRIPTION

This provides some helpful utility methods for use with Bolts.

=head1 EXPORTED FUNCTIONS

=head2 locator_for

    my $loc = locator_for($bag);

Given a bag, it will return a L<Bolts::Role::Locator> for acquiring artifacts from it. If the bag provides it's own locator, the bag will be returned. If it doesn't (e.g., if it's a hash or an array or just some other object that doesn't have a locator built-in), then a new locator will be built to locate within the bag and returned on the first call. Subsequent calls using the same reference will return the same locator object.

=head2 meta_locator_for

    my $metaloc = meta_locator_for($bag);

Attempts to find the meta locator for the bag. It returns a L<Bolts::Role::Locator> that is able to return artifacts used to manage a collection of bolts bags and artifacts. If the bag itself does not have such a locator associated with it, one is constructed using the L<Bolts/$Bolts::GLOBAL_FALLBACK_META_LOCATOR> class, which is L<Bolts::Meta::Locator> by default. After the first call, the object created the first time for each reference will be reused.

=head2 bolts_init

    my $init = bolts_init(@path, \%params);

This is shorthand for:

    my $init = Bolts::Meta::Initializer->new(@path, \%params);

This returns an initializer object that may be used with L<Bolts::Role::Initializer> to automatically initialize attributes from a built-in locator.

=head1 AUTHOR

Andrew Sterling Hanenkamp <hanenkamp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Qubling Software LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
