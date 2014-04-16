
require'neography'
require'neo4j-cypher'
class Interest
	#tested
	@@neo = ClientHelper.get_client
	attr_reader :name,:category

	def initialize(args)
		@category = args.fetch(:category)
		@name = args.fetch(:name)
	end

	def in_database?
		query = "MATCH (interest {name:'"+self.name+"'}) RETURN interest.name"
		if @@neo.find_nodes_labeled("Interest",{:name => self.name}).first
			true
		else
			false
		end
	end

	def save
		unless self.in_database?
			interest = @@neo.create_node("name" => self.name)
			@@neo.add_label(interest, "Interest")
			@@neo.add_label(interest, self.category)
		end
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
		person = @@neo.find_nodes_labeled("Person", {:user_id_hash => person.user_id_hash}).first
		@@neo.create_relationship("like",person, interest)
		self
	end


	#untested


  def self.get_interest_names(label = "Interest")
    # @@neo.get_nodes_labeled(label).map{ |labeled|  @@neo.get_node_properties(labeled, 'name')}
    @@neo.execute_query("MATCH (n:Interest) RETURN n.name")["data"].inject(Array.new){ |array, name| array << {"name" => name.first }}
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


  def self.node_matrix(interest, label="Interest")
    paths = @@neo.execute_query("MATCH (startnode {name:\"" + interest + "\"})--(p)--(ri1) WHERE NOT ri1.name = startnode.name RETURN startnode.name, ri1.name ORDER BY startnode.name, ri1.name limit 10")['data']
    paths = paths.uniq.map {|path| path << paths.count(path) }
    paths = paths.inject({}) {|h,i| t = h; i.each {|n| t[n] ||= {}; t = t[n]}; h}
    Interest.with_children(paths)
  end

# @@neo.execute_query("MATCH (interest {name:'"+ self.name+"'})--(person)--(recommendation) WHERE NOT interest=recommendation RETURN labels(recommendation)[1],recommendation.name")['data']
	def self.with_children(node)
	  if node[node.keys.first].keys.first.is_a?(Integer)
	    { "name" => node.keys.first,
	      "size" => 1 + node[node.keys.first].keys.first
	     }
	  else
	    { "name" => node.keys.first,
	      "children" => node[node.keys.first].collect { |c|
	        with_children(Hash[c[0], c[1]]) }
	    }
	  end
	end



  	def self.combined_weighted_recommendations(interest_array)
		recommendations = self.combined_recommendations(interest_array)
    if recommendations
	    results = []
	    # titles = recommendations.map{|title| title[1]}
	    unique = recommendations.uniq
	    unique.each do |title|
	      title << recommendations.count{|interest| interest[1] == title[1]}
	      results << title
	    end
	    return results.sort{ |a,b| b[2] <=> a[2]}[0..19]
	  else
	  	nil
	  end
  end

  def self.combined_percentage_recommendations(interest_array)
  	recommendations = self.combined_weighted_recommendations(interest_array)
  	if recommendations
	    categories = recommendations.map{|interest| interest[0]}.uniq
	    category_count = {}
	    categories.each do |category|
		    count = 0
		    recommendations.each do |interest|
	      	if interest[0] == category
	      		count+=interest[2]
	      	end
	    	end
	    	category_count[category] = count
	    end
	    return recommendations.map{|interest| [interest[0],interest[1],interest[2].to_f/category_count[interest[0]].to_f]}
	  else
	  	nil
	  end
  end









  def self.combined_donut(interest_array)
  	input = self.combined_percentage_recommendations(interest_array)
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


	def weighted_recommendations
		recommendations = self.recommendations
    if recommendations
	    results = []
	    unique = recommendations.uniq
	    unique.each do |title|
	      title << recommendations.count{|interest| interest[1] == title[1]}
	      results << title
	    end
	    return results.sort{ |a,b| b[2] <=> a[2]}
	  else
	  	nil
	  end
	end



	def self.combined_recommendations(interest_array)
		interests = interest_array.map{|interest| interest.name}
		result = interest_array.map{|interest| interest.recommendations}
		result.flatten!(1).reject!{|recommendation| interests.include?(recommendation[1])}
		if result[0]
			return result
		else
			return nil
		end
	end











# var root = { "set": [{label : 'SE', size : 28}, {label : 'Treat', size: 35}, {label : 'snow', size: 20}],
#     "overlap": [{sets : [0,1], size:2},
#           {sets :  [0,2], size:3},
#           {sets : [1,2], size: 10},
#           {sets : [0,1,2], size: 10}
#                        ]};

	def self.venn(interest_array)
		interest_names=interest_array.map{|interest| interest.name}
		# p interest_names
		interest_hashes = interest_array.map{|interest| {"name"=>interest.name,"recommendations"=>interest.recommendations.uniq}}
		# p interest_hashes
		output = {"set"=>[],"overlap"=>[]}
		# p interest_hashes[0]['recommendations'][0]
		#part 1
		interest_hashes.each do |interest|
			interest_names.each do |name|
				interest['recommendations'].reject! do |recommendation|
					name == recommendation[1]
				end
			end
			
			output['set'] << {'label'=>interest['name'] ,'size'=> interest['recommendations'].length}
		end
		#part 2
		indices = (0...interest_hashes.length).to_a
		index_combos= 2.upto(indices.length).flat_map { |n| indices.combination(n).to_a }
		recommendation_lists = interest_array.map{|interest| interest.recommendations}
		recommendation_lists.each do |list| 
			interest_names.each do |name|
				list.reject! do |recommendation|
					name == recommendation[1]
				end
			end	
		end
		# p recommendation_lists[1]
		# p recommendation_lists[2]
		index_combos.each do |combo|
			p combo 
			intersection = recommendation_lists[combo[0]]
			combo.each_with_index do |number, index|
				if intersection[0]
					intersection = intersection & recommendation_lists[combo[index]]
				else
					break
				end
			end
			if intersection
				size = intersection.length
			else
				size = 0
			end
			output['overlap'] << {sets: combo, size: size} 
		end 
		return output
	end
end







