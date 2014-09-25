require "spec_helper"

describe Tabloid::ReportColumn do
  it "converts key to a string" do
    expect(Tabloid::ReportColumn.new(:foo).key).to eq('foo')
  end

  it "humanizes implied labels" do
    expect(Tabloid::ReportColumn.new(:fooBar).label).to eq("Foo Bar")
  end
end
