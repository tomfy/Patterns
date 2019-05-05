#!/usr/bin/perl -w
use strict;
use Math::Trig;

my $scale = 16.0;
my $nrows = 22;
my $ncols = 12;
my $angle = 1.0*pi/3; # angle in radians.
my $stroke_width = 1.5; 
my $rgb = "50,0,199";

# whole figure is rotated by $overall_rotation_angle, and then
# translated by ($xoffset, $yoffset)
my $overall_rotation_angle = 0.0; # additional rotation of the entire pattern compared to default. 
my ($xoffset, $yoffset) = ($scale, $scale); 

# get the set of lines forming the pattern:
my $pattern_lines_ref;
if(0){
$pattern_lines_ref = pattern_from_unit_cell($nrows, $ncols, $overall_rotation_angle, $xoffset, $yoffset, snub_square_unit($scale, $angle));
}else{
$pattern_lines_ref = pattern_from_unit_cell($nrows, $ncols, $overall_rotation_angle, $xoffset, $yoffset, cairo_pentagonal_unit($scale, $angle));
}
# generate the svg code for this set of lines:
my $svg_output_string = svg_output_lines($pattern_lines_ref, $rgb, $stroke_width);

my $gnuplot_output_string = gnuplot_output_lines($pattern_lines_ref);

# print the svg to stdout:
 print $svg_output_string;

#print in gnuplot format
# print $gnuplot_output_string, "\n";

# end of main

sub gnuplot_output_lines{   

my $lines_ref = shift;
        my $rgb = shift || "99,99,99";
        my $stroke_width = shift || 1;
	my $gnuplot_string = "";
        foreach my $line_ref (@$lines_ref){
                my ($x1, $y1) = @{$line_ref->[0]};
                my ($x2, $y2) = @{$line_ref->[1]};
	$gnuplot_string .= "$x1  $y1 \n" . "$x2 $y2 \n\n";
}
return $gnuplot_string;
}


sub svg_output_lines{
# returns a string containing svg code to draw the set of lines

	my $lines_ref = shift;
	my $rgb = shift || "99,99,99";
	my $stroke_width = shift || 1;

# Not sure of the significance of the width and height here - just set to largish value.
	my $svg_string = '<?xml version="1.0" standalone="no"?> <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' . "\n";
	$svg_string .= '<svg width="2000" height="2000" version="1.1" xmlns="http://www.w3.org/2000/svg">' . "\n";

	foreach my $line_ref (@$lines_ref){
		my ($x1, $y1) = @{$line_ref->[0]};
		my ($x2, $y2) = @{$line_ref->[1]}; 
# print "$x1, $x2 \n";

		$svg_string .= "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" style=\"" .  "stroke:rgb($rgb);stroke-width:$stroke_width\"/>" . "\n";

	}

	$svg_string .= '</svg>' . "\n";
	return $svg_string;
}

sub pattern_from_unit_cell{
	my $nrows = shift;
	my $ncols = shift;
	my $overall_rotation_angle = shift;
	my $xoffset = shift;
	my $yoffset = shift;

	my ($unit_lines, $translation1, $edge_lines_1, $translation2, $edge_lines_2) = @_;  # ;
	my @lines = ();
	for (my $i=0; $i<$ncols; $i++){
		for (my $j=0; $j<$nrows; $j++){
			foreach my $line (@{$unit_lines}){
				my $p1_ref = $line->[0];
				my $p2_ref = $line->[1];
				my $x1 = $p1_ref->[0] + $i * $translation1->[0] + $j * $translation2->[0];
				my $y1 = $p1_ref->[1] + $i * $translation1->[1] + $j * $translation2->[1];
				my $x2 = $p2_ref->[0] + $i * $translation1->[0] + $j * $translation2->[0];
				my $y2 = $p2_ref->[1] + $i * $translation1->[1] + $j * $translation2->[1];

				($x1, $y1) = rotate($x1, $y1, $overall_rotation_angle);
				($x2, $y2) = rotate($x2, $y2, $overall_rotation_angle);
				$x1 += $xoffset; $x2 += $xoffset; 
				$y1 += $yoffset; $y2 += $yoffset;

				push @lines, [[$x1, $y1], [$x2, $y2]];
			}
		}
	# close off the ragged edges at the end of the column
		foreach my $line (@{$edge_lines_2}){
			my $p1_ref = $line->[0];
			my $p2_ref = $line->[1];
			my $x1 = $p1_ref->[0] + $i * $translation1->[0] + $nrows * $translation2->[0];
			my $y1 = $p1_ref->[1] + $i * $translation1->[1] + $nrows * $translation2->[1];
			my $x2 = $p2_ref->[0] + $i * $translation1->[0] + $nrows * $translation2->[0];
			my $y2 = $p2_ref->[1] + $i * $translation1->[1] + $nrows * $translation2->[1];

			($x1, $y1) = rotate($x1, $y1, $overall_rotation_angle);
			($x2, $y2) = rotate($x2, $y2, $overall_rotation_angle);
			$x1 += $xoffset; $x2 += $xoffset;
			$y1 += $yoffset; $y2 += $yoffset;

			push @lines, [[$x1, $y1], [$x2, $y2]];
		}
	}

	# close off the ragged edges at the ends of the rows
	for(my $j = 0; $j < $nrows; $j++){
		foreach my $line (@{$edge_lines_1}){
			my $p1_ref = $line->[0];
			my $p2_ref = $line->[1];
			my $x1 = $p1_ref->[0] + $ncols * $translation1->[0] + $j * $translation2->[0];
			my $y1 = $p1_ref->[1] + $ncols * $translation1->[1] + $j * $translation2->[1];
			my $x2 = $p2_ref->[0] + $ncols * $translation1->[0] + $j * $translation2->[0];
			my $y2 = $p2_ref->[1] + $ncols * $translation1->[1] + $j * $translation2->[1];

			($x1, $y1) = rotate($x1, $y1, $overall_rotation_angle);
			($x2, $y2) = rotate($x2, $y2, $overall_rotation_angle);
			$x1 += $xoffset; $x2 += $xoffset;
			$y1 += $yoffset; $y2 += $yoffset;

			push @lines, [[$x1, $y1], [$x2, $y2]];
		}
	}
	return \@lines;
}

