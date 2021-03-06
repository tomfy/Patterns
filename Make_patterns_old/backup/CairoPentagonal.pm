Hex.pm                                                                                              0000664 0001750 0001031 00000005271 11536762305 010675  0                                                                                                    ustar   tomfy                           svn                                                                                                                                                                                                                    package Hex;
use Math::Trig;
use TLYVector qw(rotate_2d);
use UnitCell;
@ISA = ("UnitCell");

sub new{
	my $class        = shift;
	my $self         = bless {}, $class;

	my $long = shift;
	$long = (defined $long)? $long: 1.0;
	my $angle = shift;
	if ( !defined $angle){ $angle = pi/3.0; } # determines shape of unit cell
		my ($cosang, $sinang) = (cos($angle), sin($angle));
	$long /= ($sinang + $cosang);
	my $overall_rotation_angle = 0.0; # 0.5*($angle + pi/2.0); # determines orientation of unit cell
	my $gap = 0.0*$long;
		my ($x1, $y1) = ($long*$sinang, 0);
	my ($x2, $y2) = ($x1 - $long*$sinang, $y1 + $long*$cosang);
	my ($x3, $y3) = ($x1 + $long*$sinang, $y1 + $long*$cosang);
	my ($x4, $y4) = ($x3, $y3 + $long);
	my ($x5, $y5) = ($x4 - $long*$sinang, $y4 + $long*$cosang);
	my ($x6, $y6) = ($x4 + $long*$sinang, $y4 + $long*$cosang);
	my ($x7, $y7) = ($x6, $y6 + $long);
# point 8,9,10 only used in edge
	my ($x8, $y8) = ($x7 - $long*$sinang, $y7 + $long*$cosang);
	my ($x9, $y9) = ($x5, $y5 + $long);
my ($x10, $y10) = ($x2, $y2 + $long);
my ($x11, $y11) = ($x9 - $long*$sinang, $y9 + $long*$cosang);

	my @points = ([$x1, $y1], [$x2, $y2], [$x3, $y3], [$x4, $y4], [$x5, $y5],
			[$x6, $y6], [$x7, $y7], [$x8, $y8], [$x9, $y9], [$x10, $y10], [$x11, $y11]);

	foreach (@points){
		my @point = @{$_};
	#	print join(" ", @point), " ... ";
		@point = TLYVector::rotate_2d(@point, $overall_rotation_angle);
	#	print join(" ", @point), "\n";
		$_ = \@point; # store the rotated point
	}
	$self->set_points(\@points);	

	my @lines = ();
	push @lines, [$points[0], $points[1]];
	push @lines, [$points[0], $points[2]];
	push @lines, [$points[1], $points[9]];
	push @lines, [$points[9], $points[4]];
	push @lines, [$points[4], $points[3]];
	push @lines, [$points[4], $points[8]];

	push @lines, [$points[2], $points[3]];
	push @lines, [$points[3], $points[5]];
	push @lines, [$points[5], $points[6]];
	push @lines, [$points[6], $points[7]];
	push @lines, [$points[7], $points[8]];
push @lines, [$points[8], $points[10]];
	my @ulines = @lines[0,1,2,3,4,5];
	$self->set_lines(\@ulines);

   my @translation_1 = ($points[2]->[0] - $points[1]->[0] + $gap, $points[2]->[1] - $points[1]->[1]);
        my @translation_2 = ($points[8]->[0] - $points[0]->[0], $points[8]->[1] - $points[0]->[1] + $gap);
        $self->{translation_1} = \@translation_1;
        $self->{translation_2} = \@translation_2;


	my @edge_lines_1 = ();
	push @edge_lines_1, $lines[2];
	push @edge_lines_1, $lines[3];
push @edge_lines_1, $lines[5];
	push @edge_lines_1, $lines[11];
	$self->{edge_lines_1} = \@edge_lines_1;

	my @edge_lines_2 = ();
	push @edge_lines_2, $lines[0];
	push @edge_lines_2, $lines[1];
	$self->{edge_lines_2} = \@edge_lines_2;

	return $self;
}


