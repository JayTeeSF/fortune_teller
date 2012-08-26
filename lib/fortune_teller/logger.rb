module FortuneTeller
  class Logger
    DEBUG_LEVEL = nil
    def self.log message, msg_level = 0
      puts message if DEBUG_LEVEL && msg_level >= DEBUG_LEVEL
    end
  end
end
