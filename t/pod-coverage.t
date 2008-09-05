use strict;
use warnings;

use Test::More;

eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

# This is a stripped down version of all_pod_coverage_ok which lets us
# vary the trustme parameter per module.
my @modules = all_modules();
plan tests => scalar @modules;

my %trustme =
    ( 'MooseX::ClassAttribute'                         => [ 'init_meta', 'class_has' ],
      'MooseX::ClassAttribute::Meta::Method::Accessor' => qr/.+/,
    );

for my $module ( sort @modules )
{
    my $trustme;

    if ( $trustme{$module} )
    {
        # why is qr// not a ref?
        if ( ! ref $trustme{module} )
        {
            $trustme = [ $trustme{module} ]
        }
        else
        {
            my $methods = join '|', @{ $trustme{$module} };
            $trustme = [ qr/^(?:$methods)/ ];
        }
    }

    pod_coverage_ok( $module, { trustme => $trustme },
                     "Pod coverage for $module"
                   );
}
