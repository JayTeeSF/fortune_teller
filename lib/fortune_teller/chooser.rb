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
    attr_reader :list_renderer
    def initialize(_tl_panel, _tr_panel, _bl_panel = nil, _br_panel = nil, options = {})
      @tl_panel = _tl_panel
      Logger.log "tl_panel: #{@tl_panel}"
      @tr_panel = _tr_panel
      Logger.log "tr_panel: #{@tr_panel}"
      @bl_panel = _bl_panel || NilPanel.new
      Logger.log "bl_panel: #{@bl_panel}"
      @br_panel = _br_panel || NilPanel.new
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
        self.class.clear_screen
        choice = self.class.prompt( list_renderer.render( selections | [:exit] ) )
        Logger.log("got: #{choice.inspect}")
      end until( valid?( choice ) )
      Logger.log("trying it...")
      self.class.clear_screen(1)
      send( choice )
    end

    def self.clear_screen( after = 0 )
      sleep( after )
      puts "\e[H\e[2J"
    end

    LOCATIONS.each do |location|
      define_method(location) {
        send( "#{location}_panel" ).pick
      }
    end

    def self.prompt(text)
      print text
      gets.chomp.tap do |result|
        puts
      end
    end
  end
end
require_relative "panel"
