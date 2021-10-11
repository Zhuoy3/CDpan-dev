#!/usr/bin/perl

# Description:
# Author: zhuoy
# Date: 2021-10-09

package CDpan::PreProcess;

use strict;
use warnings;

use File::Spec::Functions  qw /:ALL/;
use File::Slurp;
use Config::IniFiles;

use CDpan::Print qw / :PRINT /;

sub PreProcess {
    (my $par) = @_;

    # Check
    __CheckTools__($par);
    __CheckConfig__($par);
    __CheckFile__($par);

    $par->newval('CDPAN', 'module',             $main::module);
    $par->newval('CDPAN', 'input_dir',          $main::input_dir);
    $par->newval('CDPAN', 'config_file',        $main::config_file);
    $par->newval('CDPAN', 'output_prefix',      $main::output_prefix);
    $par->newval('CDPAN', 'output_dir',         $main::output_dir);
    $par->newval('CDPAN', 'work_dir',           $main::work_dir);
    $par->newval('CDPAN', 'output_level',       $main::output_level);
    $par->newval('CDPAN', 'no_quality_control', $main::no_quality_control);

    return 1;
}

sub __CheckTools__ {
    (my $par) = @_;

    PrintStartMessage("Start checking tools");

    my $exit_tools = 0;

    my @tools_needed = qw \ trim_galore
                            cutadapt
                            fastqc
                            bwa
                            gatk
                            samtools
                            masurca
                            centrifuge
                            centrifuge-kreport
                            mmseqs
                            nucmer
                            show-coords
                            RepeatMasker
                            bedtools
                            bowtie2
                            bowtie2-build \;

    print STDERR "Tools needed: @tools_needed\n";
    print STDERR "\n";

    my @tools_specify = $par->Parameters('TOOLS');
    print STDERR "Tools specified: @tools_specify\n";
    print STDERR "\n";

    print STDERR "Specified:\n";
    print STDERR "\n";
    foreach my $tools (@tools_specify) {
        unless (grep { $_ eq $tools } @tools_needed) {
            PrintWarnMessage("$tools is not needed, ignore it");
            $par->delval('TOOLS', $tools);
            next;
        }

        my $tools_path = $par->val('TOOLS', $tools);
        $tools_path = rel2abs($tools_path) unless file_name_is_absolute($tools_path);
        printf STDERR "%-22s", "$tools:";
        print  STDERR "$tools_path\n";

        if ( -e -x $tools_path ) {
            $par->setval('TOOLS', $tools, $tools_path);
        }
        else{
            PrintWarnMessage("$tools does not exist or lacks execute permission, search it from PATH");
            $par->delval('TOOLS', $tools);
        }
    }

    print STDERR "\n";
    print STDERR "Search from PATH:\n";
    print STDERR "\n";
    foreach my $tools (@tools_needed) {
        unless ( defined $par->val('TOOLS', $tools) ) {
            my $cmd_findtool = "command -v ${tools}";
            my $new_tools_path =  `$cmd_findtool`;
            chomp($new_tools_path);

            if ($new_tools_path eq '') {
                PrintErrorMessage("Couln't find tool $tools from PATH\n", 0);
                $exit_tools = 1;
            }
            else{
                printf STDERR "%-22s", "$tools:";
                print  STDERR "$new_tools_path\n";
                $par->newval('TOOLS', $tools, $new_tools_path);
            }
        }
    }

    exit(255) if $exit_tools;

    PrintEndMessage("Finish checking tools");

    return 1;
}

