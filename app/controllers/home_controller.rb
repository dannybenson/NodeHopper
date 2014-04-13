class HomeController < ApplicationController
  def index
  end

  def template
  end

  def typeahead
    render json: Interest.get_interest_names
  end

end
