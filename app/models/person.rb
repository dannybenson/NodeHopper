class Person
	@@neo = ClientHelper.get_client
	attr_reader :user_id_hash

	def initialize(args)
		@user_id_hash= args.fetch(:user_id_hash)
	end

	def save
		unless self.in_database?
			person = @@neo.create_node("user_id_hash" => self.user_id_hash)
			@@neo.add_label(person, "Person")
		end
		self
	end

	def self.create(args)
		node = self.new(args)
		node.save
	end

	def destroy
		nodes = @@neo.find_nodes_labeled("Person", {:user_id_hash => self.user_id_hash})
		nodes.each do |node|
			@@neo.delete_node!(node)
		end
		self
	end

	def self.find(user_id_hash)
		node = @@neo.find_nodes_labeled("Person", {:user_id_hash =>user_id_hash}).first
		if node
			user_id_hash = @@neo.get_node_properties(node)["user_id_hash"]
			return person = Person.new({:user_id_hash => user_id_hash})
		end
	end

	def <<(interest)
		interest = @@neo.find_nodes_labeled("Interest", {:name => interest.name}).first
		person = @@neo.find_nodes_labeled("Person", {:user_id_hash => self.user_id_hash}).first
		@@neo.create_relationship("like",person, interest)
		self
	end

	def in_database?
		query = "MATCH (person {user_id_hash:'"+self.user_id_hash.to_s+"'}) RETURN person.user_id_hash"
		if @@neo.find_nodes_labeled("Person",{:user_id_hash => self.user_id_hash}).first
			true
		else
			false
		end
	end
end
