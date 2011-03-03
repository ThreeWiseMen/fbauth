require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe FacebookController do
  context "with no auth information" do
    before(:each) do
      @controller = FacebookController.new
    end

    it "should redirect to login" do
      @controller.require_facebook_auth
      @controller.logger.messages.size.should == 1
      @controller.logger.messages[0].should == 'Unable to parse any security params for request - cold authentication required'
      @controller.redirected_path.should == "http://localhost:3000/login"
    end
  end

  context "with valid signed_request" do
    before(:each) do
      @controller = FacebookController.new
      @controller.params[:signed_request] = "GXXAcWOgOgIHPwHo0vVXCzdfCJ_Dmln3sDuRsZ2oKNo.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEyOTY2NjYwMDAsImlzc3VlZF9hdCI6MTI5NjY2MTgzNSwib2F1dGhfdG9rZW4iOiIxMTg4OTE2NDgxMjM5MzR8Mi5NR0ZDRFBEb0FZb2ZHa2NpSnZCeHRRX18uMzYwMC4xMjk2NjY2MDAwLTg0OTM5NTIxNnxaLVg3NlVza1MtUUlfN3VEalNKR1FOZ0JMelEiLCJ1c2VyIjp7ImxvY2FsZSI6ImVuX1VTIiwiY291bnRyeSI6ImNhIn0sInVzZXJfaWQiOiI4NDkzOTUyMTYifQ"
    end

    it "should authenticate" do
      @controller.require_facebook_auth
      @controller.setup_facebook_auth.should_not == nil
      @controller.setup_facebook_auth.access_token.should == '118891648123934|2.MGFCDPDoAYofGkciJvBxtQ__.3600.1296666000-849395216|Z-X76UskS-QI_7uDjSJGQNgBLzQ'
      @controller.setup_facebook_auth.uid.should == '849395216'
      @controller.setup_facebook_auth.expires.strftime('%Y-%m-%d %H:%M:%S').should == "2011-02-02 12:00:00"
puts @controller.setup_facebook_auth.inspect
      @controller.setup_facebook_auth.user_data['first_name'].should == 'John'
      @controller.setup_facebook_auth.user_data['last_name'].should == 'Smith'
    end
  end
end
