class HomeController < ApplicationController
  def index
  end


  def template
  end

  def typeahead
    render json: Interest.get_interest_names

  end

  def test
  	@neo=Neography::Rest.new
  	node1 = @neo.create_node("age" => 31, "name" => "Max")
  	node2 = @neo.create_node("age" => 31, "name" => "Sam")
  	node3 = @neo.create_node("age" => 31, "name" => "Dan")
  	@neo.create_relationship(:friends, node1, node2)
  	@neo.create_relationship(:friends, node2, node3)  
  	a = @neo.execute_query("START user=node(1) MATCH user<-[:friends]->person<-[:friends]->person2 RETURN person2")
  	
# MATCH user-[:likes]->Movie<-[:likes]-person-[:likes]->stuff
# WHERE NOT user-[:likes]->stuff
# RETURN stuff   
  	@test = a
  	@test = @neo.get_node_relationships(node1)   


  end

end
