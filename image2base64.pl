use strict;
use warnings;
use utf8;
use Clipboard;
use Win32::Clipboard;
use Encode;
use MIME::Base64;

##############################################################
### Convert jpeg, png, gif, bmp to base64.
##############################################################

# Getting the target file from the clipboard
my $file_tmp              = Win32::Clipboard();
my $file_tmp_decode_paste = $file_tmp->GetAs(CF_UNICODETEXT);
my $file                  = decode( 'UTF16-LE', $file_tmp_decode_paste );
$file =~ s{^"}{};
$file =~ s{"$}{};

my $regex_extension_jpg = qr|\.(jpe?g)$|;
my $regex_extension_png = qr|\.(png)$|;
my $regex_extension_gif = qr|\.(gif)$|;
my $regex_extension_bmp = qr|\.(bmp)$|;

my $mime_type;

if ( $file =~ $regex_extension_jpg ) {
    $mime_type = 'jpeg';
} elsif ( $file =~ $regex_extension_png ) {
    $mime_type = 'png';
} elsif ( $file =~ $regex_extension_gif ) {
    $mime_type = 'gif';
} elsif ( $file =~ $regex_extension_bmp ) {
    $mime_type = 'bmp';
} else {
    print $file, "\n";
    die 'Unknown image file type.';
}

my $filesize = -s $file; # Get a byte count

open my $IN, '<', $file;
binmode $IN;

my $binary;

read $IN, $binary, $filesize;
close $IN;

# Encode binary to base64
my $base64 = encode_base64( $binary, '' );

my $toClipboard = 'data:image/' . $mime_type . ';base64,' . $base64;

Clipboard->copy($toClipboard);
