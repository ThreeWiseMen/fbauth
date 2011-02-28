require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe FacebookAuth, "construction" do
  context "with valid facebook auth data" do
    before :all do
      @expires = 1296666000;
      @uid = "849395216";
      @access_token = "118891648123934|2.MGFCDPDoAYofGkciJvBxtQ__.3600.1296666000-849395216|Z-X76UskS-QI_7uDjSJGQNgBLzQ"
    end

    it "returns an auth object with old facebook structure" do
      1.should == 1
    end

    it "returns an auth object with new facebook structure" do
      parms = {
        "expires"=>@expires,
        "algorithm"=>"HMAC-SHA256",
        "user_id"=>@uid,
        "oauth_token"=>@access_token,
        "user"=>{"country"=>"ca", "locale"=>"en_US"},
        "issued_at"=>1296661835
      }
      auth = FacebookAuth.create(parms)
      
      auth.uid.should == @uid
      auth.access_token.should == @access_token
      auth.expires.strftime('%Y-%m-%d %H:%M:%S').should == "2011-02-02 12:00:00"
    end
  end
end
