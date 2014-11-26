class Resources
  class << self
    attr_accessor :data

    def [](key)
      data[key]
    end
  end
end