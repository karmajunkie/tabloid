require "spec_helper"

class TestReport
  DATA=[
    {'col1' => 1, 'col2' => 2},
    {'col1' => 3, 'col2' => 4}
  ]
  include Tabloid::Report

  parameter :param1

  element :col1, 'Col1'
  element :col2

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

  #class's rows
  describe 'compiling data' do
    context "with ActiveRecord::Relation present" do
      TestReport.class_eval do
        def rows

        end
      end
      it "uses the relation as the source of SQL" do
      end
    end
    context "with a raw enumerable returned" do
      TestReport.class_eval do
        def rows
          return TestReport::DATA
        end
      end
      it "allows an enumerable to be returned" do
        expect(TestReport.new.records).to eq(TestReport::DATA)
      end
      it "can give a record count" do
        expect(TestReport.new.record_count).to eq(TestReport::DATA.count)
      end
    end
    context "when a SQL adapter is defined" do
      it "allows a SQL string to be returned"
    end
  end

  #instance rows
  describe 'reading data' do
    #given report data is available as an array of keyed lookup structures (e.g. hash),
    #instance.rows should return a report row object for each element of the array
  end

end
