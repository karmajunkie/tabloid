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
      @config ||= Tabloid::ReportConfiguration.new(
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
      @records ||= if to_sql
        execute_sql(to_sql)
      else
        row_data
      end
    end

    def execute_sql(sql)
      ActiveRecord::Base.connection.execute(sql)
    end

    def record_count
      rows_definition.count
    end

    def row_data
      @row_data ||= rows_definition
    end

    def to_sql
      @sql ||= if row_data.is_a?(String)
        finalize_sql(row_data)
      elsif row_data.respond_to?(:to_sql)
        finalize_sql(row_data.to_sql)
      end
    end

    def finalize_sql(sql)
      params = self.attributes
      binds = []
      sanitize_arr = [sql.gsub(/:(\w+):/) do |m|
          if parameter_exists?($1)
            binds << self.send($1)
            '?'
          else
            m
          end
        end
      ]+binds
      ActiveRecord::Base.send(:sanitize_sql_array, sanitize_arr)
    end

    def report_columns
      self.class.report_columns
    end

    def parameters
      self.class.parameters
    end

    def data
      load_from_cache if Tabloid.cache_enabled?
      build_and_cache_data
      @data
    end

    private

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
