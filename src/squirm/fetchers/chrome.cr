require "marionette"

module Squirm
  module Fetchers
    class Chrome < Base
      @session : Marionette::Session = Marionette::WebDriver.create_session(:chrome, capabilities: Marionette.chrome_options(args: ["headless"]))

      def fetch(request : Request) : Response
        if request.filter
          @session.navigate(request.url)

          response = HTTP::Client::Response.new(status: HTTP::Status::OK, body: @session.page_source)
          Response.new(response, request)
        else
          Log.error { "Failed to validate the request to #{request.url} through the filter for spider #{request.spider.try(&.id)}." }
          raise Exception.new
        end
      end
    end
  end
end
