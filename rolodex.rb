#Declaring rolodex class 
class Rolodex
	attr_reader :contacts, :id, :counter 

	def initialize 
		@contacts = [] #Array that holds our contact objects
		@id = 1000 # Each contact is to be given a unique ID, first contact will be given id 1000
		@counter = 0 #To keep track of number of contacts in the rolodex
	end

	def add_contact(contact) #adding contact to the rolodex
		contact.id = @id #contact that is added is given current id
		@contacts << contact #contact that is added is added to the contact array in the rolodex
		@id += 1 #id increases by one (so next contact added has a different id)
		@counter += 1 #number of contacts in rolodex goes up by one
	end

	def remove_contact(contact) #for deletion of contacts from rolodex
		@contacts.delete(contact) #call .delete method on array of contacts in rolodex for contact passed to remove_contact
		@counter -= 1 #counter goes down by one to account for deletion of contact from rolodex
	end

end

