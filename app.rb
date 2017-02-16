require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:123.db"

class Client < ActiveRecord::Base
	validates :name, presence: true
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :barber, presence: true
end

class Barber < ActiveRecord::Base
end

class Opinion < ActiveRecord::Base
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
	@opinions_list = Opinion.all #Opinion.order "created_at DESC" для вывода в обратном порядке, т.е. последние наверху
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do	
  erb :index
end

get '/about' do
	
	erb :about
end

get '/visit' do
	@new_contact = Client.new
	erb :visit
end

post '/visit' do	
		
	@new_contact = Client.new params[:client]	
	
	if @new_contact.save
		erb "#{@new_contact.name}, Вы записаны на #{@new_contact.datestamp} к специалисту #{@new_contact.barber}"
	else
		@error = @new_contact.errors.full_messages.second
		erb :visit
	end
	
end
get '/barbers/:id' do
	
	@barber = Barber.find params[:id]	
	@clients = Client.where("barber = ?", [@barber.name])
	erb :barber
end


#здесь происходит переход к виду contacts при нажатии на ссылку Контакты на главной
get '/contacts' do
	erb :contacts
end

#здесь происходит добавление новых отзывов
post '/contacts' do

	new_opinion = Opinion.new
	new_opinion.client_name = params[:opinion_client_name]
	new_opinion.client_email = params[:opinion_client_email]
	new_opinion.opinion_text = params[:opinion_client_text]
	new_opinion.save
	erb "Уважаемый #{params[:opinion_client_name]}, Ваш отзыв сохранен!"
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
