use strict;
use warnings;

use Test::More;

{
    package Role;

    use Moose::Role;
    use MooseX::ClassAttribute;

    class_has 'CA' => (
        is      => 'ro',
        isa     => 'HashRef',
        default => sub { {} },
    );

	class_has 'lazy_fail' => (
		isa => 'Int'
		, is => 'ro'
		, lazy => 1
		, default => sub {
			my $self = shift;
			$self->life + 42;
		}
	);
}

{
    package Role2;
    use Moose::Role;
}

{
    package Bar;
    use Moose;
	use MooseX::ClassAttribute;

    with( 'Role2', 'Role' );
	
	class_has 'life' => ( isa => 'Int', is => 'ro', default => 42 );
}

{
    local $TODO = 'Class attributes are lost during role composition';
    can_ok( 'Bar', 'CA', );
	my $obj;
	eval {
		$obj = Bar->new;
	};
	ok( !$@, 'No errors creating object' );
	is( $obj->life, 42, 'Right value for object' );
	eval {
		$obj->lazy_fail;
	};
	ok (!$@, "Calling class attribute declared in role syyucceeded" );

	eval {
		$obj->lazy_fail = 84 ? return : die "Not equal";
  };
	ok (!$@, "Lazy class attribute in role was able to utilize non-lazy values in base class" );
}

done_testing();
