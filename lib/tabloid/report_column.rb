module Tabloid
  class ReportColumn
    attr_accessor :key
    attr_accessor :label
    attr_accessor :hidden
    attr_accessor :formatter
    attr_accessor :html

    def initialize(key, label = nil, options={})
      self.key = key.to_s
      self.label = label || humanize(self.key)
      @hidden =  options[:hidden]
      @formatter = options[:formatter]
      @html = options[:html] || {}
    end

    def to_s
      @key.to_s
    end

    def total?
      @total
    end

    def hidden?
      hidden
    end

    def with_format?
      !@formatter.nil?
    end

    def to_header
      return self.label if label
      self.key
    end

    def format(value, row)
      @formatter.arity == 1 ? @formatter.call(value) : @formatter.call(value, row)
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
