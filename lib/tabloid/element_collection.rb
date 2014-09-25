module Tabloid
  class ElementCollection < Array
    def <<(element)
      push(element)
    end
    def push(element)
      keys[element.key.to_s] = self.count-1
      super
    end

    def [](key)
      return super(keys[key.to_s]) if keys.has_key?(key.to_s)
      super
    end

    private
    def keys
      @keys ||= Hash.new
    end
  end
end
