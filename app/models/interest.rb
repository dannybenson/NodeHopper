
require'neography'
require'neo4j-cypher'
class Interest

	attr_reader :id,:name,:category


  def self.get_interest_names(label = "Interest")
    @neo.get_nodes_labeled(label).map{ |labeled|  @neo.get_node_properties(labeled, 'name')["name"] }
  end

  def self.find_or_create_by(label, name)
    if @neo.find_nodes_labeled(label, {:name => name}).empty?
      node = @neo.create_node("name" => name)
      @neo.add_label(node, ["Interest", label])
      node
    else
      @neo.find_nodes_labeled(label, {:name => name}).first
    end
  end






	
	

	def initialize(args)
		@category = args.fetch(:category)
		@name = args.fetch(:name)
	end	

	def save
		unless self.in_database? 
			interest = 	@neo.create_node("name" => self.name,"category" => self.category) 
			@neo.add_label(interest, "Interest")
			@neo.add_label(interest, self.category)
		end
	end

	def self.create(args)
		node = self.new(args)
		node.save		
	end

	def destroy
		nodes = @neo.find_nodes_labeled("Interest", {:name => self.name})
		nodes.each do |node|
			@neo.delete_node!(node)
		end
		# nodes.first		  
	end

	# def << 

	# end

	def weighted_recommendations(number)
		recommendations = self.recommendations['data'].map{|d| d['name']}
    results = []
    recommendations.uniq.each do |title|
      results << {label: title, value: recommendations.count(title)}
    end
    JSON.generate(results.sort{ |a,b| b[:value] <=> a[:value]}[0..number])
  end



	def recommendations  
		@neo.execute_query('MATCH (movie {name})--(person)--(recommendation) WHERE NOT movie=recommendation RETURN recommendation.name',{:name => self.name})['data']
	end

	def in_database?
		if @neo.find_nodes_labeled(self.category, {:name => self.name}).empty?		
			return false
		else
			true
		end
	end
end

