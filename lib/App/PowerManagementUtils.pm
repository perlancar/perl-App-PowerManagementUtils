package App::PowerManagementUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{prevent_sleep_while} = {
    v => 1.1,
    summary => 'Prevent sleep while running a command',
    description => <<'_',

Uses <pm:Proc::Govern> to run a command, with the option `no-sleep' to instruct
Proc::Govern to disable system from sleeping while running the command. For more
options when running command, e.g. timeout, load control, autorestart,
screensaver control, use the module or its CLI <prog:govproc> directly.

Note that sleep prevention survives reboot, so if this script is terminated
prematurely before it can unprevent sleep again, you'll need to invoke
<prog:unprevent-sleep> to restore normal sleep.

_
    args => {
        command => {
            schema => ['array*', of=>'str*'],
            req => 1,
            pos => 0,
            slurpy => 1,
        },
    },
};
sub prevent_sleep_while {
    require Proc::Govern;

    my %args = @_;

    my $exit = Proc::Govern::govern_process(
        command => $args{command},
        no_sleep => 1,
    );

    [200, "Exit code is $exit", "", {"cmdline.exit_code"=>$exit}];
}

$SPEC{prevent_sleep_until_interrupted} = {
    v => 1.1,
    summary => 'Prevent sleep until interrupted',
    description => <<'_',

Uses <pm:Proc::Govern> to run `sleep infinity`, with the option `no-sleep' to
instruct Proc::Govern to disable system from sleeping. To stop preventing sleep,
you can press Ctrl-C.

Note that sleep prevention survives reboot, so if this script is terminated
prematurely before it can unprevent sleep again, you'll need to invoke
<prog:unprevent-sleep> to restore normal sleep.

_
    args => {
    },
};
sub prevent_sleep_until_interrupted {
    require Proc::Govern;

    my %args = @_;

    print "Now preventing system from sleeping. ",
        "Press Ctrl-C to stop.\n";
    my $exit = Proc::Govern::govern_process(
        command => ['sleep', 'infinity'],
        no_sleep => 1,
    );

    [200, "Exit code is $exit", "", {"cmdline.exit_code"=>$exit}];
}

1;
# ABSTRACT: CLI utilities related to power management

=head1 DESCRIPTION

This distribution contains the following CLI utilities related to screensaver:

# INSERT_EXECS_LIST
