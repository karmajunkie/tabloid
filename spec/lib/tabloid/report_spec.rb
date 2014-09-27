require "spec_helper"

class TestReport
  DATA=[
    {'col1' => 1, 'col2' => 2},
    {'col1' => 3, 'col2' => 4}
  ]
  include Tabloid::Report

  parameter :param1, "Parameter 1"
  parameter :required_param, required: true

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
      let(:relation){Address.where(:city => "Hattiesburg")}
      it "uses the relation as the source of SQL" do
        TestReport.class_eval do
          rows do
            Address.where(:city => "Hattiesburg")
          end
        end
        expect(TestReport.new.row_data.to_sql).to eq(relation.to_sql)
      end
    end
    context "with a raw enumerable returned" do
      before do
        TestReport.class_eval do
          rows do
            return TestReport::DATA
          end
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
      before do
        TestReport.class_eval do
          rows do
            "select * from addresses where city = :param1"
          end
        end
      end
      it "allows a SQL string to be returned" do
        expect(TestReport.new.row_data).to match(/select \* from addresses/)
      end

      it "replaces parameters in the string" do
        expect(TestReport.new(param1: "foo").to_sql).to eq("select * from addresses where city = 'foo'")
      end

      it "will replace parameters in the string in the correct order" do
        klass = Class.new do
          include Tabloid::Report
          parameter :param1
          parameter :param2
          parameter :param4
          parameter :param3
          rows do
            ":param1 :param3 :param4 :param2"
          end
        end

        report = klass.new(param1: 'foo1', param2: 'foo2', param3: 'foo3', param4: 'foo4')
        expect(report.to_sql).to eq(
          "'foo1' 'foo3' 'foo4' 'foo2'"
        )

      end
    end
  end

  #instance rows
  describe 'reading data' do
    #given report data is available as an array of keyed lookup structures (e.g. hash),
    #instance.rows should return a report row object for each element of the array
  end

end
