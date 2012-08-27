require_relative "nil_panel"
module FortuneTeller
  class Panel
    attr_reader :label
    attr_accessor :reveal
    attr_accessor :ui
    def initialize(label, options = {} )
      @label = label
      @ui = options[:ui]
      @reveal = options[:reveal] || NilPanel.new(@ui)
    end
    alias_method :to_s, :label

    def present?
      true
    end

    def pick
      ui.interstitial( "Flick, flick, flick, flick..." )
      reveal.choose
    end

  end
end
require_relative "reveal"
