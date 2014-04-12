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


	@neo=Neography::Rest.new
	@@node_count = 0 #?
	attr_reader :id,:name,:category,

	def new(args)
		if args.fetch(:id)
			@id = args.fetch(:id)
		else
			@id||= count
		end

		@category = args.fetch(:category)
		@name = args.fetch(:name)
	end	

	def save
		@neo.create_node(("id" => this.id, "name" => this.name,"category" => this.category)) unless self.in_database?
	end

	def self.create(args)
		self.new(args)
		self.save		
	end

	def weighted_recommendations(number)
		recommendations = self.recommendations['data'].map{|d| d['name']}
    results = []
    recommendations.uniq.each do |title|
      results << {label: title, value: recommendations.count(title)}
    end
    JSON.generate(results.sort{ |a,b| b[:value] <=> a[:value]}[0..number])
  end

	private

	def recommendations  
		@neo.execute_query('MATCH (movie {name})--(person)--(recommendation) WHERE NOT movie=recommendation RETURN recommendation.name',{:name => self.name})['data']
	end

	def in_database?
		@neo.execute_query('MATCH (this {name}) RETURN recommendation.name',{:name => self.name})['data']
	end

>>>>>>> ORM
end

