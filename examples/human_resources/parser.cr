module HumanResources
  class Parser
    include Squirm::Parser

    def parse(spider : Squirm::Spider, response : Squirm::Response)
      document = Lexbor::Parser.new(response.body)

      id = document.find("h4.text-center").first.inner_text.strip.split(" ").last
      puts "Id: #{id}"
    end
  end
end
