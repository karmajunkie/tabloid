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
    def parameter(name, type = nil, options = {})
      type ||= String
      options[:required] = true unless options.has_key?(:required)
      required_params.push(name) if options[:required]
      self.attribute name, type, options
    end
    module InstanceMethods
      def parameters_valid?
        self.class.required_params.detect{|p| self[p].nil? || self.nil == ''}.nil?
      end
    end
  end
end
