class FacebookAuth

  attr_accessor :access_token, :expires, :uid
  attr_accessor :user_data, :validation_error

  def self.create parms
    auth = self.new
    auth.access_token = parms['access_token']
    auth.uid = parms['uid']
    auth.expires_epoch = parms['expires'].to_i unless parms['expires'].nil?
    auth
  end

  def expires_epoch= epoch
    # Need to convolve for SanFran TZ?
    self.expires = Time.at(epoch)
  end

  def is_expired?
    if self.expires.nil?
      true
    else
      self.expires < Time.now
    end
  end

  def validate
    valid = false
    unless self.uid.nil? || self.access_token.nil?
      self.user_data = FacebookGraph.call(self.uid, self.access_token)
      if self.user_data.has_key? 'error'
        self.validation_error = self.user_data['error'].inspect
        self.user_data = nil
      else
        valid = true
      end
    end
    return valid
  end

  def session_data
    return {
      'access_token' => self.access_token,
      'uid' => self.uid,
      'expires' => self.expires.to_i
    }.to_json
  end

end

# User data typically looks like this:
#
# {
#   "id"=>"849395216",
#   "name"=>"Steven Vetzal",
#   "first_name"=>"Steven"
#   "last_name"=>"Vetzal",
#   "gender"=>"male",
#   "verified"=>true,
#   "link"=>"http://www.facebook.com/svetzal",
#   "timezone"=>-5,
#   "locale"=>"en_US",
#   "location"=>{
#     "name"=>"Oshawa, Ontario",
#     "id"=>"114418101908145"
#   },
#   "hometown"=>{
#     "name"=>"Oshawa, Ontario",
#     "id"=>"114418101908145"
#   },
#   "updated_time"=>"2010-04-28T12:57:20+0000",
# }