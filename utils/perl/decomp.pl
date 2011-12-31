#!/usr/bin/perl

use strict; use Imager; use POSIX;

die "Usage: $0 source-file\n" unless $ARGV[0];

my $Width = 190.4;
my $Height = 188.7;

(my $target_dir = $ARGV[0]) =~ s/\.[^\.\/\\]*$//;

my $source_img = Imager->new();
$source_img->read(file=>$ARGV[0]) or die $source_img->errstr;

my $filenum = 0;
for (my $y=0; $y < ($source_img->getheight - $Height); $y += $Height) {
	for (my $x=0; $x < ($source_img->getwidth - $Width); $x += $Width) {
		my $decomposed = $source_img->crop(left=>floor($x+$Width/4),
		                                   right=>floor($x+$Width+$Width/4),
		                                   top=>floor($y+$Height/4),
		                                   bottom=>floor($y+$Height+$Height/4));
		$decomposed->write(file=>sprintf("%s/%05d.bmp", $target_dir, $filenum++)) or die $decomposed->errstr;
	}
}
