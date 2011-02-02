require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe FacebookDecoder, "decode" do
  context "data 1" do
    before(:each) do
      @data = "GXXAcWOgOgIHPwHo0vVXCzdfCJ_Dmln3sDuRsZ2oKNo.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEyOTY2NjYwMDAsImlzc3VlZF9hdCI6MTI5NjY2MTgzNSwib2F1dGhfdG9rZW4iOiIxMTg4OTE2NDgxMjM5MzR8Mi5NR0ZDRFBEb0FZb2ZHa2NpSnZCeHRRX18uMzYwMC4xMjk2NjY2MDAwLTg0OTM5NTIxNnxaLVg3NlVza1MtUUlfN3VEalNKR1FOZ0JMelEiLCJ1c2VyIjp7ImxvY2FsZSI6ImVuX1VTIiwiY291bnRyeSI6ImNhIn0sInVzZXJfaWQiOiI4NDkzOTUyMTYifQ"
    end

    it "should parse data 1" do
      parms = FacebookDecoder.decode(@data)
      parms['user_id'].should == '849395216'
      parms['oauth_token'].should == '118891648123934|2.MGFCDPDoAYofGkciJvBxtQ__.3600.1296666000-849395216|Z-X76UskS-QI_7uDjSJGQNgBLzQ'
      parms['expires'].should == 1296666000
    end
  end

  context "data 2" do
    before(:each) do
      @data = "rIDyCvtufQMlamuK3Nx_n54BcGvWrAiHXyOGvDz48ww.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEyOTY2NzY4MDAsImlzc3VlZF9hdCI6MTI5NjY3MTM5OSwib2F1dGhfdG9rZW4iOiIxMTg4OTE2NDgxMjM5MzR8Mi55eU4wa1RrQXJrYUpwdlJZSWpfRWZBX18uMzYwMC4xMjk2Njc2ODAwLTU4MDAxNjExfHFJbWlOVXMtQVdLdGhDZWpOaHEzby1EZXdvayIsInVzZXIiOnsibG9jYWxlIjoiZW5fVVMiLCJjb3VudHJ5IjoiY2EifSwidXNlcl9pZCI6IjU4MDAxNjExIn0"
    end

    it "should parse data 2" do
      parms = FacebookDecoder.decode(@data)
      parms['user_id'].should == '58001611'
      parms['oauth_token'].should == '118891648123934|2.yyN0kTkArkaJpvRYIj_EfA__.3600.1296676800-58001611|qImiNUs-AWKthCejNhq3o-Dewok'
      parms['expires'].should == 1296676800
    end
  end

  context "invalid data" do
    before(:each) do
      @data = "gibberish"
    end

    it "should return nil" do
      parms = FacebookDecoder.decode(@data)
      parms.should == nil
    end
  end
end
