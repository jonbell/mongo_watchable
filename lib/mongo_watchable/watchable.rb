module MongoWatchable
  module Watchable
    def self.included(watchable)
      watchable.class_eval do
        MongoWatchable.watchers.each do |watcher|
          key :"#{watcher.name.underscore}_watcher_ids", Array
          key :"#{watcher.name.underscore}_watchers_count", Integer, :default => 0
          ensure_index :"#{watcher.name.underscore}_watchers_count"
          
          define_method :"#{watcher.name.underscore}_watchers" do
            MongoWatchable::Proxy.new(self, :"#{watcher.name.underscore}_watcher_ids", :"#{watcher.name.underscore}_watchers_count", watcher)
          end
        end
      end
      
      MongoWatchable.watchers.each do |watcher|
        watcher.class_eval do
          key :"#{watchable.name.underscore}_watching_ids", Array
          key :"#{watchable.name.underscore}_watchings_count", Integer, :default => 0
          ensure_index :"#{watchable.name.underscore}_watchings_count"
          
          define_method :"#{watchable.name.underscore}_watchings" do
            MongoWatchable::Proxy.new(self, :"#{watchable.name.underscore}_watching_ids", :"#{watchable.name.underscore}_watchings_count", watchable)
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
      send("#{klass.name.underscore}_watchers")
    end
  end
end