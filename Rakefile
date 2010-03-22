require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

begin
  GEM = "mongo_watchable"
  AUTHOR = "Jonathan Bell"
  EMAIL = "jonbell@spamcop.net"
  SUMMARY = "A ruby gem for adding watching to mongo documents."
  HOMEPAGE = "http://github.com/jonbell/mongo_watchable"
  
  gem 'jeweler', '>= 1.0.0'
  require 'jeweler'
  
  Jeweler::Tasks.new do |s|
    s.name = GEM
    s.summary = SUMMARY
    s.email = EMAIL
    s.homepage = HOMEPAGE
    s.description = SUMMARY
    s.author = AUTHOR
    
    s.require_path = 'lib'
    s.files = %w(MIT-LICENSE README.textile Rakefile) + Dir.glob("{rails,lib,generators,spec}/**/*")
    
    # Runtime dependencies: When installing Formtastic these will be checked if they are installed.
    # Will be offered to install these if they are not already installed.
    s.add_dependency 'mongo_mapper', '>= 0.7.0'
    
    # Development dependencies. Not installed by default.
    # Install with: sudo gem install formtastic --development
    #s.add_development_dependency 'rspec-rails', '>= 1.2.6'
    s.add_development_dependency 'shoulda', '>= 2.10.0'
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "[mongo_watchable:] Jeweler - or one of its dependencies - is not available. Install it with: sudo gem install jeweler -s http://gemcutter.org"
end

desc 'Test the mongo_watchable plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the mongo_watchable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Mongo Watchable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end