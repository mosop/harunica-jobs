module Harunica
  autoload :Jobs, 'harunica/jobs'
  autoload :Mylist, 'harunica/mylist'
  autoload :Notice, 'harunica/notice'
  autoload :Video, 'harunica/video'

  def self.root
    @root ||= Dir.pwd
  end

  def self.env
    @env ||= ENV['HARUNICA_ENV'] || 'development'
  end

  def self.config
    @config ||= begin
      h = YAML.load_file("#{root}/config/#{env}.yml")
      configure_twitter h
      h
    end
  end

  def self.configure_twitter(config)
    if env == 'production'
      h = config['twitter'] = {}
      %w[consumer_key consumer_secret access_token access_token_secret].each do |k|
        h[k] = ENV["HARUNICA_TWITTER_#{k.upcase}"]
      end
    end
  end

  def self.twitter
    @twitter ||= Twitter::REST::Client.new do |config|
      %w[consumer_key consumer_secret access_token access_token_secret].each do |k|
        config.__send__ "#{k}=", self.config['twitter'][k]
      end
    end
  end
end
