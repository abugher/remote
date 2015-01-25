#!/usr/bin/perl -W

use strict;
use warnings;

use CGI;
use URI::Encode;


use lib '/var/www/parts/perl';
use MelioraRemote::IncludeHTML;

my $uri     = URI::Encode->new( { encode_reserved => 1 } );

# Operate on a specified directory, or a default.
my $sortBy = 'name';
my $q = CGI->new();
my $content_dir = $q->param('dir');
if( defined($content_dir) and $content_dir =~ /^\/storage\/bittorrent\/content\// ) {
  $content_dir = "$content_dir";
} else {
  $sortBy = 'date';
  $content_dir = '/storage/bittorrent/content';
}

# Get a listing in @content.
opendir (my($content_handle), $content_dir) or die "$! -- '$content_dir'";
my @content = grep { !/^\./ } readdir $content_handle;
closedir( $content_handle );

# Kick off the HTTP session.
print( "Content-type:text/html\n\n" );

MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/page-open.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/head-open.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/listing-js.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/head-close.html');

print( "<body>\n" );

print( "<form action='/cgi-bin/mplayer/play.pl?'>\n");

  print << "EOF";

  <input type='submit' class='big-button' value='Play Selected'>
  </input>

  <input type='button' class='big-button' value='Select All' onclick='toggleSelectAll()'>
  </input>

  <div class='level'>
  </div>

EOF


# Hash some modification times by file name.
# $mtimes{'filename'} == secondsSinceEpoch
my %mtimes;
for my $file ( @content ) {
  $mtimes{$file}=(stat( "${content_dir}/${file}" ))[9];
}

my @sortedFiles;
if( 'date' eq $sortBy ) {
  # By date.
  @sortedFiles = sort { $mtimes{$b} <=> $mtimes{$a} } keys( %mtimes );
} else {
  # By name.
  @sortedFiles = sort( keys( %mtimes ) );
}

for my $file ( @sortedFiles ) {
  (my $second, my $minute, my $hour, my $day_of_month, my $month, my $year, , , ) = localtime( $mtimes{$file} );
  $month+=1;

  my $stamp = sprintf( "%04d-%02d-%02d, %02d:%02d:%02d", $year + 1900, $month, $day_of_month, $hour, $minute, $second );

  my $link_target;
  my $escaped_file = $uri->encode("${content_dir}/${file}");
  my $class = '';
  my $checkbox = '';
  if( -f "${content_dir}/${file}" ) {
    $class = 'file-entry';
    $checkbox = "<input class='file-set-checkbox' type='checkbox' name='fileset' value='${escaped_file}'>";
    $link_target="/cgi-bin/mplayer/play.pl?file=${escaped_file}";
  } elsif( -d "${content_dir}/${file}" ) {
    $class = 'dir-entry';
    $link_target="/cgi-bin/listing.pl?dir=${escaped_file}";
    $file .= '/';
  } else {
    die "Unknown file type:  '${file}'";
  }
  print << "EOF";

  <div class='date-stamp'>
    ${stamp}
  </div>
  <div class='level'>
  </div>
  <div class='${class}'>
    $checkbox
    <a href='${link_target}'>
      ${file}
    </a>
  </div>
  <div class='level'>
  </div>

EOF
}

print << "EOF";
  <div class='select-all-area'>
    <input id='big-checkbox' type='checkbox' class='file-set-checkbox' value='Select All' onclick='selectAll(this)'>
    </input>
    Select All
  </div>
</form>
</body>
</html>
EOF
