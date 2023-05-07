module Squirm
  module Spider
    Log = ::Log.for(self)

    abstract def id : String
    abstract def base_url : String
    abstract def cache : Caches::Base
    abstract def start_urls : Array(String)
    abstract def start_requests : Array(Request)
    abstract def parser : Parser
    abstract def fetcher : Fetchers::Base
    abstract def parse_item(request : Request, response : Response) : ParsedItem
    abstract def request_filters : Array(RequestFilters::Base)
    abstract def response_filters : Array(ResponseFilters::Base)
    abstract def timeout : Time::Span
    abstract def concurrent_requests_per_domain : Int32
  end
end