1;
                                                                                                                                                                                                                                                                                                                                       Octa.pm                                                                                             0000664 0001750 0001031 00000004622 11537751766 011050  0                                                                                                    ustar   tomfy                           svn                                                                                                                                                                                                                    package Octa;
use Math::Trig;
use TLYVector qw(rotate_2d);
use UnitCell;
@ISA = ("UnitCell");

sub new{
	my $class        = shift;
	my $self         = bless {}, $class;

	my $long = shift;
	$long = (defined $long)? $long: 1.0;
	my $angle = shift;
	if ( !defined $angle){ $angle = pi/3.0; } # determines shape of unit cell
		my ($cosang, $sinang) = (cos($angle), sin($angle));
	$long /= ($sinang + $cosang);
my $l1 = $long;
my $l2 = $long;
	my $overall_rotation_angle = 0.0; # 0.5*($angle + pi/2.0); # determines orientation of unit cell
	my $gap = 0; # 0.3*$l1; # 16*$long;
	my $sqrt2 = sqrt(2.0);
	my $hsqrt2 = 0.5*$sqrt2;
		my ($x1, $y1) = ($l1*$hsqrt2, 0);
	my ($x2, $y2) = (0, $l2*$hsqrt2);
	my ($x3, $y3) = ($x2, $y2 + $l2);
	my ($x4, $y4) = ($x3 + $l1*$hsqrt2, $y3 + $l1*$hsqrt2);
	my ($x5, $y5) = ($x4 + $l2, $y4);
	my ($x6, $y6) = ($x5 + $l1*$hsqrt2, $y5 - $l1*$hsqrt2);
my ($x7, $y7) = ($x6, $y6 - $l2);
my ($x8, $y8) = ($x7 - $l1*$hsqrt2, $y7 - $l1*$hsqrt2);
my ($x9, $y9) = ($x5 + $l1*$hsqrt2, $y5 + $l1*$hsqrt2);
my ($x10, $y10) = ($x6 + $l1*$hsqrt2, $y6 + $l1*$hsqrt2);

	my @points = ([$x1, $y1], [$x2, $y2], [$x3, $y3], [$x4, $y4], 
	[$x5, $y5], [$x6, $y6], [$x7, $y7], [$x8, $y8],
	[$x9, $y9], [$x10, $y10]); 

	foreach (@points){
		my @point = @{$_};
	#	print join(" ", @point), " ... ";
		@point = TLYVector::rotate_2d(@point, $overall_rotation_angle);
	#	print join(" ", @point), "\n";
		$_ = \@point; # store the rotated point
	}
	$self->set_points(\@points);	

	my @lines = ();
	push @lines, [$points[6], $points[7]];
	push @lines, [$points[7], $points[0]];
	push @lines, [$points[0], $points[1]];
	push @lines, [$points[1], $points[2]];
	push @lines, [$points[2], $points[3]];
	push @lines, [$points[4], $points[5]];

#	push @lines, [$points[2], $points[4]];
#	push @lines, [$points[2], $points[5]];

#	my @ulines = @lines[0,1,2,3,4,5];
	$self->set_lines(\@lines);

   my @translation_1 = ($points[6]->[0] - $points[1]->[0] + $gap, $points[6]->[1] - $points[1]->[1]);
        my @translation_2 = ($points[3]->[0] - $points[0]->[0], $points[3]->[1] - $points[0]->[1] + $gap);
        $self->{translation_1} = \@translation_1;
        $self->{translation_2} = \@translation_2;


	my @edge_lines_1 = ();
	push @edge_lines_1, $lines[3];
#	push @edge_lines_1, $lines[4];
	$self->{edge_lines_1} = \@edge_lines_1;

	my @edge_lines_2 = ();
	push @edge_lines_2, $lines[1];
	$self->{edge_lines_2} = \@edge_lines_2;

	return $self;
}


