lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
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

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'guard', '~> 2.5'

  git = ENV['TEAMCITY_GIT_PATH'] || 'git'
  s.files         = `"#{git}" ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
end
