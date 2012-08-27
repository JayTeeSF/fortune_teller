require_relative "chooser"
require_relative "cli_ui"
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
      new( options.delete(:selection_groups), options.delete(:fortunes), options ).run
    end

    attr_reader :selection_groups, :fortunes
    attr_reader :chooser_class, :reveal_class, :panel_class
    attr_reader :chooser_options
    attr_reader :ui
    def initialize( selection_groups, fortunes, options = {} )
      @original_selection_groups = selection_groups
      @original_fortunes = fortunes
      
      @ui = options[:ui] || CliUi.new(:game => self)

      @chooser_class = options[:choose_class] || Chooser
      @reveal_class = options[:reveal_class] || Reveal
      @panel_class = options[:panel_class] || Panel
      @chooser_options = options[:chooser_options] || {}
      @chooser_options[:ui] ||= ui

      reset
    end

    def restart
      reset
      run
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
        reveal_class.new( fortune, :ui => ui )
      }
    end

    def final_choices
      @final_choices ||= selection_groups.pop.map { |selection|
        Logger.log("fc-selection: #{selection.inspect}")
        panel_class.new( selection, :reveal => chooser_class.reduce_choices!(fortune_reveals), :ui => ui )
      }
    end

    def final_chooser
      @final_chooser ||= chooser_class.new( chooser_class.reduce_choices!(final_choices), chooser_class.reduce_choices!(final_choices), chooser_options )
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
            panels << panel_class.new( selection, :reveal => choosers.first, :ui => ui )
          end
        end
        chooser_params = panels.pop, panels.pop
        chooser_options[:bl_panel] = panels.pop if panels.first
        chooser_options[:br_panel] = panels.pop if panels.first
        chooser_params << chooser_options
        choosers.unshift chooser_class.new( *chooser_params )
      end until [] == selection_groups
      return choosers.first
    end
  end
end
