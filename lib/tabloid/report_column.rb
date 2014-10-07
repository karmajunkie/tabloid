module Tabloid
  class ReportColumn
    include Virtus.model
    attribute :key
    attribute :label
    attribute :hidden

    def initialize(key, label = nil, options={})
      self.key = key.to_s
      self.label = label || humanize(self.key)
      @hidden =  options[:hidden]
      @formatter = options[:formatter]
      @html = options[:html] || {}
    end

    def name
      key
    end

    def to_s
      name
    end

    def total?
      @total
    end

    def hidden?
      hidden
    end

    def to_header
      return self.label if label
      self.key
    end

    private
    def humanize(str)
      str.
        gsub(/(\w)(\d+)/){ "#{$1} #{$2}" }.
        gsub(/([a-z])([A-Z])/){"#{$1} #{$2}"}.
        split(/[_\s]/).
        map(&:capitalize).
        join(" ")
    end
  end
end
