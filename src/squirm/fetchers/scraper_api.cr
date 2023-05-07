module Squirm
  module Fetchers
    class ScraperAPI < Base
      Log = ::Log.for(self)

      def initialize(@api_key : String, @render : Bool = false)
      end

      def fetch(request : Request) : Response
        if request.filter
          url = "http://api.scraperapi.com?api_key=#{@api_key}&url=#{request.url}&render=#{@render}"
          request = Request.new(:get, url)

          Response.new(request.execute.http_client_res, request)
        else
          Log.error { "Failed to validate the request to #{request.url} through the filter for spider #{request.spider.try(&.id)}." }
          raise Exception.new
        end
      end
    end
  end
end
