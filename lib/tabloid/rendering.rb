module Tabloid
  module Rendering
    def render_formats
      @render_formats ||= {}
    end
    def render(format, with:)
      render_formats[format] = with
      define_method "to_#{format}" do
        render_to_format format
      end
    end
  end
end
