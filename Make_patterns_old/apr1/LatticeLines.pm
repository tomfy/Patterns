package LatticeLines;

# object to hold a set of line segments between lattice points.
#
# stroke:#000000;stroke-width:20;stroke-linecap:round

my %defaults = ('basis' => [[1,0], [0,1]],
		'offset' => [0, 0],
		'font-size' => 24,
		'text-anchor' => 'middle',
		'line_options' =>
		{'stroke' => '#000000',
		 'stroke-width' => '1',
		 'stroke-linecap' => 'round'}
	       );

sub new{
  my $class        = shift;
  my $self         = bless {}, $class;

  my $args_href = shift || undef; 
  foreach (keys %defaults) {
    $self->{$_} = $defaults{$_}; #
  }
  if (defined $args_href) {
    foreach (keys %$args_href) {
      #   print "arg hash key: ", $_, "  ", $args_href->{$_}, "\n";
      if ($_ eq 'line_options') {
	#	print "[", join("; ", keys %{$args_href->{'line_options'}}), "]\n";

	foreach my $line_option (keys %{$args_href->{'line_options'}}) {
	  my $value = $args_href->{'line_options'}->{$line_option};
	  #print "In new, set line option: $line_option  to  $value\n";
	  $self->{'line_options'}->{$line_option} = $value; # $args_href->{'line_options'}->{$line_option};

	  #  print $self->{'line
	}
      } else {
	$self->{$_} = $args_href->{$_};
      }
    }
  }
  my $dimensions = scalar @{$self->{'basis'}->[0]};
  foreach (@{$self->{'basis'}}) {
    my $dim = scalar @{$_};
    warn "dimensions of basis vectors not all same. $dim  $dimensions \n" if($dim != $dimensions);
  }
  $self->{'lines'} = {};
  #print "bottom on LatticeLines constructor\n";
  #$self->show_lines_and_options();
  return $self;
}

sub add_line{
  my $self = shift;
  my $endpoints = shift;	# string e.g. '0,1,1,0' 
  my $new_line_option_hashref = shift || {};
  my %line_option_hash = ();
  foreach (keys %{$self->{line_options}}) {
    $line_option_hash{$_} = $self->{line_options}->{$_};
  }
  foreach (keys %$new_line_option_hashref) {
    $line_option_hash{$_} = $new_line_option_hashref->{$_};
  }
  #  foreach (keys %line_option_hash){
  #    print "$_  ", $line_option_hash{$_}, "\n";
  #  }
  $self->{'lines'}->{$endpoints} = \%line_option_hash; #overrides any existing line with same endpoints.
  #  $self->show_lines_and_options();
}

sub show_lines_and_options{
  my $self = shift;
  my %endpts_lineoptions = %{$self->{'lines'}};
  foreach my $endpts (keys %endpts_lineoptions) {
    print "endpoints: $endpts \n";
    my %lineoptions = %{$endpts_lineoptions{$endpts}};
    foreach (keys %lineoptions) {
      print "line style option $_  ", $lineoptions{$_}, "\n";
    }
  }
}

sub svg_string{
  my $self = shift;
  my $svg_string = '';
  my %endpt_lineoptions = %{$self->{'lines'}};
  my $basis = $self->{'basis'};
  my $offset = $self->{'offset'};
  foreach my $endpts (keys %endpt_lineoptions) {
    my ($a1, $a2, $b1, $b2) = split(",", $endpts);
    my $a_x = $basis->[0]->[0] * $a1 + $basis->[1]->[0] * $a2 + $offset->[0];
    my $a_y = $basis->[0]->[1] * $a1 + $basis->[1]->[1] * $a2 + $offset->[1];
    my $b_x = $basis->[0]->[0] * $b1 + $basis->[1]->[0] * $b2 + $offset->[0];
    my $b_y = $basis->[0]->[1] * $b1 + $basis->[1]->[1] * $b2 + $offset->[1];

    $svg_string .= "<line \n" .
      "x1=\"$a_x\" y1=\"$a_y\"    " .
	"x2=\"$b_x\" y2=\"$b_y\"\n" .
	  "style=\"";
    # $svg_string .= 'style=\"';
    my %line_options = %{$endpt_lineoptions{$endpts}};
    #print "Line style OPTIONS: ", join("; ", keys %line_options), "\n";
    
    foreach my $option_name (keys %line_options) {
      #      print "$option_name ", $line_options{$option_name}, "\n";
      $svg_string .= $option_name . ':' . $line_options{$option_name} . ';';
    }
    $svg_string =~ s/;$//;	# remove final ';' if present.
    $svg_string .= "\"";
    $svg_string .= "\n" . 'id="' . $endpts . "\"/>\n";
  }
  return $svg_string;
}

sub point_position{
  my $self = shift;
  my $point = shift;		# array ref
  my ($c1, $c2) = @{$point};
  my $basis = $self->{basis};
  my $offset = $self->{offset};

  my $b_x = $basis->[0]->[0] * $c1 + $basis->[1]->[0] * $c2 + $offset->[0];
  my $b_y = $basis->[0]->[1] * $c1 + $basis->[1]->[1] * $c2 + $offset->[1];

  return [$b_x, $b_y];
}

sub text_svg{
  my $self = shift;
  my $text = shift;
  my $point = shift;   # array ref giving coefficents of basis vectors
  my $font_size = shift || $self->{'font-size'};
  my $text_anchor = shift || $self->{'text-anchor'};
  my ($x, $y) = @{$self->point_position($point)};
  # <text x="250" y="150"  font-family="Verdana" font-size="55" fill="blue" > Hello, out there </text>

  my $svg_text_string = '<text x="' . $x . '" y="' . $y . '" ';
  $svg_text_string .= ' font-size="' . $font_size . '" style="text-anchor:' . $text_anchor . '" > ' . $text . "</text>\n";
  return $svg_text_string;
}

1;

