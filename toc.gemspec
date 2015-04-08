require File.expand_path('../version.rb', __FILE__)
require File.expand_path('../files.rb', __FILE__)

Gem::Specification.new do |s|
  s.name                  = 'toc'
  s.version               = TOC.gem_version
  s.required_ruby_version = '>= 1.9.3'
  s.licenses              = ['MIT']

  s.description           = 'Generate a table of contents for JavaScript files'
  s.summary               = 'Generate a table of contents for JavaScript files indicating line numbers for key elements'
  date                    = '2015-04-01'

  s.authors               = ['Dana Scheider']
  s.email                 = 'dana.scheider@gmail.com'
  s.homepage              = 'https://github.com/danascheider/toc'

  s.files                 = TOC.files
  s.require_paths         = ['lib']
  s.test_files            =  s.files.select {|path| path =~ /^spec\/.*\.rb/ }
  s.extra_rdoc_files      = %w(README.md LICENSE)

  s.add_dependency 'gli', '~> 2.13'
  s.add_dependency 'colorize', '~> 0.7', '>=0.7.5'

  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'bundler', '~> 1.7', '>=  1.7.3'
  s.add_development_dependency 'coveralls', '~> 0.7', '>= 0.7.2'
  s.add_development_dependency 'simplecov', '~> 0.9', '>= 0.9.1'
  s.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
  s.add_development_dependency 'reactive_support', '~> 0.5'
end