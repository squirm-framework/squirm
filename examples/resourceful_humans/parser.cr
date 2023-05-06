module ResourcefulHumans
  class Parser
    include Squirm::Parser

    def parse(spider : Squirm::Spider, response : Squirm::Response)
      _document = Lexbor::Parser.new(response.body)

      id = response.url.split("/").[4]
      puts "Id: #{id}"
    end
  end
end
