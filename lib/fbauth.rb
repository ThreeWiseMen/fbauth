%w{ controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), '..', 'app', dir) + "/"
  $LOAD_PATH << path

  Dir.new(path).entries.each do |file|
    if file =~ /\.rb$/
      require file
    end
  end
end

require 'facebook_decoder.rb'
require 'facebook_auth.rb'
require 'facebook_config.rb'
require 'facebook_graph.rb'
