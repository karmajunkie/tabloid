module Tabloid
  class ElementCollection < Array
    def <<(element)
      @keys ||= Hash.new
      @keys[element.key] = self.count
      super
    end

    def [](key)
      super(@keys[key])
    end
  end
end
