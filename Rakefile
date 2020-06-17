require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'removes all data from db'
task :destroy_all do
  [Store,Deal,Game].each{|t|t.destroy_all}
end