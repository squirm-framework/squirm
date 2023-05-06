module Squirm
  module ResponseFilters
    class ContentValidator < Base
      Log = ::Log.for(self)

      @mutex = Mutex.new(:reentrant)

      def initialize(@selector : String)
      end

      def valid?(response : Response, spider : Spider) : Bool
        @mutex.synchronize do
          document = Lexbor::Parser.new(response.body)
          valid = document.find(@selector).size != 0

          unless valid
            Log.error { "Page failed validation: #{response.url}" }
            return false
          end

          return true
        end
      end
    end
  end
end
