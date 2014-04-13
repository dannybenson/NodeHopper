require 'spec_helper'
require 'neography'
require 'neo4j-cypher'


describe Interest do

  describe "new" do

  	it "creates a new object" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"poops",category:'thing'})
  		expect(a.name).to eq('poops')
  	end
  end
  describe "save" do
  	it "creates a node" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"sneep",category:'thing'})
  		expect(a.in_database?).to eq(false)
  		a.save
  		expect(a.in_database?).to eq(true)
  	end
  end  

  describe "in_database?" do
  	it "returns true if the interest is in the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"Batman Begins",category:'thing'}) 
  		expect(a.in_database?).to eq(true)
  	end 

  	it "returns false if the interest is not in the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"fleeps",category:'thing'})
  		b = a.in_database?
  		expect(b).to eq(false)
  	end
  end

  describe "destroy" do
  	it "deletes a node from the database" do
  		@neo = ClientHelper.get_client
  		a = Interest.new({name:"glurp",category:"chirp"})
  		a.save
  		expect(a.in_database?).to eq(true)
  		a.destroy
  		expect(a.in_database?).to eq(false)
  	end
  end
end


