module Squirm
  class Request < Crest::Request
    Log = ::Log.for(self)

    getter retry_count : Int32 = 0

    def filter(spider : Spider) : Request?
      results = spider.request_filters.map do |filter|
        filter.valid?(self, spider)
      end

      unless results.all?
        return nil
      end

      self
    end

    def filter!(spider : Spider) : Request
      results = spider.request_filters.map do |filter|
        filter.valid?(self, spider)
      end

      unless results.all?
        raise "Failed to filter the request #{request.url}"
      end

      self
    end

    def set_proxy!(p_addr, p_port, p_user, p_pass)
      return unless p_addr && p_port

      @proxy = HTTP::Proxy::Client.new(p_addr, p_port, username: p_user, password: p_pass)
    end

    def retriable? : Bool
      @retry_count <= 5
    end

    def retry
      Log.info { "Retrying the request to #{self.url}." }
      @retry_count += 1
    end
  end
end
