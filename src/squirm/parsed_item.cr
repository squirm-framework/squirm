module Squirm
  class ParsedItem
    Log = ::Log.for(self)

    getter requests : Array(Request)
    getter items : Array(NamedTuple(response: Response))

    def initialize(@requests : Array(Request), @items : Array(NamedTuple(response: Response)))
    end
  end
end
