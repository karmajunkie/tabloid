require 'csv'
module Tabloid
  module Rendering
    class CSVProcessor
      include Tabloid::Rendering::Processor

      def render
        headers = @config.elements.map(&:label)
        csv_string = CSV.generate do |csv|
          csv << headers
          @data.each do |row|
            csv << @config.elements.map(&:key).inject([]){|arr, col| arr.push(row[col])}
          end
        end
        return csv_string
      end
    end
  end
end