sub cairo_pentagonal_unit{

my $long = shift || 50.0;
my $angle = shift || pi/3;
my ($cosang, $sinang) = (cos($angle), sin($angle));
my $short = 2.0*($sinang - $cosang) * $long;
my $overall_rotation_angle = 0.25*pi;

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

foreach (@points){
	my @point = @{$_};
	@point = rotate(@point, $overall_rotation_angle);
	$_ = \@point; # store the rotated point	
}

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

 return (\@lines, \@translation1, \@edge_lines_1, \@translation2, \@edge_lines_2);

} # end of cairo_pentagonal_unit

sub snub_square_unit{
	my $long = shift;
	$long = (defined $long)? $long: 50.0; 
	my $angle = shift || (pi/3.0); # determines shape of unit cell 
	my ($cosang, $sinang) = (cos($angle), sin($angle));
	$long /= ($sinang + $cosang);	
	my $overall_rotation_angle = 0.5*($angle + pi/2.0); # determines orientation of unit cell

	my ($x1, $y1) = (0, 0);
	my ($x2, $y2) = ($x1 - $long, $y1);
	my ($x3, $y3) = ($x1 + $long*$cosang, $y1 + $long*$sinang);
	my ($x4, $y4) = ($x2 + $long*$cosang, $y2 + $long*$sinang);
	my ($x5, $y5) = ($x2 - $long*$sinang, $y2 + $long*$cosang);
	my ($x6, $y6) = ($x4 - $long*$sinang, $y4 + $long*$cosang);
	my ($x7, $y7) = ($x4, $y4 + $long);
	my ($x8, $y8) = ($x3, $y3 + $long);
	my ($x9, $y9) = ($x6, $y6 + $long);

	my @points = ([$x1, $y2], [$x2, $y2], [$x3, $y3], [$x4, $y4], [$x5, $y5],
			[$x6, $y6], [$x7, $y7], [$x8, $y8], [$x9, $y9]);

foreach (@points){
        my @point = @{$_};
        @point = rotate(@point, $overall_rotation_angle);
        $_ = \@point; # store the rotated point
}

	my @lines = ();
	push @lines, [$points[0], $points[1]];
	push @lines, [$points[0], $points[2]];
	push @lines, [$points[0], $points[3]];
	push @lines, [$points[1], $points[4]];
	push @lines, [$points[1], $points[3]];

	push @lines, [$points[2], $points[3]];
	push @lines, [$points[2], $points[7]];
	push @lines, [$points[3], $points[5]];
	push @lines, [$points[3], $points[6]];
	push @lines, [$points[5], $points[6]];

	my @edge_lines_1 = ();
	push @edge_lines_1, $lines[0];
	push @edge_lines_1, $lines[3];

	my @edge_lines_2 = ();
	push @edge_lines_2, $lines[1];
	push @edge_lines_2, $lines[6];

	my @translation1 = ($points[7]->[0] - $points[0]->[0], $points[7]->[1] - $points[0]->[1]);
	my @translation2 = ($points[4]->[0] - $points[0]->[0], $points[4]->[1] - $points[0]->[1]);

	return (\@lines, \@translation1, \@edge_lines_1, \@translation2, \@edge_lines_2);
}

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
	return ($xout, $yout);
}

