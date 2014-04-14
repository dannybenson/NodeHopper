require 'json'

class HomeController < ApplicationController

  def index
  end

  def template
  	render 'show'
  end

  def typeahead
    render json: Interest.get_interest_names
  end

 	def show
 		render json: Interest.find(params["search"]).donut(40)

 	end


end

