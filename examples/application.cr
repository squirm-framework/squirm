require "../src/squirm"
require "./human_resources/**"
require "./resourceful_humans/**"

Log.setup(:debug)

engine = Squirm::Engine.new

engine.add_spider(HumanResources::Spider.new)
engine.add_spider(ResourcefulHumans::Spider.new)

loop do
  sleep 60

  engine.spiders.each do |spider|
    queue_size = Squirm::RequestStorage.instance.requests[spider.id].size
    Log.info { "Spider #{spider.id} is running and has queued #{queue_size} requests." } if queue_size != 0
  end
end
