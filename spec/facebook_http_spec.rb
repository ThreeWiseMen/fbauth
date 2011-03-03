require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe FacebookHttp, "build_query_string" do
  include FacebookHttp

  context "no params" do

    it "should be nil for no params" do
      build_query_string.should be_nil
    end

    it "should be well formed for 1 param" do
      build_query_string({:key => :value}).should == "?key=value"
    end

    it "should be well formed for 2 params" do
      build_query_string({:key1 => "test1", :key2 => "test2"}).should == "?key1=test1&key2=test2"
    end

    it "should ignore nil values in params" do
      build_query_string({:key1 => "test1", :key2 => "test2", :key3 => nil}).should == "?key1=test1&key2=test2"
    end
  end

end
