module Tabloid
  module Elements
    def self.extended(base)
      base.class_eval do
        include InstanceMethods
      end
    end

    def element(key, label = nil, options={})
      #hand-rolled version of titleize from active support
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
