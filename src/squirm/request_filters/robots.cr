module Squirm
  module RequestFilters
    class Robots < Base
      Log = ::Log.for(self)

      @mutex = Mutex.new(:reentrant)

      getter parser : ::Robots::Parser

      def initialize(@base_url : String, @user_agent : String)
        @parser = ::Robots::Parser.new(@base_url, @user_agent)
      end

      def valid?(request : Request, spider : Spider) : Bool
        @mutex.synchronize do
          path = URI.parse(request.url).path
          valid = @parser.allowed?(path)

          unless valid
            Log.debug { "Dropping request: #{request.url} (robots.txt filter)" }
            return false
          end

          return true
        end
      end
    end
  end
end
