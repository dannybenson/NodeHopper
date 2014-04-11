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

  def test



  end
end
# [{label: "title", value: <frequency>},]
