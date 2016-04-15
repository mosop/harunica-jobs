module Harunica
  module Jobs
    class TweetNew
      def perform
        Harunica::Video.fetch 'new'
        now = Time.now
        Harunica::Video.where(period: 'new', tweeted_at: nil).each do |v|
          Delayed::Job.enqueue Harunica::Jobs::TweetVideo.new(v.id), run_at: now
          now += 90
        end
        self.class.enqueue
      end

      def self.enqueue
        now = Time.now.getlocal('+09:00')
        run_at = if now >= now.change(hour: 22)
          now.change(hour: 22) + 1.day
        else
          now.change(hour: 22)
        end
        Delayed::Job.enqueue self.new, run_at: run_at
      end
    end
  end
end
