$:.unshift(__dir__ + '/lib')
require_relative 'config/config'
require 'delayed/tasks'

task :environment

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

namespace :video do
  task :fetch_past do
    Harunica::Video.delete_all period: 'past'
    Harunica::Video.fetch 'past'
  end

  task :clear_new do
    Harunica::Video.delete_all period: 'new'
  end
end

namespace :jobs do
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

namespace :test do
end
