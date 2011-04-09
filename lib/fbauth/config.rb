class FacebookConfig
  def self.[](key)
    get_environment[key].value
  end

  private

  def self.get_environment
    read_yaml[Rails.env]
  end

  def self.read_yaml
    file = File.join(Rails.root, 'config', 'facebook.yml')
    YAML.parse(ERB.new(IO.read(file)).result)
  end

  def self.app_url
    "http://apps.facebook.com/#{self['app_context']}/"
  end
end
