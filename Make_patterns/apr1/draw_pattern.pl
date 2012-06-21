#!/usr/bin/perl -w
use strict;
use Math::Trig;
use UnitCell;
use SnubSquare;
use CairoPentagonal;
use Hex;
use Triangle;
use TruncatedSquare;;
use TLYVector qw(add_V scalar_mult_V rotate_2d_V);
use Getopt::Std;

# read data from stdin
# -p <pattern>  choose the pattern ss, cp, tr, hx, ...
# -r <nrows> number of rows
# -c <ncols> number of cols
# -s <scale> scale (20-100 typical)
# -a <angle> angle param used in def of unit cell (for some patterns)
# angle is pi times this param.
use vars qw($opt_p $opt_r $opt_c $opt_s $opt_a);

# get options
getopts("p:r:c:s:a:h");

if(!defined $opt_p){
print "Usage: draw_pattern -p <pattern> -r <nrows> -c <ncols> -s <scale> -a <angle_param> \n";
print " possible patterns: SnubSquare CairoPentagonal Triangle Hex TruncatedSquare \n";
print " Pattern must be specified on command line; other parameters have following defaults: \n";
print " nrows: 10; ncols: nrows; scale 50; angle_param: 1/3. \n";
print " The actual angle used is pi*angle_param, which is pi/3 by default. \n";
print " Outputs svg to stdout. \n";
exit;
}
# print "# \'histogram.pl -c 1  -l -3.0 -u 11.0 -w 0.1  < data\'\n";
# print "[$opt_p, $opt_r, $opt_c, $opt_s, $opt_a] \n";

my $scale = $opt_s || 50.0;
my $offset_factor = 0.01;
my $nrows = $opt_r || 10;
my $ncols = $opt_c || $nrows;
my $angle = (defined $opt_a)? pi*$opt_a: pi/3; # angle in radians.

# print "[$opt_p, $opt_r, $opt_c, $opt_s, $opt_a] \n";

my $stroke_width = 1.2; 
my $rgb = "50,50,50"; #"180,180,180";
my $ss = 1;
# whole figure is rotated by $overall_rotation_angle, and then
# translated by ($xoffset, $yoffset)
my $overall_rotation_angle = 0.0; # additional rotation of the entire pattern compared to default. 
my ($xoffset, $yoffset) = ($offset_factor*$scale, $offset_factor*$scale); 

my $unit_cell_obj;
if($opt_p eq 'SnubSquare'){
$unit_cell_obj = SnubSquare->new($scale, $angle);
}
elsif($opt_p eq 'CairoPentagonal'){
$unit_cell_obj = CairoPentagonal->new($scale, $angle);
}
elsif($opt_p eq 'Hex'){
$unit_cell_obj = Hex->new($scale, $angle);
}
elsif($opt_p eq 'Triangle'){
$unit_cell_obj = Triangle->new($scale, $angle);
}
elsif($opt_p eq 'TruncatedSquare'){
$unit_cell_obj = TruncatedSquare->new($scale, $angle);
}

# get the set of lines forming the pattern:
my $pattern_lines_ref = pattern_from_unit_cell($unit_cell_obj, $nrows, $ncols, $overall_rotation_angle, $xoffset, $yoffset);

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
# just lots of individual lines, not polylines

	my $lines_ref = shift; # this is an array ref. Each elem of array is a ref to two pts
# specifying the endpoints of the line segment. Each point is specified as a ref to an array of 
# x and y coordinates.
	my $rgb = shift || "99,99,99";
	my $stroke_width = shift || 1;

# example of svg code for line:
# ponoko requires fill:none, and small stroke-width. Not sure why stroke:#0000ff (i.e. black) here.
#   id="line31515" /><line
#     x1="1090.9858"
#     y1="875.58185"
#     x2="1049.9911"
#     y2="946.58704"
#     style="stroke:#0000ff;stroke-width:0.02834646000000000;stroke-opacity:1;stroke-miterlimit:4;stroke-dasharray:none;fill:none"


# Not sure of the significance of the width and height here - just set to largish value.
	my $svg_string = '<?xml version="1.0" standalone="no"?> <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' . "\n";
	$svg_string .= '<svg width="2000" height="2000" version="1.1" xmlns="http://www.w3.org/2000/svg">' . "\n";

	foreach my $line_ref (@$lines_ref){
		my ($x1, $y1) = @{$line_ref->[0]};
		my ($x2, $y2) = @{$line_ref->[1]}; 
# print "$x1, $x2 \n";

		$svg_string .= "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" style=\"" .  "stroke:rgb($rgb);stroke-width:$stroke_width;fill:none\"/>" . "\n";

	}

	$svg_string .= '</svg>' . "\n";
	return $svg_string;
}

sub pattern_from_unit_cell{

	my $unit_cell_obj = shift;
	my $nrows = shift;
	my $ncols = shift;
	my $overall_rotation_angle = shift;
	my $xoffset = shift;
	my $yoffset = shift;
#	my $unit_cell_obj = shift;

	my $unit_lines = $unit_cell_obj->get_lines();
	my $edge_lines_1 = $unit_cell_obj->get_edge_lines_1();
	my $translation1 = $unit_cell_obj->get_translation_1();
	my $edge_lines_2 = $unit_cell_obj->get_edge_lines_2();
	my $translation2 = $unit_cell_obj->get_translation_2();

	my @lines = ();
	for (my $i=0; $i<$ncols; $i++){
		for (my $j=0; $j<$nrows; $j++){
			my $translation = add_V(scalar_mult_V($i, $translation1), scalar_mult_V($j, $translation2));
			foreach my $line (@{$unit_lines}){
				my $p1_ref = $line->[0];
				my $p2_ref = $line->[1];
				my ($x1, $y1) = @{add_V( $p1_ref, $translation ) };
				my ($x2, $y2) = @{add_V( $p2_ref, $translation ) };

				($x1, $y1) = rotate_2d_V($x1, $y1, $overall_rotation_angle);
				($x2, $y2) = rotate_2d_V($x2, $y2, $overall_rotation_angle);
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

			($x1, $y1) = rotate_2d_V($x1, $y1, $overall_rotation_angle);
			($x2, $y2) = rotate_2d_V($x2, $y2, $overall_rotation_angle);
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

			($x1, $y1) = rotate_2d_V($x1, $y1, $overall_rotation_angle);
			($x2, $y2) = rotate_2d_V($x2, $y2, $overall_rotation_angle);
			$x1 += $xoffset; $x2 += $xoffset;
			$y1 += $yoffset; $y2 += $yoffset;

			push @lines, [[$x1, $y1], [$x2, $y2]];
		}
	}
	return \@lines;
}
