require 'active_support/ordered_hash'
require 'mongo_watchable/proxy'
module MongoWatchable
  def self.register_watchable(watchable)
    @watchables ||= ActiveSupport::OrderedHash.new
    @watchables[watchable.name] = watchable
  end
  
  def self.watchables
    @watchables ||= ActiveSupport::OrderedHash.new
    @watchables.values
  end
  
  def self.register_watcher(watcher)
    @watchers ||= ActiveSupport::OrderedHash.new
    @watchers[watcher.name] = watcher
  end
  
  def self.watchers
    @watchers ||= ActiveSupport::OrderedHash.new
    @watchers.values
  end
  
  autoload :Watchable,         'mongo_watchable/watchable'
  autoload :Watcher,           'mongo_watchable/watcher'
end

$LOAD_PATH << File.dirname(__FILE__)
#ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__)
#ActiveSupport::Dependencies.load_once_paths.delete(File.dirname(__FILE__))