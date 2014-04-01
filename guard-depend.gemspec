lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbconfig'
require 'guard/depend/version'

Gem::Specification.new do |s|
  s.name        = 'guard-depend'
  s.version     = Guard::DependVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexander Groß']
  s.email       = ['agross@therightstuff.de']
  s.homepage    = 'http://grossweber.com'
  s.license     = 'MIT'
  s.description = %q{Run commands only if build output is not up to date.}
  s.summary     = %q{guard-depend is useful for projects that produce build output like binaries. guard-depend will only run the command you specify if the build output does not exist or is not up to date with regard to the watched files.}

  s.add_dependency 'rake'
  s.add_dependency 'guard', '~> 2.5'

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rspec', '>= 3.0.0.beta2'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-rspec'

  case RbConfig::CONFIG['target_os']
  when /windows|bccwin|cygwin|djgpp|mingw|mswin|wince/i
    s.add_development_dependency 'ruby_gntp'
    s.add_development_dependency 'wdm'
  when /linux/i
    s.add_development_dependency 'rb-inotify'
  when /mac|darwin/i
    s.add_development_dependency 'rb-fsevent'
    s.add_development_dependency 'growl'
  end

  git = ENV['TEAMCITY_GIT_PATH'] || 'git'
  s.files         = `"#{git}" ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
end
