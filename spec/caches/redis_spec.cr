describe Squirm::Caches::Redis do
  redis = Squirm::Caches::Redis.new(UUID.random.to_s)

  it "saves URLs to the cache" do
    redis.save!(["https://www.hr.ge/announcement/290206/uZravi-qonebis-agentibrokeri", "https://www.hr.ge/announcement/289906/servis-departamentis-xelmRvanelis-moadgile"])
    redis.list!.size.should eq 2

    redis.flush
  end

  it "deletes an URL from the cache" do
    redis.save!(["https://www.hr.ge/announcement/290206/uZravi-qonebis-agentibrokeri", "https://www.hr.ge/announcement/289906/servis-departamentis-xelmRvanelis-moadgile"])
    redis.list!.size.should eq 2

    redis.delete!("https://www.hr.ge/announcement/290206/uZravi-qonebis-agentibrokeri")
    redis.list!.size.should eq 1

    redis.flush
  end

  it "lists URLs from the cache" do
    redis.save!(["https://www.hr.ge/announcement/290206/uZravi-qonebis-agentibrokeri", "https://www.hr.ge/announcement/289906/servis-departamentis-xelmRvanelis-moadgile"])
    redis.list!.size.should eq 2

    redis.flush
  end

  it "lists URLs and converts them into requests" do
    redis.save!(["https://www.hr.ge/announcement/290206/uZravi-qonebis-agentibrokeri", "https://www.hr.ge/announcement/289906/servis-departamentis-xelmRvanelis-moadgile"])
    requests = redis.list_requests!("https://www.hr.ge/")

    requests.size.should eq 2

    requests.each do |request|
      request.method.should eq "GET"
    end

    redis.flush
  end

  it "flushes the cache" do
    redis.save!(["https://www.hr.ge/announcement/290206/uZravi-qonebis-agentibrokeri", "https://www.hr.ge/announcement/289906/servis-departamentis-xelmRvanelis-moadgile"])
    redis.flush

    redis.list!.size.should eq 0
  end
end