1;
                                                                                                              SnubSquare.pm                                                                                       0000664 0001750 0001031 00000004567 11536755662 012260  0                                                                                                    ustar   tomfy                           svn                                                                                                                                                                                                                    package SnubSquare;
use Math::Trig;
use TLYVector qw(rotate_2d);
use UnitCell;
@ISA = ("UnitCell");

sub new{
	my $class        = shift;
	my $self         = bless {}, $class;

	my $long = shift;
	$long = (defined $long)? $long: 1.0;
	my $angle = shift;
	if ( !defined $angle){ $angle = pi/3.0; } # determines shape of unit cell
		my ($cosang, $sinang) = (cos($angle), sin($angle));
	$long /= ($sinang + $cosang);
	my $overall_rotation_angle = 0.5*($angle + pi/2.0); # determines orientation of unit cell
	my $trans_factor = 1.0; # 1.0; # for debugging

		my ($x1, $y1) = (0, 0);
	my ($x2, $y2) = ($x1 - $long, $y1);
	my ($x3, $y3) = ($x1 + $long*$cosang, $y1 + $long*$sinang);
	my ($x4, $y4) = ($x2 + $long*$cosang, $y2 + $long*$sinang);
	my ($x5, $y5) = ($x2 - $long*$sinang, $y2 + $long*$cosang);
	my ($x6, $y6) = ($x4 - $long*$sinang, $y4 + $long*$cosang);
	my ($x7, $y7) = ($x4, $y4 + $long);
	my ($x8, $y8) = ($x3, $y3 + $long);
	my ($x9, $y9) = ($x6, $y6 + $long);

	my @points = ([$x1, $y1], [$x2, $y2], [$x3, $y3], [$x4, $y4], [$x5, $y5],
			[$x6, $y6], [$x7, $y7], [$x8, $y8], [$x9, $y9]);

	foreach (@points){
		my @point = @{$_};
	#	print join(" ", @point), " ... ";
		@point = TLYVector::rotate_2d(@point, $overall_rotation_angle);
	#	print join(" ", @point), "\n";
		$_ = \@point; # store the rotated point
	}
	$self->set_points(\@points);	

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
	$self->set_lines(\@lines);

	my @edge_lines_1 = ();
	push @edge_lines_1, $lines[0];
	push @edge_lines_1, $lines[3];
	$self->{edge_lines_1} = \@edge_lines_1;

	my @edge_lines_2 = ();
	push @edge_lines_2, $lines[1];
	push @edge_lines_2, $lines[6];
	$self->{edge_lines_2} = \@edge_lines_2;

	my @translation_1 = ($trans_factor*($points[7]->[0] - $points[0]->[0]), $trans_factor*($points[7]->[1] - $points[0]->[1]));
	my @translation_2 = ($trans_factor*($points[4]->[0] - $points[0]->[0]), $trans_factor*($points[4]->[1] - $points[0]->[1]));
	$self->{translation_1} = \@translation_1;
	$self->{translation_2} = \@translation_2;

	

	return $self;
}


1;
                                                                                                                                         TLYVector.pm                                                                                        0000664 0001750 0001031 00000000765 11534753002 011777  0                                                                                                    ustar   tomfy                           svn                                                                                                                                                                                                                    package TLYVector; # just a few routines for manipulating vectors
use Math::Trig;

