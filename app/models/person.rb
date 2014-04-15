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
	end

	# def weighted_recommendations(number)
	# 	recommendations = self.recommendations
 #    if recommendations
	#     results = []
	#     # titles = recommendations.map{|title| title[1]}
	#     unique = recommendations.uniq
	#     unique.each do |title|
	#       title << recommendations.count{|interest| interest[1] == title[1]}
	#       results << title
	#     end
	#     return results.sort{ |a,b| b[2] <=> a[2]}[0..number]
	#   else
	#   	nil
	#   end
 #  end

  # def donut(number)
  # 	input = self.weighted_recommendations(number)
  # 	if input
	 #  	results = {'title' => 'params', 'children' => []}
	 #  	categories = input.map(&:first).uniq
	 #  	categories.each do |category|
	 #  		category_recs = input.select {|recommendation| recommendation.first == category }
	 #  		children = []
	 #  		category_recs.each do |c, title, freq|
	 #  			children << {"title" => title, "data" => freq}
	 #  		end
	 #  		results['children'] << {'title' => category, 'children' => children}
	 #  	end
	 #  	results
	 #  else
	 #  	nil
	 #  end
  # end



	# def recommendations
	# 	result = @@neo.execute_query("MATCH (interest {name:'"+ self.name+"'})--(person)--(recommendation) WHERE NOT interest=recommendation RETURN labels(recommendation)[1],recommendation.name")['data']
	# 	if result[0]
	# 		return result
	# 	else
	# 		return nil
	# 	end
	# end

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
