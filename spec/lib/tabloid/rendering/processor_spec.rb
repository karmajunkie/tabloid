require 'spec_helper'

describe Tabloid::Rendering::Processor do
  class ProcessorExample
    include Tabloid::Rendering::Processor
  end
  let(:config){ Tabloid::ReportConfiguration.new([], Tabloid::ElementCollection.new().push(Tabloid::ReportColumn.new(:foo, "Foo"))) }
  let(:data){[{:foo => :bar}]}

  describe "formatting data" do
    it "demands a configuration and data in the initializer" do
      expect{ProcessorExample.new(config, data)}.not_to raise_error
    end
    it "responds to #render" do
      expect(ProcessorExample.new(config, data)).to respond_to(:render)
    end
    it "raises an error by default" do
      expect{ProcessorExample.new(config, data).render}.to raise_error
    end
    it "does not raise an error if render is redefined" do
      ProcessorExample.class_eval do
        def render

        end
      end
      expect{ProcessorExample.new(config, data).render}.not_to raise_error
    end
  end
end
