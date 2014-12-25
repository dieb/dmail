# encoding: utf-8

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'dmail/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'dmail'
  s.version     = Dmail::VERSION
  s.authors     = ["Andre Dieb Martins"]
  s.email       = ["andre.dieb@gmail.com"]
  s.homepage    = 'https://github.com/dieb/dmail'
  s.summary     = "Command-line email client"
  s.description = "Command-line email client"
  s.license     = 'MIT'

  s.files = Dir['{lib,bin}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']
  s.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path = 'lib'

  s.add_development_dependency('rake', '~> 10.3')
  s.add_development_dependency('rspec', '~> 3.0')

  s.add_dependency('mail', '~> 2.6')
  s.add_dependency('term-ansicolor', '~> 1.3')
  s.add_dependency('pager', '~> 1.0.1')
end
