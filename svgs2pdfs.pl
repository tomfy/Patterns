#!/usr/bin/perl -w
use strict;
use IPC::Filter qw( filter );

my $input_file = shift;
open my $fh, "<$input_file";
my $file_string = do { local $/; <$fh> };

my @pages_svg = split("<!-- PAGE SEPARATOR -->", $file_string);
my $pdf_files_to_combine = '';

my $page_number = 1;
for my $page_svg (@pages_svg){
$page_svg =~ s/^\s+//; # delete initial whitespace
#print STDERR "top of loop over pages.\n";
#print STDERR $page_svg, "\n";
my $tmp_pdf_page_file = "tmp_page_" . $page_number . '.pdf';

if(0){
my $tmp_svg_page_file = "tmp_page_" . $page_number . '.svg';
open my $fh, ">$tmp_svg_page_file";
print $fh $page_svg, "\n";
close $fh;
my $output = `cairosvg $tmp_svg_page_file -f pdf > $tmp_svg_page_file`;
print $output, "\n end of page number $page_number. \n\n\n";
}else{
my $pdf_page_output = filter $page_svg, 'cairosvg -f pdf - ';  # , '--with', 'various=args', '--etc';
#my $tmp_svg_page_file = "tmp_page_" . $page_number
open my $fh, ">$tmp_pdf_page_file";
print $fh $pdf_page_output;

$pdf_files_to_combine .= " $tmp_pdf_page_file ";
}

$page_number++;
}

my $pdf_file_name = $input_file;
$pdf_file_name =~ s/[.]svg$//;
$pdf_file_name .= '.pdf';
system " gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$pdf_file_name -dBATCH  $pdf_files_to_combine ";

my @tmp_pdf_files = split(" ", $pdf_files_to_combine);
unlink @tmp_pdf_files;
