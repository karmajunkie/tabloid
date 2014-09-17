require "spec_helper"

describe Tabloid::Parameters do
  def new_class
    klass = Class.new
    klass.send(:include, Virtus.model)
    klass.extend Tabloid::Parameters
  end

  it "allows a class to define a parameter" do
    klass=new_class
    klass.should respond_to(:parameter)
  end

  it "defaults to a required parameter" do
    klass = new_class
    klass.parameter :foo
    klass.new.parameters_valid?.should == false
  end

  it 'allows for non-required parameters' do
    klass = new_class
    klass.parameter :foo, nil, required: false
    klass.new.parameters_valid?.should == true
  end

end
