package UnitCell;

# abstract UnitCell class

sub setup{
my $self = shift;


}

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
