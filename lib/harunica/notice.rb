require 'twitter'

module Harunica
  class Notice
    def initialize(data)
      @data = data
    end

    def tweet_text
      @data['tweet_text']
    end

    def time_within?(time)
      time >= @data['started_at'] && time < @data['ended_at']
    end

    def tweet
      Harunica.twitter.update tweet_text
    end
  end
end
