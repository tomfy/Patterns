package Triangle;
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
