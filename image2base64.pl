use strict;
use warnings;
use utf8;
use Clipboard;
use Win32::Clipboard;
use Encode;
use MIME::Base64;

##############################################################
### jpeg、png、gif、bmpをbase64に変換する。
### HTMLに埋め込むことを想定している。
### https://gist.github.com/tatesuke/57054a31e193ac835b60
##############################################################

# クリップボードから対象ファイルを得る
my $file_tmp = Win32::Clipboard();
my $file_tmp_decode_paste = $file_tmp->GetAs(CF_UNICODETEXT);
my $file  = decode('UTF16-LE', $file_tmp_decode_paste);
$file =~ s{^"}{};
$file =~ s{"$}{};

my $regex_extension_jpg = qr|\.(jpe?g)$|;
my $regex_extension_png = qr|\.(png)$|;
my $regex_extension_gif = qr|\.(gif)$|;
my $regex_extension_bmp = qr|\.(bmp)$|;

my $mime_type;

if ( $file =~ $regex_extension_jpg ) {
    $mime_type = 'jpeg';
}
elsif ( $file =~ $regex_extension_png ) {
    $mime_type = 'png';
}
elsif ( $file =~ $regex_extension_gif ) {
    $mime_type = 'gif';
}
elsif ( $file =~ $regex_extension_bmp ) {
    $mime_type = 'bmp';
}
else {
    print $file, "\n";
    die 'Unknown image file type.';
}

my $filesize = -s $file;    # バイト数を得る

#print $filesize . "\n";

open my $IN, '<', $file;
binmode $IN;

my $binary;

# ファイルハンドルからバイト分のデータ（バイナリ）をスカラ変数$binaryに格納する
read $IN, $binary, $filesize;
close $IN;

# バイナリをbase64にエンコード
my $base64 = encode_base64( $binary, '' );

#print 'data:image/' . $mime_type . ';base64,', $base64;
my $toClipboard = 'data:image/' . $mime_type . ';base64,' . $base64;
#print $toClipboard;

Clipboard->copy($toClipboard);