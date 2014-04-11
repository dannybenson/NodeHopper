class HomeController < ApplicationController
  def index
  end

  def test
  	@neo=Neography::Rest.new
  	
  	
		@node= @neo.execute_query("match (user{ name:'Me'}) return user")
  	
  	@me = @neo.get_node(8)['data']['name']

  	# @test = @neo.execute_query("start n=node({id}) MATCH user-[:like]->movie<-[:like]-person2-[:like]->movie2 return movie2", {:id => 8})
  	
		# @test = @neo.get_node_properties(@node)
	
		  
	 
		@result = @neo.execute_query('MATCH (person { name:"Me" })--(movie)--(person2)--(movie2)--(person3)--(movie3) WHERE NOT person--(movie3) RETURN movie2.name,movie3.name')
		
		@test = @result['data']


  end
end
