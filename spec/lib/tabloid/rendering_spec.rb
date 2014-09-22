require "spec_helper"

describe Tabloid::Rendering do
  class RenderingExample
    extend Tabloid::Rendering
  end
  class FooRenderer
  end

  subject{RenderingExample.new}

  it "tracks arbitrary output formats" do
    RenderingExample.render :foo, with: FooRenderer
    expect(subject).to respond_to(:to_foo)
  end
end
