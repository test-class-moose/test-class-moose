package TestsFor::Person;

use Test::Class::Moose bare => 1;

use Test2::Tools::Compare qw( array call end event is T );

with 'Test::Class::Moose::Role::AutoUse';

has 'test_fixture' => ( is => 'rw' );

sub extra_constructor_args { }

sub test_setup {
    my $test = shift;
    $test->test_fixture(
        $test->class_name->new(
            first_name => 'Bob',
            last_name  => 'Dobbs',
            $test->extra_constructor_args,
        )
    );
}

sub test_person {
    my $test = shift;
    $test->test_report->plan(2);
    is $test->test_fixture->full_name, 'Bob Dobbs',
      'Our full name should be correct';
}

sub expected_test_events {
    event Note => sub {
        call message => 'Subtest: TestsFor::Person';
    };
    event Subtest => sub {
        call name      => 'Subtest: TestsFor::Person';
        call pass      => T();
        call subevents => array {
            event Plan => sub {
                call max => 1;
            };
            event Note => sub {
                call message => 'Subtest: test_person';
            };
            event Subtest => sub {
                call name      => 'Subtest: test_person';
                call pass      => T();
                call subevents => array {
                    event Ok => sub {
                        call pass => T();
                        call name => 'Our full name should be correct';
                    };
                    event Plan => sub {
                        call max => 1;
                    };
                    end();
                };
            };
            end();
        };
    };
}

1;
