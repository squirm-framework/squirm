module Squirm
  module Parser
    Log = ::Log.for(self)

    abstract def parse(spider : Spider, response : Response)
  end
end
