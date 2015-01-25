#!/usr/bin/perl -W

use strict;
use warnings;

use lib '/var/www/parts/perl';
use MelioraRemote::IncludeHTML;


# Kick off the HTTP session.
print( "Content-type:text/html\n\n" );

MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/page-open.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/head-open.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/magic-scroll.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/remote-js.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/head-close.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/remote-body.html');

print << "EOF";

</html>

EOF
