require 'twitter'

module Harunica
  class Video < ActiveRecord::Base
    def self.from_rss(rss)
      video = self.new
      video.video_id = rss_link_to_video_id(rss.link)
      video.title = rss.title
      video.published_at = parse_rss_date(rss)
      video
    end

    def self.rss_link_to_video_id(link)
      %r{([^/]+)$} =~ link
      $1
    end

    def self.parse_rss_date(rss)
      %r{<strong class="nico-info-date">(\d+)年(\d+)月(\d+)日 (\d+)：(\d+)：(\d+)</strong>} =~ rss.description
      Time.new($1, $2, $3, $4, $5, $6, '+09:00')
    end

    def url_for_tweet
      @url_for_tweet ||= "nico.ms/#{video_id}"
    end

    def shorten_title(size)
      if title.size > size
        "#{title[0...(size-3)]}..."
      else
        title
      end
    end

    def twitter_tags
      @twitter_tags ||= begin
        a = []
        case Harunica.env
        when 'development'
          a << '#harunica_test'
        when 'production'
          a << '#harunica'
        end
        a.join(' ')
      end
    end

    def twitter_message
      @twitter_message ||= begin
        a = if period == Harunica.period.to_s
          ["【春ニカ祭#{period}新着紹介】 ", " #{url_for_tweet} #{twitter_tags}"]
        else
          ["【春ニカ過去曲紹介】春ニカ祭#{period}の参加曲より ", " #{url_for_tweet} #{twitter_tags}"]
        end
        a[0] + shorten_title(140 - (a[0].size + a[1].size)) + a[1]
      end
    end

    def tweet!
      return if tweeted? || unavailable?
      Harunica.twitter.update twitter_message
      self.tweeted_at = Time.now
      self.tweeted = true
      save!
    end

    def self.fetch(period)
      (Harunica.config["mylist_ids_in_#{period}"] || []).each do |list_id|
        list = Harunica::Mylist.new(list_id)
        list.videos.each do |v|
          if Harunica::Video.where(video_id: v.video_id).count == 0
            v.period = period
            v.save!
          end
        end
      end
    end
  end
end
