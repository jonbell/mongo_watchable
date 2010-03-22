module MongoWatchable
  class Proxy
    attr_reader :array_key
    attr_reader :model
    attr_reader :target_class
    
    def initialize(model, array_key, target_class)
      @model, @array_key, @target_class = model, array_key, target_class
    end
    
    def to_a
      fetch_all.to_a
    end
    
    def count
      array.size
    end
    
    def all(opts = {})
      fetch_all
    end
    
    def each(&block)
      fetch_all.each {|entry| yield entry}
    end
    
    def find(id)
      return nil unless array.include?(id)
      target_class.find(id)
    end
    
    def first(opts = {})
      return @first ||= target_class.find(array.first) if opts.empty?
      target_class.first(opts.merge(:_id.in => array))
    end
    
    def last(opts = {})
      return @last ||= target_class.find(array.last) if opts.empty?
      target_class.last(opts.merge(:_id.in => array))
    end
    
    def empty?
      array.empty?
    end
    
    alias :size :count
    
    def << (entry)
      array << entry.id
      @fetch ? @fetch << entry : fetch_all
    end
    
    def delete(entry)
      array.delete entry.id
      @fetch ? @fetch.delete(entry) : fetch_all
    end
    
    def inspect
      all.inspect
    end
    
  private
    def fetch_all
      @fetch ||= target_class.find(array)
    end
    
    def array
      model.send(array_key)
    end
  end
end
