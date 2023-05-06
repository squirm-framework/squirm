module Squirm
  class Utils
    Log = ::Log.for(self)

    def self.build_absolute_url(url : String, base_url : String) : String
      URI.parse(base_url).resolve(url).to_s
    end

    def self.build_absolute_urls(urls : Array(String), base_url : String) : Array(String)
      urls.map do |url|
        self.build_absolute_url(url, base_url)
      end
    end

    def self.build_absolute_urls(urls : Array(Redis::RedisValue), base_url : String) : Array(String)
      urls.map do |url|
        self.build_absolute_url(url.to_s, base_url)
      end
    end

    def self.request_from_url(url : String) : Request
      Request.new(:get, url)
    end

    def self.requests_from_urls(urls : Array(String)) : Array(Request)
      urls.map do |url|
        self.request_from_url(url)
      end
    end
  end
end
