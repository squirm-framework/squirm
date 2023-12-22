module ResourcefulHumans
  class Spider
    include Squirm::Spider

    # Class variable for the identificator.
    @@id = "hr-ge"

    # Identificator of the spider throughout the whole system.
    property id : String = @@id

    # The base URL of the website.
    property base_url : String = "https://www.hr.ge/"

    # Start URLs for the spider.
    property start_urls : Array(String) = ["https://www.hr.ge/search-posting?pg=1"]

    # Caching mechanism used by the spider to cache the requests in case of a restart/failure.
    property cache : Squirm::Caches::Base = Squirm::Caches::Redis.new(@@id)

    # If you want to use the Chrome fetcher add the chromedriver to your PATH.
    property fetcher : Squirm::Fetchers::Base = Squirm::Fetchers::Default.new

    # Parser used by the spider to parse the HTML content.
    property parser : Squirm::Parser = Parser.new

    # Used by the spider to filter the requests.
    property request_filters : Array(Squirm::RequestFilters::Base) = [Squirm::RequestFilters::DomainFilter.new, Squirm::RequestFilters::UserAgent.new]

    # Used by the spider to filter the responses.
    property response_filters : Array(Squirm::ResponseFilters::Base) = [Squirm::ResponseFilters::ContentValidator.new(selector: ".ann-title")] of Squirm::ResponseFilters::Base

    # Time spent between each request.
    property request_timeout : Time::Span = 5.seconds

    # Concurrent requests per domain.
    property concurrent_requests_per_domain : Int32 = 2

    # Used by the caching mechanism to retrieve the requests from the cache.
    def start_requests : Array(Squirm::Request)
      cache.list_requests!(base_url())
    end

    # Parsing logic to identify the listing URLs and pagination URLs.
    def parse_item(request : Squirm::Request, response : Squirm::Response) : Squirm::ParsedItem
      cache.delete!(request.url)

      # URLs are sepparated into two types: Pagination and Listing, by identifying each one of them we can create
      # a simple sepparator based on the request URL with which we can decide if we need to continue the pagination
      # and listing URL collection or send the response to the parser.
      if request.url.includes?("https://www.hr.ge/search-posting?pg=")
        document = Lexbor::Parser.new(response.body)

        listing_urls = listing_urls(document)
        pagination_urls = pagination_urls(document)

        urls = listing_urls + pagination_urls
        cache.save!(urls)

        requests = urls.map do |url|
          Squirm::Request.new(:get, url)
        end

        Squirm::ParsedItem.new(requests: requests, items: [] of NamedTuple(response: Squirm::Response))
      else
        item = {response: response}
        Squirm::ParsedItem.new(requests: [] of Squirm::Request, items: [item])
      end
    end

    # Parse HTML for listing URLs.
    def listing_urls(document : Lexbor::Parser) : Array(String)
      document
        .find(".content.ann-tile a.title")
        .map(&.attribute_by("href").to_s)
        .uniq!
        .map { |href| Squirm::Utils.build_absolute_url(href, base_url) }
    end

    # Parse HTML for pagination URLs.
    def pagination_urls(document : Lexbor::Parser) : Array(String)
      document
        .find(".paging-container a.item")
        .map(&.attribute_by("href").to_s.split("&").first)
        .uniq!
        .map { |href| Squirm::Utils.build_absolute_url(href, base_url) }
    end
  end
end
