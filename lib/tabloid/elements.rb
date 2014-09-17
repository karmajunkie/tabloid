module Tabloid
  module Elements
    def self.extended(base)
      base.class_eval do
        include InstanceMethods
      end
    end

    def element(key, label = nil, options={})
      #hand-rolled version of titleize from active support
      label ||= key.to_s.
        gsub(/(\w)(\d+)/){ "#{$1} #{$2}" }.
        split(/[_\s]/).
        map(&:capitalize).
        join(" ")
      elements << Tabloid::ReportColumn.new(key, label, options)
    end

    def elements
      @report_columns ||= ElementCollection.new
    end

    module InstanceMethods
      def elements
        self.class.elements
      end

      def headers
        elements.map(&:label)
      end
    end

  end
end
