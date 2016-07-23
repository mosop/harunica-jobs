$:.unshift(__dir__ + '/lib')
require_relative 'config/config'

namespace :db do
  task :migrate do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("#{Harunica.root}/db/migrate")
  end

  task :drop do
    File.delete("#{Harunica.root}/db/#{Harunica.env}.sqlite3")
  end
end

namespace :twitter do
  task :authorize do
    require 'oauth'
    consumer_key = Harunica.config['twitter']['consumer_key']
    consumer_secret = Harunica.config['twitter']['consumer_secret']
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, :site => "https://twitter.com")
    request_token = consumer.get_request_token
    puts "authorize url: #{request_token.authorize_url}"
    print "enter PIN: "
    pin = STDIN.gets.chomp
    access_token = request_token.get_access_token(oauth_verifier: pin)
    puts "token: #{access_token.token}"
    puts "secret: #{access_token.secret}"
  end
end

namespace :jobs do
  task :now do
    Delayed::Job.update :all, run_at: Time.now
  end

  task :work do
    Delayed::Worker.new.start
  end

  task :clear do
    Delayed::Job.destroy_all
  end

  task :enqueue do
    # Harunica::Jobs::TweetNotice.enqueue
    Harunica::Jobs::TweetNew.enqueue
    Harunica::Jobs::TweetPast.enqueue
  end
end

task :tweeted_videos do
  puts Harunica::Video.where(tweeted: true).all.map{|i| i.video_id}.to_s
end

task :fetch_past do
  Harunica::Video.fetch 'past'
end

task :past_to_year do
  Harunica::Video.where(period: 'past').all.each do |v|
    v.period = v.published_at.year
    v.save!
  end
end

task :mark_unavailable do
  a = File.read("#{__dir__}/config/unavailable_videos.#{Harunica.env}").strip.split("\n")
  a.each do |vid|
    if v = Harunica::Video.find_by_video_id(vid)
      v.unavailable = true
      v.save!
    end
  end
end

task :mark_tweeted do
  Harunica::Video.where.not(tweeted_at: nil).update tweeted: true
end

task :migrate_201607 => %w(
    jobs:clear
    past_to_year
    mark_unavailable
    mark_tweeted
    jobs:enqueue
  )