# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'codebreaker-rg-te'
  spec.version = '0.1.15'
  spec.authors = ['Eugene Tereschenko']
  spec.email = ['tereschenko.eugene@gmail.com']

  spec.summary = 'Codebreaker app'
  spec.homepage = 'https://github.com/EugeneTereschenko/codebreaker'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = ['lib/codebreaker.rb', 'lib/codebreaker/console.rb', 'lib/codebreaker/game.rb', 'lib/codebreaker/localization.rb', 'lib/codebreaker/statistics.rb', 'lib/codebreaker/validation.rb', 'lib/codebreaker/storage/storage_interceptor.rb']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'i18n'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
end