# rotate 2-d vector ($x, $y) by angle $angle:
# rotate_2d($x, $y, $angle);
sub rotate_2d{
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

1;

           Triangle.pm                                                                                         0000664 0001750 0001031 00000003753 11537037710 011715  0                                                                                                    ustar   tomfy                           svn                                                                                                                                                                                                                    package Triangle;
use Math::Trig;
use TLYVector qw(rotate_2d);
use UnitCell;
@ISA = ("UnitCell");

sub new{
	my $class        = shift;
	my $self         = bless {}, $class;

	my $long = shift;
	$long = (defined $long)? $long: 1.0;
	my $angle = shift;
	if ( !defined $angle){ $angle = pi/3.0; } # determines shape of unit cell
		my ($cosang, $sinang) = (cos($angle), sin($angle));
	$long /= ($sinang + $cosang);
	my $overall_rotation_angle = 0.0; # 0.5*($angle + pi/2.0); # determines orientation of unit cell
	my $gap = 0.0; # 16*$long;

		my ($x1, $y1) = (0, 0);
	my ($x2, $y2) = ($x1 + $long, $y1);
	my ($x3, $y3) = ($x1 + $long*$cosang, $y1 + $long*$sinang);
	my ($x4, $y4) = ($x3 + $long, $y3);
	my ($x5, $y5) = ($x3 - $long*$cosang, $y3 + $long*$sinang);
	my ($x6, $y6) = ($x5 + $long, $y5);

	my @points = ([$x1, $y1], [$x2, $y2], [$x3, $y3], [$x4, $y4], [$x5, $y5], [$x6, $y6]); 

	foreach (@points){
		my @point = @{$_};
	#	print join(" ", @point), " ... ";
		@point = TLYVector::rotate_2d(@point, $overall_rotation_angle);
	#	print join(" ", @point), "\n";
		$_ = \@point; # store the rotated point
	}
	$self->set_points(\@points);	

	my @lines = ();
	push @lines, [$points[0], $points[1]];
	push @lines, [$points[0], $points[2]];
	push @lines, [$points[1], $points[2]];
	push @lines, [$points[2], $points[3]];
	push @lines, [$points[2], $points[4]];
	push @lines, [$points[2], $points[5]];

#	my @ulines = @lines[0,1,2,3,4,5];
	$self->set_lines(\@lines);

   my @translation_1 = ($points[1]->[0] - $points[0]->[0] + $gap, $points[1]->[1] - $points[0]->[1]);
        my @translation_2 = ($points[4]->[0] - $points[0]->[0], $points[4]->[1] - $points[0]->[1] + $gap);
        $self->{translation_1} = \@translation_1;
        $self->{translation_2} = \@translation_2;


	my @edge_lines_1 = ();
	push @edge_lines_1, $lines[1];
	push @edge_lines_1, $lines[4];
	$self->{edge_lines_1} = \@edge_lines_1;

	my @edge_lines_2 = ();
	push @edge_lines_2, $lines[0];
	$self->{edge_lines_2} = \@edge_lines_2;

	return $self;
}


1;
                     UnitCell.pm                                                                                         0000664 0001750 0001031 00000001604 11534755234 011665  0                                                                                                    ustar   tomfy                           svn                                                                                                                                                                                                                    package UnitCell;

# abstract UnitCell class


sub set_points{
my $self = shift;
	$self->{points} = shift;
}
sub get_points{
my $self = shift;
return $self->{points}
}

sub set_lines{
my $self = shift;
        $self->{lines} = shift;
}
sub get_lines{
my $self = shift;
return $self->{lines}
}

sub get_edge_lines_1{
my $self = shift;
return $self->{edge_lines_1};
}

sub get_edge_lines_2{
my $self = shift;
return $self->{edge_lines_2};
}

sub get_translation_1{
my $self = shift;
return $self->{translation_1};
}

sub get_translation_2{
my $self = shift;
return $self->{translation_2};
}

sub get_lines_string{
# return a string with one line on each line:
# x1,y1 x2,y2
#
my $self = shift;
my $lines_ref = $self->get_lines();
my $string = '';
foreach my $line (@$lines_ref){
	my ($x1, $y1) = @{$line->[0]};
	my ($x2, $y2) = @{$line->[1]};

	$string .= "$x1,$y1 $x2,$y2\n";
}
return $string;
}


1;
                                                                                                                            draw_pattern.pl                                                                                     0000664 0001750 0001031 00000013340 11541654032 012627  0                                                                                                    ustar   tomfy                           svn                                                                                                                                                                                                                    #!/usr/bin/perl -w
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                