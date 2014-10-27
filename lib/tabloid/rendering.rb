require 'tabloid/rendering/json_processor'
require 'tabloid/rendering/html_processor'
require 'tabloid/rendering/csv_processor'
module Tabloid
  module Rendering
    def render_formats
      @render_formats ||= {}
    end
    def render(format, with: nil)
      render_formats[format] = with
      define_method "to_#{format}" do
        render_to_format format
      end
    end
    def self.extended(base)
      base.class_eval do
        include InstanceMethods
      end
      base.render :html, with: HTMLProcessor
      base.render :json, with: JsonProcessor
      base.render :csv, with: CSVProcessor

    end

    module InstanceMethods
      def render_to_format(format)
        processor = self.class.render_formats[format].new(self.class.configuration, self.records)

        processor.render
      end
    end
  end
end
