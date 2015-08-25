#!/usr/bin/perl

for $arg (@ARGV) {
    open($fh, "<$arg") or die $!;
    open($of, ">$arg.new") or die $!;

    while(<$fh>) {
        @cols = split /,/;
        chomp(@cols);
        print $of ( join ',', (@cols[0..8])) . ",\n";
    }
    system("mv $arg.new $arg");
}
