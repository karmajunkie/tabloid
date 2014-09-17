require "spec_helper"

class TestReport
  DATA=[
    {'col1' => 1, 'col2' => 2},
    {'col1' => 3, 'col2' => 4}
  ]
  include Tabloid::Report

  parameter :param1, "TestParameter"

  element :col1, 'Col1'
  element :col2

  rows do
    TestReport::DATA
  end

  def name
    "Report"
  end
end

describe Tabloid::Report do
  subject{TestReport.new( param1: 'foo' )}

  describe "parameters" do
    it "has an instance setter for each parameter" do
      expect(subject).to respond_to("param1=")
    end
    it "has an instance getter for each parameter" do
      expect(subject).to respond_to("param1")
      expect(subject.param1).to eq('foo')
    end

  end

  describe "headers" do
    it "contains a header for each element" do
      expect(subject.headers.count).to eq(2)
    end
    it "defaults to a humanized version of the element name" do
      expect(subject.headers).to include('Col 2')
    end
    it "uses the label when supplied" do
      expect(subject.headers).to include("Col1")
    end
  end

  describe "elements" do
    it "has an instance element for every defined element" do
      expect(subject.elements[:col1]).not_to be_nil
    end
  end
end
