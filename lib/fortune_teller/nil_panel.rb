module FortuneTeller
  class NilPanel
    attr_reader :ui
    def initialize(ui)
      @ui = ui
    end
    def to_s
      ""
    end

    def present?
      false
    end

    def pick
      ui.exit
    end

    def choose
      ui.exit
    end
  end
end
