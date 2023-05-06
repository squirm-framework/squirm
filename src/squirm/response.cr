module Squirm
  class Response < Crest::Response
    Log = ::Log.for(self)

    def filter(spider : Spider) : Response?
      results = spider.response_filters.map do |filter|
        filter.valid?(self, spider)
      end

      unless results.all?
        return nil
      end

      self
    end
  end
end
