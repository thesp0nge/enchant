# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/enchant/version'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  #
  gem.name = "enchant"
  gem.summary = "Your magical web application fuzzer"
  gem.description = "Enchant is tool aimed to discover web application directory and pages by fuzzing the requests using a dictionary approach"
  gem.required_ruby_version = '>= 1.8.7'
  gem.email = "thesp0nge@gmail.com"
  gem.homepage = "http://github.com/thesp0nge/enchant"
  gem.authors = ["Paolo Perego"]
  gem.add_dependency('progressbar')
  gem.add_dependency('rainbow')
  gem.add_dependency('httpclient')
  gem.executables = ['enchant']
  gem.default_executable = 'enchant'
  gem.require_path = 'lib'
  gem.license = "BSD"
  gem.version = Enchant::Version.version

  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new

desc "Rebuild VERSION file"
task :version do
  File.open('VERSION', 'w') {|f| f.write(Enchant::Version.version)}
end
