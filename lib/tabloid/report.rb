require 'pdfkit'

module Tabloid::Report
  def self.included(base)
    base.class_eval do
      include Virtus.model lazy: false
      extend Tabloid::Report::ClassMethods
      extend Tabloid::Parameters
      extend Tabloid::Elements
      extend Tabloid::Rendering
      include Tabloid::Report::InstanceMethods
    end
  end

  module ClassMethods
    def configuration
      @config ||= ReportConfiguration.new(
        self.parameters,
        self.elements
      )
    end

    def report_columns
      @report_columns
    end

    def cache_key(&block)
      if block
        @cache_block = block
      end
    end

    def cache_key_block
      @cache_block
    end

    def rows(*args, &block)
      define_method :rows_definition, &block

      @rows_block = block
    end

    def formatting_by(obj)
      @formatting_by = obj
    end

    def grouping(key, options = {})
      @grouping_key     = key
      @grouping_options = options
    end

    def grouping_key
      @grouping_key
    end

    def grouping_options
      @grouping_options
    end

    def summary_options
      @summary_options
    end
  end

  module InstanceMethods

    def records
      source = rows
    end

    def record_count
      records.count
    end

    def report_columns
      self.class.report_columns
    end

    def parameters
      self.class.parameters
    end

    def parameter(key)
      load_from_cache if Tabloid.cache_enabled?
      @report_parameters[key] if @report_parameters
    end

    def data
      load_from_cache if Tabloid.cache_enabled?
      build_and_cache_data
      @data
    end

    private

    def to_complete_html
      HTML_FRAME % [ self.to_html]
    end

    def grouping_options
      self.class.grouping_options
    end

    def grouping_key
      self.class.grouping_key
    end

    def summary_options
      self.class.summary_options
    end

    def parameter_info_html
      html = Builder::XmlMarkup.new
      html = html.p("id" => "parameters") do |p|
        formatted_parameters.each do |param|
          p.div do |div|
            div.span(param[0], "class" => "parameter_label")
            div.span(param[1], "class" => "parameter_value", "style" => "padding-left: 10px;")
          end
        end
      end
      html.to_s
    end

    def formatted_parameters
      displayed_parameters.map{ |param| [param.label, format_parameter(param)] }
    end

    def format_parameter(param)
      parameter(param.key)
    end

    def displayed_parameters
      params = self.parameters.select { |param| displayed?(param) }
      params
    end

    def displayed?(param)
      true
    end

    def generate_html_id
      class_name = self.class.to_s
      class_name.gsub!(/::/, '-')
      class_name.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      class_name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      class_name.downcase!
    end
  end
end
