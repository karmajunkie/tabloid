module Tabloid
  module Parameters
    def self.extended(base)
      base.class_eval do
        include InstanceMethods
      end
    end
    def required_params
      @required_params ||= []
    end
    def parameters
      @parameters ||= []
    end
    def parameter(name, label = nil, options = {})
      unless (label.nil? || label.is_a?(String))
        options = label
        label = nil
      end

      options[:required] = true unless options.has_key?(:required)
      parameters.push(Parameter.new(name, label, options))
      required_params.push(name) if options.delete(:required)
      self.attribute name, options.delete(:type), options
    end
    module InstanceMethods
      def parameter_exists?(key)
        parameters.detect{|p| p.key.to_s == key.to_s}
      end
      def parameters_valid?
        self.class.required_params.detect{|p| self[p].nil? || self.nil == ''}.nil?
      end
    end
  end
end
