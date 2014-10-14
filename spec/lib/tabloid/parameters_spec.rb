require "spec_helper"

describe Tabloid::Parameters do
  def new_class
    klass = Class.new
    klass.send(:include, Virtus.model)
    klass.extend Tabloid::Parameters
  end

  it "allows a class to define a parameter" do
    klass=new_class
    expect(klass).to respond_to(:parameter)
  end

  it "defaults to a required parameter" do
    klass = new_class
    klass.parameter :foo
    expect(klass.new.parameters_valid?).to eq(false)
  end

  it 'allows for non-required parameters' do
    klass = new_class
    klass.parameter :foo, required: false
    klass.new.parameters_valid?.should == true
  end

  describe 'types' do
    it "accepts a type for the parameter" do
      klass = new_class
      klass.parameter :foo, type: Time
      expect(klass.parameters.count).to eq(1)
    end
    it "returns the type as a string representation on the parameter" do 
      klass = new_class
      klass.parameter :foo, type: Time
      expect(klass.parameters.first.type).to eq("datetime")
    end
  end

end
