require 'json'

class HomeController < ApplicationController

  def index
    render 'show'
  end

  def typeahead
    render json: Interest.get_interest_names
  end

  def show
    interests = params[:list].map{|name| Interest.find(name)}
    # interests.reject!{|interest| interest.nil?}
    render json: Interest.combined_donut(interests)
 	end

  def nodes
    render json: Interest.node_matrix(params[:name])
  end

  def d3_3
    interests = params[:list].map{|name| Interest.find(name)}
    render json: Interest.venn(interests)
  end

  def top
    interests = params[:list].map{|name| Interest.find(name)}
    render json: Interest.combined_weighted_recommendations(interests).take(7)
  end

end

