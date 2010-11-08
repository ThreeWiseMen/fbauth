class FacebookConfig
  def self.[](key)
    get_environment[key].value
  end

  private

  def self.get_environment
    read_yaml[ENV["RAILS_ENV"]]
  end

  def self.read_yaml
    file = File.join(::RAILS_ROOT, 'config', 'facebook.yml')
    YAML.parse(ERB.new(IO.read(file)).result)
  end
end
