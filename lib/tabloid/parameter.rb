module Tabloid
  class Parameter
    attr_accessor :key, :label
    def initialize(key, label = nil, required: true)
      self.key = key
      self.label = label || humanize(key.to_s)
    end

    private
    def humanize(string)
      string.capitalize.gsub("_", " ")
    end
  end
end
