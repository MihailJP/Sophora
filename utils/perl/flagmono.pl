#!/usr/bin/perl

use strict;
use Font::TTF;
use Font::TTF::Font;
use Font::TTF::Post;
use Font::TTF::OS_2;
use Font::TTF::Hmtx;

die "Usage: $0 source-ttf target-ttf\n" if ($#ARGV < 1);

die "No such file: $ARGV[0]\n" unless (-e $ARGV[0]);

my $f = Font::TTF::Font->open("$ARGV[0]") or die "Cannot open font: $ARGV[0]\n";
my $t = $f->{'post'};
$t -> read;
$t->{'isFixedPitch'} = 1;
my $m = $f->{'hmtx'};
$m -> read;
my $w = $m->{'advance'}[3];
my $o = $f->{'OS/2'};
$o -> read;
$o->{'xAvgCharWidth'} = $w;


$f->update;

$f->out("$ARGV[1]") or die "Cannot write font: $ARGV[1]\n";
