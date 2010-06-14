module MongoWatchable
  module Watcher
    def self.included(watcher)
      watcher.class_eval do
        MongoWatchable.watchables.each do |watchable|
          key :"#{watchable.name.underscore}_watching_ids", Array
          key :"#{watchable.name.underscore}_watchings_count", Integer, :default => 0, :index => true
          
          define_method :"#{watchable.name.underscore}_watchings" do
            MongoWatchable::Proxy.new(self, :"#{watchable.name.underscore}_watching_ids", :"#{watchable.name.underscore}_watchings_count", watchable)
          end
        end
      end
      
      MongoWatchable.watchables.each do |watchable|
        watchable.class_eval do
          key :"#{watcher.name.underscore}_watcher_ids", Array
          key :"#{watcher.name.underscore}_watchers_count", Integer, :default => 0, :index => true
          
          define_method :"#{watcher.name.underscore}_watchers" do
            MongoWatchable::Proxy.new(self, :"#{watcher.name.underscore}_watcher_ids", :"#{watcher.name.underscore}_watchers_count", watcher)
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
      send("#{klass.name.underscore}_watching_ids")
    end
    
    def watchings_proxy_for(watchable)
      klass = watchable.class
      while klass.superclass && klass.superclass.include?(MongoWatchable::Watchable)
        klass = klass.superclass
      end
      send("#{klass.name.underscore}_watchings")
    end
    
    def watchings_count_proxy_for(watchable)
      klass = watchable.class
      while klass.superclass && klass.superclass.include?(MongoWatchable::Watchable)
        klass = klass.superclass
      end
      send("#{klass.name.underscore}_watchings")
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