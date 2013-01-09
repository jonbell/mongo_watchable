module MongoWatchable
  module Watcher
    def self.included(watcher)
      watcher.class_eval do
        MongoWatchable.watchables.each do |watchable|
          watchable_key_prefix = watchable.name.underscore.gsub(/\//, '_')
          key :"#{watchable_key_prefix}_watching_ids", Array
          key :"#{watchable_key_prefix}_watchings_count", Integer, :default => 0
          ensure_index :"#{watchable_key_prefix}_watchings_count"
          
          define_method :"#{watchable_key_prefix}_watchings" do
            MongoWatchable::Proxy.new(self, :"#{watchable_key_prefix}_watching_ids", :"#{watchable_key_prefix}_watchings_count", watchable)
          end
        end
      end
      
      MongoWatchable.watchables.each do |watchable|
        watchable.class_eval do
          watcher_key_prefix = watcher.name.underscore.gsub(/\//, '_')
          key :"#{watcher_key_prefix}_watcher_ids", Array
          key :"#{watcher_key_prefix}_watchers_count", Integer, :default => 0
          ensure_index :"#{watcher_key_prefix}_watchers_count"
          
          define_method :"#{watcher_key_prefix}_watchers" do
            MongoWatchable::Proxy.new(self, :"#{watcher_key_prefix}_watcher_ids", :"#{watcher_key_prefix}_watchers_count", watcher)
          end
        end
      end
      
      MongoWatchable.register_watcher watcher
    end
    
    def watch(watchable)
      unless watching?(watchable)
        watchings_proxy_for(watchable) << watchable
        watchable.watchers_proxy_for(self) << self
        save if watchable.save
      end
    end
    
    def watch!(watchable)
      raise "#{self.class.name} is already watching #{watchable.class.name}" if watching?(watchable)
      watchings_proxy_for(watchable) << watchable
      watchable.watchers_proxy_for(self) << self
      watchable.save!
      self.save!
    end
    
    def watching?(watchable)
      watching_ids_for(watchable).include?(watchable.id)
    end
    
    def unwatch(watchable)
      if watching?(watchable)
        watchings_proxy_for(watchable).delete watchable
        watchable.watchers_proxy_for(self).delete self
        save if watchable.save
      end
    end
    
    def unwatch!(watchable)
      raise "#{self.class.name} is not watching #{watchable.class.name}" unless watching?(watchable)
      watchings_proxy_for(watchable).delete watchable
      watchable.watchers_proxy_for(self).delete self
      watchable.save!
      self.save!
    end
    
    def watching_ids_for(watchable)
      klass = watchable.class
      while klass.superclass && klass.superclass.include?(MongoWatchable::Watchable)
        klass = klass.superclass
      end
      watchable_key_prefix = klass.name.underscore.gsub(/\//, '_')
      send("#{watchable_key_prefix}_watching_ids")
    end
    
    def watchings_proxy_for(watchable)
      klass = watchable.class
      while klass.superclass && klass.superclass.include?(MongoWatchable::Watchable)
        klass = klass.superclass
      end
      watchable_key_prefix = klass.name.underscore.gsub(/\//, '_')
      send("#{watchable_key_prefix}_watchings")
    end
    
    def watchings_count_proxy_for(watchable)
      klass = watchable.class
      while klass.superclass && klass.superclass.include?(MongoWatchable::Watchable)
        klass = klass.superclass
      end
      watchable_key_prefix = klass.name.underscore.gsub(/\//, '_')
      send("#{watchable_key_prefix}_watchings")
    end
  
  private
    def root_watching_class(instance)
      klass = instance
      while klass.superclass && klass.superclass.include?(MongoWatchable::Watchable)
        klass = klass.superclass
      end
      klass
    end
  end
end