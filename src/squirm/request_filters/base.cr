module Squirm
  module RequestFilters
    abstract class Base
      Log = ::Log.for(self)

      abstract def valid?(request : Request, spider : Spider) : Bool
    end
  end
end
