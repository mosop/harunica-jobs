require 'harunica'
require 'bundler'
Bundler.setup(:default, Harunica.env)
require 'delayed_job_active_record'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/calculations'
require 'yaml'

db_config = if Harunica.env == 'production'
  ENV['CLEARDB_DATABASE_URL'].sub(/^mysql/, 'mysql2')
else
  {
    adapter: 'sqlite3',
    database: "#{Harunica.root}/db/#{Harunica.env}.sqlite3"
  }
end

ActiveRecord::Base.establish_connection db_config
