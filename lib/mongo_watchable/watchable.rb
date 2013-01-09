module MongoWatchable
  module Watchable
    def self.included(watchable)
      watchable.class_eval do
        MongoWatchable.watchers.each do |watcher|
          watcher_key_prefix = watcher.name.underscore.gsub(/\//, '_')
          key :"#{watcher_key_prefix}_watcher_ids", Array
          key :"#{watcher_key_prefix}_watchers_count", Integer, :default => 0
          ensure_index :"#{watcher_key_prefix}_watchers_count"
          
          define_method :"#{watcher_key_prefix}_watchers" do
            MongoWatchable::Proxy.new(self, :"#{watcher_key_prefix}_watcher_ids", :"#{watcher_key_prefix}_watchers_count", watcher)
          end
        end
      end
      
      MongoWatchable.watchers.each do |watcher|
        watcher.class_eval do
          watchable_key_prefix = watchable.name.underscore.gsub(/\//, '_')
          key :"#{watchable_key_prefix}_watching_ids", Array
          key :"#{watchable_key_prefix}_watchings_count", Integer, :default => 0
          ensure_index :"#{watchable_key_prefix}_watchings_count"
          
          define_method :"#{watchable_key_prefix}_watchings" do
            MongoWatchable::Proxy.new(self, :"#{watchable_key_prefix}_watching_ids", :"#{watchable_key_prefix}_watchings_count", watchable)
          end
        end
      end
      MongoWatchable.register_watchable watchable
    end
  
    def watchers_proxy_for(watcher)
      klass = watcher.class
      while klass.superclass && klass.superclass.include?(MongoWatchable::Watcher)
        klass = klass.superclass
      end
      watcher_key_prefix = klass.name.underscore.gsub(/\//, '_')
      send("#{watcher_key_prefix}_watchers")
    end
  end
end