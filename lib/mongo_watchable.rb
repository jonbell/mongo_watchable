require 'mongo_watchable/proxy'
require 'mongo_watchable/watcher'
require 'mongo_watchable/watchable'

module MongoWatchable
  def self.watchables
    @watchables ||= []
  end
  
  def self.watchers
    @watchers ||= []
  end
end