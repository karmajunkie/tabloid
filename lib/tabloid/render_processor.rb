module Tabloid
  DefaultRenderError = Class.new(Tabloid::Error)
  module RenderProcessor
    def initialize(report_configuration, data)
      @config= report_configuration
      @data = data
    end

    def render()
      raise DefaultRenderError.new("A renderer must redefine the render method")
    end
  end
end
