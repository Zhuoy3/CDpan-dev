#!/usr/bin/perl

# Description:
# Author: Zhuo Yue
# Date: 2021-03-07
# called by: CDpan.pl

package CDpan::GetPar;

use strict;
use warnings;
use Config::IniFiles;
use CDpan::Check;

sub getpar {
    # &getpar($opt)
    # Import parameter form file which be given by command line
    my $file_par_path = shift;

    # Since "FindBin" uses a "BEGIN" block, it'll be executed only once, and only the first caller will get it right
    # $FindBin::Bin is path to bin directory from where 'CDpan.pl' was invoked
    my  $par_default = new Config::IniFiles(-file => "$FindBin::Bin/../config/par_default.ini");
    our %par_accept  = CDpan::GetPar::getstdpar("$FindBin::Bin/../config/par_accept.txt");
    our %par_require = CDpan::GetPar::getstdpar("$FindBin::Bin/../config/par_require.txt");

    my $par = new Config::IniFiles(-file                => $file_par_path,
                                   -import              => $par_default,
                                   -allowedcommentchars => '#')
        or die "ERROR: Could not import parameter from $file_par_path: @Config::IniFiles::errors";

    CDpan::Check::checkpar($par);

    #TODO 需要一个检查转换为全局路径的函数

    $par->WriteConfig("$file_par_path.import") if $main::opt_d;

    return $par;
}

sub getstdpar {
    # &getstdpar($file)
    # Import parameter form file in the folder '/CDpan/config/'
    my $file_path = shift;
    my %output;

    open PARFILE, "<", $file_path or die "ERROR: Cannot open file \'$file_path\': $!";
    while (<PARFILE>) {
        next unless s/^(.*?):\s*//; # Capturing the first parameter of the line: Section
        $output{$1} =[ split ]; # A hash that points to the list
    }
    close PARFILE;

    return %output;
}

1;

__END__
