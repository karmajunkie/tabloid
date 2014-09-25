require 'spec_helper'
require 'json'

describe Tabloid::Rendering::JsonProcessor do
  describe "Rendering data" do
    let(:config){ Tabloid::ReportConfiguration.new(
      [],
      Tabloid::ElementCollection.new().push(Tabloid::ReportColumn.new(:foo, "Foo")))
    }
    let(:data){ [{"foo" => "bar1"}, {"foo" => "bar2", 'foo2' => 'bar3'}] }
    subject{Tabloid::Rendering::JsonProcessor.new(config, data)}
    it "converts data to json" do
      expect(JSON.parse(subject.render)).to include({"foo" => "bar1"})
    end

    it "should not include non-elements in the dump by default" do
      expect(JSON.parse(subject.render)).to include({"foo" => "bar2"})
      expect(JSON.parse(subject.render)).not_to include({"foo" => "bar2", 'foo2' => 'bar3'})
    end
  end
end
