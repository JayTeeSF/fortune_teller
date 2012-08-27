require_relative "list_renderer"
require_relative "logger"
module FortuneTeller
  class Chooser
    LOCATIONS = [ :tl, :tr, :bl, :br ]

    def self.subset(list, num=list.size)
      Logger.log("got list: #{list.inspect}, num: #{num.inspect}")
      choices = list.dup
      num.times.collect {|num|
        reduce_choices!(choices)
      }
    end

    def self.reduce_choices!( choices, by=random_choice(choices) )
      choices.delete(by)
    end

    def self.random_choice(choices)
      choices[rand(choices.size)]
    end

    attr_reader :tl_panel, :tr_panel, :bl_panel, :br_panel
    attr_reader :list_renderer, :ui
    def initialize(_tl_panel, _tr_panel, options = {})
      @ui = options[:ui]
      @tl_panel = _tl_panel
      Logger.log "tl_panel: #{@tl_panel}"
      @tr_panel = _tr_panel
      Logger.log "tr_panel: #{@tr_panel}"
      @bl_panel = options[:bl_panel] || NilPanel.new(@ui)
      Logger.log "bl_panel: #{@bl_panel}"
      @br_panel = options[:br_panel] || NilPanel.new(@ui)
      Logger.log "br_panel: #{@br_panel}"
      @list_renderer = options[:list_renderer] || ListRenderer.new
      define_selection_aliases
    end

    def selections_hash
      LOCATIONS.reduce({}) {|memo, location|
        if (value = send( "#{location}_panel" )).present?
          memo[location] = value
        end
        memo
      }
    end

    def selections
      selections_hash.values
    end

    def define_selection_aliases
      selections_hash.each_pair do |k,v|
        self.class.send(:alias_method, v.to_s.to_sym, k)
      end
    end

    def valid? choice
      respond_to? choice
    end

    def exit
      yield if block_given?
      Logger.log "exiting..."
      Kernel.exit
    end
    alias_method :Q, :exit
    alias_method :q, :exit

    def choose
      choice = nil
      begin
        ui.clear_screen
        choice = ui.prompt( list_renderer.render( selections | [:exit] ) )
        Logger.log("got: #{choice.inspect}")
      end until( valid?( choice ) )
      Logger.log("trying it...")
      ui.clear_screen(1)
      # need to unalias methods...
      send( choice )
    end

    LOCATIONS.each do |location|
      define_method(location) {
        send( "#{location}_panel" ).tap do |panel|
          panel.pick
        end
      }
    end
  end
end
require_relative "panel"
