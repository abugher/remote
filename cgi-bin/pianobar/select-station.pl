#!/usr/bin/perl -W

use strict;
use warnings;


my $config_link = readlink '/etc/pianobard/config';

my %stations;
if( 'config_aaron' eq $config_link ) {
  %stations = (
    'Mellow'                    => '1279496493032844030',
    'Tranquil'                  => '1945162032447007486',
    'Messages'                  => '2017382573249178366',
    'Green'                     => '1563419605397187326',
    'Light &amp; Dark'          => '1357116537870527230',
    'Dad (Grandpa)'             => '2445031010917985022',
  );
} elsif( 'config_rachel' eq $config_link ) {
  %stations = (
    'Mezzanine'                 => '1562875583332104695',
    'White Town'                => '841120468271643127',
    'Motion City Soundtrack'    => '1055134290584812023',
    'Cake'                      => '1418472044036897271',
  );
} else {
  die( "Whose config file is this?  $config_link" );
}

print( "Content-type:text/html\n\n" );
print << "EOF";
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width; height=device-height; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">

    <link rel="stylesheet" type="text/css" href="/style.css">
  </head>

  <body>
EOF

for my $station_name ( sort( keys( %stations ) ) ) {
  my $station_id = $stations{$station_name};
  print << "EOF";
    <div class="date-stamp">
    </div>
    <div class="level">
    </div>
    <a href="/cgi-bin/pianobar/change-station.pl?station=$station_id">
      <div class='file-entry'>
        $station_name
      </div>
    </a>
    <div class="level">
    </div>

EOF
}

print << "EOF";
  </body>
</html>
EOF
