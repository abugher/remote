#!/usr/bin/perl -W

use strict;
use warnings;

use CGI;
use File::Spec;
use URI::Encode;
use Time::HiRes qw( usleep );


my $uri         = URI::Encode->new( { encode_reserved => 1 } );
my $q           = CGI->new();

my $file        = $q->param('file');
my @fileset     = $q->param('fileset');

# .1 seconds seems to work, so let's do .15 for wiggle room.
# microseconds
my $napTime     = 150000;

sub issue_command {
  my $command = $_[0];

  my $control_file_name = '/mplayer.control';

  open( my $control_file_handle, '>', $control_file_name ) 
    or die "Failed to open control file ( '${control_file_name}' ) for writing:  '$!'";
  print $control_file_handle "${command}\n";
  close $control_file_handle;
  usleep( $napTime );
}


if( defined( $file ) ) {
  $file = File::Spec->rel2abs( 
    $uri->decode( $file ),
    '/'
  );
  $file =~ /^\/storage\/bittorrent\/content\// or die "Invalid file path: ${file}";
} else {
  for my $f ( keys( @fileset ) ) {
    $fileset[$f] = File::Spec->rel2abs( 
      $uri->decode( $fileset[$f] ),
      '/' 
    );
    $fileset[$f] =~ /^\/storage\/bittorrent\/content\// or die "Invalid file path: $fileset[$f]";
  }
}


if( defined( $file ) ) {
  $file =~ s/'/\\'/;
  if( "${file}" =~ /^\/storage\/bittorrent\/content\/radio\.m3u$/  ) {
    issue_command( "loadlist '${file}'" );
  } else {
    issue_command( "loadfile '${file}'" );
  }
} else {
  my $append = 0;
  for my $f ( sort( @fileset ) ) {
    $f =~ s/'/\\'/;
    if( "${f}" =~ /^\/storage\/bittorrent\/content\/radio\.m3u$/  ) {
      issue_command( "loadlist '${f}' ${append}" );
    } else {
      issue_command( "loadfile '${f}' ${append}" );
    }
    $append = 1;
  }
}

usleep( $napTime );
issue_command( "vo_fullscreen 1" );

print( "Content-type:text/html\n\n" );
print( "<meta http-equiv=refresh content='.1;/cgi-bin/remote.pl'>\n" );
