module Harunica
  module Jobs
    class TweetVideo
      def initialize(video_id)
        @video_id = video_id
      end

      def perform
        v = Harunica::Video.find_by_id(@video_id)
        v.tweet! if v
      end
    end
  end
end
