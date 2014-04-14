
require'neography'
require'neo4j-cypher'
class Interest

	@@neo = ClientHelper.get_client

  def self.get_interest_names(label = "Interest")
    @@neo.get_nodes_labeled(label).map{ |labeled|  @@neo.get_node_properties(labeled, 'name')}
  end

  def self.find_or_create_by(label, name)
    if @@neo.find_nodes_labeled(label, {:name => name}).empty?
      node = @@neo.create_node("name" => name)
      @@neo.add_label(node, ["Interest", label])
      node
    else
      @@neo.find_nodes_labeled(label, {:name => name}).first
    end
  end






	attr_reader :id,:name,:category

	def initialize(args)
		@category = args.fetch(:category)
		@name = args.fetch(:name)
	end

	def save
		interest = @@neo.create_node("name" => self.name) unless self.in_database?
		@@neo.add_label(interest, "Interest")
		@@neo.add_label(interest, self.category)
		self
	end

	def self.create(args)
		node = self.new(args)
		node.save
	end

	def destroy
		nodes = @@neo.find_nodes_labeled(self.category, {:name => self.name})
		nodes.each do |node|
			@@neo.delete_node!(node)
		end
		self
	end

	def self.find(name)
		node = @@neo.find_nodes_labeled("Interest", {:name => name}).first
		if node
			name = @@neo.get_node_properties(node)["name"]

			category = "yeah, this doesn't support category yet"#this...needs fixing
			return interest = Interest.new({name:name,category:category})
		end
	end

	def <<(person)
		interest = @@neo.find_nodes_labeled("Interest", {:name => self.name}).first
		person = @@neo.find_nodes_labeled("Person", {:fb_id_hash => person.fb_id_hash}).first
		@@neo.create_relationship("like",person, interest)
	end

	def weighted_recommendations(number)
		recommendations = self.recommendations
    if recommendations
	    results = []
	    # titles = recommendations.map{|title| title[1]}
	    unique = recommendations.uniq
	    unique.each do |title|
	      title << recommendations.count{|interest| interest[1] == title[1]}
	      results << title
	    end
	    return results.sort{ |a,b| b[2] <=> a[2]}[0..number]
	  else
	  	nil
	  end
  end

  def donut(number)
  	input = self.weighted_recommendations(number)
  	if input
	  	results = {'title' => '', 'children' => []}
	  	categories = input.map(&:first).uniq
	  	categories.each do |category|
	  		category_recs = input.select {|recommendation| recommendation.first == category }
	  		children = []
	  		category_recs.each do |c, title, freq|
	  			children << {"title" => title, "data" => freq}
	  		end
	  		results['children'] << {'title' => category, 'children' => children}
	  	end
	  	results
	  else
	  	nil
	  end
  end



	def recommendations
		result = @@neo.execute_query("MATCH (interest {name:'"+ self.name+"'})--(person)--(recommendation) WHERE NOT interest=recommendation RETURN labels(recommendation)[1],recommendation.name")['data']
		if result[0]
			return result
		else
			return nil
		end
	end

	def in_database?
		query = "MATCH (interest {name:'"+self.name+"'}) RETURN interest.name"
		if @@neo.find_nodes_labeled("Interest",{:name => self.name}).first
			true
		else
			false
		end
	end

	def bubbles(number)
		self.donut(number)['children']
	end
end
