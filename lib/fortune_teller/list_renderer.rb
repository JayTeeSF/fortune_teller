module FortuneTeller
  class ListRenderer
    attr_reader :separator
    def initialize( options = {} )
      @separator = options[:separator] || "\n"
    end

    def render( text_array )
      "Pick one (i.e. type it, then press enter):\n" +
        text_array.map(&:to_s).join( separator ) + "\n"
    end
  end
end
