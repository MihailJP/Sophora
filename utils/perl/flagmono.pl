#!/usr/bin/perl

use strict;
use Font::TTF;
use Font::TTF::Font;
use Font::TTF::Post;

die "Usage: $0 source-ttf target-ttf\n" if ($#ARGV < 1);

die "No such file: $ARGV[0]\n" unless (-e $ARGV[0]);

my $f = Font::TTF::Font->open("$ARGV[0]") or die "Cannot open font: $ARGV[0]\n";
my $t = $f->{'post'};
$t -> read;
$t->{'isFixedPitch'} = 1;

$f->update;

$f->out("$ARGV[1]") or die "Cannot write font: $ARGV[1]\n";
