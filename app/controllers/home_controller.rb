require 'JSON'

class HomeController < ApplicationController
  before_action :set_client
  def index
    @result = @neo.execute_query('MATCH (movie { name:{interest} })--(person)--(recommendation) WHERE NOT movie=recommendation RETURN recommendation.name', {:interest => "Mulan"})

    @titles = @result['data'].map{|d| d[0]}
    p @titles
    result_array = []
    @test = @titles.uniq.each do |m|
      # freq =
      result_array << {label: m, value: @titles.count(m)}
    end
    @data = JSON.generate(result_array.sort{ |a,b| b[:value] <=> a[:value]}[0..9])
  end


  def set_client
    @neo = Neography::Rest.new
  end
end
# [{label: "title", value: <frequency>},]
