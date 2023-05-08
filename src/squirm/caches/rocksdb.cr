require "rocksdb"

module Squirm
  module Caches
    class RocksDB < Squirm::Caches::Base
      Log = ::Log.for(self)

      property id : String
      property client : Squirm::Synchronized(::RocksDB::DB)

      def initialize(@id : String)
        @client = Squirm::Synchronized(::RocksDB::DB).new("/tmp/#{@id}")
      end

      def save!(urls : Array(String))
        Log.debug { "Adding #{urls} to the cache." }
        @client.put(key, ((get?(key) || [] of String).concat(urls)).to_json)
      end

      def delete!(url : String)
        Log.debug { "Removing #{url} from the cache." }
        urls = (get?(key) || [] of String)

        urls.delete(url)
        @client.put(key, urls.to_json)
      end

      def list! : Array(String)
        get?(key) || [] of String
      end

      def list_requests!(base_url) : Array(Request)
        urls = Utils.build_absolute_urls(list!, base_url)
        Utils.requests_from_urls(urls)
      end

      def flush
        Log.debug { "Flushing the cache." }
        @client.delete(key)
      end

      private def get?(key) : Array(String)?
        if data = @client.get?(key)
          JSON.parse(data).as_a.map(&.to_s)
        end
      end

      private def key : String
        %(urls-cache)
      end
    end
  end
end
