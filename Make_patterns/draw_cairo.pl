#!/usr/bin/perl -w
use strict;
use Math::Trig;

my ($xoffset, $yoffset) = (45, 35);
my $scale = 86.0;
my $nrows = 7;
my $ncols = 7;
my $angle = 0.375*pi/3;
my $sinang = sin($angle);
my $cosang = cos($angle);
my $long = $scale/(2.0*$sinang);

#print "$angle $sqrt3  $cosang \n";
my $short = 2.0*($sinang - $cosang) * $long;



my ($x1, $y1) = (0, 0);
my ($x2, $y2) = ($x1 - $long*$cosang, $y1 + $long*$sinang);
my ($x3, $y3) = ($x1 + $long*$sinang, $y1 + $long*$cosang);
my ($x4, $y4) = ($x2 - $short, $y2);
my ($x5, $y5) = ($x3, $y3 + $short);
my ($x6, $y6) = ($x4 - $long*$cosang, $y4 + $long*$sinang);
my ($x7, $y7) = ($x2 + $long*$cosang, $y2 + $long*$sinang);
my ($x8, $y8) = ($x5 + $long*$sinang, $y5 + $long*$cosang);
my ($x9, $y9) = ($x7 - $long*$sinang, $y7 + $long*$cosang);
my ($x10, $y10) = ($x7 + $long*$cosang, $y7 + $long*$sinang);

my @p1 = ($x1, $y1);
my @p2 = ($x2, $y2);
my @p3 = ($x3, $y3);
my @p4 = ($x4, $y4);
my @p5 = ($x5, $y5);
my @p6 = ($x6, $y6);
my @p7 = ($x7, $y7);
my @p8 = ($x8, $y8);
my @p9 = ($x9, $y9);
my @p10 = ($x10, $y10);


my @points = (\@p1, \@p2, \@p3, \@p4, \@p5,
		\@p6, \@p7, \@p8, \@p9, \@p10);


my @lines = ();

push @lines, [$points[0], $points[1]];
push @lines, [$points[0], $points[2]];
push @lines, [$points[1], $points[3]];
push @lines, [$points[2], $points[4]];
push @lines, [$points[3], $points[5]];

push @lines, [$points[1], $points[6]];
push @lines, [$points[4], $points[6]];
push @lines, [$points[4], $points[7]];
push @lines, [$points[6], $points[8]];
push @lines, [$points[6], $points[9]];

my @edge_lines_1 = ();
push @edge_lines_1, $lines[1];
push @edge_lines_1, $lines[3];
push @edge_lines_1, $lines[7];

my @edge_lines_2 = ();
push @edge_lines_2, $lines[0];
push @edge_lines_2, $lines[2];
push @edge_lines_2, $lines[4];

my @translation1 = ($points[5]->[0] - $points[0]->[0], $points[5]->[1] - $points[0]->[1]);
my @translation2 = ($points[7]->[0] - $points[0]->[0], $points[7]->[1] - $points[0]->[1]);


# print the svg to stdout:

print '<?xml version="1.0" standalone="no"?> <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">', "\n";

#print '<?xml version="1.0" standalone="no"?> <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">', "\n";


print '<svg width="1600" height="1600" version="1.1" xmlns="http://www.w3.org/2000/svg">', "\n";


#my ($nrows, $ncols) = (int (480/$scale), int (360/$scale) );
# $nrows = 8; $ncols = 8;

for (my $i=0; $i<$nrows; $i++){
	for (my $j=0; $j<$ncols; $j++){

		foreach my $line (@lines){
			my $p1_ref = $line->[0];
			my $p2_ref = $line->[1];
			my $x1 = $p1_ref->[0] + $i * $translation1[0] + $j * $translation2[0];
			my $y1 = $p1_ref->[1] + $i * $translation1[1] + $j * $translation2[1];
			my $x2 = $p2_ref->[0] + $i * $translation1[0] + $j * $translation2[0];
			my $y2 = $p2_ref->[1] + $i * $translation1[1] + $j * $translation2[1];

			my ($rx1, $ry1) = rotate($x1, $y1, 0.25*pi);
			my ($rx2, $ry2) = rotate($x2, $y2, 0.25*pi);
			($x1, $y1) = ($rx1, $ry1);
			($x2, $y2) = ($rx2, $ry2);
			$x1 += $xoffset; $x2 += $xoffset; 
			$y1 += $yoffset; $y2 += $yoffset;

			print "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" style=\"stroke:rgb(99,99,99);stroke-width:1\"/> \n"
		}
}
# close off the ragged edge at the end of the row
		foreach my $line (@edge_lines_2){
	my $p1_ref = $line->[0];
	my $p2_ref = $line->[1];
	 my $x1 = $p1_ref->[0] + $i * $translation1[0] + $ncols * $translation2[0];
                        my $y1 = $p1_ref->[1] + $i * $translation1[1] + $ncols * $translation2[1];
                        my $x2 = $p2_ref->[0] + $i * $translation1[0] + $ncols * $translation2[0];
                        my $y2 = $p2_ref->[1] + $i * $translation1[1] + $ncols * $translation2[1];

     my ($rx1, $ry1) = rotate($x1, $y1, 0.25*pi);
                        my ($rx2, $ry2) = rotate($x2, $y2, 0.25*pi);
                        ($x1, $y1) = ($rx1, $ry1);
                        ($x2, $y2) = ($rx2, $ry2);
                        $x1 += $xoffset; $x2 += $xoffset;
                        $y1 += $yoffset; $y2 += $yoffset;

                        print "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" style=\"stroke:rgb(99,99,99);stroke-width:1\"/> \n"

	}
}

for(my $j = 0; $j < $ncols; $j++){

            foreach my $line (@edge_lines_1){
        my $p1_ref = $line->[0];
        my $p2_ref = $line->[1];
         my $x1 = $p1_ref->[0] + $nrows * $translation1[0] + $j * $translation2[0];
                        my $y1 = $p1_ref->[1] + $nrows * $translation1[1] + $j * $translation2[1];
                        my $x2 = $p2_ref->[0] + $nrows * $translation1[0] + $j * $translation2[0];
                        my $y2 = $p2_ref->[1] + $nrows * $translation1[1] + $j * $translation2[1];

     my ($rx1, $ry1) = rotate($x1, $y1, 0.25*pi);
                        my ($rx2, $ry2) = rotate($x2, $y2, 0.25*pi);
                        ($x1, $y1) = ($rx1, $ry1);
                        ($x2, $y2) = ($rx2, $ry2);
                        $x1 += $xoffset; $x2 += $xoffset;
                        $y1 += $yoffset; $y2 += $yoffset;

                        print "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" style=\"stroke:rgb(99,99,99);stroke-width:1\"/> \n"

        }

}

print '</svg>', "\n";




# rotate 2-d vector by angle
# rotate($x, $y, $angle);
sub rotate{
	my $x = shift;
	my $y = shift;
	my $angle = shift;
	my $unit = shift || 'radians';
	if($unit =~ /deg/){ $angle *= 180/pi; }
	my ($xout, $yout) =
		($x*cos($angle) + $y*sin($angle),
		 -$x*sin($angle) + $y*cos($angle));

}

