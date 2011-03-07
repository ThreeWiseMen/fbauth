class FacebookController

  class MockLogger
    attr_accessor :messages
    def initialize
      self.messages = []
    end
    def warn message
      self.messages << message
    end
  end

  class MockRequest
    def protocol
      "http://"
    end
    def host_with_port
      "localhost:3000"
    end
    def post?
      false
    end
  end

  class MockResponse
    attr_accessor :headers
    def initialize
      self.headers = {}
    end
  end

  include FacebookAuthFunctions

  attr_accessor :session, :params, :cookies, :request, :response, :logger
  attr_accessor :redirected_path

  def initialize
    self.session = {}
    self.params = {}
    self.cookies = {}
    self.logger = MockLogger.new
    self.request = MockRequest.new
    self.response = MockResponse.new
  end

  def redirect_to path
    self.redirected_path = path
  end

end
