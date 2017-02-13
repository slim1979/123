require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:123.db"

class Client < ActiveRecord::Base
end


get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

