require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe FacebookController do

  context "building channel url" do
    before(:each) do
      class TestWrapper
        include FbauthHelper
        def request
          FacebookController::MockRequest.new
        end
      end
      @helper = TestWrapper.new
    end

    it "should build correct url" do
      @helper.fbauth_build_url('/channel.html').should == "http://localhost:3000/channel.html"
    end
  end

end
