
require'neography'
require'neo4j-cypher'
class Interest



  def self.get_interest_names(label = "Interest")
    @neo = ClientHelper.get_client
    @neo.get_nodes_labeled(label).map{ |labeled|  @neo.get_node_properties(labeled, 'name') }
  end

  def self.find_or_create_by(label, name)
    @neo = ClientHelper.get_client
    if @neo.find_nodes_labeled(label, {:name => name}).empty?
      node = @neo.create_node("name" => name)
      @neo.add_label(node, ["Interest", label])
      node
    else
      @neo.find_nodes_labeled(label, {:name => name}).first
    end
  end




	@@neo = ClientHelper.get_client

	@@node_count = 0 #?
	attr_reader :id,:name,:category

	def initialize(args)
		if args.fetch(:id)
			@id = args.fetch(:id)
		else
			@id||= count
			@@count+=1
		end
		@category = args.fetch(:category)
		@name = args.fetch(:name)
	end	

	def save
		@neo.create_node("id" => self.id, "name" => self.name,"category" => self.category) unless self.in_database?
	end

	def self.create(args)
		node = self.new(args)
		node.save		
	end

	def destroy
		node = @neo.get_node(self.id) 
		@neo.delete_node!(node)
		self		  
	end

	def << 

	end

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
		@neo = ClientHelper.get_client
		query = "MATCH (interest {name:'"+self.name+"'}) RETURN interest.name"	
		if @neo.execute_query(query)['data'][0]
			true
		else
			false
		end
	end

end


