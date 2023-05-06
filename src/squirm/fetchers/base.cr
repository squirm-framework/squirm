module Squirm
  module Fetchers
    abstract class Base
      Log = ::Log.for(self)

      def initialize(@spider : Spider)
      end

      abstract def fetch(request : Request) : Response
    end
  end
end
