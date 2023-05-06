module Squirm
  module ResponseFilters
    abstract class Base
      Log = ::Log.for(self)

      abstract def valid?(response : Response, spider : Spider) : Bool
    end
  end
end
