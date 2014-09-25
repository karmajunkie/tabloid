module Tabloid
  module Rendering
    class JsonProcessor
      include Tabloid::Rendering::Processor

      def render
        keys = @config.elements.map{|elm| elm.key}

        JSON.fast_generate(@data.map{|d| slice(d, *keys)})
      end

      def slice(data, *keys)
        data_keys = data.keys.map(&:to_s)
        keys.inject(Hash.new){|h, k| h[k] = data[k]; h}
      end
    end
  end
end
