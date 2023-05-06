module Squirm
  module Caches
    abstract class Base
      Log = ::Log.for(self)

      property id : String

      def initialize(@id : String)
      end

      abstract def save!(urls : Array(String))
      abstract def delete!(url : String)
      abstract def list! : Array(String)
      abstract def list_requests!(base_url) : Array(Request)
      abstract def flush
    end
  end
end
