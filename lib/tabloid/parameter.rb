module Tabloid
  class Parameter
    include Virtus.model
    attribute :key
    attribute :label, String
    attribute :type
    attribute :required, Boolean

    def initialize(key, label = nil, type: nil, required: true)
      self.key = key
      self.label = label || humanize(key.to_s)
    end

    def name
      key
    end

    private
    def humanize(string)
      string.capitalize.gsub("_", " ")
    end
  end
end
