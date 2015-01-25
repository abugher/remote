#!/usr/bin/perl -W

use strict;
use warnings;

use CGI;
use URI::Encode;


use lib '/var/www/parts/perl';
use MelioraRemote::IncludeHTML;

# Kick off the HTTP session.
print( "Content-type:text/html\n\n" );

MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/page-open.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/head-open.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/listing-js.html');
MelioraRemote::IncludeHTML::includeHTML('/var/www/parts/html/head-close.html');

print << "EOF";

<form action=''>
<input class='' type='textarea' name='entry'></input>
</form>
</body>
</html>
EOF
