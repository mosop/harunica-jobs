require 'rss'

module Harunica
  class Mylist
    def initialize(id)
      @id = id
    end

    def videos
      @videos ||= rss.items.map{|i| Harunica::Video.from_rss(i)}
    end

    def rss
      @rss ||= RSS::Parser.parse("http://www.nicovideo.jp/mylist/#{@id}?rss=2.0")
    end
  end
end
