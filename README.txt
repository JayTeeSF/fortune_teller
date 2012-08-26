Total hack of a commandline Ruby version of an origami fortune teller:
  http://en.wikipedia.org/wiki/Paper_fortune_teller

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

TODO:
  custom fortune-teller
  graphics
