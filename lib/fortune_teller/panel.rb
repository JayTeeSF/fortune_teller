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
      puts "Flick, flick, flick, flick...\n"
      begin
        require "rubygame"
        if defined?(Rubygame::Sound)
          sound = Rubygame::Sound.load('flick_flick.ogg')
          sound.play
        end
      ensure
        reveal.choose
      end
    end
  end
end
require_relative "reveal"
