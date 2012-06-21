package Hex;
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
