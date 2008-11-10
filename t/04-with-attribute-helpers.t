#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

do {
    package MyClass;
    use MooseX::ClassAttribute;
    use MooseX::AttributeHelpers;

    class_has counter => (
        metaclass => 'Counter',
        is        => 'ro',
        provides  => {
            inc => 'inc_counter',
        },
    );
};

is(MyClass->counter, 0);
MyClass->inc_counter;
is(MyClass->counter, 1);
