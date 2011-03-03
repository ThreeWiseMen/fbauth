require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe FacebookQuery, "basic query call" do
  context "with valid data" do

    it "should call the query API and produce the right url" do
      fql_query = "SELECT name FROM user WHERE id='1'"
      fquery = FacebookQuery.new
      value = fquery.fql(fql_query)
      value.should be_empty
      fquery.url.should == "https://api.facebook.com/method/fql.query?format=JSON&query=SELECT+name+FROM+user+WHERE+id%3D%271%27"
    end

    it "should call the query API with the right url and access token" do
      fql_query = "SELECT name FROM user WHERE id='1'"
      fquery = FacebookQuery.new("12345")
      value = fquery.fql(fql_query)
      value.should be_empty
      fquery.url.should == "https://api.facebook.com/method/fql.query?access_token=12345&format=JSON&query=SELECT+name+FROM+user+WHERE+id%3D%271%27"
    end

  end
end
