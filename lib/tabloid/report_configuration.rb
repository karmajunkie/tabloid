module Tabloid
  class ReportConfiguration
    attr_reader :parameters, :element_collection
    def initialize(parameters, element_collection)
      @parameters = parameters
      @elements = element_collection
    end
  end
end
