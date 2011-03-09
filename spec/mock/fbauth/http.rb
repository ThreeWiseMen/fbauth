module FacebookHttp

  attr_accessor :url, :options

  def get url, options = {}
    self.url = build_get_url(url, options)
    self.options = options
    {}
  end

  def post url, options = {}
    self.url = url
    self.options = options
    {}
  end

  def get_call
    [ self.url, self.options ]
  end
end
