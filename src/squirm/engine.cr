module Squirm
  class Engine
    Log = ::Log.for(self)

    getter spiders : Synchronized(Array(Spider)) = Synchronized(Array(Spider)).new

    def add_spider(spider : Spider)
      RequestStorage.instance.store(spider, spider.start_urls) if spider.start_requests.empty?
      RequestStorage.instance.store(spider, spider.start_requests)

      @spiders.push(spider)

      spawn do
        pool = Pool.new(spider.concurrent_requests_per_domain)
        fetcher = spider.fetcher

        loop do
          unless RequestStorage.instance.empty?(spider)
            request = RequestStorage.instance.pop!(spider)

            pool.spawn do
              begin
                response = fetcher.fetch(request)

                parsed_item = spider.parse_item(request, response)
                parse(spider, parsed_item)

                sleep(spider.timeout)
              rescue exception : Crest::RequestFailed
                status_code = exception.response.status_code.to_i

                case status_code
                when 429, 500..511
                  Log.error(exception: exception) { exception.message }

                  if request.retriable?
                    request.retry
                    RequestStorage.instance.store(spider, request)
                  end
                else
                  Log.error(exception: exception) { "Dropping the request, failed to get a response status code which could be used to recover a request." }
                end
              rescue exception : Exception
                Log.error(exception: exception) { "Dropping the request, a non HTTP error occured." }
              end
            end
          end
        end
      end
    end

    def remove_spider(spider : Spider)
      spider.cache.flush
      RequestStorage.instance.flush(spider)
      @spiders.delete(spider)
    end

    private def parse(spider : Spider, parsed_item : ParsedItem)
      parse_requests(spider, parsed_item) unless parsed_item.requests.empty?
      parse_items(spider, parsed_item) unless parsed_item.items.empty?
    end

    private def parse_requests(spider : Spider, parsed_item : ParsedItem)
      RequestStorage.instance.store(spider, parsed_item.requests)
    end

    private def parse_items(spider : Spider, parsed_item : ParsedItem)
      response = parsed_item.items.first.dig(:response)
      spider.parser.parse(spider, response) if response.filter(spider)
    end
  end
end
