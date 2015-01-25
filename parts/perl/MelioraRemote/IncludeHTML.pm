use strict;
use warnings;

package MelioraRemote::IncludeHTML;

sub includeHTML {
  my ($file_name) = @_;

  my $file_handle;
  if( open($file_handle, '<', $file_name) ) {
    while( my $line = <$file_handle> ) {
      print( $line );
    }
  } else {
    die( "Failed to open ${file_name}:  $!" );
  }
  close( $file_handle );
}

1;
