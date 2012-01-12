#!/usr/bin/perl

use strict;

die "Usage: $0 header-sfd body-sfd\n" if ($#ARGV < 1);

open HEAD, $ARGV[0] or die "Cannot open header SFD: $ARGV[0]\n";
open BODY, $ARGV[1] or die "Cannot open body SFD: $ARGV[1]\n";

while (<HEAD>) {
	last if /^BeginChars:/;
	print $_;
}
close HEAD;
while (<BODY>) {
	print $_;
}
close BODY;
