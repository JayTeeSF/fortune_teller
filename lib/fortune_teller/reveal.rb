module FortuneTeller
  class Reveal < Panel
    def choose
      ui.exit( self.to_s )
    end
  end
end
