module Squirm
  class RequestStorage
    Log = ::Log.for(self)

    INSTANCE = new

    def self.instance
      INSTANCE
    end

    getter requests : Synchronized(Hash(String, Array(Request))) = Synchronized(Hash(String, Array(Request))).new
    getter history : Synchronized(Hash(String, Array(String))) = Synchronized(Hash(String, Array(String))).new

    def store(id : String, request : Request)
      if @requests.has_key?(id)
        unless @history[id].includes?(request.url)
          @history[id].push(request.url)
          @requests[id].push(request)
        end
      else
        @history[id] = [request.url]
        @requests[id] = [request]
      end
    end

    def store(id : String, requests : Array(Request))
      requests.each do |request|
        store(id, request)
      end
    end

    def store(id : String, url : String)
      store(id, Request.new(:get, url))
    end

    def store(id : String, urls : Array(String))
      urls.each do |url|
        store(id, url)
      end
    end

    def flush(id : String)
      @requests[id] = [] of Request
    end

    def clear(id : String)
      @requests[id] = [] of Request
      @history[id] = [] of String
    end

    def pop!(id : String)
      @requests[id].pop? || raise Exception.new("Request storage is empty")
    end

    def delete_history(id : String, url : String)
      @history[id].delete(url)
    end

    def seen?(id : String, url : String) : Bool
      @history[id].includes?(url)
    end

    def empty?(id : String) : Bool
      @requests[id].empty?
    end

    def exists?(id : String) : Bool
      @requests[id]? != nil || @history[id]? != nil
    end
  end
end
