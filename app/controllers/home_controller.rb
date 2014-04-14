require 'json'

class HomeController < ApplicationController

  def index
  end

  def template
  end

  def typeahead
    render json: Interest.get_interest_names
  end

 	def show
 		Interest.find(params["search"]).donut

 	end


end

