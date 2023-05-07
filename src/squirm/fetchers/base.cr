module Squirm
  module Fetchers
    abstract class Base
      Log = ::Log.for(self)

      abstract def fetch(request : Request) : Response
    end
  end
end
