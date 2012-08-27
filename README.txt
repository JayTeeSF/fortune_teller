What?
  A total hack
  A Ruby-based commandline version of an origami fortune-teller:
    http://en.wikipedia.org/wiki/Paper_fortune_teller

Why?
 Cuz my kids were making paper fortune-tellers and I thought I'd
 inspire them with a little computer-science
 (so far they just like that I can change my fortune-teller faster than
they can)

To use it simply...
  install it:
    gem install fortune_teller
    (
      if you also want sound-effects, you'll need to
      install sdl. The following is probably overkill, but
      worked for me (on OSX 10.7.4):
        brew install sdl
        brew install sdl_gfx sdl_image sdl_mixer sdl_ttf
    )

  then, run it:
    fortune_teller

  Expect to see (something like):
    Pick one (i.e. type it, then press enter):
    bird
    dog
    chicken
    mouse
    exit

At which point, you type your selection, followed by pressing the
enter-key
...it's that easy.

To integrate with your own code...
  require 'fortune_teller'
  
  And have fun (see FortuneTeller::Game.run):

   # array of array of strings
   selection_groups = FortuneTeller::Game::DEFAULT_SELECTION_GROUPS.map(&:call)

   # array of strings
   fortunes = FortuneTeller::Game::DEFAULT_FORTUNES

   # options include the :ui to use, default is CliUi

   game = FortuneTeller::Game.new( selection_groups, fortunes, options )

   game.run

TODO:
  confirm (i.e. create proof-of-concept) that modularized & injected dependencies (i.e. :ui) work w/ Commandline, Ruby, Rubygame, etc...
