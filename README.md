remote

This is my remote control application for music and shows.  Specifically, it is
a web front end for both mplayer and pianobar.

mplayer and pianobar can each be configured to accept commands, similar to the
way it does interactively, though a control FIFO file.  When you click a button
on the web page, a Perl script chucks a few commands into the appropriate
control file.  There's some other voodoo like changing config file symlinks,
but that's the gist of it.

Depends on:
  
  - mplayer
  - pianobar

It probably relies on programs being in specific unreasonable places, and
you'll probably need to touch some FIFO's, and there might just be a file
missing.  I hope to amend some of that soon, and make this a sane-looking,
fairly portable project.

Right now, this is this is the naked truth.  It's not finished, but I'm
uploading it, because it works for me, and I'm actually using it.  If you can
make it work for you, don't let me get in your way.

I'll try to clean it up soon, though; I swear.  :)
