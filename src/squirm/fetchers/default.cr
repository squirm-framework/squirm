module Squirm
  module Fetchers
    class Default < Base
      Log = ::Log.for(self)

      def initialize
      end

      def fetch(request : Request) : Response
        if request.filter
          Response.new(request.execute.http_client_res, request)
        else
          Log.error { "Failed to validate the request to #{request.url} through the filter for spider #{request.spider.try(&.id)}." }
          raise Exception.new
        end
      end
    end
  end
end
