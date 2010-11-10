class FacebookAuth

  attr_accessor :access_token, :expires, :uid
  attr_accessor :user_data, :validation_error

  def create parms
    self.access_token = parms['access_token']
    self.uid = parms['uid']
    self.expires_epoch = parms['expires'].to_i if parms.has_key? 'expires'
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

end
