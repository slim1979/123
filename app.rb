require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:123.db"

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before do
	@barbers_list = Barber.all
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
	@barbers = Barber.order "created_at DESC"
  erb :index
end

get '/visit' do
	
	erb :visit
end

post '/visit' do	
	
	@new_user_name = params[:new_user_name]
	@new_user_phone = params[:new_user_phone]
	@new_user_datetime = params[:new_user_datetime]
	@barber_for_user = params[:barber]
	
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
