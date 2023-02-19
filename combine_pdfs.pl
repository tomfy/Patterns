#!/usr/bin/perl -w
use strict;

my $pdf_files_to_combine = shift;

my $pdf_file_name = '4shapes';
$pdf_file_name =~ s/[.]svg$//;
$pdf_file_name .= '.pdf';
system " gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$pdf_file_name -dBATCH  $pdf_files_to_combine ";

#my @tmp_pdf_files = split(" ", $pdf_files_to_combine);
#unlink @tmp_pdf_files;
