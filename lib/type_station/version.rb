module TypeStation
  module Version
    MAJOR = 0
    MINOR = 0
    TINY  = 1
    PRE   = 'pre'
    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
