package MooseX::ClassAttribute::Meta::Role::Attribute;

use strict;
use warnings;

use List::MoreUtils qw( uniq );

use namespace::autoclean;
use Moose;

extends 'Moose::Meta::Role::Attribute';

sub new {
    my ( $class, $name, %options ) = @_;

    $options{traits} = [
        uniq( @{ $options{traits} || [] } ),
        'MooseX::ClassAttribute::Role::Meta::Attribute'
    ];

    return $class->SUPER::new( $name, %options );
}

1;