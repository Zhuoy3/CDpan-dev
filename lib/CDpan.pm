#!/usr/bin/perl

# Description:
# Author: zhuoy
# Date: 2021-08-11

package CDpan;

use strict;
use warnings;

require CDpan::Print;
require CDpan::Check;

# use CDpan::Parameter;
# use CDpan::QualityControl;
# use CDpan::Comparison;
# use CDpan::Extract;
# use CDpan::Assembly;
# use CDpan::Test;
# use CDpan::Judge;
# use CDpan::MMSeqs;
# use CDpan::Nucmer;
# use CDpan::DeRepeat;
# use CDpan::Recode;
# use CDpan::RepeatMasker;
# use CDpan::Align;
# use CDpan::Change;
# use CDpan::Integration;

require Exporter;
our @ISA = qw \ Exporter \;
our @EXPORT = qw \ PrintExitMessage PrintWarnMessage PrintErrorMessage
                   PreCheck \;
our %EXPORT_TAGS = ( ALL => [ @EXPORT ],
                     PRINT => [ qw \ PrintExitMessage PrintWarnMessage PrintErrorMessage\ ] );

# module CDpan::Print
sub PrintExitMessage  { return &CDpan::Print::PrintExitMessage };
sub PrintWarnMessage  { return &CDpan::Print::PrintWarnMessage };
sub PrintErrorMessage { return &CDpan::Print::PrintErrorMessage };

# module CDpan::Check
sub PreCheck { return &CDpan::Check::PreCheck };


1;

__END__
