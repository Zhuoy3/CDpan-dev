#!/usr/bin/perl

# Description:
# Author: zhuoy
# Date: 2021-10-09

package CDpan::Master;

use strict;
use warnings;

use Config::IniFiles;

use CDpan::Print qw / :PRINT /;

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

sub Filter;
sub Align;
sub Extract;
sub Assembly;
sub Mope;
sub Vot;
sub Soot;
sub Merge;
sub Location;
sub RunAll;
sub RunDisplace;

# print "\n================================================================================\n\n";
# print "Start quality control...\n";

# my @input_folder = sort ( File::Slurp::read_dir($par->val('DATA', 'input'), prefix => 1) );

# our $ref_index = 0; # mark the existence of the reference genome index used by bwa
# our $ref_dict = 0; # mark the existence of the reference genome dict used by gatkmy

# my @idv_names;
# foreach my $idv_folder (@input_folder) {
#     my $idv_name = pop [ splitdir($idv_folder) ];
#     push @idv_names, $idv_name;
#     my $idv_output_folder = catdir($folder_process, $idv_name);

#     #TODO　Filteration
#     CDpan::QualityControl::QualityControl($par, $idv_folder, $idv_name, $idv_output_folder)
#         or die "Error: Operation QualityControl is abnormal.\n";
#     CDpan::Comparison::comparison($par, $idv_name, $idv_output_folder)#TODO alignment
#         or die "Error: Operation Comparison is abnormal.\n";
#     CDpan::Extract::extract($par, $idv_name, $idv_output_folder)
#         or die "Error: Operation Extract is abnormal.\n";
#     CDpan::Assembly::assembly($par, $idv_name, $idv_output_folder)
#         or die "Error: Operation Assembly is abnormal.\n";
#     CDpan::Test::test($par, $idv_name, $idv_output_folder)#remove contaminents
#         or die "Error: Operation Test is abnormal.\n";
#     CDpan::Judge::judge($par, $idv_name, $idv_output_folder)
#         or die "Error: Operation Judge is abnormal.\n";
#     CDpan::MMSeqs::mmseqs($par, $idv_name, $idv_output_folder)#remove redundant
#         or die "Error: Operation MMSeqs is abnormal.\n";
#     CDpan::Nucmer::nucmer($par, $idv_name, $idv_output_folder)#precise delete
#         or die "Error: Operation Nucmer is abnormal.\n";
#     CDpan::DeRepeat::de_repeat($par, $idv_name, $idv_output_folder)
#         or die "Error: Operation DeRepeat is abnormal.\n";

#     move "$idv_output_folder/$idv_name.filtered.mmseqs.final.fa", "$folder_process/$idv_name.fasta"
#         or die "Error:Couln't move $idv_output_folder/$idv_name.filtered.mmseqs.final.fa to $folder_process/$idv_name.fasta: $!.\n";

# }

# CDpan::Recode::recode($folder_process, \@idv_names)
#     or die "Error: Operation Recode is abnormal.\n";
# CDpan::RepeatMasker::repeat_masker($par, $folder_process)#mask
#     or die "Error: Operation RepeatMasker is abnormal.\n";

# foreach my $idv_name (@idv_names) {
#     print "\n================================================================================\n\n";
#     my $idv_output_folder = catdir($folder_process, $idv_name);

#     CDpan::Align::align($par, $idv_name, $idv_output_folder, $folder_process)
#         or die "Error: Operation Align is abnormal.\n";
#     CDpan::Change::change($par, $idv_name, $idv_output_folder)
#         or die "Error: Operation Change is abnormal.\n";
#     CDpan::Integration::integration($par, $idv_name, $idv_output_folder, $folder_process)
#         or die "Error: Operation Integration is abnormal.\n";
#     #location
#     system "python3 $FindBin::Bin/ex.py"
# }



# chdir $cwd;
# system "rm -rf $folder_process";

#     print "\n================================================================================\n\n";
#     print "END OF PROGRAMME.\n";
# exit 0;




1;

__END__
