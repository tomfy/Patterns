package TLYVector; # just a few routines for manipulating vectors
use Exporter 'import';
@EXPORT_OK = qw(add_V  subtract_V  scalar_mult_V  dot_product_V  rotate_2d_V);
use Math::Trig;

# rotate 2-d vector ($x, $y) by angle $angle:
# rotate_2d($x, $y, $angle);
sub rotate_2d_V{
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


# returns ref to array with difference of input vectors
sub scalar_mult_V{
	my $a = shift; # scalar factor
		my $v  = shift; # 2nd vector (array ref)
		my @result = ();
	foreach (@$v){
		push @result, $a*$_;
	}
	return \@result;
}


# returns ref to array with difference of input vectors
sub add_V{
	my $v1 = shift; # 1st vector (array ref)
		my $v2 = shift; # 2nd vector (array ref)
		if(scalar @$v1 == scalar @$v2){
			my @result = ();
			for(my $i = 0; $i < scalar @$v1; $i++){
				$result[$i] = $v1->[$i] + $v2->[$i];
			}
			return \@result;
		}else{
			return;
		}
}



# returns ref to array with difference of input vectors
sub subtract_V{
	my $v1 = shift; # 1st vector (array ref)
		my $v2 = shift; # 2nd vector (array ref)
		if(scalar @$v1 == scalar @$v2){
			my @result = ();
			for(my $i = 0; $i < scalar @$v1; $i++){
				$result[$i] = $v1->[$i] - $v2->[$i];
			}
			return \@result;
		}else{
			return;
		}
}

sub dot_product_V{
  my $v1 = shift; # 1st vector (array ref)
                my $v2 = shift; # 2nd vector (array ref)
                if(scalar @$v1 == scalar @$v2){
                        my $result = 0;
                        for(my $i = 0; $i < scalar @$v1; $i++){
                                $result += $v1->[$i] * $v2->[$i];
                        }
                        return $result;
                }else{
                        return;
                }
}







1;

