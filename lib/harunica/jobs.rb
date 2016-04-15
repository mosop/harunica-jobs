module Harunica
  module Jobs
    autoload :TweetNew, 'harunica/jobs/tweet_new'
    autoload :TweetNotice, 'harunica/jobs/tweet_notice'
    autoload :TweetPast, 'harunica/jobs/tweet_past'
    autoload :TweetVideo, 'harunica/jobs/tweet_video'
  end
end
