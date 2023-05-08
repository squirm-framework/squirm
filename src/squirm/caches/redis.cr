require "redis"

module Squirm
  module Caches
    class Redis < Base
      Log = ::Log.for(self)

      property id : String
      property client : Synchronized(::Redis)

      def initialize(@id : String)
        @client = Synchronized(::Redis).new
      end

      def save!(urls : Array(String))
        Log.debug { "Adding #{urls} to the cache." }
        @client.sadd(key, urls) unless urls.empty?
      end

      def delete!(url : String)
        Log.debug { "Removing #{url} from the cache." }
        @client.srem(key, url)
      end

      def list! : Array(String)
        @client.smembers(key).map(&.to_s)
      end

      def list_requests!(base_url) : Array(Request)
        urls = Utils.build_absolute_urls(@client.smembers(key), base_url)
        Utils.requests_from_urls(urls)
      end

      def flush
        Log.debug { "Flushing the cache." }
        @client.del(key)
      end

      private def key : String
        %(#{@id}:urls-cache)
      end
    end
  end
end
