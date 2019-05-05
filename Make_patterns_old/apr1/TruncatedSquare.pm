package TruncatedSquare;
use Math::Trig;
use TLYVector qw(rotate_2d_V);
use UnitCell;
@ISA = ("UnitCell");

sub new{
	my $class        = shift;
	my $self         = bless {}, $class;

	my $l1 = shift;
	$l1 = (defined $l1)? $l1: 1.0;
	my $l2 = $l1;	
	my $overall_rotation_angle = 0.0; # determines orientation of unit cell
		my $gap = 0;   # 0.3*$l1; 
	my $sqrt2 = sqrt(2.0);
	my $hsqrt2 = 0.5*$sqrt2;
	my ($x1, $y1) = ($l2*$hsqrt2, 0);
	my ($x2, $y2) = (0, $l2*$hsqrt2);
	my ($x3, $y3) = ($x2, $y2 + $l1);
	my ($x4, $y4) = ($x3 + $l2*$hsqrt2, $y3 + $l2*$hsqrt2);
	my ($x5, $y5) = ($x4 + $l1, $y4);
	my ($x6, $y6) = ($x5 + $l2*$hsqrt2, $y5 - $l2*$hsqrt2);
	my ($x7, $y7) = ($x6, $y6 - $l1);
	my ($x8, $y8) = ($x7 - $l2*$hsqrt2, $y7 - $l2*$hsqrt2);
	my ($x9, $y9) = ($x5 + $l2*$hsqrt2, $y5 + $l2*$hsqrt2);
	my ($x10, $y10) = ($x6 + $l2*$hsqrt2, $y6 + $l2*$hsqrt2);

	my @points = ([$x1, $y1], [$x2, $y2], [$x3, $y3], [$x4, $y4], 
			[$x5, $y5], [$x6, $y6], [$x7, $y7], [$x8, $y8],
			[$x9, $y9], [$x10, $y10]); 

	foreach (@points){
		my @point = @{$_};
#	print join(" ", @point), " ... ";
		@point = rotate_2d_V(@point, $overall_rotation_angle);
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
