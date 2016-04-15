module Harunica
  module Jobs
    class TweetPast
      def perform
        vs = Harunica::Video.where(period: 'past', tweeted_at: nil).all
        if vs.size > 0
          v = vs[rand(0...vs.size)]
          v.tweet!
        end
        self.class.enqueue
      end

      def self.enqueue
        now = Time.now.getlocal('+09:00')
        run_at = nil
        [8, 14, 20].each do |h|
          if now < now.change(hour: h)
            run_at = now.change(hour: h)
            break
          end
        end
        run_at ||= now.change(hour: 8) + 1.day
        Delayed::Job.enqueue self.new, run_at: run_at
      end
    end
  end
end
