module Tabloid
  class ReportColumn
    attr_accessor :key
    attr_accessor :label
    attr_accessor :hidden
    attr_accessor :formatter
    attr_accessor :html

    class FormatterError < RuntimeError; end

    def initialize(key, label = "", options={})
      self.key = key
      self.label = label
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
  end
end
