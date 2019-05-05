package CairoPentagonal;
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
	$long /= (2.0*$sinang);
	my $short = 2.0*($sinang - $cosang) * $long;

	my $overall_rotation_angle = pi/4.0; #0.5*($angle + pi/2.0); # determines orientation of unit cell
	my $trans_factor = 1.0; # 1.0; # for debugging


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

# ss
	my @points = ([$x1, $y1], [$x2, $y2], [$x3, $y3], [$x4, $y4], [$x5, $y5],
			[$x6, $y6], [$x7, $y7], [$x8, $y8], [$x9, $y9], [$x10, $y10]);

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
push @lines, [$points[1], $points[3]];
push @lines, [$points[2], $points[4]];
push @lines, [$points[3], $points[5]];

push @lines, [$points[1], $points[6]];
push @lines, [$points[4], $points[6]];
push @lines, [$points[4], $points[7]];
push @lines, [$points[6], $points[8]];
push @lines, [$points[6], $points[9]];
	$self->set_lines(\@lines);

	my @edge_lines_2 = ();
	push @edge_lines_2, $lines[1];
	push @edge_lines_2, $lines[3];
	push @edge_lines_2, $lines[7];
	$self->{edge_lines_2} = \@edge_lines_2;

	my @edge_lines_1 = ();
	push @edge_lines_1, $lines[0];
	push @edge_lines_1, $lines[2];
	push @edge_lines_1, $lines[4];
	$self->{edge_lines_1} = \@edge_lines_1;

	my @translation_2 = ($trans_factor*($points[5]->[0] - $points[0]->[0]), $trans_factor*($points[5]->[1] - $points[0]->[1]));
	my @translation_1 = ($trans_factor*($points[7]->[0] - $points[0]->[0]), $trans_factor*($points[7]->[1] - $points[0]->[1]));
	$self->{translation_1} = \@translation_1;
	$self->{translation_2} = \@translation_2;

	

	return $self;
}


1;
