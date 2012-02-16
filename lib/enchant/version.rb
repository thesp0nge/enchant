module Enchant
  module Version
    MAJOR = 1 
    MINOR = 0
    PATCH = 0
    BUILD = 'pre2'

    def self.version
      if BUILD.empty?
        return [MAJOR, MINOR, PATCH].compact.join('.')
      else
        return [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
      end
    end
  end
end
