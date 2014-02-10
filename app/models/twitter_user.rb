class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def fetch_tweets!
    CLIENT.user_timeline(self.username).each do |tweet|
      self.tweets << Tweet.where(text: tweet.text, tweet_time: tweet.created_at).first_or_create
    end
  end

  def tweets_stale?
    self.average_time_between_tweets < 20000 && Time.now - self.average_time_between_tweets > self.tweet.order(tweet_time: :asc).limit(1)
  end

  def average_time_between_tweets
    tweets = self.tweets.order(tweet_time: :asc).limit(10)
    time1 = tweets.first.tweet_time
    time_array = []
    tweets.each do |t|
      time2 = t.tweet_time
      time_array << time2 - time1
      time1 = time2
    end
    time_array.shift
    time_array.reduce(:+) / 9
  end
end
