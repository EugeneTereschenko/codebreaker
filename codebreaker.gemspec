# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codebreaker/version'

Gem::Specification.new do |spec|
  spec.name = 'codebreaker-rg-te'
  spec.version = '0.1.9'
  spec.authors = ['Eugene Tereschenko']
  spec.email = ['tereschenko.eugene@gmail.com']

  spec.summary = 'Codebreaker app'
  spec.homepage = 'https://github.com/EugeneTereschenko/codebreaker'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com/EugeneTereschenko'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  #spec.files = Dir.chdir(File.expand_path(__dir__)) do
  #  `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|codebreaker-rg-te)/}) }
  #  end
  spec.files = ['lib/codebreaker.rb', 'lib/codebreaker/console.rb', 'lib/codebreaker/game.rb', 'lib/codebreaker/localization.rb', 'lib/codebreaker/stats.rb', 'lib/codebreaker/validation.rb', 'lib/codebreaker/storage/StorageInterceptor.rb']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'fasterer'
  spec.add_development_dependency 'i18n'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
end