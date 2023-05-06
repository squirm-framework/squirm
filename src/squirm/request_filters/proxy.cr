module Squirm
  module RequestFilters
    class Proxy < Base
      Log = ::Log.for(self)

      @mutex = Mutex.new(:reentrant)

      def initialize(@address : String, @port : Int32, @username : String, @password : String)
      end

      def valid?(request : Request, spider : Spider) : Bool
        @mutex.synchronize do
          request.set_proxy!(@address, @port, @username, @password)

          return request.proxy != nil
        end
      end
    end
  end
end
