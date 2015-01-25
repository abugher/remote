#!/usr/bin/perl -W

use strict;
use warnings;

use CGI;


my $q = CGI->new();
my $station = $q->param('station');

if(  $station !~ /^[0-9]{1,100}$/ ) {
  die( 'I need a reasonably sized number.' );
}

my $ret = 0;
system( 'sudo /etc/init.d/pianobar stop >/dev/null 2>&1' );
$ret = $? >> 8;
if( 0 != $ret ) {
  die "Error:  Failed to stop pianobar: ${ret}";
}
my $real_config = readlink( '/etc/pianobard/config' );
system( "sed -Ei 's/autostart_station = [0-9]+/autostart_station = ${station}/' '/etc/pianobard/${real_config}'" );
system( 'sudo /etc/init.d/pianobar start >/dev/null 2>&1' );
$ret = $? >> 8;
if( 0 != $ret ) {
  die "Error:  Failed to start pianobar: ${ret}";
}

# It starts paused.  User is interacting.  Make sound.
system( 'echo " " > /etc/pianobard/ctl' );

print( "Content-type:text/html\n\n" );
print( "<meta http-equiv=refresh content='.1;/cgi-bin/remote.pl'>\n" );
