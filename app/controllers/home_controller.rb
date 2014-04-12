require 'JSON'

class HomeController < ApplicationController
  def index
    @neo=Neography::Rest.new

    @result = @neo.execute_query('MATCH (movie { name:"Daft Punk" })--(person)--(recommendation) WHERE NOT movie=recommendation RETURN recommendation.name')

    @titles = @result['data'].map{|d| d[0]}
    result_array = []
    @test = @titles.uniq.each do |m|
      # freq =
      result_array << {label: m, value: @titles.count(m)}
    end
    @data = JSON.generate(result_array.sort{ |a,b| b[:value] <=> a[:value]}[0..9])
  end


  def template
  end

  def typeahead
    render json: Interest.get_interest_names

  end

  def test

  	@neo=Neography::Rest.new
  	

 
  	@test = a
  	@test = @neo.get_node_relationships(node1)   
  	
		@node= @neo.execute_query("match (user{ name:'Me'}) return user")
  	
  	@me = @neo.get_node(8)['data']['name']

  end

end
# [{label: "title", value: <frequency>},]
