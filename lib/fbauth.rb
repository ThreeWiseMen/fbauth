%w{ controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), '..', 'app', dir) + "/"
  $LOAD_PATH << path

  Dir.new(path).entries.each do |file|
    if file =~ /\.rb$/
      require file
    end
  end
end

require 'fbauth/decoder.rb'
require 'fbauth/auth.rb'
require 'fbauth/config.rb'
require 'fbauth/http.rb'
require 'fbauth/graph.rb'
require 'fbauth/query.rb'
