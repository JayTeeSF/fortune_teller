module FortuneTeller
  class CliUi
    DEFAULT_SOUND_FILE = 'flick_flick.ogg'.freeze
    attr_reader :game, :sound_file
    def initialize( options = {} )
      @game = options[ :game ]
      @sound_file = options[ :sound_file ] || DEFAULT_SOUND_FILE
    end

    def prompt(text)
      print text
      gets.chomp.tap do |result|
        display
      end
    end

    def exit( message = nil )
      display( message )
      Kernel.exit
    end

    def display( text = nil )
      puts text
    end

    def interstitial( text )
      display text
      play
      sleep(1.2)
    end

    def clear_screen( after = 0 )
      sleep( after )
      display "\e[H\e[2J"
    end

    def play
      sound.play
    end

    def sound
      @sound ||= begin
                   require "rubygame"
                   if defined?(Rubygame::Sound)
                     Rubygame::Sound.load(sound_file)
                   end
                 rescue
                 end
    end
  end
end
