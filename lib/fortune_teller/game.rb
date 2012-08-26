require_relative "chooser"
module FortuneTeller
  class Game
    DEFAULT_SELECTION_GROUPS = [
      lambda { Chooser.subset([ "dog", "chicken", "mouse", "cat", "dragon", "turtle", "tiger", "snake", "monkey" ], 4) },
      lambda { Chooser.subset([ "3", "9", "5", "7", "10", "27", "100" ], 4) },
      lambda { Chooser.subset([ "pink", "green", "blue", "yellow" ], 2) },
    ].freeze

    DEFAULT_FORTUNES = [
      "Oops, you're in Jail!",
      "Yuck, you're in the mud!",
      "Wow, you get a cookie!",
      "Ouch, you got bit!",
      "Hey, you get a hug!",
    ].freeze

    def self.run( options = {} )
      options[:selection_groups] ||= DEFAULT_SELECTION_GROUPS.map(&:call)
      options[:fortunes] ||= DEFAULT_FORTUNES
      new( options[:selection_groups], options[:fortunes] ).run
    end

    attr_reader :selection_groups, :fortunes
    def initialize( selection_groups, fortunes )
      @original_selection_groups = selection_groups
      @original_fortunes = fortunes
      reset
    end

    def reset
      @fortunes = @original_fortunes.dup
      @selection_groups = @original_selection_groups.dup
    end

    def run
      chooser_tree.choose
    end


    private

    def fortune_reveals
      @fortune_reveals ||= fortunes.map { |fortune|
        Reveal.new( fortune )
      }
    end

    def final_choices
      @final_choices ||= selection_groups.pop.map { |selection|
        Logger.log("fc-selection: #{selection.inspect}")
        Panel.new( selection, Chooser.reduce_choices!(fortune_reveals) )
      }
    end

    def final_chooser
      @final_chooser ||= Chooser.new( Chooser.reduce_choices!(final_choices), Chooser.reduce_choices!(final_choices) )
    end

    def chooser_tree
      @chooser_tree ||= generate_choosers
    end

    def generate_choosers
      choosers = [ final_chooser ]
      begin
        panels = []
        if selection_group = selection_groups.pop
          selection_group.each do |selection|
            panels << Panel.new( selection, choosers.first )
          end
        end
        choosers.unshift Chooser.new( *panels )
      end until [] == selection_groups
      return choosers.first
    end
  end
end
