module Tabloid
  class Parameter
    include Virtus.model
    attribute :key
    attribute :label, String
    attribute :type
    attribute :required, Boolean

    def initialize(key, label = nil, type: nil, required: true)
      self.type = type_class_to_string(type)
      self.key = key
      self.label = label || humanize(key.to_s)
    end

    def name
      key
    end

    private
    def type_class_to_string(klass)
      return klass if klass.eql?(String)
      return 'string' if klass.nil?
      return 'string' if klass.eql?(String); 
      return 'datetime' if klass.eql?(Time) || klass.eql?(Date)
      return 'integer' if klass.eql?(Integer) || klass.eql?(Bignum)
      return 'range' if klass.eql?(Range)
      return 'float' if klass.eql?(Float) || klass.eql?( Rational) || klass.eql?(Numeric)
      return klass.to_s
    end
    def humanize(string)
      string.capitalize.gsub("_", " ")
    end
  end
end
