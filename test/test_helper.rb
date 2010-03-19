require 'rubygems'
require 'active_support'

require 'active_support/test_case'
require 'test/unit'

ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
env_rb = File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

if File.exists? env_rb
  require env_rb
else
  require 'mongo_mapper'
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')
  require 'mongo_watchable'
  config = {'test' => {'database' => 'mongo_watchable-test'}}
  MongoMapper.setup(config, 'test')
end

class ActiveSupport::TestCase
  # Drop all columns after each test case.
  def teardown
    MongoMapper.database.collections.each do |coll|
      coll.drop  
    end
  end
 
  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method teardown do 
      super
    end
  end
end

# kinda weird, but we have to do this so we can ignore the app's User class and use our own for testing
Object.send(:remove_const, :User) if Object.const_defined?(:User)

class User
  include MongoMapper::Document
  include MongoWatchable::Watcher
  key :name, String
end

class Widget
  include MongoMapper::Document  
  include MongoWatchable::Watchable
  key :name, String
end

