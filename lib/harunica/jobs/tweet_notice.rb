module Harunica
  module Jobs
    class TweetNotice
      def perform
        now = Time.now
        notices = Harunica.config['notices'].map{|i| Harunica::Notice.new(i)}
        notices = notices.find_all{|i| i.time_within?(now)}
        if notices.size > 0
          v = notices[rand(0...notices.size)]
          v.tweet
        end
        self.class.enqueue
      end

      def self.enqueue
        now = Time.now.getlocal('+09:00')
        run_at = nil
        [[12, 10], [21, 0]].each do |hm|
          t = now.change(hour: hm[0], min: hm[1])
          if now < t
            run_at = t
            break
          end
        end
        run_at ||= now.change(hour: 12, min: 10) + 1.day
        Delayed::Job.enqueue self.new, run_at: run_at
      end
    end
  end
end
