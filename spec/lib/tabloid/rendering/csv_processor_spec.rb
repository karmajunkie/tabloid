require 'spec_helper'
require 'csv'

describe Tabloid::Rendering::CSVProcessor do
  describe "Rendering data" do
    let(:config){ Tabloid::ReportConfiguration.new(
      [],
      Tabloid::ElementCollection.new().push(Tabloid::ReportColumn.new(:foo, "Foo")))
    }
    let(:data){ [{"foo" => "bar1"}, {"foo" => "bar2", 'foo2' => 'bar3'}] }
    let(:output){ subject.render}
    subject{Tabloid::Rendering::CSVProcessor.new(config, data)}

    it "should not include non-elements in the dump by default" do
      expect(CSV.parse(output, headers: true).map(&:to_h)).to include({"Foo" => "bar2"})
      expect(CSV.parse(output, headers: true).map(&:to_h)).not_to include({"Foo" => "bar2", 'foo2' => 'bar3'})
    end

    it "should include a header row" do
      expect(output).to match(/\AFoo$/)
    end
  end
end
