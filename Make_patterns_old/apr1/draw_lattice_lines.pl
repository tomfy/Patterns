#!/usr/bin/perl -w
use strict;
use Math::Trig;
use LatticeLines;

my $scale = 150;
my $std_line_width = 2;
my $thick_line_width = 6;
my $angle = pi/3;
my $LLobj = LatticeLines->new({
			       'basis' => [[$scale, 0], 
					   [$scale*cos($angle), -1*$scale*sin($angle)]], 
			       'offset' => [1*$scale, (1 + 5)*$scale], 
			       'font-size' => 30,
			       'text-anchor' => 'middle', 
			       'line_options' => {'stroke-width' => $std_line_width}
});

#$LLobj->show_lines_and_options();

$LLobj->add_line('0,0,0,1');
$LLobj->add_line('1,0,1,3');
$LLobj->add_line('2,0,2,2');

$LLobj->add_line('3,1,4,1');
$LLobj->add_line('0,2,3,2');
$LLobj->add_line('0,3,2,3');

$LLobj->add_line('-1,3,1,1');
$LLobj->add_line('-1,4,2,1');
$LLobj->add_line('-1,5,0,4');

$LLobj->add_line('0,1,0,4', {'stroke-width' => $thick_line_width});
$LLobj->add_line('0,1,3,1', {'stroke-width' => $thick_line_width});
$LLobj->add_line('0,4,3,1', {'stroke-width' => $thick_line_width});

	my $svg_string = '<?xml version="1.0" standalone="no"?> <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' . "\n";
	$svg_string .= '<svg width="2000" height="2000" version="1.1" xmlns="http://www.w3.org/2000/svg">' . "\n";

# 	foreach my $line_ref (@$lines_ref){
# 		my ($x1, $y1) = @{$line_ref->[0]};
# 		my ($x2, $y2) = @{$line_ref->[1]}; 
# # print "$x1, $x2 \n";

# 		$svg_string .= "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" style=\"" .  "stroke:rgb($rgb);stroke-width:$stroke_width;fill:none\"/>" . "\n";

# 	}
$svg_string .= $LLobj->svg_string();

my $svg_text_string = $LLobj->text_svg('1054', [-0.5, 3], 30);
$svg_string .= $svg_text_string;

	$svg_string .= '</svg>' . "\n";

print $svg_string, "\n";

