require_relative "nil_panel"
module FortuneTeller
  class Panel
    attr_reader :label
    attr_accessor :reveal
    def initialize(_label, _reveal = nil )
      @label = _label
      @reveal = _reveal ||= NilPanel.new
    end
    alias_method :to_s, :label

    def present?
      true
    end

    def pick
      sound.play
      puts "Flick, flick, flick, flick...\n"
      sleep(1.2)
      reveal.choose
    end

    private

    def sound
      @sound ||= begin
                   require "rubygame"
                   if defined?(Rubygame::Sound)
                     Rubygame::Sound.load('flick_flick.ogg')
                   end
                 rescue
                 end
    end
  end
end
require_relative "reveal"
