require 'sinatra'
require 'data_mapper'
# for importing sinatra/datamapper, require keyword is used (are not files being imported)
DataMapper.setup(:default, "sqlite3:database.sqlite3") #initializes connection to database

class Contact # Declare class contact
	include DataMapper::Resource # when this datamapper module included, allos us access to Datamapper methods to interface with database
	# Above line results in DataMapper considering this class to represent a single database table
	# AKA every time we create new contact record, will automatically insert into contacts database table

	#We can remove attr_accessor and initialize method, as properties also set up getter/setter methods for each one

	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :note, String
	# FYI Serial = integer that automatically increments
end 

DataMapper.finalize #placed at end of class definitions, validates issues with tables/columns
DataMapper.auto_upgrade! #takes care of effecting changes to underlying structure of tables/columns

# for importing files in same dir, we use require_relative
# for importing sinatra, require keyword is used

@@crm_app_name = "Rollo"

#Routes start here
get '/' do
	erb :add_contact
end

get '/contacts' do
	@contacts = Contact.all 
	erb :contacts
end

get '/contacts/new' do
	erb :add_contact
end

# this is not search; this is to list a specific contact (with contact :id)
# /contacts/1000  -> show the page for contact 1000.
# params[:id] == 1000

get '/contacts/:id' do
	@contact = Contact.get(params[:id].to_i)
	if @contact
		erb :contact
	else 
		raise Sinatra::NotFound
	end
end


get '/contacts/:id/edit' do
	@contact = Contact.get(params[:id].to_i)
	if @contact
		erb :edit_specific_contact
	else 
		raise Sinatra::NotFound
	end
end 

post '/contacts' do
		contact = Contact.create(
			:first_name => params[:first_name],
			:last_name => params[:last_name],
			:email => params[:email],
			:note => params[:note],
			)
		redirect to('/contacts')

end

put '/contacts/:id' do 
	@contact = Contact.get(params[:id].to_i)
	if @contact 
		@contact.first_name = params[:first_name]
		@contact.last_name = params[:last_name]
		@contact.email = params[:email]
		@contact.note = params[:note]
		@contact.save

	  redirect to('/contacts')
	else 
		raise Sinatra::NotFound
	end
end

delete "/contacts/:id" do 
	@contact = Contact.get(params[:id].to_i) 
	if @contact 
		@contact.destroy
		redirect to("/contacts")
	else
		raise Sinatra::NotFound 
	end
end
