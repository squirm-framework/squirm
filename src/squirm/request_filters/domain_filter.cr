module Squirm
  module RequestFilters
    class DomainFilter < Base
      Log = ::Log.for(self)

      @mutex = Mutex.new(:reentrant)

      def valid?(request : Request, spider : Spider) : Bool
        @mutex.synchronize do
          base_url = spider.base_url
          parsed_url = URI.parse(request.url)
          host = parsed_url.host || raise "Invalid host provided in the request."

          valid = base_url.includes?(host)

          unless valid
            Log.debug { "Dropping request: #{request.url} (domain filter)" }
            return false
          end

          return true
        end
      end
    end
  end
end
