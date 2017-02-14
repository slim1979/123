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
	
	#======код для обработки пустых строк при записи.
		#если посетитель нажимает сабмит при незаполненных полях формы на /visit,		
		hh ={   
				:new_user_name => 'Введите Ваше имя',
				:new_user_phone => 'Введите Ваш номер телефона',
				:new_user_datetime => 'Введите дату и время посещения',
				:barber => 'Выберите специалиста'
			}
		#то этот код проверяет, какие строки незаполнены 
		#и выдает ошибку, равную значению для каждого поля.
		hh.each do |key, value|
			if params[key] =="" 
				@error = hh[key]
				return erb :visit
			end
		end
	#========конец кода обработки ошибки заполнения полей формы записи.
	
	new_contact = Client.new
	new_contact.name = params[:new_user_name]
	new_contact.phone = params[:new_user_phone]
	new_contact.datestamp =params[:new_user_datetime]
	new_contact.barber = params[:barber]
	new_contact.save
	
	erb "#{params[:new_user_name]}, Вы записаны на #{new_contact.datestamp} к специалисту #{new_contact.barber}"
	
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
