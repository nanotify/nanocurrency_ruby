require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

spec = Gem::Specification.load('nanocurrency.gemspec')

Rake::ExtensionTask.new('nanocurrency_ext', spec) do |ext|
  ext.source_pattern = '*{c,h}'
end

desc 'clean, compile, and run the full test suite'
task full: %w(clean compile spec)
