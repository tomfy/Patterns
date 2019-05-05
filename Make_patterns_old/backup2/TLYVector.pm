package TLYVector; # just a few routines for manipulating vectors
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

