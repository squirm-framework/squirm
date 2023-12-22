require "../src/squirm/caches/redis"
require "../src/squirm"
require "./human_resources/**"
require "./resourceful_humans/**"

Log.setup(:debug)

engine = Squirm::Engine.new

spiders = [
  HumanResources::Spider.new,
  ResourcefulHumans::Spider.new,
] of Squirm::Spider

spiders.each do |spider|
  engine.add_spider(spider)
end

engine.run

loop do
  spiders.each do |spider|
    unless Squirm::RequestStorage.instance.empty?(spider.id)
      size = Squirm::RequestStorage
        .instance
        .requests
        .[spider.id]
        .size

      Log.debug { "#{spider.id} running with #{size} request(s)" }
    end
  end

  sleep 30
end