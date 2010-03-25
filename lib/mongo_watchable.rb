module MongoWatchable
  def self.watchables
    @watchables ||= []
  end
  
  def self.watchers
    @watchers ||= []
  end
end

$LOAD_PATH << File.dirname(__FILE__)
ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__)
ActiveSupport::Dependencies.load_once_paths.delete(File.dirname(__FILE__))