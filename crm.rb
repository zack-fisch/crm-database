require_relative 'contact'
require_relative 'rolodex'

require 'sinatra'
require 'data_mapper'
# for importing sinatra/datamapper, require keyword is used (are not files being imported)

Datamapper.setup(:default, "sqlite3:database.sqlite3") #initializes connection to database

# for importing files in same dir, we use require_relative
# for importing sinatra, require keyword is used

#declare class variable rolodex as new rolodex
@@rolodex = Rolodex.new

# declare class variable for the name of the app, to be used
# in the layout page
@@crm_app_name = "Rollo"

#Routes start here
# When HTTP verb is called on specific url -> call the block
get '/' do
	erb :add_contact
end

get '/contacts' do
	erb :contacts
end

get '/contacts/new' do
	erb :add_contact
end

# this is not search; this is to list a specific contact (with contact :id)
# /contacts/1000  -> show the page for contact 1000.
# params[:id] == 1000

get '/contacts/:id' do
	# search contact = an integer that is id input in the URL
	search_contact = params[:id].to_i 
	# display contact is the contact pulled from the rolodex when the squeried ID matches a contact id
	@display_contact = @@rolodex.contacts.find {|contact| contact.id == search_contact }
	# if display contact successfully pulled, call contact.erb
	if @display_contact
		erb :contact
	else # else 404
		raise Sinatra::NotFound
	end
end


get '/contacts/:id/edit' do
	# Same logic as above, id input in url set to search contact, used to query rolodex
	search_contact = params[:id].to_i 
	@display_contact = @@rolodex.contacts.find {|contact| contact.id == search_contact }
	if @display_contact
		erb :edit_specific_contact
	else 
		raise Sinatra::NotFound
	end
end 

post '/contacts' do # When a post is made to /contacts, take the information passed to params via HTML FORM
	# and assign that information to a new contact (new instance of contact class)
	new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
	# Add this new contact to rolodex
	@@rolodex.add_contact(new_contact)
	redirect to('/contacts') #redirect browser back to display all contacts page
end

put '/contacts/:id' do #When put is made to contacts/:id (aka an ammendment to existing contact)
	search_contact = params[:id].to_i  # Same logic as above
	@display_contact = @@rolodex.contacts.find {|contact| contact.id == search_contact }
	if @display_contact #If contact already exists and is in rolodex (aka display_contact != nil, then make ammendments)
		@display_contact.first_name = params[:first_name]
		@display_contact.last_name = params[:last_name]
		@display_contact.email = params[:email]
		@display_contact.note = params[:note]
	  redirect to('/contacts')
	else # else raise 404
		raise Sinatra::NotFound
	end
end

delete "/contacts/:id" do #When HTTP delete verb is passed to a contact at a specific id
	search_contact = params[:id].to_i 
	@display_contact = @@rolodex.contacts.find {|contact| contact.id == search_contact } #Find the contact
	if @display_contact #if contact found, then remove from rolodex
		@@rolodex.remove_contact(@display_contact)
		redirect to("/contacts")
	else
		raise Sinatra::NotFound #Else 404
	end
end
