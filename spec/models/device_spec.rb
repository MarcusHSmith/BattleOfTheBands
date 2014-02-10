require File.dirname(__FILE__) + '/../spec_helper'

describe Device do
  it "should be valid" do
    Device.new.should be_valid
  end
end
