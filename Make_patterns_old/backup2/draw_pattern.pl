#!/usr/bin/perl -w
use strict;
use Math::Trig;
use UnitCell;
use SnubSquare;
use CairoPentagonal;
use Hex;
use Triangle;
use Octa;
use TLYVector;

my $scale = 160.0;
my $offset_factor = 0.25;
my $nrows = 4;
my $ncols = 3;
my $angle = 1.0*pi/3; # angle in radians.
my $stroke_width = 1.2; 
my $rgb = "50,0,199";
my $ss = 1;
# whole figure is rotated by $overall_rotation_angle, and then
# translated by ($xoffset, $yoffset)
my $overall_rotation_angle = 0.0; # additional rotation of the entire pattern compared to default. 
my ($xoffset, $yoffset) = ($offset_factor*$scale, $offset_factor*$scale); 

my $snub_square_unit_obj = SnubSquare->new($scale);
#print scalar @{$snub_square_unit_obj->get_lines()}, "\n";
my $cairo_pentagonal_unit_obj = CairoPentagonal->new($scale);
#print scalar @{$cairo_pentagonal_unit_obj->get_lines()}, "\n";
my $hex_unit_obj = Hex->new($scale);
my $tri_unit_obj = Triangle->new($scale);
my $octa_unit_obj = Octa->new($scale);
# get the set of lines forming the pattern:
my $pattern_lines_ref = pattern_from_unit_cell($cairo_pentagonal_unit_obj, $nrows, $ncols, $overall_rotation_angle, $xoffset, $yoffset);
#pattern_from_unit_cell($snub_square_unit_obj, $nrows, $ncols, $overall_rotation_angle, $xoffset, $yoffset):
#pattern_from_unit_cell($cairo_pentagonal_unit_obj, $nrows, $ncols, $overall_rotation_angle, $xoffset, $yoffset);

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


#	my ($unit_lines, $translation1, $edge_lines_1, $translation2, $edge_lines_2) = @_;  # ;
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

				($x1, $y1) = TLYVector::rotate_2d($x1, $y1, $overall_rotation_angle);
				($x2, $y2) = TLYVector::rotate_2d($x2, $y2, $overall_rotation_angle);
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

			($x1, $y1) = TLYVector::rotate_2d($x1, $y1, $overall_rotation_angle);
			($x2, $y2) = TLYVector::rotate_2d($x2, $y2, $overall_rotation_angle);
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

			($x1, $y1) = TLYVector::rotate_2d($x1, $y1, $overall_rotation_angle);
			($x2, $y2) = TLYVector::rotate_2d($x2, $y2, $overall_rotation_angle);
			$x1 += $xoffset; $x2 += $xoffset;
			$y1 += $yoffset; $y2 += $yoffset;

			push @lines, [[$x1, $y1], [$x2, $y2]];
		}
	}
	return \@lines;
}