sub __CheckConfig__ {
    (my $par) = @_;

    PrintStartMessage("Start checking configs");

    my %default_params = (
        "CDPAN" => {
            "thread" => 12,
        },
        "FILTER" => {
            "quality" => 20,
            "length" => 20,
            "error-rate" => 0.1,
        },
    );

    my @par_sections = sort $par->Sections;

    foreach my $section (@par_sections) {
        next if (grep { $_ eq $section } qw \ TOOLS DATA \ );
        unless (grep { $_ eq $section } ( keys %default_params )) {
            PrintWarnMessage("[$section] => ... is not needed, ignore it");
            $par->DeleteSection($section);
            next;
        }

        my @par_parameters = sort $par->Parameters($section);
        foreach my $param (@par_parameters) {
            unless (grep { $_ eq $param } ( keys $default_params{$section} )){
                PrintWarnMessage("[$section] => $param is not needed, ignore it");
                $par->delval($section, $param);
            }
        }
    }

    print STDERR "\n";

    foreach my $section ( sort keys %default_params ) {
        foreach my $param ( sort keys $default_params{$section} ) {
            if ( defined $par->val($section, $param)) {
                printf STDERR "%-30s", "[$section] => $param:";
                print  STDERR $par->val($section, $param);
                print  STDERR "\n";
            }
            else{
                if ( defined $default_params{$section}{$param} ) {
                    $par->delval($section, $param);
                    $par->newval($section, $param, $default_params{$section}{$param});
                    printf STDERR "%-30s", "[$section] => $param:";
                    print  STDERR $par->val($section, $param);
                    print  STDERR " (Default)\n";
                }
                else{
                    PrintErrorMessage("[$section] => $param mustbeen specified");
                }
            }
        }
    }

    PrintEndMessage("Finish checking configs");

    return 1;
}

sub __CheckFile__ {
    (my $par) = @_;

    PrintStartMessage("Start checking files");

    my @file_for_check = qw \\  ;
    #TODO my @file_for_check = qw \ ref qry index taxid \;
    foreach my $file_for_check (@file_for_check) {
        unless ( defined $par->val('DATA', $file_for_check) ) {
            PrintErrorMessage("[DATA] => $file_for_check must been specified");
        }

        if ( -e -r $par->val('DATA', $file_for_check) ){
            unless (file_name_is_absolute($par->val('DATA', $file_for_check))){
                $par->setval('DATA', $file_for_check,rel2abs($par->val('DATA', $file_for_check)));
            }
            printf STDERR "%-30s", "['DATA'] => $file_for_check:";
            print  STDERR $par->val('DATA', $file_for_check);
            print  STDERR "\n";
        }
        else{
            if ( $file_for_check eq 'index' ){
                my $file_for_check_path = $par->val('DATA', $file_for_check);
                $file_for_check_path = "ls $file_for_check_path*";
                my @file_for_check_path = `$file_for_check_path`;
                if (@file_for_check_path){
                    unless (file_name_is_absolute($par->val('DATA', $file_for_check))){
                        $par->setval('DATA', $file_for_check,rel2abs($par->val('DATA', $file_for_check)));
                    }
                    printf STDERR "%-30s", "['DATA'] => $file_for_check:";
                    print  STDERR $par->val('DATA', $file_for_check);
                    print  STDERR "\n";
                    next;
                }
            }

            PrintErrorMessage("Could not open $file_for_check file: " . $par->val('DATA', $file_for_check) . "");
        }
    }

    print STDERR "\n";

    if ( -e $main::work_dir) {
        my @dir_files = File::Slurp::read_dir($main::work_dir, prefix => 1);
        if ( @dir_files ) {
            # PrintErrorMessage("Working direction $main::work_dir exists and has file");
        # }
        # else { #TODO
            PrintWarnMessage("Working direction $main::work_dir exists but is empty");
        }
    }
    else{
        mkdir $main::work_dir or PrintErrorMessage("Cannot create working direction: $!");
    }

    unless ( -e $main::output_dir) {
        mkdir $main::output_dir or PrintErrorMessage("Cannot create output direction: $!");
    }

    my @output_suffix = qw \ .dispensable_genome.fasta .location.txt \;
    foreach my $output_suffix (@output_suffix) {
        my $output_file_name = catfile("$main::output_dir", "$main::output_prefix$output_suffix");
        if ( -e $output_file_name ) {
            rename $output_file_name => "$output_file_name.old"
                or PrintErrorMessage("Cannot change the name of file $output_file_name: $!");
            PrintWarnMessage("Output file $output_file_name exists and has been renamed");
        }
    }

    PrintEndMessage("Finish checking files");

    return 1;

}

1;

__END__
