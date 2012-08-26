module FortuneTeller
  class NilPanel
    def to_s
      ""
    end

    def present?
      false
    end

    def pick
      Kernel.exit
    end

    def choose
      Kernel.exit
    end
  end
end
