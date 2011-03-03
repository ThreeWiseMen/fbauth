require "rake"

require "rake/gempackagetask"

spec = Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = "fbauth"
  s.version           = "1.0.0.1"
  s.author            = "Three Wise Men Inc."
  s.licenses          = "Simplified BSD License"
  s.email             = "info @nospam@ threewisemen.ca"
  s.homepage          = "http://github.com/ThreeWiseMen/fbauth"
  s.summary           = "Authentication framework for Rails Facebook apps"
  s.description       = "This library simplifies life when it comes to authentication in a Facebook iFrame application"
  s.files             = FileList[ 'lib/*.rb', 'app/**/*', 'rails/*.rb' ].to_a
  s.require_path      = "lib"
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README.mdown"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts "generated latest version"
end

