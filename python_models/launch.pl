#!/usr/bin/perl
#

use Getopt::Std;
use POSIX qw(strftime);
use Scalar::Util qw(looks_like_number);
use File::Basename;

sub my_system;

my $timestamp = strftime "%F-%H-%M", localtime;
my $me = `whoami`;
chomp $me;

getopts('rtnh');
my $rerun = $opt_r;
my $test = $opt_t;
my $norun = $opt_n;
my $help = $opt_h;

if ($help) {
    print <<END_HELP;
    launches jobs on condor
        options:

        -t
        test: prints commands instead of executing them

        -n
        norun: does everything but launch the job

        -r
        rerun: rerun any failed runs
END_HELP
        exit;
}

my $resultDir = "/aenao-99/$me/dnn-sim/results";
my $scriptDir = ".";
my $filterDir = "/localhome/juddpatr/dnn-sim/python_models/filters";

$script = "bubble_up.py";
$script = "bubble_up_rm_dup.py";

$prec = "high";
$prec = "low";

$batchName = "shared_FA_buffer_size_$prec";
$batchName = "find_max_buffer_size_$prec";
$batchName = "test_dont_evict_$prec";
$batchName = "same_row_explore_$prec";

$filterDir = $filterDir . "/" . $prec;
( my $scriptName = $script )=~ s/\.[^.]+$//;
# create common batch-job.submit for all jobs in this batch
open($fh, ">batch-job.submit") or die "could not open batch-job.submit for writing\n";
print $fh <<'END_MSG';
Universe = vanilla
Getenv = True
Requirements = (Activity == "Idle") && ( Arch == "X86_64" ) && regexp( ".*fc16.*", TARGET.CheckpointPlatform )
Executable = run.sh
Output = stdout
Error = stderr
Log = condor.log
Rank = (TARGET.Memory*1000 + Target.Mips) + ((TARGET.Activity =?= "Idle") * 100000000) - ((TARGET.Activity =?= "Retiring" ) * 100000000 )
Notification = error
Copy_To_Spool = False
Should_Transfer_Files = no
#When_To_Transfer_Output = ON_EXIT
END_MSG

print $fh "request_memory = 3072\n";
close $fh;

die "$resultDir does not exist\n" if ( ! -d $resultDir );

$batchDir = "$resultDir/$batchName";

# create batch dir and skeleton dir
if ($rerun) {
    die "$batchDir does not exists\n" unless ( -d $batchDir );
} else {
    if (-d $batchDir and not $test){
        print "$batchDir exists, clobber (y/n)?";
        my $in = <>;
        exit if ( $in !~ /^\s*[yY]\s*$/ );
        my_system("rm -rf $batchDir");
    }
    my_system("mkdir $batchDir");

# make skeleton dir
    my_system("mkdir $batchDir/.skel");
    for $py (glob "*.py") {
        my_system ("cp $scriptDir/$py $batchDir/.skel/.");
    }
}

my_system("cp batch-job.submit $batchDir/.skel/.") ;

print "running for everything in $filterDir\n";
@filters = ("alexnet");
@filters = `cat nets.txt`;
chomp(@filters);

print "Preparing $batchDir\n" unless $rerun;

# create individual submit script
my_system("cp batch-job.submit job.submit");
open($fh, ">>job.submit") or die "could not open submit for append\n";

$num_rerun=0;

$lah = 3;
$las = 4;
$in = 1;
$out = 1;

$buffer_size = 1000000;
for my $out (1,2,4,8,16){
    for my $in (1,2,4,8,16){
#for my $buffer_size (16,32,64,128,256,512,1024,2048,4096,8192,16384){
        $args = "$lah $las $out $in $buffer_size";
#print "lah=$lah las=$las " unless $test;
#print "buffer_size = $buffer_size" unless $test;
        print "out=$out in=$in " unless $test;

#$configDir = "$batchDir/$scriptName-$buffer_size";
        $configDir = "$batchDir/$scriptName-$out-$in";

        my_system("mkdir $configDir") unless $rerun;

        for my $filter (@filters){
            #next unless $filter =~ m/\.csv/;

            ( my $filterName = $filter )=~ s/\.[^.]+$//;
            my $runDir = "$configDir/$filterName";
            if ($rerun and -d $runDir) {
                if (system("grep \"job completed sucessfully\" $runDir/stdout 2>&1 >/dev/null") == 0) {
                    next; # if so, skip
                } else {
                    print "Rerunning $runDir\n";
                    $num_rerun++;
                }
            } else { 
                # setup runDir
                my_system("mkdir $runDir");
                for $py (glob "$batchDir/.skel/*.py"){
                    my_system("ln -s $py $runDir/" . basename($py));
                }
                my_system("ln -s $runDir/$script $runDir/script");
                my_system("echo $filterDir/$filter*.csv > $runDir/filters.txt");
                my_system("echo \" $args\" > $runDir/args"); 
            }

            # append job details to submit script
            print $fh "InitialDir = $runDir\n";
            print $fh "Args = \n";
            print $fh "Queue\n\n";
            print "." unless $rerun;
        }
        print "\n" if not $test and not $rerun;
    } # foreach config
    print "\n" if not $test and not $rerun;
} # foreach filter
close $fh;

if ($rerun and $num_rerun == 0){
    print "All jobs completed successfully, nothing to rerun\n";
    exit;
}

my_system("condor_submit job.submit") unless $norun;

#----------------------------------------------------------------------------------------------

# system call wrapper for testing
sub my_system {
    my $cmd = shift(@_);
    if ($test) {
        print "$cmd\n";
    } else {
        system ("$cmd") and die "failed to run $cmd";
    }
}

