package SnubSquare;
use Math::Trig;
use TLYVector qw(rotate_2d_V);
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
		@point = rotate_2d_V(@point, $overall_rotation_angle);
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
