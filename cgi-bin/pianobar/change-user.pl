#!/usr/bin/perl -W

use strict;
use warnings;

use CGI;


my $q = CGI->new();
my $user = $q->param('user');

if( ! defined( $user ) ) {
  die('Who?');
}

my $config_file;
if( 'aaron' eq "${user}" ) {
  $config_file = 'config_aaron';
} elsif( 'rachel' eq "${user}" ) {
  $config_file = 'config_rachel';
} else {
  die 'Who?';
}

my $ret = 0;
system( 'sudo /etc/init.d/pianobar stop >/dev/null 2>&1' );
$ret = $? >> 8;
if( 0 != $ret ) {
  die "Error:  Failed to stop pianobar: ${ret}";
}
unlink( '/etc/pianobard/config' );
symlink( $config_file, '/etc/pianobard/config' );
system( 'sudo /etc/init.d/pianobar start >/dev/null 2>&1' );
$ret = $? >> 8;
if( 0 != $ret ) {
  die "Error:  Failed to start pianobar: ${ret}";
}

# It starts paused.  User is interacting.  Make sound.
system( 'echo " " > /etc/pianobard/ctl' );

print( "Content-type:text/html\n\n" );
print( "<meta http-equiv=refresh content='.1;/cgi-bin/remote.pl'>\n" );
